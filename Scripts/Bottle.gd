@tool
extends MeshInstance3D

@export var width : float
@export var height : float

@export_range(-2, 2, 0.0001) var fill_amount : float

@export_range(0.0, 0.02, 0.0001) var glass_thickness : float

@export_color_no_alpha var liquid_colour : Color
@export_color_no_alpha var surface_colour : Color

@onready var liquid_shader : ShaderMaterial = mesh.surface_get_material(0).next_pass as ShaderMaterial
@onready var surface_shader : ShaderMaterial = liquid_shader.next_pass as ShaderMaterial

func _ready():
	pass

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
	pass
