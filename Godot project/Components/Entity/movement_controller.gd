class_name MovementComponent
extends Node

@export_group("Components")
@export var character_body: CharacterBody2D
@export var dash_duration_timer: Timer
@export var dash_cooldown_timer: Timer

@export_group("Parameters")
@export var walk_speed: float = 300
@export var dash_speed_multiplier: float = 5
@export var jump_velocity: float = 400
@export_range(0, 1) var jump_release_deceleration = 0.5

var is_dashing: bool = false
var is_dash_on_cooldown: bool = false
var is_looking_right: bool = true

var double_jump_active:bool = false

@onready var base_walk_speed: float = walk_speed
@onready var dash_speed: float = walk_speed * dash_speed_multiplier

func move(delta: float) -> void:
	if !character_body.is_on_floor() && !is_dashing:
		character_body.velocity += character_body.get_gravity() * delta

	if Input.is_action_just_pressed("Up"):
		if character_body.is_on_floor():
			character_body.velocity.y = -jump_velocity
			double_jump_active = true
		elif PlayerVars.double_jump_unlocked && double_jump_active:
			character_body.velocity.y = -jump_velocity
			double_jump_active = false

	if Input.is_action_just_released("Up"):
		character_body.velocity.y *= jump_release_deceleration
		
	if PlayerVars.dash_unlocked && Input.is_action_just_pressed("Dash") && !is_dash_on_cooldown:
		is_dashing = true
		is_dash_on_cooldown = true
		walk_speed = dash_speed
		dash_duration_timer.start()
		
	var direction: float
	
	if is_dashing:
		if is_looking_right:
			direction = 1
		else:
			direction = -1
	else:
		direction = Input.get_axis("Left", "Right")
	
	if direction:
		character_body.velocity.x = direction * walk_speed
		is_looking_right = direction > 0
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, walk_speed)

	character_body.move_and_slide()


func _on_dash_duration_timeout() -> void:
	is_dashing = false
	walk_speed = base_walk_speed
	dash_cooldown_timer.start()


func _on_dash_cooldown_timeout() -> void:
	is_dash_on_cooldown = false
