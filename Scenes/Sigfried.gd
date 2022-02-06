extends KinematicBody2D

onready var Blood = preload("res://Scenes/Blood.tscn")

var gravity = 3500
var move_vector = Vector2.ZERO
var move_speed_slow = 100
var move_speed_fast = 250

export var direction = 1
var is_shooting = false
var is_player_in_sight = false
var is_walking = false

var damage = 35
var health = 12
var is_alive = true
var hitpos = Vector2.ZERO

func _ready():
	scale.x *= direction
	$AnimationPlayer.play("walking")
	$Turn_area.connect("area_entered", self, "on_turnpoint")
	$Detect_player_area.connect("area_entered", self, "on_detect_area_entered")
	$Detect_player_area.connect("area_exited", self, "on_detect_area_exited")
	$Player_behind_area.connect("area_entered", self, "on_player_behind_area_entered")

func _process(delta):
	move_vector.y += gravity*delta

	if(is_alive):
		if(!is_shooting):
			move_vector.x = direction*move_speed_fast
		else:
			move_vector.x = 0
		
		move_and_slide(move_vector, Vector2.UP)
		if(is_on_floor()):
			move_vector.y = 0

		process_animations()
	else:
		move_vector.x = 0


func process_animations():
	if(is_alive && !is_shooting && $AnimationPlayer.current_animation != "fire_turn"):
		if(is_player_in_sight):
			$AnimationPlayer.play("fire_normal")
		else:
			$AnimationPlayer.play("walking")

func on_turnpoint(area2d):
	direction *= -1
	scale.x *= -1

func on_detect_area_entered(area2d):
	is_player_in_sight = true
	
func on_detect_area_exited(area2d):
	is_player_in_sight = false


func fire_shot():
	$RayCast2D.force_raycast_update()
	if($RayCast2D.is_colliding()):
		var obj_hit = $RayCast2D.get_collider().get_parent()
		var point = $RayCast2D.get_collision_point()
		if(obj_hit.get("health") != null):
			if(obj_hit.type=="player"):
				obj_hit.change_health(-damage, global_position)
				splurt_blood(10, point, obj_hit)

func splurt_blood(damage, point, obj_hit):
	var scene = get_tree().get_nodes_in_group("scene")[0]
	for i in range(5*damage):
		var new_blood = Blood.instance()
		new_blood.global_position = point
		if(obj_hit.global_position.x < global_position.x):
			new_blood.set_direction("left")
		else:
			new_blood.set_direction("right")
		scene.add_child(new_blood)

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
		#spawn_item()
		if(is_alive):
			if(fall_direction=="forwards"):
				$AnimationPlayer.play("die_forward")
			else:
				$AnimationPlayer.play("die_backward")
		is_alive = false
		shrink_collision_shapes()
	else:
		if(fall_direction=="forwards"):
			$AnimationPlayer.play("fire_turn")
			print("shot in the back, turning")
			#turn()


func shrink_collision_shapes():
	$CollisionShape2D.scale.y = 0
	$CollisionShape2D.position.y = 43
	$CollisionShape2D.position.x = 20
	$HitBox/CollisionShape2D.scale.y = 0
	$HitBox/CollisionShape2D.position.y = 40

func set_shooting(value):
	is_shooting = value
	#print("shooting: ", is_shooting)

func turn():
	direction *= -1
	move_vector.x *= -1
	scale.x *= -1

func on_player_behind_area_entered(_area2d):
	if(is_alive):
		turn()
