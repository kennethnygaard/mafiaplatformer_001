extends Node

var start_ammo = [0, 1, 0, 0, 0]
var start_guns = [true, false, false, false, false]
var active_gun = 0
var endprogress = 0

var the_end = false

func _ready():
	get_tree().paused = true
	$Camera2D.global_position = $Gangster_v2.global_position
	$Showdown_Sammy.connect("Sammy_died", self, "on_sammy_died")
	$TheEndTimer.connect("timeout", self, "on_end_timer")
	$Panel.visible = false
	$End_fadeout/Sprite.modulate = Color(1, 1, 1, 0)
	$End_fadeout/Label.modulate = Color(1, 1, 1, 0)


func _process(delta):
	$Camera2D.global_position = $Gangster_v2.global_position
	if(Input.is_action_just_pressed("escape") || Input.is_action_just_pressed("enter")):
		if(the_end):
			$"/root/LevelManager".change_level(0)	
	

func on_sammy_died():
	$Gangster_v2.activated = false
	$TheEndTimer.start(4)

func on_end_timer():
	if(endprogress == 0):
		$MusicPlayer.stop()
		$Panel.visible = true
		$Panel/Label.text = "You motherfucker! I beat you to the pulp you deserve to be!"
		$Panel.rect_position = $Gangster_v2.global_position - Vector2(90, 200)
		endprogress += 1
		$TheEndTimer.start(5)
	else:

		$End_fadeout/AnimationPlayer.play("fadeout")

func set_the_end():
	the_end = true
