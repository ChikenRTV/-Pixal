extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 8.5
const SENSITIVITY = 0.01
var PATRONS = 10
var ENEMYCON = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var pistolAnim = $Head/Camera3D/Pistol/LaserGun/AnimationPlayer
@onready var pistol = $Head/Camera3D/Pistol/AudioStreamPlayer
@onready var pistol_ray = $Head/Camera3D/Pistol/RayCast3D

var bullet = load("res://Bullet/bullet.tscn")



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Patrons/Label.text = str(PATRONS)
	$EnemyIcon/Label.text = str(ENEMYCON)
	if Global.Rig_Det == false:
		$Head/Camera3D/Pistol.position.x = -0.317
	elif Global.Rig_Det == true:
		$Head/Camera3D/Pistol.position.x = 0.317
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40),deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Jump.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = 0
			velocity.z = 0
	else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 2)
		
	if Input.is_action_pressed("shoot"):
		if !pistolAnim.is_playing() and PATRONS >0 :
			pistol.play()
			PATRONS -= 1
			$Patrons/Label.text = str(PATRONS)
			pistolAnim.play("lasergunShoot")
			var instance = bullet.instantiate()
			instance.position = pistol_ray.global_position
			instance.transform = pistol_ray.global_transform
			get_parent().add_child(instance)
		if !pistolAnim.is_playing() and PATRONS <=0 :
			$Patrons/Label.text = "Перезарядка"
			pistolAnim.play("magReload")
			await get_tree().create_timer(1).timeout
			PATRONS = 10
			$Patrons/Label.text = str(PATRONS)

	move_and_slide()


func _on_colison_item_body_entered(body):
	if body.is_in_group("Chest"):
		$Control/OpenE.visible = true
		var anima = body.get_node('AnimationPlayer')
		var anima2 = body.get_node('CollisionShape3D')
		while $Control/OpenE.visible == true:
			await get_tree().create_timer(0.1).timeout
			if Input.is_action_pressed("E"):
				print("privet")
				$Control/OpenE.visible = false
				anima2.queue_free()
				anima.play("CrateOpen")
				body.Open = true
				PATRONS += 5
				
				$Patrons/Label.text = str(PATRONS)




func _on_colison_item_body_exited(body):
	if body.is_in_group("Chest"):
		$Control/OpenE.visible = false


func dead_enemy():
	ENEMYCON -= 1
	$EnemyIcon/Label.text = str(ENEMYCON)
