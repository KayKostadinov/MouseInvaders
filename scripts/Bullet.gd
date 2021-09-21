extends Area2D


var velocity = Vector2(500, 0)
var damage = 20


func _physics_process(delta):
	translate(velocity * delta)


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()


func _on_Bullet_body_entered(body):
	body.take_damage(damage)
	queue_free()

