class_name Player
extends CharacterBody2D

@export_group("Components")
@export var movement_component: MovementComponent

func _physics_process(delta: float) -> void:
	movement_component.move(delta)
		
	DebugTools.update_velocity_x(velocity.x)
	DebugTools.update_velocity_y(velocity.y)
