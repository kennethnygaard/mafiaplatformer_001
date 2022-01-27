extends Node


var active_item = 0
var active_anims = ["start_active", "SFX_volume_active", "music_volume_active", "select_level_active", "quit_active"]
var inactive_anims = ["start_inactive", "SFX_volume_inactive", "music_volume_inactive", "select_level_inactive", "quit_inactive"]
onready var menu_labels = $CanvasLayer/MenuLabels.get_children()

var SFX_volume = 100
var musicvolume = 100
var volume_steps = 10

func _ready():
	$AnimationPlayer.play("start_active")

func _process(delta):
	process_input()
	update_anims()
	
func process_input():
	if(Input.is_action_just_pressed("ui_down")):
		active_item += 1
		if(active_item > 4):
			active_item = 0
		$Audioplayer/MenuChange.play()
	if(Input.is_action_just_pressed("ui_up")):
		active_item -= 1
		if(active_item < 0):
			active_item = 4
		$Audioplayer/MenuChange.play()
		
	if(Input.is_action_just_pressed("ui_left")):
		match active_item:
			0:
				pass
			1:
				$Audioplayer/MenuChange.play()
				SFX_volume = clamp(SFX_volume-volume_steps, 0, 100)
				$"CanvasLayer/MenuLabels/SFX Volume".text = "SFX Volume: " + str(SFX_volume) + "%"
				set_sfx_volume(SFX_volume)
				
	if(Input.is_action_just_pressed("ui_right")):
		match active_item:
			0:
				pass
			1:
				$Audioplayer/MenuChange.play()
				SFX_volume = clamp(SFX_volume+volume_steps, 0, 100)
				$"CanvasLayer/MenuLabels/SFX Volume".text = "SFX Volume: " + str(SFX_volume) + "%"
				set_sfx_volume(SFX_volume)
		
	if(Input.is_action_just_pressed("ui_select")):
		match active_item:
			0:
				LevelManager.change_level(1)
			4:
				get_tree().quit()
	
func update_anims():
	for i in range(active_anims.size()):
		if(i == active_item):
			$AnimationPlayer.play(active_anims[i])
			menu_labels[i].add_color_override("font_color", Color(1, 0, 0, 1))
		else:
			menu_labels[i].add_color_override("font_color", Color(1, 1, 1, 1))
			#$AnimationPlayer.play(inactive_anims[i])

func set_sfx_volume(vol):
	vol /= 100.0
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	var volume = linear2db(vol)
	AudioServer.set_bus_volume_db(sfx_bus_index, volume)
	print(vol)
