extends Node

onready var dice_dots = [
	load("res://Sprites/dice_dot1.png"),
	load("res://Sprites/dice_dot2.png"),
	load("res://Sprites/dice_dot3.png"),
	load("res://Sprites/dice_dot4.png"),
	load("res://Sprites/dice_dot5.png"),
	load("res://Sprites/dice_dot6.png"),
]

onready var jump_out_effect_resource = load("res://Components/JumpOutEffect.tscn")
onready var jump_in_effect_resource = load("res://Components/JumpInEffect.tscn")
onready var dice_ui_resource = load("res://Components/UI/DiceUI.tscn")


var collected_dice = []

func _ready():
	pass 
