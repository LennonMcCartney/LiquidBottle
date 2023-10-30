@tool
extends Node3D

@export var width : float
@export var height : float

@export_range(-2, 2, 0.0001) var fill_amount : float

@export_range(0.0, 0.02, 0.0001) var glass_thickness : float

@export_color_no_alpha var liquid_colour : Color
@export_color_no_alpha var surface_colour : Color

@onready var rigid_body : RigidBody3D = $RigidBody
@onready var mesh_instance : MeshInstance3D = $RigidBody/CollisionShape/MeshInstance

@onready var liquid_shader : ShaderMaterial = mesh_instance.mesh.surface_get_material(0).next_pass as ShaderMaterial
@onready var surface_shader : ShaderMaterial = liquid_shader.next_pass as ShaderMaterial

var dragging : bool = false
var mouse_relative : Vector2

func _process(_delta):
	liquid_shader.set_shader_parameter("fill_amount", fill_amount)
	surface_shader.set_shader_parameter("fill_amount", fill_amount)
	
	liquid_shader.set_shader_parameter("glass_thickness", glass_thickness)
	surface_shader.set_shader_parameter("glass_thickness", glass_thickness)
	
	liquid_shader.set_shader_parameter("width", width)
	liquid_shader.set_shader_parameter("height", height)
	
	surface_shader.set_shader_parameter("width", width)
	surface_shader.set_shader_parameter("height", height)
	
	liquid_shader.set_shader_parameter("liquid_colour", liquid_colour)
	surface_shader.set_shader_parameter("surface_colour", surface_colour)

func _physics_process(_delta):
	if (dragging and rigid_body.linear_velocity.length_squared() < 30.0):
		var mouse_y : float = -mouse_relative.y / 2.0
		var mouse_x : float = mouse_relative.x / 6.0
		rigid_body.apply_central_force(Vector3(mouse_x, mouse_y, 0.0))
		mouse_relative = Vector2(0.0,0.0)

func _input(event):
	if (event.is_action_pressed("left_mouse_button")):
		var space = get_world_3d().direct_space_state
		var camera : Camera3D = get_viewport().get_camera_3d()
		var mouse_pos : Vector2 = get_viewport().get_mouse_position()
		var ray_from : Vector3 = camera.project_ray_origin(mouse_pos)
		var ray_to : Vector3 = ray_from + camera.project_ray_normal(mouse_pos) * 100000
		var ray_query := PhysicsRayQueryParameters3D.create(ray_from, ray_to)
		var result := space.intersect_ray(ray_query)
		if (result and result.collider == rigid_body):
			rigid_body.gravity_scale = 0
			rigid_body.linear_damp = 10
			rigid_body.angular_damp = 10
			dragging = true
	elif (event.is_action_released("left_mouse_button")):
		rigid_body.gravity_scale = 1
		rigid_body.linear_damp = 1
		rigid_body.angular_damp = 1
		dragging = false
	if (dragging and event is InputEventMouseMotion):
		mouse_relative = event.relative
