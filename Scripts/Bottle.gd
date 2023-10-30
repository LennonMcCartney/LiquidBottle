@tool
extends MeshInstance3D

@onready var liquid_shader : ShaderMaterial = mesh.surface_get_material(0).next_pass as ShaderMaterial

func _ready():
	pass

func _physics_process(delta):
	pass
