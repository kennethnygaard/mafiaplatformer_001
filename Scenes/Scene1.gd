extends Node



func _ready():
	print("Scene 1 ready")


func _process(delta):
	$Camera2D.global_position = $Player.global_position
