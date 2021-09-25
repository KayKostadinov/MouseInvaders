extends Enemy


var move_away = false
onready var moveTimer = $MoveAway


func _physics_process(delta):
	move(delta, move_away)


func move(delta, _move_away):
	if not is_dead:
		if _move_away:
			collider = move_and_collide(-direction * delta * ms * 5) 
			return
		look_at(player.global_position)
		collider = move_and_collide(direction * delta * ms) 

var dont_stun = false

func kamikaze():
	if collider and collider.collider is IDamageable:
		if collider.collider.is_invulnerable:
			return
		
		if collider.collider.is_shielded:
			collider.collider.take_damage(damage * damage_multiplier)
			take_damage(hp)
			dont_stun = true
			return
		
		if not dont_stun:
			collider.collider.take_damage(damage * damage_multiplier)
			collider.collider.stun()
			move_away = true
			moveTimer.start()


func _on_MoveAway_timeout():
	move_away = false


func _on_Timer_timeout():
	pass # Replace with function body.
