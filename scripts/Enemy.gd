extends IDamageable
class_name Enemy


var ms = 100
var collider
var direction = Vector2.ZERO
var damage_multiplier = 1
var player
var already_collided = false
export var damage = 10

onready var Players = Global.Players
onready var sprite = $Sprite
onready var timer = $Timer
onready var GunTip = $GunTip

var HealthPickup = preload("res://scenes/Pickables/PickHealth.tscn")
var ShieldPickup = preload("res://scenes/Pickables/PickShield.tscn")
var EnergyPickup = preload("res://scenes/Pickables/PickEnergy.tscn")
var WeaponPickup = preload("res://scenes/Pickables/PickWeapon.tscn")
var bullet = preload("res://scenes/EnemyBullet.tscn")


func _ready():
	random_timer()
	player = pick_player()


func _physics_process(_delta):
	die()
	kamikaze()


func _process(_delta):
	if player.is_dead:
		player = pick_player()
	
	direction = get_direction()
	position_sprite()



func take_damage(damage, shooter=null):
	.take_damage(damage, shooter)
	if is_dead:
		$CollisionShape2D.set_deferred("disabled", true)
		randomize()
		var dropChance = randi() % 100 + 1
		if dropChance <= 7:
			instance_pickup(HealthPickup)
		elif dropChance <= 15:
			instance_pickup(ShieldPickup)
		elif dropChance <= 25:
			instance_pickup(EnergyPickup)
#		elif dropChance <= 40:
		else:
			instance_pickup(WeaponPickup)


func instance_pickup(pickup_node):
	var pickupInstance = pickup_node.instance()
	pickupInstance.global_position = global_position
	get_tree().root.add_child(pickupInstance)


func random_timer():
	randomize()
	timer.wait_time = (randi() % 5 + 1) + randf()


func get_direction() -> Vector2:
	if !player: return Vector2()
	return (player.global_position - global_position).normalized()


func position_sprite():
	if !player: return
	look_at(player.global_position)
	if direction.x < 0:
		sprite.flip_v = true
		return
	sprite.flip_v = false


func kamikaze():
	if collider and collider.collider is IDamageable:
		if not already_collided:
			already_collided = true
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


func pick_player():
	var players_alive = []
	for p in Players:
		if p and not p.is_dead:
			players_alive.append(p)
	
	if players_alive.size() == 0:
		var _change_scene = get_tree().change_scene("res://scenes/Menus/MainMenu.tscn")
		return
	
	randomize()
	var index = randi() % players_alive.size()
	
	return Players[index]


func _on_Enemy_tree_exited():
	pass # Replace with function body.
