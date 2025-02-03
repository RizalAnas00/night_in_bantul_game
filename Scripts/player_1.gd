extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var SPEED: float = 100.0
var is_attacking: bool = false
var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_process_input()
	move_and_slide()

func _process_input():
	direction = Input.get_vector("left", "right", "up", "down")  # Get the movement direction
	
	# Start the attack when the attack input is pressed
	if Input.is_action_just_pressed("attack"):
		_start_attack()

	# Stop the attack when the attack input is released
	if Input.is_action_just_released("attack"):
		_stop_attack()
	
	# Handle movement
	if direction.x > 0:
		animated_sprite_2d.flip_h = false  #  right
	elif direction.x < 0:
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
	if direction.x or direction == Vector2.ZERO:
		animated_sprite_2d.play("attack_side_1")  # Play the attack animation
	if direction.y > 0:
		animated_sprite_2d.play("attack_front_2")
	if direction.y < 0:
		animated_sprite_2d.play("attack_back_1")
		
func _stop_attack():
	is_attacking = false
	animated_sprite_2d.play("idle_front")  # Return to idle or other animations when attack stops
