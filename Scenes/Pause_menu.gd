extends CanvasLayer

var active_item = 0
var active_anims = ["continue_active", "SFX_volume_active", "music_volume_active", "quit_active"]
var volume_steps = 10

onready var menu_labels = $MenuLabels.get_children()

func _ready():
	update_volume_labels()
	$AnimationPlayer.play("continue_active")


func _process(delta):
	process_input()
	process_anims()
	
func process_input():
	if(Input.is_action_just_pressed("ui_down")):
		active_item += 1
		if(active_item > menu_labels.size()-1):
			active_item = 0
		$Audioplayer/MenuChange.play()
	if(Input.is_action_just_pressed("ui_up")):
		active_item -= 1
		if(active_item < 0):
			active_item = menu_labels.size()-1
		$Audioplayer/MenuChange.play()
		
	if(Input.is_action_just_pressed("ui_left")):
		match(active_item):
			1:
				if($"/root/Globals".SFX_volume - volume_steps > 0-volume_steps):
					$Audioplayer/MenuChange.play()
				else:
					$Audioplayer/MenuThud.play()
				$"/root/Globals".SFX_volume = clamp($"/root/Globals".SFX_volume-volume_steps, 0, 100)
				$MenuLabels/SFX_volume.text = "SFX Volume: " + str($"/root/Globals".SFX_volume) + "%"
				set_sfx_volume($"/root/Globals".SFX_volume)
			2:
				if($"/root/Globals".music_volume - volume_steps > 0-volume_steps):
					$Audioplayer/MenuChange.play()
				else:
					$Audioplayer/MenuThud.play()
				$"/root/Globals".music_volume = clamp($"/root/Globals".music_volume-volume_steps, 0, 100)
				update_volume_labels()
				set_music_volume($"/root/Globals".music_volume)
	
	if(Input.is_action_just_pressed("ui_right")):
		match(active_item):
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
	
	if(Input.is_action_just_pressed("escape")):
		get_tree().paused = false
		queue_free()
		
	if(Input.is_action_just_pressed("enter")):
		match(active_item):
			0:
				get_tree().paused = false
				queue_free()
			3:
				get_tree().paused = false
				$"/root/LevelManager".change_level(0)

func process_anims():
	for i in range(active_anims.size()):
		if(i == active_item):
			$AnimationPlayer.play(active_anims[i])
			menu_labels[i].add_color_override("font_color", Color(1, 0, 0, 1))
		else:
			menu_labels[i].add_color_override("font_color", Color(1, 1, 1, 1))
			#$AnimationPlayer.play(inactive_anims[i])

func update_volume_labels():
	$MenuLabels/SFX_volume.text = "SFX Volume: " + str($"/root/Globals".SFX_volume) + "%"
	$MenuLabels/Music_volume.text = "Music Volume: " + str($"/root/Globals".music_volume) + "%"

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
