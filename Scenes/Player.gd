extends KinematicBody2D

var move_vector = Vector2.ZERO
var gravity = 3000
var acceleration = 2000
var max_speed = 750
var direction = Vector2.ZERO
var break_factor_floor = 0.99
var break_factor_air = 1.0
var jump_strength = -1000
var was_stuck_on_wall = false
var is_stuck_on_wall = false

func _ready():
	$Stuck_on_wall_timer.connect("timeout", self, "unstick_from_wall")

func _process(delta):
	process_movement(delta)
	process_input()


func process_input():
	direction = Vector2.ZERO
	if(Input.is_action_pressed("left")):
		direction.x -= 1
	if(Input.is_action_pressed("right")):
		direction.x += 1
	if(Input.is_action_just_pressed("jump")):
		if($FloorCast2D.is_colliding()):
			move_vector.y = jump_strength
			$AnimationPlayer.play("jump")
		if(is_stuck_on_wall):
			move_vector.y = jump_strength
			if($WallCastLeft.is_colliding()):
				move_vector.x = max_speed*0.6
			if($WallCastRight.is_colliding()):
				move_vector.x = -max_speed*0.6
		if($FloorCast2D.is_colliding() || is_stuck_on_wall):
			$AudioStreamPlayer.play()
	if(Input.is_action_just_pressed("interact")):
		interact()



func process_movement(delta):
	move_vector.x += acceleration*direction.x*delta
	if(direction.x == 0):
		if($FloorCast2D.is_colliding()):
			move_vector.x *= break_factor_floor*delta
		else:
			move_vector.x *= break_factor_air*delta
	move_vector.x = clamp(move_vector.x, -max_speed, max_speed)
	if($WallCastLeft.is_colliding() || $WallCastRight.is_colliding()):
		if(!was_stuck_on_wall):
			was_stuck_on_wall = true
			is_stuck_on_wall = true
			move_vector.y = 0
			$Stuck_on_wall_timer.start(0.5)
	else:
		was_stuck_on_wall = false
		is_stuck_on_wall = false	

	if(is_stuck_on_wall):
		move_vector.y += gravity/4*delta
	if(!is_stuck_on_wall):
		move_vector.y += gravity*delta

	move_and_slide(move_vector, Vector2.UP)

	if(is_on_floor()):
		move_vector.y = 0

func interact():
	print("interacting")

func unstick_from_wall():
	is_stuck_on_wall = false
