extends Node2D


onready var timer = $Timer
var shootingMouse = preload("res://scenes/Enemies/ShootingMouse.tscn")
var homingMouse = preload("res://scenes/Enemies/HomingMouse.tscn")

export var max_shooters = 10
export var max_homing = 10

var current_shooters = 0
var current_homing = 0

func _init():
	Global.EnemyManager = self


func instance_mice(mouse):
	var mouse_instance = mouse.instance()
	randomize()
	mouse_instance.position = get_random_position()
	add_child(mouse_instance)


func _on_Timer_timeout():
	if current_shooters < max_shooters:
		instance_mice(shootingMouse)
		current_shooters += 1
	
	if current_homing < max_homing:
		instance_mice(homingMouse)
		current_homing += 1
	
	timer.start()


func get_random_position() -> Vector2:
	var x = rand_range(0, 1920)
	var y = rand_range(0, 1080)
	
	var half_x = 1920/2
	var half_y = 1080/2
	
	if x <= (half_x):
		x = -20
	else:
		x = 1940
	
	return Vector2(x, y)
