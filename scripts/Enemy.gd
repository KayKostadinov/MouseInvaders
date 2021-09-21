extends KinematicBody2D
class_name Enemy


var ms = 100
var collider
var hp = 100
var direction = Vector2.ZERO
var is_dead = false

onready var Player = Global.Player
onready var sprite = $Sprite
onready var timer = $Timer

var bullet = preload("res://scenes/EnemyBullet.tscn")

onready var BulletManager = Global.BulletManager
onready var GunTip = $GunTip

func _ready():
	randomize()
	timer.wait_time = randi() % 5 + 1

func _physics_process(delta):
	die()
	move(delta)
	kamikaze()
	


func _process(delta):
	direction = get_direction()
	position_sprite()


func take_damage(damage):
	hp -= damage
	if hp <= 0:
		is_dead = true
		$CollisionShape2D.disabled = true


func move(delta):
	if not is_dead:
		look_at(Player.global_position)
		collider = move_and_collide(direction * delta * ms)


func get_direction() -> Vector2:
	return (Player.global_position - global_position).normalized()


func position_sprite():
	if direction.x < 0:
		sprite.flip_v = true
		return
	sprite.flip_v = false


func kamikaze():
	if collider and collider.collider.name == "Player":
		collider.collider.take_damage(10)
		take_damage(100)


func _on_Sprite_animation_finished():
	if sprite.animation.get_basename() == "die":
		queue_free()
	else:
		sprite.play("idle")


func die():
	if is_dead:
		sprite.play("die")
		sprite.scale.x = 1
		sprite.scale.y = 1


func shoot():
	sprite.play("shoot")
	var bullet_instance = bullet.instance()
	bullet_instance.position = GunTip.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.velocity = bullet_instance.velocity.rotated(rotation)
	BulletManager.add_child(bullet_instance)


func _on_Timer_timeout():
	shoot()
	timer.start()

