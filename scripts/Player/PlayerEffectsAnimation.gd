extends AnimatedSprite

var is_stunned := false
var is_shielded := false
var is_dead := false
var has_active_effects := false


func _process(_delta):
	set_active()
	controller()


func set_active():
	if is_dead:
		has_active_effects = false
		return
	
	has_active_effects = is_stunned or is_shielded


func controller():
	if is_dead:
		play("off")
	
	if !has_active_effects:
		play("off")
		return
	
	if is_stunned:
		play("stun")
		return
	
	if is_shielded:
		play("shield")
		return
