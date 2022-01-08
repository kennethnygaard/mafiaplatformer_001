extends KinematicBody2D

var gravity = 3500
var move_vector = Vector2.ZERO
var acceleration = 6000
var max_velocity_x = 4000
var ground_friction = 0.85
var air_friction = 0.95
var keys = Vector2.ZERO
var prev_keys = Vector2.ZERO

var jump_strength = 1000
var direction = "right"

var is_shooting = false

var active_gun = 0
var damage = [0, 2, 1]

var shooting_animation = ["top_nothing_idle", "top_pistol_shooting", "top_MG_shooting"]
var top_idle_animation = ["top_nothing_idle", "top_pistol_idle", "top_MG_idle"]

enum {WALKING, STANDING, SHOOTING, NOT_SHOOTING}

var walk_state = STANDING
var shoot_state = NOT_SHOOTING

onready var Blood = preload("res://Scenes/Blood.tscn")

signal change_gun_icon

func _ready():
	$Hit.visible = false
	print("player ready")

func _process(delta):

	process_input()
	process_states()
	process_animation()
	process_SFX()
	#process_fire_raycast()

func _physics_process(delta):
	process_movement(delta)	

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
		if(active_gun==1):
			$RayCast2D.position.y = -5
		if(active_gun==2):
			$RayCast2D.position.y = 0		
	else:
		is_shooting = false

	if(Input.is_action_just_pressed("change_gun")):
		active_gun += 1
		if(active_gun > 2):
			active_gun -= 3
		emit_signal("change_gun_icon", active_gun)

func process_movement(delta):
	move_vector.y += gravity*delta
	move_and_slide_with_snap(move_vector, Vector2(0,0), Vector2.UP, true)
	if(is_on_floor()):
		move_vector.y = 0
		move_vector.x *= ground_friction
	else:
		move_vector.x *= ground_friction
	move_vector.x += acceleration*keys.x*delta
	move_vector.x = clamp(move_vector.x, -max_velocity_x, max_velocity_x)
	if(keys.y == -1 && is_on_floor()):
		move_vector.y -= jump_strength

func process_states():
	if(move_vector.x < 10 && move_vector.x > -10):
		walk_state = STANDING
	else:
		walk_state = WALKING

func process_animation():
	
	# BOTTOM SPRITE
	
	if(walk_state == STANDING):
		if(is_shooting):
			$BottomAnimationPlayer.play("bottom_shooting")
		else:
			$BottomAnimationPlayer.play("bottom_idle")
	if(walk_state == WALKING):
		$BottomAnimationPlayer.play("bottom_walking")		
	
	#TOP SPRITE
	
	if(is_shooting):
		$TopAnimationPlayer.play(shooting_animation[active_gun])
	else:
		#play idle animation both walking and idle
		$TopAnimationPlayer.play(top_idle_animation[active_gun])
		var base_frame = 32
		var frame_offset = $BottomSprite.frame % 8

		$TopSprite.frame = base_frame + active_gun*8 + frame_offset

func process_SFX():
	if(walk_state==WALKING && is_on_floor()):
		$SFX_player.play_footstep()

func shoot():

	if($RayCast2D.is_colliding() && is_shooting):
		var point = $RayCast2D.get_collision_point()
		$Hit.global_position = point
#		if(active_gun > 0):
#			$Hit.visible = true

		var obj_hit = $RayCast2D.get_collider().get_parent()
		var has_hp = false
		if(obj_hit.get("hp") != null):
			has_hp = true
		if(has_hp && active_gun > 0):
			for i in range(5*damage[active_gun]):
				var new_blood = Blood.instance()
				new_blood.global_position = point
				if(obj_hit.global_position.x < global_position.x):
					new_blood.set_direction("left")
				else:
					new_blood.set_direction("right")
				get_parent().add_child(new_blood)

	else:
		$Hit.visible = false
