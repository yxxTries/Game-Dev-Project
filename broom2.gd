extends Path2D

@export var loop = true
@export var speed = 0
@export var speed_scale = 0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready() -> void:
	set_process(false)
	
func start_movement() -> void:
	speed = 0.5
	var speed_scale = 0.5
	print("movement started")
	animation.play("move")
	animation.speed_scale = speed_scale
	set_process(true)

func _process(delta: float):
	path.progress += speed
