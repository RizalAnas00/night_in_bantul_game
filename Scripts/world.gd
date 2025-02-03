extends Node2D

@onready var camera_2d: Camera2D = $player_1/Camera2D

var zoom_val
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass
func _input(event: InputEvent):
	if Input.is_action_just_pressed("zoom_out"):
		zoom_val = camera_2d.zoom.x + 0.1
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
		
	if Input.is_action_just_pressed("zoom_in"):
		zoom_val = camera_2d.zoom.x - 0.1
		camera_2d.zoom = Vector2(zoom_val, zoom_val)
