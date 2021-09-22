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
		look_at(Player.global_position)
		collider = move_and_collide(direction * delta * ms) 


func kamikaze():
	if collider and collider.collider is IDamageable:
		collider.collider.take_damage(5)
		collider.collider.stun()
		move_away = true
		moveTimer.start()


func _on_MoveAway_timeout():
	move_away = false
