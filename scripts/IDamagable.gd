extends KinematicBody2D
class_name IDamageable

export var hp := 100
var is_dead = false
var is_shielded = false
var is_invulnerable = false

func take_damage(damage, shooter=null):
	if is_invulnerable:
		damage = 0
		return
	
	if is_shielded:
		is_shielded = false
		return
	
	if shooter:
		shooter.set_energy(5)
	
	hp -= damage
	if hp <= 0:
		is_dead = true
