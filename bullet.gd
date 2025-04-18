extends CharacterBody2D

@export var speed := 400

func _physics_process(delta):
	velocity.x = speed
	move_and_slide()

	# Destroy bullet when it goes off-screen
	if not get_viewport_rect().has_point(global_position):
		queue_free()
