extends IDamageable
class_name Player


var move_speed := 400
var attack_damage := 20
var attack_cd := .5
var velocity
var is_stunned := false

onready var sprite = $Sprite
onready var stunTimer = $Stun
onready var Gun = $Gun


func _init():
	Global.Player = self


func _physics_process(_delta):
	move()


func _process(_delta):
	Gun.is_stunned = is_stunned


func get_input() -> Vector2:
	var x = Input.get_action_strength("P1_right") - Input.get_action_strength("P1_left")
	var y = Input.get_action_strength("P1_down") - Input.get_action_strength("P1_up")
	return Vector2(x, y).normalized()


func move():
	if is_stunned:
		return
	velocity = move_and_slide(get_input() * move_speed)


func take_damage(damage):
	.take_damage(damage)
	sprite.play("damage")


func _on_Sprite_animation_finished():
	sprite.play("idle")


func stun(duration=1):
	is_stunned = true
	stunTimer.start(duration)
	sprite.play("stunned")

func _on_Stun_timeout():
	is_stunned = false
