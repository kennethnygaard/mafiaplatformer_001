extends Node

var progress = 0

var story = ["After the raid at the warehouse, and Johnnie's death, Donnie went into mourning.",
"His best friend was dead. \n\nAnd someone he thought was his friend had betrayed them both..",
"After a few weeks, Donnie got word that Sammy was hiding in a bar downtown.",
"Only thing was, Sammy's thugs knew Donnie would come looking for him..."]


func _ready():
	pass # Replace with function body.
	$Panel.rect_size = Vector2(400, 230)
	$Panel/Label.text = story[0]
	print("story telling thins ready")

func _process(delta):
	if(Input.is_action_just_pressed("enter")):
		print("enter pressed")
		progress += 1
		
		if(progress >= story.size()):
			$"/root/LevelManager".increment_level()
		else:
			$Panel/Label.text = story[progress]


func set_panel_height(rows):
	$Panel.rect_size.y = 40 + 18*rows

func next():
	pass
