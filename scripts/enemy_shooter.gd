extends CharacterBody2D
var bullet_path = preload("res://scenes/enemy_bullet.tscn")
var bullet:Node2D
var facing_left:bool
var enemy_entered: bool
@export var max_health := 3
var health := max_health

@onready var healthbar = $HealthBar/ProgressBar
@onready var healthbar_timer = Timer.new()
@export var speed: float = 20
@export var patrol_distance: float = 100

var direction := 1
var start_position := Vector2.ZERO
var body_entered:Node2D = null
var player_entered:bool = false
var delayOver:bool = true
var hurt:bool = false
func _ready():
	start_position = global_position
	
func _physics_process(delta):
	if player_entered and is_instance_valid(body_entered) and not body_entered.dead:
			attack()
			
	elif not hurt:
		patrol()
		
	if health <= 0:
		die()
func patrol():
	velocity.x = direction * speed
	if direction < 0:
		$AnimatedSprite2D.flip_h =  true
	else:
		$AnimatedSprite2D.flip_h =  false
	$AnimatedSprite2D.play("walk")
	move_and_slide()
	
	# Reverse direction if too far from start
	if abs(global_position.x - start_position.x) > patrol_distance:
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
		direction *= -1

func _on_enemy_view_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):  
		body_entered = body
		player_entered = true
func _on_enemy_view_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == body_entered:
		body_entered = null
		player_entered = false
	
func attack():
	velocity = Vector2.ZERO
	if body_entered.is_in_group("player"):
		if body_entered.global_position - self.global_position < Vector2.ZERO:
			$AnimatedSprite2D.flip_h = true
			direction *= -1
			facing_left = true
		else:
			$AnimatedSprite2D.flip_h = false
			direction *= 1
			facing_left = false
		$AnimatedSprite2D.play("attack")
		if delayOver:
			fire()
			delayOver = false
		

func fire():
	$BulletDelay.start(1)
	bullet = bullet_path.instantiate()
	if facing_left:
		bullet.pos = $bullet_left.global_position
		bullet.facing_left = true
	else:
		bullet.pos = $bullet.global_position
		bullet.facing_left = false
	get_parent().add_child(bullet)
	
func hit():
	hurt = true
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("hurt")
	await $AnimatedSprite2D.animation_finished
	health-=1
	update_healthbar()
	hurt = false

func die():
	set_physics_process(false)
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	self.queue_free()
	set_physics_process(true)

func update_healthbar():
	healthbar.visible = true
	healthbar.value = health
	await get_tree().create_timer(1).timeout
	healthbar.visible = false


func _on_bullet_delay_timeout() -> void:
	delayOver = true
