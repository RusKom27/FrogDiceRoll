extends StaticBody2D

var number = 5
var active = false

func _ready():
	randomize()
	$DiceOutline.play("disabled")
	number = randi()%7
	$DiceDots.texture = Global.dice_dots[number - 1]


func _on_Timer_timeout():
	if !active:
		$Dice.play("roll")
		$RollSweep.play("sweep")
	

func _on_RollSweep_animation_finished():
	$Dice.play("idle")
	$RollSweep.play("idle")

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player" and !active:
		area.get_parent().add_dice(number)
		$Timer.stop()
		active = true
		$DiceOutline.play("active")


func _on_RollSweep_frame_changed():
	if $RollSweep.frame == 2:
		randomize()
		number = randi()%7
		$DiceDots.texture = Global.dice_dots[number - 1]
