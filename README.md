# Mystic Woods
Wave based survivor. Defeat enemies collect point to get the record

# Project Details
| Platform | Language| Timeframe | Target Platoform|
|----------------|-------------|-----------|-----------|
| Godot| GDScript| June| Arcade |

# Shortcuts
**Change Log Updates**
* **Released**

	*  [Version 1.0.0](#Version-1.0.0)
		* [Added](#Version-1.0.0/Added)
		* [Changed](#Version-1.0.0/Changed)
* **Unreleased**

	* [Version 0.8.0](#Version-0.8.0)
		* [Added](#Version-0.8.0/Added)
		* [Changed](#Version-0.8.0/Changed)
	* [Version 0.7.0](#Version-0.7.0)
		* [Added](#Version-0.7.0/Added)
		* [Changed](#Version-0.7.0/Changed)
	* [Version 0.6.0](#Version-0.6.0)
		* [Added](#Version-0.6.0/Added)
		* [Changed](#Version-0.6.0/Changed)
	*  [Version 0.5.0](#Version-0.5.0)
		* [Added](#Version-0.5.0/Added)
	* [Version 0.4.0](#Version-0.4.0)
		* [Added](#Version-0.4.0/Added)
		* [Changed](#Version-0.4.0/Changed)
	* [Version 0.3.0](#Version-0.3.0)
		* [Added](#Version-0.3.0/Added)
	* [Version 0.2.0](#Version-0.2.0)
		* [Added](#Version-0.2.0/Added)
	* [Version 0.1.0](#Version-0.1.0)
		* [Added](#Version-0.1.0/Added)


**Information**
* [System  Requirments](#System-Requirements)
* [Guide](#Guide)
	* [Movement](#Movement)
		 [Options](#Options)
* [Method Used](#Method-Used)
	* [Spawn Methods](#Spawn-methods)

# System Requirements 
**RAM:** 4GB
**Storage**: 1GB
**CPU:** Intel Pentium 4 2.00GHz
**GPU:** NVIDIA GeForce 6100

# Guide
### Movement
* **Up** 		 -  [ARROW-UP]
* **Down**	 -  [ARROW-DOWN]
* **Left**		 -   [ARROW-LEFT]
* **Right**	 -  [ARROW-RIGHT]


### Options
* **Quiet**		 -  [ARROW-UP]
* **Restart** 	 - [LEFT-CLICK]
* **Start** - [LEFT-CLICK]

# Methods
### Player Movement
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
### Enemy spawner
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

# Change log
# [Released]
## [Version 1.0.0]
### Added
- [x] Points system
### Changed
- [x] Small tweaks and polish

# [Unreleased]

## [Version 0.8.0]
### Added
- [x] Added more variation of the enemy slime 
- [x] Character death scene
- [x] Credit scene
- [x] Player can now die and restart game
### Changed
- [x] World scene was re-worked to implement wave-like enemy spawing

## [Version 0.7.0]
### Added
- [x] Background music scene
- [x] Stat scene for enemies 
- [x] Stat scene for player
### Changed
- [x] Re-worked the tile map 

## [Version 0.6.0]
### Added
- [x] Start menu scene
- [x] Created slime scene
- [x] Added collision to the slime
- [x] Created hurtbox/hitbox scene
- [x] Added hitbox to player
### Changed
- [x] Animation changed to move htibox with animation
- [x] Animation play sound when played

## [Version 0.5.0]
### Added
- [x] Created tile map for world scene
- [x] Added trees to world scene
- [x] Made trees and player Y-sorted

## [Version 0.4.0]
### Added
- [x]  Animation tree implemented in the character script
- [x]  Added collision to player
- [x]  Added collision borders in world scene
- [x]  Character added to world scene
### Changed
- [x] Replaced animation from character script
- [x] Movement changed to be more smooth


## [Version 0.3.0] 
### Added
- [x] Add basic movement to character 
- [x] Create animation for player


## [Version 0.2.0] 
### Added
- [x] Add basic movement to character 
- [x] Create animation for player


## [Version 0.1.0] 
### Added
- [x] Create character scene
- [x] Create world scene
- [x] Add texture to character
