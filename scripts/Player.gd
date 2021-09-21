extends Character


var velocity


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

