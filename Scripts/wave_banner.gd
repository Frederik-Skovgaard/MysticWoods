extends CanvasLayer

signal wave_start

func start_wave_banner(value):
	$Label.text = value
	$AnimationPlayer.play("Fade_in")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade_in":
		$AnimationPlayer.play("Fade_out")
	elif anim_name == "Fade_out":
		emit_signal("wave_start")
