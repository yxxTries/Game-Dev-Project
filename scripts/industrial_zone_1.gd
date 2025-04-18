extends Node2D


func _ready() -> void:
	$"../Restart".visible = false
	$"../player/HealthBar".visible = false
	$"../player/Score".visible = false
	$"../player".has_gun = true
	$"../player".has_doubleJump = true
	get_tree().paused = true
	$"../player/AnimatedSprite2D".play("idle")
	$"../AnimationPlayer".play("fade_in")
	await $"../AnimationPlayer".animation_finished
	get_tree().paused = false
	Dialogic.start("level3")
	$"../player/HealthBar".visible = true
	$"../player/Score".visible = true

func _on_next_stage_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	$"../AnimationPlayer".play("fade_out")
	await $"../AnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://levels/industrialZone2.tscn")


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
