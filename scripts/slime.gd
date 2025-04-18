extends CharacterBody2D
 
class_name slimeEnemy

const speed = 30
var is_frog_chase: bool

var health = 80
var health_max = 80
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 20
var is_dealing_damage: bool = false

var dir: Vector2
const gravity = 900
var knockback_force = 200
var is_roaming: bool = true

var player:CharacterBody2D 
var playe_in_area = false

func _process(delta):
	if !is_on_floor():
		velocity.y += gravity*delta
		velocity.x = 0
	player = $"../player"
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:  
		if !is_frog_chase:
			velocity += dir * speed * delta
		elif is_frog_chase and !taking_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x 
		is_roaming = true
		
	elif dead:
		velocity.x = 0
		
func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("walk")
		if dir.x == -1:
			anim_sprite.flip_h = true
		elif dir.x == 1: 
			anim_sprite.flip_h = false
	elif !dead and taking_damage and !is_dealing_damage:
		anim_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		anim_sprite.plau("death")
		await get_tree().create_timer(1.2).timeout
		handle_death()
		
func handle_death(): #add points here
	self.queue_free()

func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.2, 2.0, 2.5])
	if !is_frog_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0 

func choose(array):
	array.shuffle()
	return array.front()


#func _on_slime_hit_box_area_entered(area: Area2D) -> void:
	#var damage = global damage
