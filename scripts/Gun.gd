extends Node2D

var bullet = preload("res://scenes/Bullet.tscn")
var bullet_speed = Vector2(1000, 1000)

onready var BulletManager = Global.BulletManager
onready var GunTip = $GunTip


func _physics_process(delta):
	look_at(get_global_mouse_position())
	fire()


func instance_bullet():
	var bullet_instance = bullet.instance()
	bullet_instance.position = GunTip.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.velocity = bullet_instance.velocity.rotated(rotation)
	BulletManager.add_child(bullet_instance)

func fire():
	var fire = Input.is_action_just_pressed("fire")
	
	if fire:
		instance_bullet()

