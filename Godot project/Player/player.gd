class_name Player
extends CharacterBody2D

@export_group("Components")
@export var movement_component: MovementComponent
@export var grappling_hook_component: GrapplingHookComponent

var is_movement_blocked: bool = false
var is_in_grappling_hook: bool = false

func _physics_process(delta: float) -> void:
	movement_component.move(delta)
	
	if is_in_grappling_hook:
		grappling_hook_component.move_player(delta)

func block_movement() -> void:
	is_movement_blocked = true
	
func unblock_movement() -> void:
	is_movement_blocked = false

## Updates the GrapplingHookComponent on which GrapplingPoint the player just interacted with
func update_grappling_point(destination: GrapplingPoint) -> void:
	grappling_hook_component.current_grappling_point = destination
