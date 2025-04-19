extends Node2D


func _ready() -> void:
	var player = get_tree().get_nodes_in_group("player").front()
	if player == null:
		push_error("❌ No node found in 'player' group!")
		return

	player.SPEED = 300
	player.has_gun = true
	player.has_doubleJump = true

	var restart_button = get_node_or_null("Restart")
	if restart_button:
		restart_button.visible = false
	else:
		push_warning("⚠️ 'Restart' node not found under Canvas")
	player.get_node("HealthBar").visible = false
	player.get_node("Score").visible = false

	get_tree().paused = true
	player.get_node("AnimatedSprite2D").play("idle")
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	Dialogic.start("level4")
	player.get_node("HealthBar").visible = true
	player.get_node("Score").visible = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_next_stage_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	get_tree().change_scene_to_file("res://levels/ExclusionZone.tscn")
