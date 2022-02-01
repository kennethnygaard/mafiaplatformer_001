extends Node

func _ready():
	$Camera2D.global_position = $Gangster_v2.global_position
	
	$EndArea.connect("area_entered", self, "on_end_area_entered")
	$End_fadeout/Sprite.modulate = Color(1, 1, 1, 0)
	$End_fadeout/Sprite.visible = true
	#get_tree().paused = true

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
