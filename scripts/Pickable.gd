extends Area2D


export(String, "health", "shield", "energy", "weapon boost") var type
export var amount := 100.0
export var timer = 5

func _ready():
	$Timer.start(timer)

func _on_Pickable_body_entered(body):
	body.pick_up(type, amount)
	queue_free()


func _on_Timer_timeout():
	queue_free()
