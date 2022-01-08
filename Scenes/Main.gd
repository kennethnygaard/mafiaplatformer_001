extends Node

onready var players = get_tree().get_nodes_in_group("player")

func _ready():
	players[0].connect("change_gun_icon", self, "on_gun_icon_changed")

func on_gun_icon_changed(active_gun):
	$HUD/Gun_icon.frame = active_gun
