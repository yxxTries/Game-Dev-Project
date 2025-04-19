extends Area2D

@export var speed := 500  # ✅ Now this property exists
var velocity := Vector2.ZERO

func _process(delta):
	position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("hit"):
			body.hit()
		queue_free()
