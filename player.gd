extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var intro  = true

func _physics_process(delta: float) -> void:
	if intro:
		$AnimatedSprite2D.play("wake_up")
		await $AnimatedSprite2D.animation_finished
		intro = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("run_left", "run_right")
	
	if velocity.x < 0:
		$AnimatedSprite2D.play("run_right")
		$AnimatedSprite2D.flip_h = true
		
	elif velocity.x > 0:
		$AnimatedSprite2D.play("run_right")
		$AnimatedSprite2D.flip_h = false
	
	elif velocity.y < 0:
		$AnimatedSprite2D.play("jump") 
	else:
		$AnimatedSprite2D.play("idle")
		
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
