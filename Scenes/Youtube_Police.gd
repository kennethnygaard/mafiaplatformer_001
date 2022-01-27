#This script is only for youtube

extends KinematicBody2D

var move_vector = Vector2.ZERO
var gravity = 4000

enum Direction {LEFT, RIGHT}

export(Direction) var start_direction = Direction.RIGHT

var direction = 1
var move_speed = 200
var hp = 5
var health = 5

var is_player_in_sight = false
var is_shooting = false

var type = "police"

var is_alive = true
var hitpos = Vector2.ZERO
var damage = 20

onready var Blood = preload("res://Scenes/Blood.tscn")

signal health_changed

func _ready():
	$AnimationPlayer.play("idle_rifle")
	$Turnpoint_area.connect("area_entered", self, "on_turnpoint_entered")
	$Detect_player_area.connect("area_entered", self, "on_detect_area_entered")
	$Detect_player_area.connect("area_exited", self, "on_detect_area_exited")
	if(start_direction == Direction.LEFT):
		turn()
	

func _process(delta):
	move_vector.y += gravity*delta
	
#	if(is_shooting):
#		move_vector.x = 0
#	else:
#		if(is_player_in_sight):
#			shoot()
#		else:
#			move_vector.x = move_speed*direction
#			if(is_alive):
#				$AnimationPlayer.play("walking_rifle")


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

func shoot():
	$RayCast2D.force_raycast_update()
	var ok = true
	var collider = $RayCast2D.get_collider()
	var obj_hit = null
	
	if(collider!= null && collider.get_parent() != null):
		pass
		obj_hit = collider.get_parent()
	if(obj_hit != null && obj_hit.get("type") != null && obj_hit.type == "police"):
		ok = false
	if(is_alive && ok):
		is_shooting = true
		$AnimationPlayer.play("shooting_rifle")
		move_vector.x = 0
	
func fire_shot():
	$RayCast2D.force_raycast_update()
	if($RayCast2D.is_colliding()):
		var obj_hit = $RayCast2D.get_collider().get_parent()
		var point = $RayCast2D.get_collision_point()
		if(obj_hit.get("health") != null):
			if(obj_hit.type=="player"):
				obj_hit.change_health(-damage, global_position)
			else:
				obj_hit.change_health(-2, global_position)
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

func on_detect_area_entered(area2d):
	is_player_in_sight = true
	shoot()
	
func on_detect_area_exited(area2d):
	is_player_in_sight = false

func finished_shooting():
	is_shooting = false
	if(is_alive):
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

func shrink_collision_shapes():
	$CollisionShape2D.scale.y = 0
	$CollisionShape2D.position.y = 40
	$CollisionShape2D.position.x = 20
	$HitBox/CollisionShape2D.scale.y = 0
	$HitBox/CollisionShape2D.position.y = 40
