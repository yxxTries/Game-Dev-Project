extends Node2D
const SPEED = 60
var direction = 1
@onready var right: RayCast2D = $Right
@onready var left: RayCast2D = $Left
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if right.is_colliding():
		direction = -1
		sprite.flip_h = true
	if left.is_colliding():
		direction = 1
		sprite.flip_h = false
	position.x += direction * SPEED * delta 
