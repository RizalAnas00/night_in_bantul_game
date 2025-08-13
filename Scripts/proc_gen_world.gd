extends Node2D

@export var noise_height_texture : NoiseTexture2D
@export var noise_tree_texture : NoiseTexture2D

var tree_noise: Noise
var noise: Noise

var zoom_val

@onready var grass_land_layer: TileMapLayer = $GrassLand
@onready var sand_land_layer: TileMapLayer = $SandLand
@onready var water_layer: TileMapLayer = $WaterLayer
@onready var tree_layer: TileMapLayer = $TreeLayer
@onready var foam_water: TileMapLayer = $FoamWater
@onready var cliff_rocks: TileMapLayer = $CliffRocks
@onready var camera_2d: Camera2D = $player_1/Camera2D
@onready var player_1: CharacterBody2D = $player_1

var width: int = 156
var height: int = 156

var center_wm = -width/2
var center_wp = width/2
var center_hm = -height/2
var center_hp = height/2

var source_id_tree: int = 1
var source_id_water: int = 0
var source_id_foamwater: int = 1
#var source_id_cliff: int = 0

var water_atlas = Vector2i(0,0)
var tree_atlas = Vector2i(0,0)
var foam_atlas = Vector2i(0,0)

var noise_value_arr: Array = []

var cliff_tiles_arr = []
var cliff_terrain_set: int = 0

var sand_tiles_arr = []
var sand_terrain_set: int = 0

var grass_tiles_arr = []
var grass_terrain_set: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise = noise_height_texture.noise
	tree_noise = noise_tree_texture.noise
	generate_world()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_scene_of_tree(player_1.global_position)
	
func generate_world():
	# First, populate sand and grass using terrain.
	for x in range(center_wm, center_wp):
		for y in range(center_hm, center_hp):
			var noise_value:float = noise.get_noise_2d(x, y)
			var tree_noise_value:float = tree_noise.get_noise_2d(x, y)
			noise_value_arr.append(noise_value)
			
			# Place grass or trees based on noise values.
			if noise_value >= 0.0:
				if noise_value > 0.1:
					if noise_value < 0.6 and noise_value > 0.18 and tree_noise_value > 0.4:
						tree_layer.set_cell(Vector2i(x, y), 0, Vector2i(0,0), 1)
					elif noise_value > 0.9:
						cliff_tiles_arr.append(Vector2i(x,y))
					grass_tiles_arr.append(Vector2i(x, y))
				sand_tiles_arr.append(Vector2i(x, y))
	
	# Apply terrain for grass and sand.
	cliff_rocks.set_cells_terrain_connect(cliff_tiles_arr, cliff_terrain_set, 0)
	grass_land_layer.set_cells_terrain_connect(grass_tiles_arr, grass_terrain_set, 0)
	sand_land_layer.set_cells_terrain_connect(sand_tiles_arr, sand_terrain_set, 0)
	
	# Now place water in the remaining empty tiles.
	for x in range(center_wm, center_wp):
		for y in range(center_hm, center_hp):
			if grass_land_layer.get_cell_source_id(Vector2i(x, y)) == -1 and sand_land_layer.get_cell_source_id(Vector2i(x, y)) == -1:
				water_layer.set_cell(Vector2i(x, y), source_id_water, water_atlas)

	place_foam_around_sand()
	
	print(noise_value_arr.min())
	print(noise_value_arr.max())

func place_foam_around_sand():
	for sand_pos in sand_tiles_arr:
		var neighbors = [
			Vector2i(sand_pos.x, sand_pos.y - 1),  # Up
			Vector2i(sand_pos.x, sand_pos.y + 1),  # Down
			Vector2i(sand_pos.x - 1, sand_pos.y),  # Left
			Vector2i(sand_pos.x + 1, sand_pos.y)   # Right
		]
		
		for neighbor in neighbors:
			# Check if the neighbor tile is water
			if water_layer.get_cell_source_id(neighbor) == source_id_water:
				# Place foam water on the sand tile near water
				foam_water.set_cell(sand_pos, source_id_foamwater, foam_atlas)

func _input(event: InputEvent) -> void:
	var min_zoom := 0.5
	var max_zoom := 1.5

	if Input.is_action_just_pressed("zoom_out"):
		var target_zoom = camera_2d.zoom.x + 0.1
		if target_zoom <= max_zoom:
			zoom_val = target_zoom
			camera_2d.zoom = Vector2(zoom_val, zoom_val)
		
	if Input.is_action_just_pressed("zoom_in"):
		var target_zoom = camera_2d.zoom.x - 0.1
		if target_zoom >= min_zoom:
			zoom_val = target_zoom
			camera_2d.zoom = Vector2(zoom_val, zoom_val)

func get_scene_of_tree(pos: Vector2) -> void:
	for child in tree_layer.get_children():
		if child is StaticBody2D:
			var tree_pos = child.global_position
			var tween = get_tree().create_tween()
			tween.set_trans(Tween.TRANS_SINE)
			tween.set_ease(Tween.EASE_IN_OUT)

			if tree_pos.y > pos.y and abs(tree_pos.x - pos.x) < 50 and abs(tree_pos.y - pos.y) < 140:
				tween.tween_property(
					child.animated_sprite_2d, 
					"self_modulate", 
					Color(1, 1, 1, 0.2),
					0.1
				)
			else:
				tween.tween_property(
					child.animated_sprite_2d, 
					"self_modulate", 
					Color(1, 1, 1, 1),
					0.24
				)
