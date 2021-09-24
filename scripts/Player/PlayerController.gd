extends Player


export var controller = {
	"kb": {
		"selected": true,
		"identifier": "P1"
	},
	"controller": {
		"selected": false,
		"identifier": "P2"
	},
}

var identifier


func _ready():
	get_controller_settings()


func get_input() -> Vector2:
	var x = Input.get_action_strength(identifier + "_right") - Input.get_action_strength(identifier + "_left")
	var y = Input.get_action_strength(identifier + "_down") - Input.get_action_strength(identifier + "_up")
	return Vector2(x, y).normalized()


func melee_attack(_identifier=identifier):
	.melee_attack(_identifier)


func fire(_identifier=identifier):
	.fire(_identifier)


func get_controller_settings():
	if controller.kb.selected:
		identifier = controller.kb.identifier
	
	if controller.controller.selected:
		identifier = controller.controller.identifier
		Gun.use_controller = true
