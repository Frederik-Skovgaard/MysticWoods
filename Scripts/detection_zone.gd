extends Area2D

var player = null
var _body

func can_player_see():
	return player != null

func _on_body_entered(body):
	player = body
	_body = body

func _return_player():
	return _body

func _on_body_exited(body):
	player = null
