extends CanvasLayer

signal transitioned

func intro_screen():
	$AnimationPlayer.play("fade_out")

func press_start():
	$AnimationPlayer.play("space_float")


func _on_animation_player_animation_finished(anim_name):
	emit_signal("transitioned")
