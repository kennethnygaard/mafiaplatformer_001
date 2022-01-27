extends KinematicBody2D

var gravity = 3500
var move_vector = Vector2.ZERO
var move_speed = 200

var progress = 0

func _ready():
	$Area2D.connect("area_entered", self, "on_stop_area_entered")
	
func _process(delta):
	move_and_slide_with_snap(move_vector, Vector2.ZERO, Vector2.UP, true)
	if(is_on_floor()):
		move_vector.y = 0
	
func _physics_process(delta):
	move_vector.y += gravity*delta

func on_stop_area_entered(area2d):
	move_vector.x = 0
	$AnimationPlayer.play("IDLE")
