extends Area2D
class_name Bullet


var shooter
var velocity = Vector2(1000, 0)
var damage = 20


func _physics_process(delta):
	translate(velocity * delta)


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()


func _on_Bullet_body_entered(body):
	if body is IDamageable:
		if body.is_invulnerable:
			queue_free()
			return
		
		body.take_damage(damage, shooter)
		queue_free()

