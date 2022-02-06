extends Node

var active_item = 0
var active_anims = ["start_active", "SFX_volume_active", "music_volume_active", "select_level_active", "quit_active"]
var inactive_anims = ["start_inactive", "SFX_volume_inactive", "music_volume_inactive", "select_level_inactive", "quit_inactive"]
onready var menu_labels = $CanvasLayer/MenuLabels.get_children()

var volume_steps = 10
var selected_level = 1

var levels = [0, 1, 4, 5, 7]
var max_level = 4

func _ready():
	update_volume_labels()
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
				if($"/root/Globals".SFX_volume - volume_steps > 0-volume_steps):
					$Audioplayer/MenuChange.play()
				else:
					$Audioplayer/MenuThud.play()
				$"/root/Globals".SFX_volume = clamp($"/root/Globals".SFX_volume-volume_steps, 0, 100)
				update_volume_labels()
				set_sfx_volume($"/root/Globals".SFX_volume)
			2:
				if($"/root/Globals".music_volume - volume_steps > 0-volume_steps):
					$Audioplayer/MenuChange.play()
				else:
					$Audioplayer/MenuThud.play()
				$"/root/Globals".music_volume = clamp($"/root/Globals".music_volume-volume_steps, 0, 100)
				update_volume_labels()
				set_music_volume($"/root/Globals".music_volume)
			3:
				if(selected_level>1):
					$Audioplayer/MenuChange.play()
				else:
					$Audioplayer/MenuThud.play()
				selected_level = clamp(selected_level-1, 1, max_level)
				$CanvasLayer/MenuLabels/SelectLevel.text = "Select Level: " + str(selected_level)
				
	if(Input.is_action_just_pressed("ui_right")):
		match active_item:
			0:
				pass
			1:
				if($"/root/Globals".SFX_volume + volume_steps < 100+volume_steps):
					$Audioplayer/MenuChange.play()
				else:
					$Audioplayer/MenuThud.play()
				$"/root/Globals".SFX_volume = clamp($"/root/Globals".SFX_volume+volume_steps, 0, 100)
				update_volume_labels()
				set_sfx_volume($"/root/Globals".SFX_volume)
			2:
				if($"/root/Globals".music_volume + volume_steps < 100+volume_steps):
					$Audioplayer/MenuChange.play()
				else:
					$Audioplayer/MenuThud.play()
				$"/root/Globals".music_volume = clamp($"/root/Globals".music_volume+volume_steps, 0, 100)
				update_volume_labels()
				set_music_volume($"/root/Globals".music_volume)
			3:
				if(selected_level<max_level):
					$Audioplayer/MenuChange.play()
				else:
					$Audioplayer/MenuThud.play()
				selected_level = clamp(selected_level+1, 1, max_level)
				$CanvasLayer/MenuLabels/SelectLevel.text = "Select Level: " + str(selected_level)

	if(Input.is_action_just_pressed("ui_select")):
		match active_item:
			0:
				LevelManager.change_level(levels[selected_level])
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

func update_volume_labels():
	$"CanvasLayer/MenuLabels/SFX Volume".text = "SFX Volume: " + str($"/root/Globals".SFX_volume) + "%"
	$"CanvasLayer/MenuLabels/Music Volume".text = "Music Volume: " + str($"/root/Globals".music_volume) + "%"

func set_sfx_volume(vol):
	vol /= 100.0
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	var volume = linear2db(vol)
	AudioServer.set_bus_volume_db(sfx_bus_index, volume)
	
func set_music_volume(vol):
	vol /= 100.0
	var music_bus_index = AudioServer.get_bus_index("Music")
	var volume = linear2db(vol)
	AudioServer.set_bus_volume_db(music_bus_index, volume)
