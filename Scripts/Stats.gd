extends Node

@export var max_health = 1
@onready var health = max_health : set = _set_health

signal no_health

func _set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
