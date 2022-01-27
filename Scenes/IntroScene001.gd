extends Node

var progress = 0
var johnny_pos = Vector2(-2920, -35)
var donnie_pos = Vector2(-2620, -35)
var dialog_time = 3

func _ready():
	get_tree().paused = false
	progress = 0
	$Timer.connect("timeout", self, "increase_progress")
	$Timer.start(2)
	$Camera2D.global_position = Vector2(-3100, 100)
	$Camera2D.zoom = Vector2(2.5, 2.5)
	$Sammy/AnimationPlayer.play("WALKING")
	$Sammy.visible = false
	
func _process(delta):
	if(Input.is_action_just_pressed("a")):
		increase_progress()
	if(Input.is_action_just_pressed("ui_cancel")):
		$"/root/LevelManager".increment_level()

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
			$Johnny/AnimationPlayer.play("IDLE")
			$Timer.start(2)
		26:
			set_talker("Johnny")
			set_dialog_text("Oh, here he is!", 2)
			$Timer.start(1)
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
			$"/root/LevelManager".increment_level()
			
func set_panel_height(rows):
	$Panel.rect_size.y = 40 + 18*rows

func set_talker(talker):
	if(talker=="Johnny"):
		$Panel.visible = true
		$Panel.rect_global_position.x = $Johnny.global_position.x - 200
	if(talker=="Donnie"):
		$Panel.visible = true
		$Panel.rect_global_position.x = $Gangster_v2.global_position.x + 20
	if(talker=="none"):
		$Panel.visible = false

func set_dialog_text(text, rows):
	$Panel/Label.text = text
	set_panel_height(rows)
