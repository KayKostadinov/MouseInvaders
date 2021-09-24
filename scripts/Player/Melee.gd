extends Area2D

var damage = 0
var direction = Vector2(1, 0)

#func _process(delta):
#	if direction == Vector2.ZERO:
#		direction = Vector2(1, 0)
#	look_at(global_position + direction)


func _on_Melee_body_entered(body):
	if body is Enemy:
		body.take_damage(damage)
		queue_free()


func _on_Timer_timeout():
	queue_free()
