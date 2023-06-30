extends CharacterBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var stats : Node = $Stats
@onready var detection : Area2D = $DetectionZone
@onready var hurtbox : Area2D = $Hurtbox
@onready var hitbox : Area2D = $Hitbox

@export var ACCELERATION = 1000
@export var MAX_SPEED = 1000	
@export var FRICTION = 1000

var movement_impared = false
var knockback_dir

var path : Array = [] 
var NavigationNode = null
var player = null

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE

func _ready():
	animation_player.play("idle_right")
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION * delta)
			if !movement_impared:
				seek_player()
		WANDER:
			pass
		CHASE:
			seek_player()
			if not $NavigationAgent2D.is_navigation_finished():
				var movement_delta = MAX_SPEED * delta
				var current_agent_position = global_position
				var next_path_position = $NavigationAgent2D.get_next_path_position()
				velocity = (next_path_position - current_agent_position).normalized() * movement_delta
			else:
				state = IDLE 	
			
			if velocity.x < 0:
				animation_player.play("move_left")
			else:
				animation_player.play("move_right")
	move_and_slide()
	
	
func seek_player():
	if detection.can_player_see():
		player = detection._return_player()
		$NavigationAgent2D.target_position = player.position
		state = CHASE

func _on_hurtbox_area_entered(area):
	if !movement_impared:
		knockback_dir = (area.get_parent().get_parent().velocity - velocity).normalized()
		velocity = area.knockback_vector * 200
		
		
	if stats.health != 0:
		movement_impared = true
		state = IDLE
		if knockback_dir.x > 0 :
			animation_player.play("damage_left")
		else:
			animation_player.play("damage_right")
		stats.health -= area.damage

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "die_right" or anim_name == "die_left":
		queue_free()
	elif anim_name == "damage_right" or anim_name == "damage_left":
		state = CHASE
		movement_impared = false
		animation_player.play("idle_right")

func _on_stats_no_health():
	hitbox.queue_free()
	$CollisionShape2D.queue_free()
	if knockback_dir.x > 0:
		animation_player.play("die_left")
	else:
		animation_player.play("die_right")
