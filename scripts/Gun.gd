extends Node2D

var bullet = preload("res://scenes/Bullet.tscn")
var bullet_speed = Vector2(1000, 1000)
var is_stunned = false
var is_dead = false
var use_controller = false
var damage

onready var BulletManager = Global.BulletManager
onready var GunTip = $GunTip
onready var sprite = $Sprite


func _physics_process(_delta):
	if is_stunned or is_dead:
		return
	
	if use_controller:
		look_at_joystick()
	else:
		look_at(get_global_mouse_position())


func instance_bullet():
	var bullet_instance = bullet.instance()
	bullet_instance.position = GunTip.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.velocity = bullet_instance.velocity.rotated(rotation)
	bullet_instance.damage = damage
	BulletManager.add_child(bullet_instance)

func fire():

	sprite.play("fire")
	instance_bullet()



func _on_Sprite_animation_finished():
	sprite.play("idle")

# TODO: fix this shit
func look_at_joystick():
	look_at(global_position + get_controller_aim())

func get_controller_aim():
	var x = Input.get_action_strength("controller_aim_right")-Input.get_action_strength("controller_aim_left")
	var y = Input.get_action_strength("controller_aim_down") - Input.get_action_strength("controller_aim_up")
	return Vector2(x, y).normalized()
