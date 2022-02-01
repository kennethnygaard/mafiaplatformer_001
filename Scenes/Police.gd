#ordinary police

extends KinematicBody2D

var move_vector = Vector2.ZERO
var gravity = 4000

enum Direction {LEFT, RIGHT}

export(Direction) var start_direction = Direction.RIGHT

var direction = 1
var move_speed = 200
var health = 5

var is_player_in_sight = false

var is_shooting = false

var type = "police"

var is_alive = true
var hitpos = Vector2.ZERO
var damage = 20

var shooting_direction = "ahead"
var raycast_position_y_ahead = -10
var raycast_position_y_down = 40
var raycast_vector_ahead = Vector2(445, 0)
var raycast_vector_down = Vector2(345, 345)

var rnd = RandomNumberGenerator.new()

export var floating = false
export var is_always_standing_still = false
export var has_ammo = false
export var has_health = false

onready var Blood = preload("res://Scenes/Blood.tscn")
onready var Item = preload("res://Scenes/Pickup.tscn")
onready var scene = get_tree().get_nodes_in_group("scene")[0]

signal health_changed

func _ready():
	rnd.randomize()
	$AnimationPlayer.play("walking_rifle")
	$Turnpoint_area.connect("area_entered", self, "on_turnpoint_entered")
	$Detect_player_area.connect("area_entered", self, "on_detect_player_area_entered")
	$Detect_player_area.connect("area_exited", self, "on_detect_player_area_exited")
	$Detect_player_down_area.connect("area_entered", self, "on_detect_player_down_area_entered")
	$Detect_player_down_area.connect("area_exited", self, "on_detect_player_down_area_exited")	
	$Stop_float_area.connect("area_entered", self, "stop_floating")
	$Shoot_timer.connect("timeout", self, "on_shoot_timer_timeout")
	$Turn_area.connect("area_entered", self, "on_turn_area_entered")
	if(start_direction == Direction.LEFT):
		turn()
	if(floating):
		z_index = -1

func _process(delta):
	if(!floating):
		move_vector.y += gravity*delta
		z_index = 1
	
	if(is_shooting):
		move_vector.x = 0
	else:
		if(is_player_in_sight):
			shoot()
		else:
			if(is_always_standing_still):
				move_vector.x = 0
				if(is_alive):
					$AnimationPlayer.play("idle_rifle")
			else:
				move_vector.x = move_speed*direction
				if(is_alive):
					$AnimationPlayer.play("walking_rifle")

func _physics_process(delta):
	if(is_alive):
		move_and_slide(move_vector, Vector2.UP)
	if(is_on_floor()):
		move_vector.y = 0
		if(!is_alive):
			var floor_normal = get_floor_normal()
			rotation = floor_normal.angle() + PI/2*direction

func on_turnpoint_entered(area2d):
	turn()

func turn():
	scale.x = -1.0
	direction *= -1

func on_turn_area_entered(area2d):
	if(is_alive && z_index>=0):
		turn()

func shoot():
	$RayCast2D.force_raycast_update()
	var ok = true
	var collider = $RayCast2D.get_collider()
	var obj_hit = null
	
	if(collider!= null && collider.get_parent() != null):
		obj_hit = collider.get_parent()
	if(obj_hit != null && obj_hit.get("type") != null && obj_hit.type == "police"):
		ok = false
	if(is_alive && ok && obj_hit != null && obj_hit.get("is_alive") != null):
		if(obj_hit.is_alive):
			is_shooting = true
			var delay = rnd.randf_range(0.0, 0.4)
			$Shoot_timer.start(delay)

func on_shoot_timer_timeout():
	if(is_alive):
		if(shooting_direction == "ahead"):
			$AnimationPlayer.play("shooting_rifle")
		else:
			$AnimationPlayer.play("shooting_rifle_down")
		move_vector.x = 0	

func fire_shot():
	$RayCast2D.force_raycast_update()
	if($RayCast2D.is_colliding()):
		var obj_hit = $RayCast2D.get_collider().get_parent()
		var point = $RayCast2D.get_collision_point()
		if(obj_hit.get("health") != null):
			if(obj_hit.type=="player"):
				obj_hit.change_health(-damage, global_position)
				splurt_blood(2, point, obj_hit)
			else:
				pass
				#obj_hit.change_health(-2, global_position)

func splurt_blood(damage, point, obj_hit):
	for i in range(5*damage):
		var new_blood = Blood.instance()
		new_blood.global_position = point
		if(obj_hit.global_position.x < global_position.x):
			new_blood.set_direction("left")
		else:
			new_blood.set_direction("right")
		get_parent().add_child(new_blood)
		new_blood.set_vertical_direction(shooting_direction)			

func on_detect_player_area_entered(area2d):
	is_player_in_sight = true
	shooting_direction = "ahead"
	$RayCast2D.position.y = raycast_position_y_ahead
	$RayCast2D.cast_to = raycast_vector_ahead
	shoot()
	
func on_detect_player_area_exited(area2d):
	is_player_in_sight = false

func on_detect_player_down_area_entered(area2d):
	if(z_index > -1):
		is_player_in_sight = true
		shooting_direction = "down"
		$RayCast2D.position.y = raycast_position_y_down
		$RayCast2D.cast_to = raycast_vector_down
		shoot()
	
func on_detect_player_down_area_exited(area2d):
	is_player_in_sight = false

func finished_shooting():
	is_shooting = false
	if(is_alive):
		if(is_always_standing_still):
			$AnimationPlayer.play("idle_rifle")
		else:
			$AnimationPlayer.play("walking_rifle")

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
			if(fall_direction=="forwards"):
				if(headshot):
					$AnimationPlayer.play("die_forward_headshot")
				else:
					$AnimationPlayer.play("Die_forward_001")
			else:
				if(headshot):
					$AnimationPlayer.play("die_headshot_backwards")
				else:
					$AnimationPlayer.play("die_backwards_001")
		is_alive = false
		shrink_collision_shapes()
	else:
		if(fall_direction=="forwards"):
			turn()

func shrink_collision_shapes():
	$CollisionShape2D.scale.y = 0
	$CollisionShape2D.position.y = 40
	$CollisionShape2D.position.x = 20
	$HitBox/CollisionShape2D.scale.y = 0
	$HitBox/CollisionShape2D.position.y = 40

func stop_floating(area2d):
	floating = false
	z_index = 0

func spawn_item():
	if(has_ammo || has_health):
		var new_item = Item.instance()
		if(has_ammo):
			new_item.item_type = "ammo"
		else:
			new_item.item_type = "health"
		new_item.global_position = global_position
		new_item.global_position.y -= 50
		scene.add_child(new_item)
		new_item.set_bounce()

