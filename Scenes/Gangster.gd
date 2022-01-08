extends KinematicBody2D

var gravity = 3500
var move_vector = Vector2.ZERO
var acceleration = 7000
var max_velocity_x = 4000
var ground_friction = 0.85
var air_friction = 0.95
var keys = Vector2.ZERO
var prev_keys = Vector2.ZERO

var jump_strength = 1000
var direction = "right"

var is_shooting = false

onready var Blood = preload("res://Scenes/Blood.tscn")

func _ready():
	$AnimationPlayer.play("Idle_violin")
	$AnimationPlayer.playback_speed = 0.7
	#set_process(true)
	$Hit.visible = false

func _process(delta):
	process_movement(delta)
	process_input()
	process_animation()
	process_fire_raycast()
	
func process_input():
	prev_keys = keys
	keys = Vector2.ZERO
	
	if(Input.is_action_pressed("left")):
		keys.x -= 1
	if(Input.is_action_pressed("right")):
		keys.x += 1
	if(Input.is_action_pressed("jump")):
		keys.y -= 1

	if(keys.x == -1 && direction == "right"):
		scale.x = -scale.x
		direction = "left"
		
	if(keys.x == 1 && direction == "left"):
		scale.x = -scale.x
		direction = "right"

	if(Input.is_action_pressed("shoot")):
		is_shooting = true
	else:
		is_shooting = false

func process_movement(delta):
	move_vector.y += gravity*delta
	move_and_slide(move_vector, Vector2.UP)
	if(is_on_floor()):
		move_vector.y = 0
		move_vector.x *= ground_friction
	else:
		move_vector.x *= ground_friction
	move_vector.x += acceleration*keys.x*delta
	move_vector.x = clamp(move_vector.x, -max_velocity_x, max_velocity_x)
	if(keys.y == -1 && is_on_floor()):
		move_vector.y -= jump_strength

func process_animation():

	if(move_vector.x < 10 && move_vector.x > -10):
		if(is_shooting):
			$AnimationPlayer.play("Shooting_standing")
		else:
			$AnimationPlayer.play("Idle_violin")
	else:
		if(is_shooting):
			$AnimationPlayer.play("Shooting_walking")
		else:
			$AnimationPlayer.play("Walk_violin")

func process_fire_raycast():
	if($RayCast2D.is_colliding() && is_shooting):
		var point = $RayCast2D.get_collision_point()
		$Hit.global_position = point
		$Hit.visible = true
		
		var obj_hit = $RayCast2D.get_collider().get_parent()
		var has_hp = false
		if(obj_hit.get("hp") != null):
			has_hp = true
		if(has_hp):
			var new_blood = Blood.instance()
			new_blood.global_position = point
			get_parent().add_child(new_blood)
	else:
		$Hit.visible = false

