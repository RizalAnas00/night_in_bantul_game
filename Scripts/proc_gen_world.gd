extends Node2D

@export var noise_height_texture : NoiseTexture2D
var noise: Noise

@onready var grass_land_layer: TileMapLayer = $GrassLand
@onready var sand_land_layer: TileMapLayer = $SandLand
@onready var water_layer: TileMapLayer = $WaterLayer

var width: int = 200
var height: int = 200

#var source_id_land: int = 0
var source_id_water: int = 0

var water_atlas = Vector2i(0,0)
#var land_atlas = Vector2i(1,1)

var noise_value_arr: Array = []

var sand_tiles_arr = []
var sand_terrain_set: int = 0

var grass_tiles_arr = []
var grass_terrain_set: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise = noise_height_texture.noise
	generate_world()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func generate_world():
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_value = noise.get_noise_2d(x,y)
			
			if noise_value >= 0.0:
				if noise_value > 0.1:
					grass_tiles_arr.append(Vector2i(x, y))
				
				sand_tiles_arr.append(Vector2i(x,y))
			
			water_layer.set_cell(Vector2i(x,y), source_id_water, water_atlas)
			
	grass_land_layer.set_cells_terrain_connect(grass_tiles_arr, grass_terrain_set, 0)
	sand_land_layer.set_cells_terrain_connect(sand_tiles_arr, sand_terrain_set, 0)
