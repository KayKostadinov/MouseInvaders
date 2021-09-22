extends KinematicBody2D
class_name IDamageable

var hp := 100
var is_dead = false
var is_shielded = false

func take_damage(damage):
	if is_shielded:
		is_shielded = false
		return
	
	hp -= damage
	if hp <= 0:
		is_dead = true
