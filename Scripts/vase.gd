extends Node2D

func _process(delta):
	pass

func _on_animation_player_animation_finished(anim_name):
	queue_free()


func _on_hurtbox_area_entered(area):
	$AnimationPlayer.play("broke")
