extends Node

onready var rnd = RandomNumberGenerator.new()
var is_footstep_playing = false
onready var steps_audio_players = $Steps_SFX_Player.get_children()

var footsteps_min_pich = 0.9
var footsteps_max_pitch = 1.1

func _ready():
	rnd.randomize()
	for player in steps_audio_players:
		player.connect("finished", self, "on_finished_footstep")


func play_gunshot():
	var audioplayers = $Gun_SFX_Player.get_children()
	var n = audioplayers.size()	
	var i = rnd.randi_range(0, n-1)
	audioplayers[i].play()

func play_footstep():
	var n = steps_audio_players.size()
	var i = rnd.randi_range(0, n-1)
	i = rnd.randi_range(1, 2)
	
	if(!is_footstep_playing):
		is_footstep_playing = true
		var pitch = rnd.randf_range(footsteps_min_pich, footsteps_max_pitch)
		steps_audio_players[i].play()
		steps_audio_players[i].pitch_scale = pitch

func play_hop():
	$Hop_SFX_Player/AudioStreamPlayer.play()
	
func play_SMG():
	$SMG_SFX_player/AudioStreamPlayer.play()

func play_police_rifle():
	$Police_rifle_SFX_player/AudioStreamPlayer.play()

func play_pistol_click():
	$Pistol_click_player/AudioStreamPlayer.play()

func play_baseball_hit():
	$Baseball_bat_hit_player/AudioStreamPlayer.play()

func play_baseball_bat_miss():
	$Baseball_bat_miss_player/AudioStreamPlayer.play()

func play_siegfrieds_cannon():
	$Siegfrieds_cannon_player/AudioStreamPlayer.play()
	$Siegfrieds_cannon_player/AudioStreamPlayer2.play()

func on_finished_footstep():
	is_footstep_playing = false

