extends Node2D

var bullet = preload("res://scenes/Bullet.tscn")
var bullet_speed = Vector2(1000, 1000)
var is_stunned = false
var is_dead = false
var use_controller = false

onready var BulletManager = Global.BulletManager
onready var GunTip = $GunTip
onready var sprite = $Sprite
onready var player = get_tree().get_root()


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
	BulletManager.add_child(bullet_instance)

func fire():

	sprite.play("fire")
	instance_bullet()



func _on_Sprite_animation_finished():
	sprite.play("idle")


func look_at_joystick():
	var controller_angle = Vector2.ZERO
	var xAxisRL = Input.get_joy_axis(0, JOY_ANALOG_RX)
	var yAxisUD = Input.get_joy_axis(0, JOY_ANALOG_RY)
	controller_angle = Vector2(xAxisRL, yAxisUD).angle()
	rotation = controller_angle
