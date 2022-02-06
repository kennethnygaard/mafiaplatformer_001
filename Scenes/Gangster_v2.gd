extends KinematicBody2D

var gravity = 3500
var move_vector = Vector2.ZERO
var acceleration = 6000
var max_velocity_x = 4000
var ground_friction = 0.85
var air_friction = 0.95
var keys = Vector2.ZERO
var prev_keys = Vector2.ZERO

var activated = true

var health = 100
var is_alive = true

var jump_strength = 1000
var direction = "right"

var is_shooting = false

var pistol_animation_running = false

var active_gun = 0
var damage = [0, 5, 4, 1, 1]

var ammo = [0, 0, 0, 0, 0]
var has_baseball_bat = false
var has_tommy_gun = false
var has_shotgun = false

var has_gun = []

var hit_raycast = [Vector2(10, 0), Vector2(15, 0), Vector2(200, 0), Vector2(200, 0), Vector2(200, 0)]

var shooting_animation = ["top_nothing_idle", "top_baseball_bat_hit", "top_pistol_shooting", "top_MG_shooting"]
var click_animation = ["top_nothing_idle", "top_baseball_bat_idle", "top_pistol_click", "top_MG_idle"]
var top_idle_animation = ["top_nothing_idle", "top_baseball_bat_idle", "top_pistol_idle", "top_MG_idle"]

var die_forward_animation = ["die_nothing_forward", "die_bat_forward", "die_pistol_forward", "die_SMG_forward"]
var die_backward_animation = ["die_nothing_backward", "die_bat_backward", "die_pistol_backward", "die_SMG_backward"]

enum {WALKING, STANDING, SHOOTING, NOT_SHOOTING}

enum Direction {LEFT, RIGHT}

export(Direction) var start_direction = Direction.RIGHT

var walk_state = STANDING
var shoot_state = NOT_SHOOTING

var type = "player"

onready var Blood = preload("res://Scenes/Blood.tscn")

onready var scene = get_tree().get_nodes_in_group("scene")[0]

signal change_gun_icon
signal health_changed
signal ammo_changed

func _ready():
	ammo = scene.start_ammo
	has_gun = scene.start_guns
	active_gun = scene.active_gun
	
	if(start_direction == Direction.LEFT):
		direction = "left"
		scale.x *= -1
	$Pickup_area.connect("area_entered", self, "on_pick_up_item")
	
	$BottomSprite.visible = true
	$Cigarette_smoke.visible = true
	
	$TopAnimationPlayer.play("top_pistol_idle")
	match active_gun:
		0:
			$TopSprite.frame = 32
		1:
			$TopSprite.frame = 40
		2:
			$TopSprite.frame = 48 

	change_ammo_on_HUD()

func _process(_delta):
	if(is_alive && activated):
		process_input()
		process_states()
		process_animation()
		process_SFX()
	
	if(!activated):
		$TopAnimationPlayer.play("top_baseball_bat_idle")
		$BottomAnimationPlayer.play("bottom_idle")
		move_vector.x = 0
	
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
		if(active_gun==2):
			$RayCast2D.position.y = -5
		else:
			$RayCast2D.position.y = 0		
	else:
		is_shooting = false

	if(Input.is_action_just_pressed("change_gun")):
		next_weapon()

	if(Input.is_action_just_pressed("debug")):
		emit_signal("ammo_changed", ammo)

func next_weapon():
	active_gun += 1
	while(!has_gun[active_gun]):
		active_gun += 1
		if(active_gun > 3):
			active_gun = 0
	if(active_gun > 3):
		active_gun = 0
	
	$RayCast2D.cast_to = hit_raycast[active_gun]
	change_ammo_on_HUD()

func process_movement(delta):
	move_vector.y += gravity*delta
	move_and_slide_with_snap(move_vector, Vector2(0,0), Vector2.UP, true)
	if(is_on_floor()):
		move_vector.y = 0
		move_vector.x *= ground_friction
	else:
		move_vector.x *= ground_friction
	if(is_alive):
		move_vector.x += acceleration*keys.x*delta
	move_vector.x = clamp(move_vector.x, -max_velocity_x, max_velocity_x)
	if(keys.y == -1 && is_on_floor() && is_alive):
		move_vector.y -= jump_strength
		$SFX_player.play_hop()

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
	if(!pistol_animation_running):
		if(is_shooting):
			if(ammo[active_gun] > 0):
				$TopAnimationPlayer.play(shooting_animation[active_gun])
			else:
				$TopAnimationPlayer.play(click_animation[active_gun])
		else:
			#play idle animation both walking and idle
			$TopAnimationPlayer.play("top_MG_idle")
			#$TopAnimationPlayer.play(top_idle_animation[active_gun])
			#print(top_idle_animation[active_gun])
			var base_frame = 32
			var frame_offset = $BottomSprite.frame % 8
			$TopSprite.frame = base_frame + active_gun*8 + frame_offset

func process_SFX():
	if(walk_state==WALKING && is_on_floor()):
		$SFX_player.play_footstep()

func shoot():
	$RayCast2D.cast_to = hit_raycast[active_gun]
	if($RayCast2D.is_colliding() && is_shooting):
		var point = $RayCast2D.get_collision_point()

		var obj_hit = $RayCast2D.get_collider().get_parent()
		var has_hp = false
		if(obj_hit.get("health") != null):
			has_hp = true
		if(has_hp && active_gun > 0):
			splurt_blood(damage[active_gun], point, obj_hit)
			obj_hit.hitpos = point
			obj_hit.change_health(-damage[active_gun], global_position)
		
	if(active_gun > 1):
		ammo[active_gun] -= 1
		change_ammo_on_HUD()

func play_baseball_hit_sound():
	$SFX_player/Baseball_bat_miss_player/AudioStreamPlayer.play()
	if($RayCast2D.is_colliding() && is_shooting):
		$SFX_player/Baseball_bat_hit_player/AudioStreamPlayer.play()

func splurt_blood(damage, point, obj_hit):
	for i in range(5*damage):
		var new_blood = Blood.instance()
		new_blood.global_position = point
		if(obj_hit.global_position.x < global_position.x):
			new_blood.set_direction("left")
		else:
			new_blood.set_direction("right")
		get_parent().add_child(new_blood)

func change_health(health_change, killerpos):
	health += health_change
	health = clamp(health, 0, 100)
	emit_signal("health_changed", health)
	if(health <= 0 && is_alive):
		is_alive = false
		$BottomSprite.visible = false
		$Cigarette_smoke.visible = false
		if(killerpos.x > global_position.x && direction == "right"):
			$TopAnimationPlayer.play(die_backward_animation[active_gun])
		elif(killerpos.x < global_position.x && direction == "left"):
			$TopAnimationPlayer.play(die_backward_animation[active_gun])
		else:
			$TopAnimationPlayer.play(die_forward_animation[active_gun])

func change_ammo_on_HUD():
	var text = ""
	if(active_gun > 1):
		text = "AMMO: " + str(ammo[active_gun])
	emit_signal("ammo_changed", text)
	emit_signal("change_gun_icon", active_gun)

func set_pistol_animation_running(status):
	pistol_animation_running = status

func on_pick_up_item(area2d):
	var item = area2d.get_parent()
	if(!item.is_picked_up):
		item.is_picked_up = true
		if(item.item_type == "ammo"):
			ammo[item.ammo_type] += item.amount
			change_ammo_on_HUD()
		if(item.item_type == "health"):
			health += item.amount
			change_health(0, Vector2.ZERO)
		if(item.item_type == "weapon"):
			has_gun[item.weapon_type] = true
			if(ammo[item.weapon_type] <= 0):
				ammo[item.weapon_type] = 6
		item.start_end_sequence()

func restart_level():
	get_tree().get_nodes_in_group("scene")[0].die_fadeout()
