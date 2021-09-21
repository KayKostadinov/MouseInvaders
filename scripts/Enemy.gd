extends KinematicBody2D
class_name Enemy


var ms = 100
var collider
var hp = 100

onready var Player = Global.Player
onready var sprite = $Sprite


func _physics_process(delta):
	move(delta)


func _process(delta):
	position_sprite()
	


func take_damage(damage):
	hp -= damage
	if hp <= 0:
		queue_free()


func move(delta):
	look_at(Player.global_position)
	print(get_direction())
	var direction = get_direction()
	collider = move_and_collide(direction * delta * ms)


func get_direction() -> Vector2:
	return (Player.global_position - global_position).normalized()


func position_sprite():
	if get_direction().x < 0:
		sprite.flip_v = true
		return
	sprite.flip_v = false
