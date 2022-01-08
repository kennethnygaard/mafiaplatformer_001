extends KinematicBody2D

var move_vector = Vector2.ZERO
var gravity = 4000

var hp = 5

func _process(delta):
	move_vector.y += gravity*delta

func _physics_process(delta):
	move_and_slide(move_vector, Vector2.UP)
	if(is_on_floor()):
		move_vector.y = 0
