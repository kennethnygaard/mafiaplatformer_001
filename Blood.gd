extends KinematicBody2D

var gravity = 500
var vel_x
var rnd = RandomNumberGenerator.new()
var move_vector = Vector2.ZERO

func _ready():
	rnd.randomize()
	$Timer.connect("timeout", self, "on_timeout")
	#move_vector.x = rnd.randi_range(-400, 400)
	move_vector.y = rnd.randi_range(-40, -20)
	
	global_position.y += rnd.randi_range(-3, 3)
	
	var time = rnd.randf_range(0.5, 4.0)
	$Timer.start(time)

func _process(delta):
	pass

func set_direction(dir):
	rnd.randomize()
	if(dir=="left"):
		move_vector.x = rnd.randi_range(-500, -200)
		global_position.x -= 15
	if(dir=="right"):
		move_vector.x = rnd.randi_range(200, 500)
		global_position.x += 15
func _physics_process(delta):
	move_vector.y += gravity*delta
	move_and_slide(move_vector, Vector2.UP)
	if(is_on_floor()):
		move_vector = Vector2.ZERO

func on_timeout():
	$AnimationPlayer.play("dissolve")
