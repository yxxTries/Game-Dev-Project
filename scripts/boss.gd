extends CharacterBody2D

@export var health := 50
@export var projectile_scene: PackedScene
@export var speed := 600
var attack_index := 0  
var jumping := false
var gravity := 1200

@onready var sprite := $AnimatedSprite2D
@onready var projectile_spawn := $ProjectileSpawn
@onready var cooldown := $CooldownTimer
var boss_health_bar: ProgressBar
@onready var boss_start_label := get_node("bossStartLabel") 

var player: Node2D 
var is_active := false 

func _ready():
	player = get_tree().get_current_scene().get_node_or_null("CharacterBody2D")

	var ui_root = get_tree().get_current_scene().get_node("BossUI")
	if ui_root:
		boss_health_bar = ui_root.get_node_or_null("BossHealthBar")
		boss_start_label = ui_root.get_node_or_null("bossStartLabel")

	if boss_health_bar:
		boss_health_bar.max_value = health
		boss_health_bar.value = health
		boss_health_bar.visible = false
		boss_health_bar.modulate.a = 0

	if sprite:
		sprite.play("Idle")

	if not Dialogic.is_connected("signal_event", Callable(self, "_on_dialogic_signal")):
		Dialogic.connect("signal_event", Callable(self, "_on_dialogic_signal"))
		print("✅ Boss is waiting for boss_intro to finish")

	cooldown.connect("timeout", _on_cooldown_timeout)



func _on_dialogic_signal(arg):
	if arg == "dialogue_complete":
		print("✅ Dialogue done — show 'Begin!!!'")

		boss_start_label.visible = true
		boss_start_label.modulate.a = 0

		if boss_health_bar:
			boss_health_bar.visible = true
			boss_health_bar.modulate.a = 0

		var tween = create_tween()

		tween.tween_property(boss_start_label, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)
		tween.tween_interval(1.0)
		tween.tween_property(boss_start_label, "modulate:a", 0.0, 0.5)

		if boss_health_bar:
			tween.parallel().tween_property(boss_health_bar, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE)

		await tween.finished

		boss_start_label.visible = false
		is_active = true
		cooldown.start()


func _on_cooldown_timeout():
	if not is_active or not is_instance_valid(player):
		return
	if attack_index % 2 == 0:
		attack1()
	else:
		attack2()

	attack_index += 1
	cooldown.start()
	sprite.flip_h = player.global_position.x < global_position.x

func wait_until_landed() -> void:
	while not is_on_floor():
		await get_tree().process_frame
		
func attack1():
	sprite.play("attack1")
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)

	projectile.global_position = projectile_spawn.global_position

	projectile.velocity = (player.global_position - global_position).normalized() * projectile.speed


func attack2():
	sprite.play("attack2")

	var direction = (player.global_position - global_position).normalized()
	jumping = true

	var horizontal_speed = direction.x * speed
	var jump_strength = 500

	velocity.x = horizontal_speed
	velocity.y = -jump_strength

	await wait_until_landed()

	velocity = Vector2.ZERO
	jumping = false
	sprite.play("Idle")



func _physics_process(delta):
	if jumping:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, 900)

	move_and_slide()

	if is_on_floor():
		if jumping:
			global_position.y -= 1
			jumping = false
			sprite.play("Idle")
		velocity.y = 0

func hit():
	take_damage(1)

func take_damage(amount: int):
	health -= amount
	if boss_health_bar:
		boss_health_bar.value = health
	if health <= 0:
		die()


func die():
	set_physics_process(false)
	set_process(false)
	cooldown.stop()
	sprite.play("death")

	if boss_health_bar:
		boss_health_bar.visible = false

	await sprite.animation_finished
	sprite.stop()

	await get_tree().create_timer(2.0).timeout 
	get_tree().change_scene_to_file("res://levels/ending.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_active:
		return 
	if body.is_in_group("player_bullet"):
		take_damage(1)
		body.queue_free()
