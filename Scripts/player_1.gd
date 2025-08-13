extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var SPEED: float = 100.0
var is_attacking: bool = false
var direction: Vector2
var attack_direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_process_input()
	move_and_slide()
	#print(attack_direction)

func _process_input():
	direction = Input.get_vector("left", "right", "up", "down")  # Get the movement direction
	
	# Start the attack when the attack input is pressed
	if Input.is_action_just_pressed("attack"):
		attack_direction = get_global_mouse_position()
		_start_attack()

	# Stop the attack when the attack input is released
	if Input.is_action_just_released("attack"):
		_stop_attack()
	
	# Handle movement
	if direction.x > 0 and is_attacking == false :
		animated_sprite_2d.flip_h = false  #  right
	elif direction.x < 0 and is_attacking == false :
		animated_sprite_2d.flip_h = true  #  left
	
	# Handle animation transitions
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		if not is_attacking:
			animated_sprite_2d.play("run_front")  # Play run animation
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		if not is_attacking:
			animated_sprite_2d.play("idle_front")  # Play idle animation

func _start_attack():
	is_attacking = true
	
	var dir_to_mouse = (attack_direction - global_position).normalized()
	
	if abs(dir_to_mouse.x) > abs(dir_to_mouse.y):
		# Horizontal attack (left/right)
		if dir_to_mouse.x > 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("attack_side_1")
	else:
		# Vertical attack (up/down)
		if dir_to_mouse.y > 0:
			animated_sprite_2d.play("attack_front_2")
		else:
			animated_sprite_2d.play("attack_back_1")
		
func _stop_attack():
	is_attacking = false
	animated_sprite_2d.play("idle_front")  # Return to idle or other animations when attack stops
