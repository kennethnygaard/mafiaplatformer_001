extends Node

var progress = 0
var johnny_pos = Vector2(-2920, -35)
var donnie_pos = Vector2(-2620, -35)
var dialog_time = 3

var offset_johnny = -200
var offset_sammy = -40

func _ready():
	get_tree().paused = false
	progress = 0
	set_talker("none")
	$Timer.connect("timeout", self, "increase_progress")
	$Timer.start(2)
	$Camera2D.global_position = Vector2(-3100, 100)
	$Camera2D.zoom = Vector2(2.5, 2.5)
	$Sammy/AnimationPlayer.play("WALKING")
	$Sammy.visible = false
	$StopDonnieArea.connect("area_entered", self, "on_donnie_stop_point")
	$Haul_truck.visible = false
	
func _process(delta):
	if(Input.is_action_just_pressed("enter")):
		increase_progress()
	if(Input.is_action_just_pressed("ui_cancel")):
		$"/root/LevelManager".increment_level()
	if(progress > 47 && !$Gangster_v2.reached_stop_point):
		$Camera2D.global_position = $Gangster_v2.global_position - Vector2(0, 40)
		$Gangster_v2.move_vector.x = -$Gangster_v2.move_speed

func increase_progress():
	progress+=1
	print("Progress = ", progress)
	
	match progress:
		1:
			$Camera2D/AnimationPlayer.play("zoom_animation_001")
		3:	
			$Camera2D.zoom = Vector2(0.5, 0.5)
			$Johnny/AnimationPlayer.play("IDLE_TURNED_HEAD")
			$Timer.start(2)
		4:
			$Camera2D.global_position = Vector2(-2685, 100)
			$Johnny/AnimationPlayer.play("IDLE")	
			$Timer.start(0.5)
		5:
			set_panel_height(1)
			set_talker("Johnny")
			set_dialog_text("Johnny:\nThey're running a bit late don't you think?", 5)
			$Timer.start(dialog_time)
			$Haul_truck.visible = true
		6:
			set_talker("Donnie")
			set_dialog_text("Donnie:\nFuck yeah..They were supposed to be here half an hour ago", 5)
			$Timer.start(dialog_time)
		7:
			set_talker("none")
			$Timer.start(0.5)
		8:
			$Johnny/AnimationPlayer.play("IDLE_TURNED_HEAD")
			$Timer.start(1)
		9:			
			$Johnny/AnimationPlayer.play("IDLE")
			$Timer.start(2)
		10:
			set_talker("Johnny")
			set_dialog_text("How are things with the missus?", 3)
			$Timer.start(dialog_time)
		11:
			set_talker("Donnie")
			set_dialog_text("Bah! You know! Same shit!", 2)
			$Timer.start(dialog_time)
		12:
			set_talker("none")
			$Timer.start(1)
		13:
			$Johnny/AnimationPlayer.play("IDLE_TURNED_HEAD")
			$Timer.start(0.5)
		14:
			$Johnny/AnimationPlayer.play("IDLE")
			$Timer.start(0.5)
		15:
			set_talker("Johnny")
			set_dialog_text("Yeah... You two should come over", 2)
			$Timer.start(dialog_time)
		16: 
			set_dialog_text("Be good for both of you..", 2)
			$Timer.start(dialog_time)
		17: 
			set_talker("Donnie")
			set_dialog_text("Thanks, Johnny! You're right..", 2)
			$Timer.start(dialog_time)
		18:
			set_dialog_text("This weekend? I'll talk to Marie, we'll come over", 3)
			$Timer.start(dialog_time)
		19:
			set_talker("none")
			$Timer.start(2)
		20:
			$Johnny/AnimationPlayer.play("IDLE_TURNED_HEAD")
			$Timer.start(1)
		21:
			$Johnny/AnimationPlayer.play("IDLE")
			$Timer.start(0.5)
		22:
			set_talker("Johnny")
			set_dialog_text("Now where the fuck is Sammy?!", 2)
			$Timer.start(dialog_time)
		23:
			set_talker("none")
			$Timer.start(1)
		24:
			$Johnny/AnimationPlayer.play("IDLE_TURNED_HEAD")
			$Timer.start(1)
		25:
			$Camera2D.zoom = Vector2(0.5, 0.5)
			$Camera2D.global_position = Vector2(-2685, 100)
			$Johnny/AnimationPlayer.play("IDLE")
			$Timer.start(2)
		26:
			$Camera2D.zoom = Vector2(0.5, 0.5)
			set_talker("Johnny")
			set_dialog_text("Oh, here he is!", 2)
			$Timer.start(dialog_time)
		27:
			$Gangster_v2.scale.x *= -1
			$Timer.start(2)
		28:
			set_talker("none")
			$Camera2D/AnimationPlayer.play("zoom_animation_002")
			$Timer.start(2)
		29:
			$Sammy.visible = true
			$Sammy.move_vector.x = -$Sammy.move_speed
			$Timer.start(1)
		30:
			$Timer.start(0.5)
		31:
			set_talker("Sammy")
			set_dialog_text("Sorry I was late!", 2)
			$Timer.start(dialog_time)
		32:
			offset_johnny = -130
			set_talker("Johnny")
			set_dialog_text("We were getting a bit worried here..", 3)
			$Timer.start(dialog_time)
		33:
			set_talker("Sammy")
			set_dialog_text("There was trouble with the truck.. Anyway, they're on their way now", 5)
			$Timer.start(dialog_time)
		34:
			set_talker("Johnny")
			set_dialog_text("Great, we're getting really chilly", 4)
			$Timer.start(dialog_time)
		35:
			set_talker("Sammy")
			set_dialog_text("I got some hot coffee for after, when we've loaded the goods", 5)
			$Timer.start(dialog_time)
		36:
			set_talker("Johnny")
			set_dialog_text("Oh my, that'll be great!", 3)
			$Timer.start(dialog_time)
		37:
			set_talker("Sammy")
			set_dialog_text("They're here any moment now, I'll just go get the paperwork", 5)
			$Timer.start(dialog_time)
		38:
			set_talker("Johnny")
			set_dialog_text("All right!", 2)
			$Timer.start(dialog_time)
		39:
			set_talker("Sammy")
			set_dialog_text("I'll be quick", 2)
			$Timer.start(dialog_time)
		40:
			set_talker("none")
			$Timer.start(1)
		41:
			$Sammy.scale.x *= -1
			$Timer.start(0.5)
		42:
			$Sammy.play_walk_animation()
			$Sammy.walk("left")
			$Timer.start(1)
		43:
			$Sammy.visible = false
			$Sammy.walk("still")
			$Johnny.scale.x *= -1
			$Timer.start(0.5)
		44:
			set_talker("Johnny")
			set_dialog_text("Oh, here they are!", 2)
			$Timer.start(0.5)
		45:
			$Gangster_v2.scale.x *= -1
			$Timer.start(1)
		46:
			set_dialog_text("Let's get it done, then", 2)
			$Timer.start(dialog_time)
		47:
			set_talker("none")
			$Johnny/AnimationPlayer.play("WALKING")
			$Johnny.move_vector = Vector2(-$Johnny.walk_speed, 0)
			$Timer.start(1)
		48:
			$Gangster_v2.move_vector = Vector2(-100, 0)
		49: 
			offset_johnny = -50
			$Panel.rect_position = $Johnny.global_position + Vector2(0, -150)
			set_talker("Johnny")
			set_dialog_text("What the fuck? Get away, Donnie!", 3)
			$Timer.start(1)
		50:
			set_talker("none")
			$Johnny/AnimationPlayer.playback_speed = 1.5
			$Johnny/Cigarette_smoke.visible = false
			$Johnny/AnimationPlayer.play("GET_SHOT")
			$Timer.start(2)
		51:
			$"/root/LevelManager".increment_level()
			
func set_panel_height(rows):
	$Panel.rect_size.y = 40 + 18*rows

func set_talker(talker):
	if(talker=="Johnny"):
		$Panel.visible = true
		$Panel.rect_global_position.x = $Johnny.global_position.x + offset_johnny
	if(talker=="Donnie"):
		$Panel.visible = true
		$Panel.rect_global_position.x = $Gangster_v2.global_position.x + 20
	if(talker=="Sammy"):
		$Panel.visible = true
		$Panel.rect_global_position.x = $Sammy.global_position.x + offset_sammy
	if(talker=="none"):
		$Panel.visible = false

func set_dialog_text(text, rows):
	$Panel/Label.text = text
	set_panel_height(rows)

func on_donnie_stop_point(area2d):
	increase_progress()
