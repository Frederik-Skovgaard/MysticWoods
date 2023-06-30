extends CanvasLayer

func _heart_restart():
	$HealthBar/Four.show()
	$HealthBar/Three.hide()
	$HealthBar/Two.hide()
	$HealthBar/One.hide()
	$HealthBar/Dead.hide()


func _fade_in():
	$AnimationPlayer.play("fade_in")

func _fade_out():
	$AnimationPlayer.play("fade_out")

func _health_reduction(value):
	match value:
		3:
			$HealthBar/Four.hide()
			$HealthBar/Three.show()
		2:
			$HealthBar/Three.hide()
			$HealthBar/Two.show()
		1:
			$HealthBar/Two.hide()
			$HealthBar/One.show()
		0:
			$HealthBar/One.hide()
			$HealthBar/Dead.show()
