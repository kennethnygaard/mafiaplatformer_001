extends KinematicBody2D

var gravity = 500
var vel_x
var rnd = RandomNumberGenerator.new()
var move_vector = Vector2.ZERO
onready var StaticBlood = preload("res://Scenes/StaticBlood.tscn")

onready var main = get_tree().get_nodes_in_group("main")[0]

func _ready():
	rnd.randomize()
	$Timer.connect("timeout", self, "on_timeout")
	#move_vector.x = rnd.randi_range(-400, 400)
	
	global_position.y += rnd.randi_range(-3, 3)
	move_vector.y = rnd.randi_range(-40, -20)	

	var time = rnd.randf_range(5.0, 10.0)
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

func set_vertical_direction(dir):
	if(dir == "down"):
		move_vector.y = rnd.randi_range(100, 200)


func _physics_process(delta):
	move_vector.y += gravity*delta
	if(is_on_wall()):
		move_vector.y = 0
	move_and_slide_with_snap(move_vector, Vector2.ZERO, Vector2.UP, true)
	if(is_on_floor()):
		move_vector = Vector2.ZERO
		var staticBlood = StaticBlood.instance()
		staticBlood.global_position = global_position
		main.add_child(staticBlood)
		queue_free()
		

func on_timeout():
	$AnimationPlayer.play("dissolve")
