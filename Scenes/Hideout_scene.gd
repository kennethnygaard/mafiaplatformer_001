extends Node

func _ready():
	$Camera2D.global_position = $Gangster_v2.global_position
	
#	$EndArea.connect("area_entered", self, "on_end_area_entered")
#	$End_fadeout/Sprite.modulate = Color(1, 1, 1, 0)
	
	get_tree().paused = true
	pass
	
func _process(delta):
	$Camera2D.global_position = $Gangster_v2.global_position 
