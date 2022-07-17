extends Node2D

enum State {
	InMenu,
	EndLevel,
	InGame,
}

var current_state = State.InMenu

func _ready():
	load_level()
	load_all_dice_ui()

func _input(event):
	if event.is_action_pressed("ui_cancel") and current_state == State.InGame:
		current_state = State.InMenu

func _physics_process(delta):
	$BackGround.position += Vector2(3*delta,3*delta)
	if $BackGround.position > Vector2(360,360):
		$BackGround.position = Vector2(0,0)
	match current_state:
		State.InMenu:
			$CanvasLayer/Menu.visible = true
			$CanvasLayer/DiceUI.visible = false
			$CanvasLayer/EndLevel.visible = false
			$AudioStreamPlayer.volume_db = -19.0
			get_tree().paused = true
		State.InGame:
			$CanvasLayer/DiceUI.visible = true
			$CanvasLayer/EndLevel.visible = false
			$CanvasLayer/Menu.visible = false
			$AudioStreamPlayer.volume_db = -10.0
			get_tree().paused = false
		State.EndLevel:
			$CanvasLayer/EndLevel.visible = true
			$CanvasLayer/Menu.visible = false
			$CanvasLayer/DiceUI.visible = false
			$AudioStreamPlayer.volume_db = -19.0			
			get_tree().paused = true
			
			

func open_portal():
	if $Map/Level/TutorialNodes/AnimationPlayer3:
		$Map/Level/TutorialNodes/AnimationPlayer3.play("init3")
	$Map/Level/Portal.open()

func _on_Player_dice_added(number):
	var dice_ui = Global.dice_ui_resource.instance()
	dice_ui.position = Vector2(len(Global.collected_dice)*32-32, 8)
	dice_ui.number = number
	$CanvasLayer/DiceUI/Dice.add_child(dice_ui)
	if len(Global.collected_dice) == len(get_tree().get_nodes_in_group("Dice")):
		$CanvasLayer/DiceUI.modulate = Color("d5dc1d")
		open_portal()

func load_all_dice_ui():
	for child in $CanvasLayer/DiceUI/Dice.get_children():
		child.queue_free()
	for child in $CanvasLayer/DiceUI/AllDice.get_children():
		child.queue_free()
	$CanvasLayer/DiceUI.modulate = Color("fff")
	for i in range(len(get_tree().get_nodes_in_group("Dice"))):
		var dice_ui = Global.dice_ui_resource.instance()
		dice_ui.position = Vector2(i*32, 8)
		dice_ui.modulate = Color("282c3c")
		$CanvasLayer/DiceUI/AllDice.add_child(dice_ui)

func end_level():
	var score = 0
	for i in Global.collected_dice:
		score += i
	$CanvasLayer/EndLevel/Label3.text = str(score)
	current_state = State.EndLevel
	
	
func load_level():
	$Map.remove_child($Map/Level)
	Global.free_orphaned_nodes()
	var level = Global.levels[Global.current_level].instance()
	$Map.add_child(level)
	$Player.position = $Map/Level/PlayerSpawn.position
	$Player.current_state = $Player.State.Jump
	Global.collected_dice = []
	load_all_dice_ui()
	current_state = State.InGame

func change_level(restart = false):
	if restart:
		load_level()
		return
	Global.current_level += 1
	if Global.current_level < len(Global.levels):
		load_level()
	else:
		Global.current_level = 0
		load_level()

func _on_NextLevelButton_pressed():
	change_level()

func _on_ContinueButton_pressed():
	current_state = State.InGame

func _on_RestartButton_pressed():
	change_level(true)

func _on_RestartEndLevelButton_pressed():
	change_level(true)

func _on_MusicOffOnButton_pressed():
	AudioServer.set_bus_mute(2, !AudioServer.is_bus_mute(2))
	if AudioServer.is_bus_mute(2):
		$CanvasLayer/Menu/MusicOffOnButton/Sprite.texture = Global.sound_off_on_texture[1]
	else:
		$CanvasLayer/Menu/MusicOffOnButton/Sprite.texture = Global.sound_off_on_texture[0]

func _on_EffectsOffOnButton2_pressed():
	AudioServer.set_bus_mute(1, !AudioServer.is_bus_mute(1))
	if AudioServer.is_bus_mute(1):
		$CanvasLayer/Menu/EffectsOffOnButton/Sprite.texture = Global.sound_off_on_texture[1]
	else:
		$CanvasLayer/Menu/EffectsOffOnButton/Sprite.texture = Global.sound_off_on_texture[0]
