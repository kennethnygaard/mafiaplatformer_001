extends KinematicBody2D

export var ammo_type = 0
var move_vector = Vector2.ZERO
var gravity = 3500
enum Type {AMMO, HEALTH}
export var item_type = "ammo"
var amount = 0
export var weapon_type = 1
var rnd = RandomNumberGenerator.new()
var is_picked_up = false

func _ready():
	$Sprite.modulate.a = 1.0
	rnd.randomize()
	if(ammo_type == 0):
		ammo_type = rnd.randi_range(2, 2)
	if(item_type == "ammo"):
		$Sprite.frame = ammo_type
		match ammo_type:
			0:	
				amount = rnd.randi_range(1, 6)
			1:
				amount = 0
			2: 
				amount = 6
				#amount = rnd.randi_range(1, 6)
			3:
				amount = rnd.randi_range(5, 10)
	if(item_type == "health"):
		amount = 50
		$Sprite.frame = 5
	if(item_type == "weapon"):
		$Sprite.frame = 6 + weapon_type

	scale = Vector2(2, 2)
	$Label.visible = false

func _process(delta):
	move_vector.y += gravity*delta
	move_and_slide_with_snap(move_vector, Vector2.ZERO, Vector2.UP, true)
	if(is_on_floor() && move_vector.y > 20):
		move_vector.y *= -0.6
		move_vector.x *= 0.75

func start_end_sequence():
	$Label.text = str(amount)
	if(item_type=="ammo" || item_type=="health"):
		$Label.visible = true
	if(item_type=="ammo"):
		match ammo_type:
			2:
				$RevolverAudioStreamPlayer.play()
			3:
				$SMGAudioStreamPlayer.play()
	if(item_type=="health"):
		$HealthAudioStreamPlayer.play()
	set_bounce()
	$AnimationPlayer.play("dissolve")
	
func set_bounce():
	move_vector.y = -800
	move_vector.x = rnd.randf_range(-200, 200)	
