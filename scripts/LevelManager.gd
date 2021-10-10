extends Node2D
class_name Level


var shootingMouse = preload("res://scenes/Enemies/ShootingMouse.tscn")
var homingMouse = preload("res://scenes/Enemies/HomingMouse.tscn")

onready var EnemyManager = $EnemyManager
onready var EnemyPool = $EnemyManager/EnemyPool
onready var enemy_spawn_timer = $EnemySpawn
onready var wave_title = $Title/VBoxContainer/WaveTitle
onready var level_label = $Title/VBoxContainer/LevelLabel
onready var wave_timer = $WaveTimer

export var wave = 1
export var max_shooters = 3
export var max_homing = 0
export var enemy_timer = 1

var current_shooters = 0
var current_homing = 0


func _ready():
	EnemyPool.connect("wave_cleared", self, "_on_wave_cleared")
	EnemyPool.max_enemies = max_shooters + max_homing


func _process(_delta):
	pause()
	EnemyPool.passed_enemies = current_homing + current_shooters


func _on_EnemySpawn_timeout():
	if current_shooters < max_shooters:
		EnemyManager.instance_mice(shootingMouse, wave)
		current_shooters += wave
	
	if current_homing < max_homing:
		EnemyManager.instance_mice(homingMouse, wave)
		current_homing += wave


func _on_wave_cleared():
	enemy_spawn_timer.stop()
	wave_timer.start(5)
	wave += 1
	wave_title.text = "Wave %d" % wave
	wave_title.visible = true
	current_homing = 0
	current_shooters = 0


func next_wave():
	enemy_spawn_timer.start(enemy_timer)
	
	if wave == 10:
		boss_level()
		return
	
	if wave < 5:
		max_shooters += 1
		max_homing += 1
	elif wave >= 5:
		max_shooters += 2
		max_homing += 2
	
	EnemyPool.max_enemies = max_shooters + max_homing


func _on_WaveTimer_timeout():
	wave_timer.stop()
	wave_title.visible = false
	next_wave()


# override in each level
func boss_level():
	pass


func pause():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		var pauseMenu = $Menus/PauseMenu
		pauseMenu.show()
