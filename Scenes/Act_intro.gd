extends CanvasLayer

export var act_number = 1
export(String) var act_title = "title"

func _ready():
	$Label.text = "Act " + str(act_number) + "\n" + act_title

func unpause():
	get_tree().paused = false
