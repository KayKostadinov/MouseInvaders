extends Control


var player_hp
var player_energy

onready var hp_bar = $hp
onready var energy = $energy

export var hp_colors = [Color(), Color(), Color()]


func _process(delta):
	hp_bar.value = player_hp
	energy.value = player_energy
	set_hp_color(player_hp)


func set_hp_color(hp):
	if hp > 65:
		hp_bar.modulate = hp_colors[0]
	elif hp > 40:
		hp_bar.modulate = hp_colors[1]
	else:
		hp_bar.modulate = hp_colors[2]
