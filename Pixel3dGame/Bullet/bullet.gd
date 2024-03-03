extends Node3D

const SPEED = 40.0
@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		print("Попал")
		mesh.visible = false
		particles.emitting = true
		if ray.get_collider().is_in_group("Enemy"):
			ray.get_collider().hit()
		await get_tree().create_timer(3).timeout
		queue_free()
		


func _on_timer_timeout():
	queue_free()
