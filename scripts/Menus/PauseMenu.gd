extends MainMenu


func _on_Start_pressed():
	Global.Players = []
	get_tree().paused = false
	var _change_scene = get_tree().change_scene("res://scenes/Level.tscn")



func _on_Resume_pressed():
	hide()
	get_tree().paused = false
