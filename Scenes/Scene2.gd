extends Node

var start_ammo = [0, 1, 3, 0, 0]
var start_guns = [true, false, true, false, false]
var active_gun = 2

func _ready():
	$Camera2D.global_position = $Gangster_v2.global_position
	
	$EndArea.connect("area_entered", self, "on_end_area_entered")
	$End_fadeout/Sprite.modulate = Color(1, 1, 1, 0)
	$Die_fadeout/Sprite.modulate = Color(1, 1, 1, 0)
	
	$End_fadeout/Sprite.visible = true
	$Die_fadeout/Sprite.visible = true

	get_tree().paused = true

func _process(delta):
	$Camera2D.global_position = $Gangster_v2.global_position 

func unpause():
	get_tree().paused = false

func on_end_area_entered(_area2d):
	print("the end is nigh")
	$Enemies/EndPolice1.is_paused = false
	$Sammys_escape_car.start_driving()
	
func start_end_fadeout():
	$End_fadeout/AnimationPlayer.play("fadeout")

func end_level():
	print("level ended")
	$"/root/LevelManager".increment_level()

func die_fadeout():
	$"/root/Globals".scene_to_start = 2
	$Die_fadeout/AnimationPlayer.play("fadeout")	

func restart_level():
	get_tree().change_scene("res://Scenes/Restart_level_scene.tscn")
