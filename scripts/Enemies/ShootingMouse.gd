extends Enemy
class_name ShootingMouse


var points = []

onready var BulletManager = Global.BulletManager


func _ready():
	points = EnemyManagar.get_child(0).get_children()


func _physics_process(delta):
	move(delta)


func move(delta):
	if not is_dead:
		look_at(Player.global_position)
		collider = move_and_collide(direction * delta * ms)


func shoot():
	sprite.play("shoot")
	var bullet_instance = bullet.instance()
	bullet_instance.position = GunTip.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.velocity = bullet_instance.velocity.rotated(rotation)
	BulletManager.add_child(bullet_instance)


func _on_Timer_timeout():
	shoot()
	random_timer()
	timer.start()
