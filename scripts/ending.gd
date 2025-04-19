extends Node2D

var dialogue_started := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("Brr")
	if body.name == "player":  # Adjust if your player's node has a different name
		if body.has_method("set_movement_enabled"):
			body.set_movement_enabled(false)

		Dialogic.start("ending")

		await Dialogic.timeline_ended

		if body.has_method("set_movement_enabled"):
			body.set_movement_enabled(true)
