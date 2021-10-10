extends IDamageable


onready var timer = $AttackTimer
onready var sprite = $AnimatedSprite
onready var bar = $Control/HPBar

var stage = 1


func _init():
	hp = 500


func _process(delta):
	bar.value = hp


func _on_AttackTimer_timeout():
	attack()
	timer.start(4)


func attack():
	if stage == 2:
		instance_trident()
	
	laser_attack()


func instance_trident():
	pass


func laser_attack():
	pass


func take_damage(damage, shooter=null):
	.take_damage(damage, shooter)
	if hp < 200 and stage == 1:
		stage = 2
		sprite.play("stage2")
