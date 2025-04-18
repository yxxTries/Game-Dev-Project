extends Area2D
var pos : Vector2

var direction := Vector2.RIGHT
var speed = 2000
var facing_left = false

func _ready() -> void:
	global_position = pos


func _physics_process(delta: float) -> void:
	if facing_left:
		direction = Vector2.LEFT
	else:
		direction = Vector2.RIGHT
		
	position += direction * speed * delta
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.hit()
		queue_free()
	elif body.is_in_group("enemy"):
		body.hit()
		queue_free()
