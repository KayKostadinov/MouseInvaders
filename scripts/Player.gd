extends KinematicBody2D

var move_speed := 400
var hp := 100
var attack_damage := 20
var attack_cd := .5
var is_shielded := false
var velocity

onready var sprite = $Sprite


func _init():
	Global.Player = self


func _physics_process(delta):
	move()


func get_input() -> Vector2:
	var x = Input.get_action_strength("P1_right") - Input.get_action_strength("P1_left")
	var y = Input.get_action_strength("P1_down") - Input.get_action_strength("P1_up")
	return Vector2(x, y).normalized()


func move():
	velocity = move_and_slide(get_input() * move_speed)



func take_damage(damage):
	hp -= damage
	sprite.play("damage")


func _on_Sprite_animation_finished():
	sprite.play("idle")

