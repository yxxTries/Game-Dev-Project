extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	$AnimationPlayer.play("fade_in")
	await get_tree().create_timer(3).timeout
	get_tree().paused = false
	Dialogic.start("timeline")
