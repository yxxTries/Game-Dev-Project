extends CharacterBody2D
 
class_name slimeEnemy

const speed = 30
var is_frog_chase: bool

@onready var healthbar = $HealthBar/ProgressBar
@onready var healthbar_timer = Timer.new()

@export var max_health := 3
var health := max_health

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 20
var is_dealing_damage: bool = false
var hurt:bool = false
var delayOver:bool = true

var dir: Vector2
const gravity = 900
var knockback_force = 200
var is_roaming: bool = true

var player:CharacterBody2D 
var playe_in_area = false



func _process(delta):
	if health <= 0:
		die()
		
	if !is_on_floor():
		velocity.y += gravity*delta
		velocity.x = 0
	player = $"../player"
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:  
		if !is_frog_chase:
			velocity += dir * speed * delta
		elif is_frog_chase and !taking_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x 
		is_roaming = true
		
	elif dead:
		velocity.x = 0
		
func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("walk")
		if dir.x == -1:
			anim_sprite.flip_h = true
		elif dir.x == 1: 
			anim_sprite.flip_h = false
	elif !dead and taking_damage and !is_dealing_damage:
		anim_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		anim_sprite.plau("death")
		await get_tree().create_timer(1.2).timeout
		handle_death()
		
func handle_death(): #add points here
	self.queue_free()

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.2, 2.0, 2.5])
	if !is_frog_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0 

func choose(array):
	array.shuffle()
	return array.front()


func _on_slime_hit_box_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"): 
		player.hit()

func hit():
	print("body hit")
	hurt = true
	health-=1
	update_healthbar()
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("hurt")
	await $AnimatedSprite2D.animation_finished
	
	hurt = false

func update_healthbar():
	print("helthbar updated")
	healthbar.visible = true
	healthbar.value = health
	await get_tree().create_timer(1).timeout
	healthbar.visible = false
	
func die():
	set_physics_process(false)
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	self.queue_free()
	set_physics_process(true)
	Global.enemies_killed += 1
	
