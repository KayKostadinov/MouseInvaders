extends IDamageable
class_name Player


export var move_speed := 400
export var attack_damage := 10
export var energy := 100

var attack_cd = 1.0
var velocity
var is_stunned := false
var dash = 1
var is_charging = false
var can_shoot = true

onready var BulletManager = Global.BulletManager
onready var sprite = $Sprite
onready var effects = $Effects
onready var stunTimer = $Stun
onready var Gun = $Gun
onready var ui = $Control
onready var dashTimer = $Dash
onready var invTimer = $Inv
onready var RespawnTimer = $Respawn
onready var Charge = $Charge
onready var isHit = $IsHit
onready var shieldSFX = $ShieldSFX
onready var chargeSFX = $ChargeSFX
onready var cameraShake = Global.camera
onready var ShootCD = $ShootCD

var Melee = preload("res://scenes/Melee.tscn")
var Shockwave = preload("res://scenes/Players/Shock.tscn")

func _init():
	if Global.Players.find(self) == -1:
		Global.Players.append(self)


func _ready():
	Gun.damage = attack_damage
	Gun.shooter = self


func _physics_process(delta):
	if is_dead and RespawnTimer.is_stopped():
		RespawnTimer.start(3)
	
	if is_stunned or is_dead or is_charging:
		return
	move(delta)
	melee_attack()
	fire()
	recharge_shield()


func _process(_delta):
	die()
	sound_effects()
	Gun.is_stunned = is_stunned
	Gun.is_dead = is_dead
	Gun.damage = attack_damage
	effects.is_stunned = is_stunned
	effects.is_shielded = is_shielded
	effects.is_dead = is_dead
	ui.player_hp = hp
	ui.player_energy = energy


func get_input() -> Vector2:
	var x = Input.get_action_strength("P1_right") - Input.get_action_strength("P1_left")
	var y = Input.get_action_strength("P1_down") - Input.get_action_strength("P1_up")
	return Vector2(x, y).normalized()


func move(delta):

	if dash > 1:
		var move_direction = get_input()
		if move_direction == Vector2.ZERO:
			move_direction = Vector2(1, 0)
		velocity = move_and_slide(move_direction * move_speed * dash)
		return
	velocity = move_and_slide(get_input() * move_speed)


func take_damage(damage, shooter=null):
	var current_hp = hp
	.take_damage(damage, shooter)
	if current_hp != hp:
		isHit.play()
		cameraShake.start(.01, 100, 1)
		sprite.play("damage")


func _on_Sprite_animation_finished():
	if sprite.animation == "die":
		sprite.playing = false
		return
	sprite.play("idle")


func stun(duration=1):
	if is_invulnerable:
		return
	cameraShake.start()
	is_stunned = true
	stunTimer.start(duration)
	sprite.play("stunned")

func _on_Stun_timeout():
	is_stunned = false


func die():
	if is_dead:
		sprite.play("die")


func melee_attack(_identifier="P1"):
	if Input.is_action_just_pressed(_identifier + "_melee"):
		if energy >= 30:
			energy -= 30
			is_invulnerable = true
			var melee_instance = Melee.instance()
			melee_instance.damage = attack_damage * 10
			var look_direction = melee_instance.global_position + get_input()
			melee_instance.look_at(look_direction)
			melee_instance.get_node("Sprite").play("attack")
			self.add_child(melee_instance)
			melee_dash(melee_instance.global_rotation)


func melee_dash(look_direction):
	cameraShake.start()
	var shockwave_instance = Shockwave.instance()
	shockwave_instance.rotation = look_direction
	shockwave_instance.global_position = global_position
	BulletManager.add_child(shockwave_instance)
	dash = 5
	dashTimer.start()
	invTimer.start()


func _on_Dash_timeout():
	dash = 1


func _on_Inv_timeout():
	is_invulnerable = false


func fire(_identifier="P1"):
	if Input.is_action_pressed(_identifier + "_fire") and can_shoot:
		Gun.fire()
		if attack_cd > 0:
			ShootCD.start(attack_cd)
			can_shoot = false


func _on_Respawn_timeout():
	RespawnTimer.stop()
	is_dead = false
	hp = 100
	energy = 100
	is_shielded = true


func set_energy(amount:int):
	energy += amount
	if energy > 100:
		energy = 100
	if energy < 0:
		energy = 0


func recharge_shield():
	if Input.is_action_just_pressed("shield") and not is_shielded:
		if energy >= 50:
			Charge.visible = true
			chargeSFX.play()
			Charge.play("default")
			is_charging = true


func set_shield_on():
	is_shielded = true
	effects.is_shielded = is_shielded


func _on_Charge_animation_finished():
	Charge.visible = false
	is_charging = false
	Charge.stop()
	Charge.frame = 0
	set_energy(-50)
	set_shield_on()


func sound_effects():
	if is_shielded and not shieldSFX.playing:
		shieldSFX.play()
	if not is_shielded and shieldSFX.playing:
		shieldSFX.stop()


func pick_up(type, amount):
	if type == "shield":
		set_shield_on()
		return
	if type == "health":
		if hp + amount > 100:
			hp = 100
			return
		hp += amount
		return
	if type == "energy":
		set_energy(amount)
		return
	if type == "weapon boost":
		attack_cd -= amount
		if attack_cd < 0:
			attack_cd = 0
		return


func _on_ShootCD_timeout():
	can_shoot = true
