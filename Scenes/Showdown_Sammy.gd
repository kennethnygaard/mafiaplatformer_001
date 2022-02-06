extends KinematicBody2D

var gravity = 3500
var move_vector = Vector2.ZERO
var jump_strength = 1000
var move_speed = 400

var is_jumping = false

var direction = 1
var hitpos = Vector2.ZERO

var health = 20
var is_alive = true

signal Sammy_died

func _ready():
	$Action_area.connect("area_entered", self, "on_action_area")
	move_vector.x = move_speed

func _process(delta):
	process_animations()

func _physics_process(delta):
	move_vector.y += gravity*delta
	if(is_on_floor() && !is_jumping):
		move_vector.y = 0
			
	if(!is_on_floor()):
		is_jumping = false
			
	move_and_slide(move_vector, Vector2.UP)

	if(!is_alive):
		move_vector.x = 0

func process_animations():
	if(is_alive):
		if(abs(move_vector.x) > 0):
			$AnimationPlayer.play("walking")
		else:
			$AnimationPlayer.play("idle")
	
		
func jump():
	if(is_alive):
		move_vector.y = -jump_strength
		is_jumping = true

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
	health += damage
	if(health < 1):
		emit_signal("Sammy_died")
		$AnimationPlayer.play("pulp")
		is_alive = false
		shrink_collision_shapes()

func shrink_collision_shapes():
	$CollisionShape2D.scale.y = 0
	$CollisionShape2D.position.y = 70
	$CollisionShape2D.position.x = 20
	$HitBox/CollisionShape2D.scale.y = 0
	$HitBox/CollisionShape2D.position.y = 40
	
func turn():
	if(is_alive):
		scale.x *= -1
		move_vector.x *= -1

func on_action_area(area2d):
	var action = area2d.get_action()
	if(action == "run_left"):
		if(get_direction() == "right"):
			turn()
		
	if(action == "run_right"):
		if(get_direction() == "left"):
			turn()
		
	if(action == "jump_left"):
		if(get_direction() == "right"):
			turn()
		jump()

	if(action == "jump_right"):
		if(get_direction() == "left"):
			turn()
		jump()

func get_direction():
	if(move_vector.x > 0):
		return "right"
	elif(move_vector.x < 0):
		return "left"
	else:
		return "standing"
