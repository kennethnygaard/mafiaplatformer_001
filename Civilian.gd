extends KinematicBody2D

var gravity = 3500
var move_vector = Vector2.ZERO
var move_speed = 0
export var direction = -1

export var character = 0
var animations = ["jew_walk", "afro_boy_walk", "lady1_walk", "lady2_walk"]
var start_frame = [8, 24, 32, 40]
var move_speeds = [100, 100, 120, 130]


func _ready():
	move_speed = move_speeds[character]
	$AnimationPlayer.play(animations[character])
	$Turnpoint_area.connect("area_entered", self, "on_turnpoint")
	scale.x *= direction
	$Sprite.frame = start_frame[character]

func _process(delta):
	move_vector.y += gravity*delta
	move_vector.x = move_speed*direction
	move_and_slide_with_snap(move_vector, Vector2.ZERO, Vector2.UP, true)
	if(is_on_floor()):
		move_vector.y = 0

func on_turnpoint(area2d):
	direction *= -1
	scale.x *= -1
