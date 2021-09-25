extends Node2D


var shootingMouse = preload("res://scenes/Enemies/ShootingMouse.tscn")
var homingMouse = preload("res://scenes/Enemies/HomingMouse.tscn")

onready var EnemyManager = $EnemyManager
onready var EnemyPool = $EnemyManager/EnemyPool
onready var timer = $EnemySpawn

export var wave = 1

export var max_shooters = 5
export var max_homing = 5
var current_shooters = 0
var current_homing = 0
export var enemy_timer = 5


func _ready():
	timer.start(enemy_timer)
	EnemyPool.connect("wave_cleared", self, "_on_wave_cleared")
	EnemyPool.max_enemies = max_shooters + max_homing


func _process(_delta):
	pause()
	EnemyPool.passed_enemies = current_homing + current_shooters


func _on_EnemySpawn_timeout():
	if current_shooters < max_shooters:
		EnemyManager.instance_mice(shootingMouse)
		current_shooters += 1
	
	if current_homing < max_homing:
		EnemyManager.instance_mice(homingMouse)
		current_homing += 1
	
	timer.start(enemy_timer)


func _on_wave_cleared():
	print("wave cleared")
	wave += 1
	current_homing = 0
	current_shooters = 0
	
	if wave < 5:
		max_shooters *= 2
		max_homing = 0
		enemy_timer -= enemy_timer * .25
	elif wave == 5:
		max_shooters = 5
		max_homing = 3
		enemy_timer = 4
	elif wave > 5:
		max_shooters *= 2
		max_homing *= 2
		enemy_timer -= enemy_timer * .25
	
	EnemyPool.max_enemies = max_shooters + max_homing


func pause():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		var pauseMenu = $PauseMenu
		pauseMenu.show()
