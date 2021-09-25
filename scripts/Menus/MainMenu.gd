extends Control
class_name MainMenu


func _on_Quit_pressed():
	get_tree().quit()


func _on_Start_pressed():
	Global.Players = []
	var _change_scene = get_tree().change_scene("res://scenes/Level.tscn")
