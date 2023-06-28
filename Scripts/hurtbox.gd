extends Area2D

var invincible = false : set = set_invincible

@onready var timer : Timer = $Timer

signal invinciblility_started
signal invinciblility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invinciblility_started")
	else:
		emit_signal("invinciblility_ended")

func start_invicibility(duration):
	self.invincible = true
	timer.start(duration)	


func _on_timer_timeout():
	self.invincible = false


func _on_invinciblility_started():
	set_deferred("monitorable", false)


func _on_invinciblility_ended():
	monitorable = true
