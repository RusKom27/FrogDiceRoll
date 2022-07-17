extends Node

signal freeing_orphans

onready var dice_dots = [
	load("res://Sprites/dice_dot1.png"),
	load("res://Sprites/dice_dot2.png"),
	load("res://Sprites/dice_dot3.png"),
	load("res://Sprites/dice_dot4.png"),
	load("res://Sprites/dice_dot5.png"),
	load("res://Sprites/dice_dot6.png"),
]

onready var levels = [
	#load("res://Levels/Default.tscn"),
	load("res://Levels/Level1.tscn"),
	load("res://Levels/Level2.tscn"),
]

onready var jump_out_effect_resource = load("res://Components/JumpOutEffect.tscn")
onready var jump_in_effect_resource = load("res://Components/JumpInEffect.tscn")
onready var dice_ui_resource = load("res://Components/UI/DiceUI.tscn")


var collected_dice = []
var current_level = 0

func _ready():
	pass 

func free_orphaned_nodes():
	emit_signal("freeing_orphans")
