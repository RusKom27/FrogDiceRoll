extends Node2D


var number = 5
var active = false

func _ready():
	$DiceDots.texture = Global.dice_dots[number - 1]
	$DiceOutline.play("disabled")
	$Dice.play("roll")
	$RollSweep.play("sweep")

func _on_RollSweep_animation_finished():
	$Dice.play("idle")
	$RollSweep.play("idle")
	$DiceOutline.play("active")
