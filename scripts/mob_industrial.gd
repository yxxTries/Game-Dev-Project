extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var shoot_interval := 2.0 # Time between shots
@export var bullet_speed := 400

func _ready():
	$Timer.wait_time = shoot_interval
	$Timer.start()
	scale.x *= -1
	$Timer.timeout.connect(shoot)
	

func shoot():
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = $Marker2D.global_position
		bullet.speed = bullet_speed if not is_flipped() else -bullet_speed
		get_parent().add_child(bullet)

func is_flipped() -> bool:
	return scale.x < 0 #depending on your enemy's behavior
