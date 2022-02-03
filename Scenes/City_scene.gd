extends Node

var start_ammo = [0, 1, 6, 0, 0]
var start_guns = [true, false, true, false, false]
var active_gun = 0

func _ready():
	$Camera2D.global_position = $Gangster_v2.global_position
	
	$EndArea.connect("area_entered", self, "on_end_area_entered")
	$End_fadeout/Sprite.modulate = Color(1, 1, 1, 0)
	$End_fadeout/Sprite.visible = true
	$Die_fadeout/Sprite.modulate = Color(1, 1, 1, 0)
	$Die_fadeout/Sprite.visible = true
	#get_tree().paused = true
	
	$"/root/Globals".set_music_volume()

func _process(_delta):
	$Camera2D.global_position = $Gangster_v2.global_position 

func unpause():
	get_tree().paused = false

func on_end_area_entered(area2d):
	if(area2d.get_parent().type == "player"):
		print("end of level")
		$End_fadeout/AnimationPlayer.play("fadeout")
		get_tree().paused = true
		
func end_level():
	$"/root/LevelManager".increment_level()

func die_fadeout():
	$"/root/Globals".scene_to_start = 4
	$Die_fadeout/AnimationPlayer.play("fadeout")	

func restart_level():
	print("restart here")

	get_tree().change_scene("res://Scenes/Restart_level_scene.tscn")

