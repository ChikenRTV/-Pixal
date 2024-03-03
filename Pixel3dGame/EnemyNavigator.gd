extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
var SPEED = 3.8
var HPZ = 3
func _physics_process(delta):
	
	var current_location = global_transform.origin
	
	var next_location = nav_agent.get_next_path_position()
	
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	

	
func target_location(target_location):
	nav_agent.target_position = target_location

func hit():
	HPZ -= 3
	if HPZ <= 0:
		$"../Player".dead_enemy()
		queue_free()

func _on_timer_timeout():
	var player = $"../Player"
	target_location(player.global_position)
