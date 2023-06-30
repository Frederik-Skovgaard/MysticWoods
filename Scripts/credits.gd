extends CanvasLayer

signal credit_finished

func play_credits():
	$AnimationPlayer.play("fade_out")

func _on_animation_player_animation_finished(anim_name):
	emit_signal("credit_finished")
