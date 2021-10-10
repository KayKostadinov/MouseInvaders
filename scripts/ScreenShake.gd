extends Node2D


const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

onready var camera = get_parent()
onready var shakeTween = $ShakeTween
onready var frequency = $Frequency
onready var duration = $Duration


func _init():
	Global.camera = self


func start(_duration = 0.2, _frequency = 15, _amplitude = 16, _priority = 0):
	if _priority >= self.priority:
		self.amplitude = _amplitude
		self.priority = _priority
		duration.wait_time = _duration
		frequency.wait_time = 1 / float(_frequency)
		duration.start()
		frequency.start()
		new_shake()


func new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	shakeTween.interpolate_property(camera, "offset", camera.offset, rand, frequency.wait_time, TRANS, EASE)
	shakeTween.start()


func reset():
	shakeTween.interpolate_property(camera, "offset", camera.offset, Vector2.ZERO, frequency.wait_time, TRANS, EASE)
	shakeTween.start()
	self.priority = 0


func _on_Frequency_timeout():
	new_shake()


func _on_Duration_timeout():
	reset()
	frequency.stop()
