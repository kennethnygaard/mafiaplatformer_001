extends KinematicBody2D

onready var Blood = preload("res://Scenes/Blood.tscn")
onready var Item = preload("res://Scenes/Pickup.tscn")

onready var scene = get_tree().get_nodes_in_group("scene")[0]

var gravity = 3500
var move_vector = Vector2.ZERO
export var move_speed = 150

export var direction = -1
var is_walking = true
var is_shooting = false

export var character = 0

var walk_anims = ["H1_walking", "H2_walking"]
var idle_anims = ["H1_idle", "H2_idle"]
var shooting_anims = ["H1_shooting", "H2_shooting"]
var die_backward_anims = ["H1_die_backward", "H2_die_backward"]
var headshot_backward_anims = ["H1_headshot_backward", "H2_headshot_backward"]
var die_forward_anims = ["H1_die_forward", "H2_die_forward"]
var headshot_forward_anims = ["H1_headshot_forward", "H2_headshot_forward"]

var type = "hoodlum"
var health = 5
var damage = 10

export var has_ammo = false
export var ammo_type = 2
export var has_health = false
export var has_weapon = false
export var weapon_type = 2

var is_player_in_sight = false
var is_ready_to_shoot = false
var hitpos = Vector2.ZERO
var is_alive = true

func _ready():
	scale.x *= direction
	$Turn_area.connect("area_entered", self, "on_turnpoint")
	$Detect_player_area.connect("area_entered", self, "on_player_detected")
	$Detect_player_area.connect("area_exited", self, "on_player_undetected")
	$Shoot_delay_timer.connect("timeout", self, "set_shooting")

	$Sprite.frame = 0
	
func _process(delta):
	move_vector.y += gravity*delta
	move_and_slide(move_vector, Vector2.UP)
	process_states()
	process_animation()
	process_movement(delta)
	
func process_animation():
	var player_is_dead = false
	if(is_alive):
		if(is_walking && !is_ready_to_shoot):
			$AnimationPlayer.play(walk_anims[character])
		else:
			#ok = true
			$RayCast2D.force_raycast_update()
			if($RayCast2D.is_colliding()):
				var obj_hit = $RayCast2D.get_collider().get_parent()
				if(obj_hit != null):
					if(obj_hit.get("is_alive") != null && !obj_hit.is_alive):
						player_is_dead = true
			if(is_shooting && !player_is_dead):
				$AnimationPlayer.play(shooting_anims[character])
			elif(player_is_dead):
				$AnimationPlayer.play(idle_anims[character])
		
func process_movement(delta):
	if(is_alive && is_walking && !is_ready_to_shoot):
		move_vector.x = move_speed*direction
	else:
		move_vector.x = 0
	if(is_on_floor()):
		move_vector.y = 0

func process_states():
	if(is_shooting || is_ready_to_shoot ):
		is_walking = false
	else:
		is_walking = true
		
	if(is_player_in_sight):
		is_ready_to_shoot = true
		if($Shoot_delay_timer.is_stopped() && is_alive):
			$Shoot_delay_timer.start(0.4)

	if(!is_alive):
		is_shooting = false
		is_ready_to_shoot = false
		is_walking = false

func on_turnpoint(area2d):
	direction *= -1
	scale.x *= -1

func on_player_detected(area2d):
	is_player_in_sight = true
	is_ready_to_shoot = true

func on_player_undetected(area2d):
	is_player_in_sight = false
	is_ready_to_shoot = false

func stop_shooting():
	is_shooting = false

func set_shooting():
	is_shooting = true

func fire_shot():
	$RayCast2D.force_raycast_update()
	if($RayCast2D.is_colliding()):
		var obj_hit = $RayCast2D.get_collider().get_parent()
		var point = $RayCast2D.get_collision_point()
		if(obj_hit.get("health") != null):
			if(obj_hit.type=="player"):
				obj_hit.change_health(-damage, global_position)
				splurt_blood(2, point, obj_hit)

func splurt_blood(damage, point, obj_hit):
	for i in range(5*damage):
		var new_blood = Blood.instance()
		new_blood.global_position = point
		if(obj_hit.global_position.x < global_position.x):
			new_blood.set_direction("left")
		else:
			new_blood.set_direction("right")
		get_parent().add_child(new_blood)

func change_health(damage, killerpos):
	var headshot = false
	var fall_direction = "forwards"
	var diff = global_position.x - killerpos.x
	#BACKWARDS:
	if(diff < 0 && direction == 1):
		fall_direction = "backwards"
	if(diff > 0 && direction == -1):
		fall_direction = "backwards"

	var distance = abs(killerpos.x - global_position.x)
	var hitpoint = hitpos.y - global_position.y
	if(hitpoint < -15 && distance < 100):
		damage *= 3
		headshot = true
	health += damage
	#print(hitpos - global_position)
	if(health < 1):
		spawn_item()
		if(is_alive):
			$Cigarette_smoke.queue_free()
			if(fall_direction=="forwards"):
				if(headshot):
					$AnimationPlayer.play(headshot_forward_anims[character])
				else:
					$AnimationPlayer.play(die_forward_anims[character])
			else:
				if(headshot):
					$AnimationPlayer.play(headshot_backward_anims[character])
				else:
					$AnimationPlayer.play(die_backward_anims[character])
		is_alive = false
		shrink_collision_shapes()
	else:
		if(fall_direction=="forwards"):
			turn()

func spawn_item():
	if(has_ammo || has_health || has_weapon):
		var new_item = Item.instance()
		if(has_ammo):
			new_item.item_type = "ammo"
			new_item.ammo_type = ammo_type
		elif(has_health):
			new_item.item_type = "health"
		else:
			new_item.item_type = "weapon"
			new_item.weapon_type = weapon_type
		new_item.global_position = global_position
		new_item.global_position.y -= 50
		scene.add_child(new_item)
		new_item.set_bounce()
	
func turn():
	pass

func shrink_collision_shapes():
	$CollisionShape2D.scale.y = 0
	$CollisionShape2D.position.y = 46
	$CollisionShape2D.position.x = 20
	$HitBox/CollisionShape2D.scale.y = 0
	$HitBox/CollisionShape2D.position.y = 40
