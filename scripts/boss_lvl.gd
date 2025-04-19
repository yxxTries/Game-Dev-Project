extends Node2D

@onready var player = $CharacterBody2D
@onready var anim = player.get_node("AnimatedSprite2D")

func _ready() -> void:
	await get_tree().process_frame  # ensure player is ready

	player.has_doubleJump = true
	player.has_gun = true
	player.set_movement_enabled(false)

	Dialogic.connect("signal_event", Callable(self, "_on_dialogic_signal"))
	Dialogic.start("boss_intro")
	

func _on_dialogic_signal(event_name):
	if event_name == "dialogue_complete":
		print("✅ Dialogue finished")
		player.set_movement_enabled(true)
		


func _on_dialogue_finished(timeline_name):
	print("✅ Dialogue finished. Switching to player camera.")
	player.input_enabled = true
 
func _on_next_stage_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
		get_tree().change_scene_to_file("res://levels/ending.tscn")

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
