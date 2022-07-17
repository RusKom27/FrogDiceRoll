extends StaticBody2D

var number = 5
var active = false

func _ready():
	randomize()
	$Sprites/DiceOutline.play("disabled")
	number = randi()%7
	$Sprites/DiceDots.texture = Global.dice_dots[number - 1]


func _on_Timer_timeout():
	if !active:
		$Sprites/Dice.play("roll")
		$Sprites/RollSweep.play("sweep")
	

func _on_RollSweep_animation_finished():
	$Sprites/Dice.play("idle")
	$Sprites/RollSweep.play("idle")

func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player" and !active:
		print("dice")
		$DiceSound.play()
		
		area.get_parent().add_dice(number)
		$Timer.stop()
		active = true
		$Sprites/DiceOutline.play("active")


func _on_RollSweep_frame_changed():
	if $Sprites/RollSweep.frame == 2:
		$DiceRollSound.play()
		randomize()
		number = randi()%7
		$Sprites/DiceDots.texture = Global.dice_dots[number - 1]


func _on_DiceSound_finished():
	$DiceSound.stop()
