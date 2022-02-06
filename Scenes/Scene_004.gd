extends Node

onready var players = get_tree().get_nodes_in_group("player")
onready var Pause_menu = preload("res://Scenes/Pause_menu.tscn")


func _ready():
	players[0].connect("change_gun_icon", self, "on_gun_icon_changed")
	players[0].connect("health_changed", self, "change_health")
	players[0].connect("ammo_changed", self, "on_ammo_changed")
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.connect("health_changed", self, "change_health")
	on_gun_icon_changed(players[0].active_gun)

func _process(delta):
	if(Input.is_action_just_pressed("escape")):
		var pause_menu = Pause_menu.instance()
		add_child(pause_menu)
		get_tree().paused = true

func on_gun_icon_changed(active_gun):
	$HUD/Gun_icon.frame = active_gun

func change_health(new_health):
	var HUD_health = clamp(new_health, 0, 100)
	$HUD/Heart_mask.scale.y = 3*(100.0-HUD_health)/100.0
	
func on_ammo_changed(text):
	$HUD/Ammo/Label.text = text
