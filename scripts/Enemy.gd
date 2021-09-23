extends IDamageable
class_name Enemy



var ms = 100
var collider
var direction = Vector2.ZERO
var damage_multiplier = 1
export var damage = 10

onready var Player = Global.Player
onready var sprite = $Sprite
onready var timer = $Timer

var bullet = preload("res://scenes/EnemyBullet.tscn")

onready var GunTip = $GunTip

func _ready():
	random_timer()


func _physics_process(_delta):
	die()
	kamikaze()


func _process(_delta):
	direction = get_direction()
	position_sprite()


func take_damage(damage):
	.take_damage(damage)
	if is_dead:
		$CollisionShape2D.set_deferred("disabled", true)


func random_timer():
	randomize()
	timer.wait_time = (randi() % 5 + 1) + randf()


func get_direction() -> Vector2:
	return (Player.global_position - global_position).normalized()


func position_sprite():
	look_at(Player.global_position)
	if direction.x < 0:
		sprite.flip_v = true
		return
	sprite.flip_v = false


func kamikaze():
	if collider and collider.collider is IDamageable:
		collider.collider.take_damage(10)
		take_damage(hp)


func _on_Sprite_animation_finished():
	if sprite.animation.get_basename() == "die":
		queue_free()
	else:
		sprite.play("idle")


func die():
	if is_dead:
		sprite.play("die")


