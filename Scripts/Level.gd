extends Node2D

func _init():
	Global.connect("freeing_orphans", self, "_free_if_orphaned")


func _free_if_orphaned():
	if not is_inside_tree():
		queue_free()
		
		
#Tutorial
func _on_Area1_area_entered(area):
	if area.get_parent().name == "Player":
		$TutorialNodes/AnimationPlayer1.play("init1")

func _on_Area1_area_exited(area):
	if area.get_parent().name == "Player":
		$TutorialNodes/AnimationPlayer1.play("hide1")


func _on_Area2_area_entered(area):
	if area.get_parent().name == "Player":
		$TutorialNodes/AnimationPlayer2.play("init2")


func _on_Area2_area_exited(area):
	if area.get_parent().name == "Player":
		$TutorialNodes/AnimationPlayer2.play("hide2")
