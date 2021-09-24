extends IDamageable
class_name Player


var move_speed := 400
var attack_damage := 20
var attack_cd := .5
var velocity
var is_stunned := false
var dash = 1

onready var sprite = $Sprite
onready var effects = $Effects
onready var stunTimer = $Stun
onready var Gun = $Gun
onready var ui = $Control
onready var dashTimer = $Dash
onready var invTimer = $Inv


var Melee = preload("res://scenes/Melee.tscn")


func _init():
	Global.Player = self


func _physics_process(delta):
	move(delta)
	melee_attack()
	fire()


func _process(_delta):
	die()
	Gun.is_stunned = is_stunned
	Gun.is_dead = is_dead
	effects.is_stunned = is_stunned
	effects.is_shielded = is_shielded
	effects.is_dead = is_dead
	ui.player_hp = hp


func get_input() -> Vector2:
	var x = Input.get_action_strength("P1_right") - Input.get_action_strength("P1_left")
	var y = Input.get_action_strength("P1_down") - Input.get_action_strength("P1_up")
	return Vector2(x, y).normalized()


func move(delta):
	if is_stunned or is_dead:
		return
	if dash > 1:
		var move_direction = get_input()
		if move_direction == Vector2.ZERO:
			move_direction = Vector2(1, 0)
		velocity = move_and_slide(move_direction * move_speed * dash)
		return
	velocity = move_and_slide(get_input() * move_speed)


func take_damage(damage):
	var current_hp = hp
	.take_damage(damage)
	if current_hp != hp:
		sprite.play("damage")


func _on_Sprite_animation_finished():
	if sprite.animation == "die":
		sprite.playing = false
		return
	sprite.play("idle")


func stun(duration=1):
	if is_invulnerable:
		return
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
		is_invulnerable = true
		collision_layer = 5
		print(collision_layer)
		var melee_instance = Melee.instance()
		melee_instance.damage = attack_damage * 10
		melee_instance.look_at(melee_instance.global_position + get_input())
		self.add_child(melee_instance)
		melee_dash()


func melee_dash():
	dash = 5
	dashTimer.start()
	invTimer.start()


func _on_Dash_timeout():
	dash = 1


func _on_Inv_timeout():
	is_invulnerable = false


func fire(_identifier="P1"):
	if Input.is_action_just_pressed(_identifier + "_fire"):
		Gun.fire()
