extends Node

func _ready():
	$Camera2D.global_position = $Gangster_v2.global_position
	
	$EndArea.connect("area_entered", self, "on_end_area_entered")
	$End_fadeout/Sprite.modulate = Color(1, 1, 1, 0)
	
	get_tree().paused = true
	
	
func _process(delta):
	$Camera2D.global_position = $Gangster_v2.global_position 

func on_end_area_entered(_area2d):
	print("the end is nigh")
	$End_fadeout/AnimationPlayer.play("fadeout")

func end_level():
	print("level ended")
	$"/root/LevelManager".increment_level()
