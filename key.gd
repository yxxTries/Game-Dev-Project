extends Area2D


# Called when the node enters the scene tree for the first time.

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		$"../broom2".start_movement()
		print("key obtained")
		$TileMapLayer.hide()
