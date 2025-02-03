class_name GoblinOne extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_attacking = false
var current_animation = "idle"

func _physics_process(delta: float):
	move_and_slide()
	
	if velocity.length() > 0:
		if not is_attacking:
			animated_sprite_2d.play("run")
		animated_sprite_2d.play(current_animation)
		
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
		
