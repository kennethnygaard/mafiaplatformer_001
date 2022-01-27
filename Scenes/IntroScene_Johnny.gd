extends KinematicBody2D

var move_vector = Vector2.ZERO
var gravity = 3500

func _ready():
	pass # Replace with function body.


func _process(delta):
	move_and_slide_with_snap(move_vector, Vector2.ZERO, Vector2.UP, true)
	if(is_on_floor()):
		move_vector.y = 0

func _physics_process(delta):
	move_vector.y += gravity*delta
