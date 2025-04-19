extends CharacterBody2D
var bullet_path = preload("res://scenes/hero_bullet.tscn")
var healthBar = []
var bullet:Node2D
@export var SPEED = 100.0
const JUMP_VELOCITY = -400.0
var has_gun = false
var facing_left = false
var has_doubleJump = false
var hurt:bool = false
var dead:bool = false
var canDoubleJump =  false
var health = 6
var score:int = 0
var is_dead:bool = false
var can_move := true
func _ready() -> void:
	healthBar = [$"HealthBar/health1",$"HealthBar/health2",$"HealthBar/health3",$"HealthBar/health4",$"HealthBar/health5",$"HealthBar/health6"]
func _physics_process(delta: float) -> void:
	if !hurt and can_move:
		move(delta)

func move(delta):
	

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released("jump"):
		canDoubleJump = true
		$JumpTimer.start()
	elif Input.is_action_just_pressed("jump") and has_doubleJump and canDoubleJump:
		velocity.y -= 200
	elif not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("shoot") and has_gun:
		#$AnimatedSprite2D.play("shoot")
		if facing_left:
			$hand_left.visible = true
			$gun_left.visible = true
		else:
			$hand.visible = true
			$gun.visible = true
		fire()
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("run_left", "run_right")
	
	if Input.is_action_pressed("run_left"):
		$AnimatedSprite2D.play("run_right")
		$AnimatedSprite2D.flip_h = true
		facing_left = true
		$hand.visible = false
		$gun.visible = false
		$hand_left.visible = false
		$gun_left.visible = false
		
	elif Input.is_action_pressed("run_right"):
		$AnimatedSprite2D.play("run_right")
		$AnimatedSprite2D.flip_h = false
		facing_left = false
		$hand.visible = false
		$gun.visible = false
		$hand_left.visible = false
		$gun_left.visible = false
	
	elif velocity.y < 0:
		$AnimatedSprite2D.play("jump")
		 
	elif not $"AnimatedSprite2D".is_playing() || Input.is_action_just_released("run_right") || Input.is_action_just_released("run_left"):
		$hand_left.visible = false
		$gun_left.visible = false
		$hand.visible = false
		$gun.visible = false
		$AnimatedSprite2D.play("idle")
		
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	
func fire():
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
	$AnimatedSprite2D.play('hurt')
	await $AnimatedSprite2D.animation_finished
	health-=1
	update_healthbar()
	if health <= 0:
		is_dead = true
		die()
	hurt = false

func die():
	hurt = true
	dead = true
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.play("dead")
	await $AnimatedSprite2D.animation_finished
	$"../Restart".visible = true
	queue_free()

func update_healthbar():
	healthBar[health].value = 0

func _on_jump_timer_timeout() -> void:
	canDoubleJump = false

func set_movement_enabled(value: bool) -> void:
	can_move = value
