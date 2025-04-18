extends Area2D
func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		body.has_doubleJump = true
		queue_free()
		$"../DoubleJumpTut/Label".visible = true
		await get_tree().create_timer(2).timeout
		$"../DoubleJumpTut/Label".visible = false
