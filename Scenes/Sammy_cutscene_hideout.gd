extends KinematicBody2D

var gravity = 3500
var move_vector = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _physics_process(delta):
	move_vector.y += gravity*delta

	move_and_slide(move_vector, Vector2.UP)
	
func play_anim(anim):
	$AnimationPlayer.play(anim)
