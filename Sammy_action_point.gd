extends Area2D

export var jump_left = 0.25
export var jump_right = 0.25
export var run_left = 0.25
export var run_right = 0.25

export var default = "run_left"

onready var rnd = RandomNumberGenerator.new()

var total = 0

func _ready():
	total = jump_left + jump_right + run_left + run_right
	rnd.randomize()

func get_action():
	var outcome = rnd.randf_range(0, total)
	var return_value
	if(jump_left != 0 && outcome <= jump_left):
		return_value = "jump_left"
	elif(jump_right != 0 && outcome <= jump_left+jump_right):
		return_value = "jump_right"
	elif(run_left != 0 && outcome <= jump_left+jump_right+run_left):
		return_value = "run_left"
	elif(run_right != 0 && outcome < jump_left+jump_right+run_left+run_right):
		return_value = "run_right"
	else:
		return_value = default
		
	return return_value
