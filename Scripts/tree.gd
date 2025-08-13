extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var tree: StaticBody2D = $"."
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var playerPos: Vector2
signal applyShader1
signal unplugShader1

func _ready() -> void:
	pass
	#if animated_sprite_2d.material:
		#animated_sprite_2d.material = animated_sprite_2d.material.duplicate()
		#animated_sprite_2d.material.set_shader_parameter("enabled", false)
		#
	#connect("applyShader1", Callable(self, "on_player_entered"))
	#connect("unplugShader1", Callable(self, "on_player_exited"))

#func on_player_entered(pos: Vector2) :
	#print("function called ...")
	#
	#if animated_sprite_2d.material:
		#print("Material type:", animated_sprite_2d.material)
		#print("Is ShaderMaterial:", animated_sprite_2d.material is ShaderMaterial)
		#
		#animated_sprite_2d.material.set_shader_parameter("enabled", true)
		#animated_sprite_2d.material.set_shader_parameter("player_pos", pos)
#
		## coba baca ulang parameter setelah set
		#var p = animated_sprite_2d.material.get_shader_parameter("player_pos")
		#print("value of shader after set:", p)
	#else:
		#print("No material assigned!")
#
#func on_player_exited()->void:
	#print("\nAIGHT I'M OUT....\n")
	#animated_sprite_2d.material.set_shader_parameter("enabled", false)
	#print("value of shader : ", animated_sprite_2d.get_shader_parameter("enabled"))
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	show()
	animated_sprite_2d.visible = true
	set_process(true)
	set_physics_process(true)
	collision_shape_2d.disabled = false
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	hide()
	animated_sprite_2d.visible = false
	set_process(false)
	set_physics_process(false)
	collision_shape_2d.disabled = true
