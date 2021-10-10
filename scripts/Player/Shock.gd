extends Node2D



func _ready():
	$Shockwave.play("default")


func _on_DashSFX_finished():
	self.queue_free()


func _on_Shockwave_animation_finished():
	$Shockwave.visible = false
