extends Node2D


func _ready() -> void:
		Dialogic.start("level7")

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_next_stage_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	get_tree().change_scene_to_file("res://levels/boss_lvl.tscn")


func _on_kill_zone_body_entered(body: Node2D) -> void:
	$"../Restart".visible = true
