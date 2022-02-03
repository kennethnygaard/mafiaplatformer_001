extends Node

var progress = 0

func _ready():
	$Timer.connect("timeout", self, "increase_progress")
	$Gangster_v2.scale.x *= -1
	$Panel.visible = false
	$Donnie_stop_area.connect("area_entered", self, "on_stop_area_reached")
	$Jump_area.connect("area_entered", self, "on_jump_area_reached")
	$Jump_area2.connect("area_entered", self, "on_jump_water_reached")
	$On_land_area.connect("area_entered", self, "on_land_area_entered")
	$Sammy_cutscene_hideout/Sprite.frame = 32
	
	$Timer.start(2)

func _process(delta):
	$Camera2D.global_position = $Gangster_v2.global_position

	
func process_progress():
	match(progress):
		1:
			$Gangster_v2.move_vector.x = 200
		2:
			$Gangster_v2.move_vector.x = 0
			$Panel.visible = true
			$Panel/Label.text = "There you are, you fucking rat! I'll kill you!"
			$Panel.rect_position = Vector2(-65, -42)
			$Timer.start(1)
		#	progress += 1
		3:
			$Gangster_v2.active_gun = 2
			$Timer.start(1)
		4: 
			$Panel.visible = false
			$Timer.start(1)
		5:
			$Sammy_cutscene_hideout.play_anim("idle")
			$Timer.start(1)
		6:
			$Sammy_cutscene_hideout.scale.x *= -1
			$Timer.start(1)
		7:
			$Sammy_cutscene_hideout.play_anim("walk")
			$Sammy_cutscene_hideout.move_vector.x = 200
			$Timer.start(0.5)
		8:
			$Gangster_v2.move_vector.x = 200
		9:
			$Gangster_v2.global_position += Vector2(100, -100)
			$Gangster_v2.active_gun = 0
			$Gangster_v2.move_vector = Vector2(200, -1000)
		10:
			$Panel.rect_position = Vector2(960,630)
			$Panel.visible = true
			$Panel/Label.text = "Fuck, I lost all my weapons in the water!"
			$Timer.start(2)
		11:
			$Panel.visible = false
			$Timer.start(2)
		12:
			$"/root/LevelManager".increment_level()

func increase_progress():
	progress += 1
	process_progress()
	print("progress: ", str(progress))

func on_stop_area_reached(area2d):
	print("stop area reached")
	increase_progress()

func on_jump_area_reached(area2d):
	area2d.get_parent().move_vector = Vector2(400, -1000)

func on_jump_water_reached(area2d):
	var character = area2d.get_parent()
	if(character == $Sammy_cutscene_hideout):
		$Sammy_cutscene_hideout.move_vector = Vector2(200, -3000)
	if(character == $Gangster_v2):
		$Gangster_v2.move_vector = Vector2.ZERO
		$Timer.start(2)

func on_land_area_entered(area2d):
	var character = area2d.get_parent()
	if(character == $Gangster_v2):
		$Gangster_v2.move_vector.x = 0
		$Timer.start(1)
