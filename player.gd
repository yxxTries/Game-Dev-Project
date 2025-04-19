extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var intro = true

func _physics_process(delta: float) -> void:
	#if intro:
		#$AnimatedSprite2D.play("wake_up")
		#await $AnimatedSprite2D.animation_finished
		#intro = false

	# Apply gravity correctly
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction
	var direction := Input.get_axis("run_left", "run_right")

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle animations
	if velocity.y < 0:  # Jumping
		$AnimatedSprite2D.play("jump")
	elif direction != 0:  # Running
		$AnimatedSprite2D.play("run_right")
		$AnimatedSprite2D.flip_h = direction < 0
	else:  # Idle
		$AnimatedSprite2D.play("idle")

	move_and_slide()
