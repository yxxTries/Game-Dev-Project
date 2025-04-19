extends Area2D

@onready var timer: Timer = $Timer


func _on_body_entered(body):
	$"../Restart".visible = true
