extends CharacterBody2D

@export var ACCELERATION = 500
@export var MAX_SPEED = 100
@export var FRICTION = 500
@export var KNOCKBACK_POWER = 200

@onready var sprite : Sprite2D = $Sprite2D
@onready var sfx : CanvasGroup = $SFX
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var swordhitbox : Area2D = $HitboxPivot/SwordHitbox
@onready var ui : CanvasLayer = $UI
@onready var hurtbox : Area2D = $Hurtbox
@onready var hurtboxCollisuion : CollisionShape2D = $Hurtbox/CollisionPolygon2D
@onready var credits : CanvasLayer = $credits

var state = true
var can_move = false
var input_vector : Vector2 = Vector2.ZERO
var stats = PlayerStats

signal restart_start
signal death_start
signal end_game

func _ready():
	stats.no_health.connect(player_died)


func player_died():
	ui._fade_out()
	hurtboxCollisuion.set_deferred("disabled", true)
	can_move = false
	animation_tree.active = false
	
	if input_vector.x < 0:
		animation_player.play("die_left")
	else:
		animation_player.play("die_right")


func _process(delta):
	if can_move:
		update_animation_parameters()
		if state:
			move_state(delta)
		else:
			attack_state(delta)	
	elif !state and Input.is_action_just_pressed("attack"):
		emit_signal("restart_start")
		state = true
		hurtboxCollisuion.set_deferred("disabled", false)
		stats.health = 4
	elif !state and Input.is_action_just_pressed("ui_up"):
		emit_signal("end_game")
		
	
func move_state(delta):	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		swordhitbox.knockback_vector = input_vector
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)	
	move_and_slide()
	
func attack_state(delta):
	velocity = Vector2.ZERO

func attack_animation_finished():
	state= true
	
func update_animation_parameters():
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		
		
	if Input.is_action_just_pressed("attack"):
		animation_tree["parameters/conditions/attack"] = true
		state = false
	else: 
		animation_tree["parameters/conditions/attack"] = false
	
	if input_vector != Vector2.ZERO:
		animation_tree["parameters/Idle/blend_position"] = input_vector
		animation_tree["parameters/Run/blend_position"] = input_vector
		animation_tree["parameters/Attack/blend_position"] = input_vector

	
func play_intro_animation():
	animation_player.play("intro")

func _on_hurtbox_area_entered(area):
	if stats.health > 0:
		sfx.get_child(1).play()
		stats.health -= 1
		knockback(area.get_parent().velocity)
		ui._health_reduction(stats.health)
		hurtbox.start_invicibility(1)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "die_left" or anim_name == "die_right":
		emit_signal("death_start")


func knockback(enemyVelocity):
	var knockback_dir = (enemyVelocity - velocity).normalized() * KNOCKBACK_POWER
	velocity = knockback_dir
	move_and_slide()

func _on_death_screen_death_try_again():
	can_move = true
	animation_tree.active = true

func _dead():
	state = false

func _live():
	ui._fade_in()
	can_move = true
	animation_tree.active = true
	
func _credits():
	credits.play_credits()
	
func _on_credits_credit_finished():
	get_tree().quit()


func _on_transition_transitioned():
	can_move = true
	animation_tree.active = true
