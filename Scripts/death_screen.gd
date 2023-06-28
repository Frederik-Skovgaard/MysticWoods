extends CanvasLayer

signal death_finished
signal death_try_again
signal credits

func play_death():
	$AnimationPlayer.play("transition")
	
func play_retry():
	$AnimationPlayer.play("try_again")
	
func play_credit_transition():
	$AnimationPlayer.play("credit_transition")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "transition":
		emit_signal("death_finished")
	elif anim_name == "try_again":
		emit_signal("death_try_again")
	elif anim_name == "credit_transition":
		emit_signal("credits")
