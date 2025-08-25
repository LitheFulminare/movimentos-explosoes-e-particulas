class_name MovementComponent
extends Node

@export_group("Components")
@export var character_body: CharacterBody2D
@export var dash_window_timer: Timer
@export var dash_duration_timer: Timer
@export var dash_cooldown_timer: Timer

@export_group("Parameters")
@export_subgroup("Walk")
@export var maximum_walk_speed: float = 300
@export var acceleration: float = 50
@export var deceleration: float = 40

@export_subgroup("Dash")
@export var dash_speed_multiplier: float = 5
@export var dash_duration: float = 0.25

@export_subgroup("Jump")
@export var jump_velocity: float = 400
@export_range(0, 1) var jump_release_deceleration = 0.5

@export_subgroup("Fly")
@export var flying_duration: float = 3
@export var flying_vertical_speed: float = 2000
@export var flying_acceleraction: float = 300
@export var flying_acceleration_multiplier: float = 2

@export_subgroup("Fall")
@export var gravity_scale: float = 1
@export var falling_scale: float = 1

var right_dash_window_active: bool = false
var left_dash_window_active: bool = false
var is_dashing: bool = false
var is_dash_on_cooldown: bool = false
var is_looking_right: bool = true

var is_flying: bool = false

var double_jump_active:bool = false

@onready var base_walk_speed: float = maximum_walk_speed
@onready var dash_speed: float = maximum_walk_speed * dash_speed_multiplier
@onready var current_max_speed: float = maximum_walk_speed
@onready var current_acceleration: float = acceleration

func _ready() -> void:
	dash_duration_timer.wait_time = dash_duration

func move(delta: float) -> void:
	fall_check(delta)

	input_check()
		
	# Old dash logic from Operation Venulysian
	#if PlayerVars.dash_unlocked && Input.is_action_just_pressed("Dash") && !is_dash_on_cooldown:
		#is_dashing = true
		#is_dash_on_cooldown = true
		#maximum_walk_speed = dash_speed
		#dash_duration_timer.start()
		
	var direction: float = get_direction()
	
	set_velocity(direction)

	character_body.move_and_slide()

func fall_check(delta: float) -> void:
	if !character_body.is_on_floor() && !is_flying:
		character_body.velocity += character_body.get_gravity() * delta

func input_check() -> void:
	if Input.is_action_pressed("Jump"):
		if character_body.is_on_floor():
			character_body.velocity.y = -jump_velocity
		else:
			fly()
			
	if Input.is_action_just_released("Jump"):
		is_flying = false
	
	if Input.is_action_just_released("Jump"):
		character_body.velocity.y *= jump_release_deceleration
		
	# dash mechanic
	# when player presses left or right twice quickly, they dash
	if Input.is_action_just_pressed("Right"):
		if (right_dash_window_active):
			dash()
			
		dash_window_timer.start()
		right_dash_window_active = true
		print("player pressed right")
		
	if Input.is_action_just_pressed("Left"):
		if (left_dash_window_active):
			dash()
			
		dash_window_timer.start()
		left_dash_window_active = true
		print("player pressed left")

func fly() -> void:
	is_flying = true
	
	if (character_body.velocity.y < flying_vertical_speed):
		character_body.velocity.y += acceleration
		
	else: character_body.velocity.y = flying_vertical_speed

func dash() -> void:
	is_dashing = true
	
	current_max_speed = maximum_walk_speed * dash_speed_multiplier
	current_acceleration = acceleration * 10 # replace with a variable
	dash_duration_timer.start()

func get_direction() -> float:
	var direction: float
	if is_dashing:
		if is_looking_right:
			direction = 1
		else:
			direction = -1
	else:
		direction = Input.get_axis("Left", "Right")
		
	return direction

func set_velocity(direction: float) -> void:
	if direction:
		
		# lower than top speed
		# BUG HERE -> if at top speed, changing directions too fast will make the player snap to top speed
		# instead of decelerating and accelerating again.
		# to fix this I should check for both positive AND negative top speeds.
		if abs(character_body.velocity.x) < current_max_speed:
			# pressing right
			if direction == 1:
				if character_body.velocity.x >= 0:
					character_body.velocity.x += direction * current_acceleration #acceleration
				else:
					character_body.velocity.x += direction * deceleration
			
			# pressing left
			if direction == -1:
				if character_body.velocity.x <= 0:
					character_body.velocity.x += direction * current_acceleration #acceleration
				else:
					character_body.velocity.x += direction * deceleration
			
		# speed higher than top speed (this happens after dashing)
		elif abs(character_body.velocity.x) > maximum_walk_speed:
			character_body.velocity.x = move_toward(character_body.velocity.x, current_max_speed, acceleration*1.5)
		
		# at top speed
		# Checking is velocityX is exactly the same as maximum walk speed might cause problems,
		# I'll have to create a margin later
		if abs(character_body.velocity.x) == current_max_speed:
			character_body.velocity.x = direction * current_max_speed
			
		is_looking_right = direction > 0
	
	# not pressing movement button
	else:
		character_body.velocity.x = move_toward(character_body.velocity.x, 0, deceleration)

func _on_dash_duration_timeout() -> void:
	is_dashing = false
	current_max_speed = maximum_walk_speed
	current_acceleration = acceleration
	dash_cooldown_timer.start()


func _on_dash_cooldown_timeout() -> void:
	is_dash_on_cooldown = false

func _on_dash_window_timeout() -> void:
	right_dash_window_active = false
	left_dash_window_active = false
