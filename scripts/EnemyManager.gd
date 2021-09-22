extends Node2D


onready var timer = $Timer
var shootingMouse = preload("res://scenes/Enemies/ShootingMouse.tscn")

export var max_shooters = 0


func _init():
	Global.EnemyManager = self


func instance_shooting_mice():
	var mouse_instance = shootingMouse.instance()
	randomize()
	mouse_instance.position = get_random_position()
	add_child(mouse_instance)


func _on_Timer_timeout():
	if max_shooters < 5:
		instance_shooting_mice()
		max_shooters += 1
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
