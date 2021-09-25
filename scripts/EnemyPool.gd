extends Node2D

signal wave_cleared

var max_enemies
var passed_enemies = 0
var is_cleared = false


func _process(delta):
	is_cleared = is_stage_cleared()
	if is_cleared:
		emit_signal("wave_cleared")


func is_stage_cleared() -> bool:
	var children = get_children().size()
	if max_enemies == passed_enemies and children == 0:
		return true
	return false
