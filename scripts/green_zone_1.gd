extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../player/HealthBar".visible = false
	$"../player/Score".visible = false
	get_tree().paused = true
	$"../AnimationPlayer".play("fade_in")
	await $"../AnimationPlayer".animation_finished
	get_tree().paused = false
	Dialogic.start("timeline")
	Dialogic.signal_event.connect(_on_signal)

func _on_signal(argument:String):
	if argument == "intro":
		$"../Tutorial/movement".visible = true
		
	
	
func _on_credits_timer_timeout():
	$"../AnimationPlayer".play("bars_fade_in")
	await $"../AnimationPlayer".animation_finished
	$"../Credits/TitleCard".visible = true
	await get_tree().create_timer(2).timeout
	$"../Credits/TitleCard".visible = false
	await get_tree().create_timer(2).timeout
	$"../Credits/Authors".visible = true
	await get_tree().create_timer(2).timeout
	$"../Credits/Authors".visible=false
	await get_tree().create_timer(2).timeout
	$"../AnimationPlayer".play("bars_fade_out")
	await $"../AnimationPlayer".animation_finished
	
	
func _on_gun_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	$"../player".has_gun = true
	$"../Gun".visible = false
	$"../Tutorial/movement".visible = false
	await get_tree().create_timer(2).timeout
	$"../Tutorial/shoot".visible = true
	await get_tree().create_timer(2).timeout
	$"../Tutorial/shoot".visible = false
	$"../CreditsTimer".start(1)


func _on_next_stage_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	$"../AnimationPlayer".play("fade_out")
	await $"../AnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://levels/greenZone2.tscn")
