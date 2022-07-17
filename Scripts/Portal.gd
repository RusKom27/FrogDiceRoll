extends Node2D



func open():
	if $InitialEffect:
		visible = true
		$InitialEffect.visible = true
		$InitialEffect.play("init")
	

func _on_InitialEffect_animation_finished():
	remove_child($InitialEffect)


func _on_InitialEffect_frame_changed():
	if $InitialEffect:
		if $InitialEffect.frame == 7:
			
			$AnimatedSprite.visible = true
			$AnimatedSprite.play("idle")
			
