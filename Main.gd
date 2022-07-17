extends Node2D


func _on_Player_dice_added(number):
	var dice_ui = Global.dice_ui_resource.instance()
	dice_ui.position = Vector2(len(Global.collected_dice)*32-24, 8)
	dice_ui.number = number
	$CanvasLayer.add_child(dice_ui)
