extends Node2D

@onready var camera_2d: Camera2D = $player_1/Camera2D
@onready var tree_layer: TileMapLayer = $TreeLayer
@onready var player_1: CharacterBody2D = $player_1
@onready var collision_shape: CollisionShape2D = $player_1/CollisionShape2D
@onready var _tree: StaticBody2D = $TreeLayer/_tree

var zoom_val
var transparenting: bool
var playerPos: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	playerPos.x = player_1.global_position.x
	playerPos.y = player_1.global_position.y
	
	print("player pos : ", player_1.global_position)
	print("tree pos : ", _tree.global_position, "\n")
	
	get_scene_of_tree(player_1.global_position)

#func _input(event: InputEvent):
	#if Input.is_action_just_pressed("zoom_out"):
		#zoom_val = camera_2d.zoom.x + 0.1
		#camera_2d.zoom = Vector2(zoom_val, zoom_val)
		#
	#if Input.is_action_just_pressed("zoom_in"):
		#zoom_val = camera_2d.zoom.x - 0.1
		#camera_2d.zoom = Vector2(zoom_val, zoom_val)

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
