extends KinematicBody2D

var move_vector = Vector2(0, 0)

func _ready():
	scale = Vector2(-3, 3)

func _process(delta):
	move_and_slide(move_vector)

func start_driving():
	$AnimationPlayer.play("driving")
	move_vector.x = 700
