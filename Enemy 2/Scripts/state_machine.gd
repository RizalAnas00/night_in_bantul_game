class_name State_Machine extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child  # Perbaikan di sini
			child.Transisioned.connect(on_child_transisioned)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) :
	if current_state:
		current_state.Update(delta)
	
func _physics_process(delta: float):
	if current_state:
		current_state.Physic_Update(delta)

func on_child_transisioned(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return 
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	current_state = new_state
