extends IDamageable
class_name Player


var move_speed := 400
var attack_damage := 20
var attack_cd := .5
var velocity
var is_stunned := false


onready var sprite = $Sprite
onready var effects = $Effects
onready var stunTimer = $Stun
onready var Gun = $Gun
onready var ui = $Control


func _init():
	Global.Player = self
	is_shielded = true
	


func _physics_process(_delta):
	move()


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


func move():
	if is_stunned or is_dead:
		return
	velocity = move_and_slide(get_input() * move_speed)


func take_damage(damage):
	.take_damage(damage)
	sprite.play("damage")


func _on_Sprite_animation_finished():
	if sprite.animation == "die":
		sprite.playing = false
		return
	sprite.play("idle")


func stun(duration=1):
	is_stunned = true
	stunTimer.start(duration)
	sprite.play("stunned")

func _on_Stun_timeout():
	is_stunned = false


func die():
	if is_dead:
		sprite.play("die")
