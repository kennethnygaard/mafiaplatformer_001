extends KinematicBody2D

var move_vector = Vector2(-400, 500)
var gravity = 800
var has_bounced = false

func _ready():
	var rnd = RandomNumberGenerator.new()
	rnd.randomize()
	var camera = get_tree().get_nodes_in_group("camera")[0]
	var x_pos = camera.global_position.x + rnd.randi_range(-400, 900)
	var y_pos = camera.global_position.y - 300
	$Timer.connect("timeout", self, "queue_free")
	global_position = Vector2(x_pos, y_pos)
	
	var speed_random = rnd.randf_range(0.7, 1.3)
	move_vector *= speed_random

func _process(delta):
	move_and_slide(move_vector, Vector2.UP)
	if(is_on_floor() && has_bounced):
		move_vector.y = 0
	if(is_on_floor() && !has_bounced):
		$Sprite.frame = 1
		has_bounced = true
		$Timer.start(0.3)
		move_vector.y *= -0.2
		move_vector.x *= 0.5
	if(has_bounced):
		move_vector.y += gravity * delta
		
	if(global_position.y > 3000):
		queue_free()
