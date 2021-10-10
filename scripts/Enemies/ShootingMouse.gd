extends Enemy
class_name ShootingMouse


onready var BulletManager = Global.BulletManager
onready var navigation = Global.navigation
onready var points = Global.points
onready var laser = $Laser

export var nav_stop_threshold = 5

var destinations
var path = []
var destination := Vector2()
var velocity


func _ready():
	destinations = points.get_children()
	make_path()


func _physics_process(_delta):
	navigate()


func make_path():
	
	randomize()
	var dest_index = randi() % destinations.size()
	var next_dest = destinations[dest_index]
	
	path = navigation.get_simple_path(self.global_position, next_dest.global_position, false)


func update_path():
	if path.size() == 1:
		var distance_to_dest = global_position.distance_to(path[0])
		if distance_to_dest > nav_stop_threshold:
			return
		make_path()
	path.remove(0)


func navigate():
	var distance_to_dest = global_position.distance_to(path[0])
	destination = path[0]
	
	if distance_to_dest > nav_stop_threshold:
		move()
	else:
		update_path()


func move():
	if not is_dead:
		var motion = (destination - global_position).normalized() * ms
		velocity = move_and_slide(motion)
		get_collider_object()


func get_collider_object():
	var slide_count = get_slide_count()
	if slide_count:
		var collision = get_slide_collision(slide_count - 1)
		collider = collision


func get_movement_direction():
	if global_position.x >= 1920:
		return Vector2(-1, 0)
	elif global_position.x <= 0:
		return Vector2(-1, 0)


func shoot():
	sprite.play("shoot")
	laser.play()
	var bullet_instance = bullet.instance()
	bullet_instance.position = GunTip.global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.velocity = bullet_instance.velocity.rotated(rotation)
	bullet_instance.damage = damage * damage_multiplier
	BulletManager.add_child(bullet_instance)


func _on_Timer_timeout():
	if not is_dead:
		shoot()
		random_timer()
		timer.start()
