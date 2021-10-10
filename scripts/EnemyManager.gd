extends Node2D


onready var EnemyPool = $EnemyPool


func _init():
	Global.EnemyManager = self


func instance_mice(mouse, batch):
	for i in batch:
		var mouse_instance = mouse.instance()
		randomize()
		mouse_instance.position = get_random_position()
		EnemyPool.add_child(mouse_instance)


func get_random_position() -> Vector2:
	var x = rand_range(0, 1920)
	var y = rand_range(0, 1080)
	
	var half_x = 1920/2
	var _half_y = 1080/2
	
	if x <= (half_x):
		x = -20
	else:
		x = 1940
	
	return Vector2(x, y)
