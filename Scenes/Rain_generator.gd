extends Node

onready var timer = $Timer
onready var Raindrop = preload("res://Scenes/RainDrop.tscn")

func _ready():
	$Timer.connect("timeout", self, "spawn_raindrop")
	#$Timer.start(0.05)

func _process(delta):
	pass
	
func spawn_raindrop():
	var main = get_parent()
	for i in range(15):
		var newDrop = Raindrop.instance()
		main.add_child(newDrop)
