extends Node2D

@onready var transition : CanvasLayer = $Transition
@onready var bgm : AudioStreamPlayer = $BGM
@onready var player : CharacterBody2D = $Player
@onready var banner : CanvasLayer = $wave_banner
@onready var timer : Timer = $SpawnTimer
@onready var spawn_location : Node = $Spawnlocation
@onready var point_label : Label = $Points/PointsLabel


var mob_cap = 5
var enemy_count = 0
var enemy_total = 0 
var wave_count = 1

var player_points = 0
var can_move = false

var enemy_list = [
	preload("res://Scense/SlimeEnemy.tscn"),
	preload("res://Scense/SlimeEnemy_2.tscn"),
	preload("res://Scense/SlimeEnemy_3.tscn"),
	preload("res://Scense/SlimeEnemy_4.tscn")
]

func _ready():
	transition.press_start()


func _process(delta):
	player_points = enemy_total - get_tree().get_nodes_in_group("enemies").size()
	point_label.text = str(player_points)
	if Input.is_action_pressed("start") and !can_move:
		timer.start()
		transition.intro_screen()
		player.play_intro_animation()
		bgm.play()
		can_move = true

func _on_player_restart_start():
	bgm.play()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	
	wave_count = 1
	mob_cap = 5
	enemy_count = 0
	enemy_total = 0
	player_points = 0
	
	player.position.x = 357.48
	player.position.y = 190.346

func _on_spawn_timer_timeout():
	if mob_cap != enemy_count:
		var nodes = get_tree().get_nodes_in_group("spawner_node")
		var node = nodes[randi() % nodes.size()]
		var position = node.position
		spawn_location.get_child(0).position = position
		
		
		var enemy_spawn = randf_range(0, enemy_list.size())
		var scene = enemy_list[enemy_spawn].instantiate()
		scene.position = spawn_location.get_child(0).position
		scene.add_to_group("enemies")
		add_child(scene)
		enemy_count += 1
		enemy_total += 1
	else :
		var enemies_live = true
		
		if get_tree().get_nodes_in_group("enemies").is_empty():
			enemies_live = false
			
		if !enemies_live:
			timer.stop()
			wave_count += 1
			mob_cap += 5
			enemy_count = 0
			banner.start_wave_banner("Wave " + str(wave_count))
		
func _on_wave_banner_wave_start():
	timer.start()


func _on_player_death_start():
	$BGM/BGM_Fade.play("fade_out")


func _on_bgm_fade_animation_finished(anim_name):
	bgm.stop()
