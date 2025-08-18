class_name GrapplingHookComponent
extends Node

@export_group("Components")
@export var player: Player
@export var path_2d: Path2D
@export var path_follow_2d: PathFollow2D
@export var line2d: Line2D

@export_group("Parameters")
@export var player_speed: float = 500

var current_grappling_point: GrapplingPoint

func _ready() -> void:
	line2d.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Grappling Hook"):
		use_grappling_hook()

# called once when the player presses Grappling Hook button
func use_grappling_hook() -> void:
	if PlayerVars.is_in_grappling_range:
		path_2d.curve.set_point_position(0, player.global_position)
		path_2d.curve.set_point_position(1, current_grappling_point.destination_point.global_position)
		player.is_in_grappling_hook = true
		line2d.set_point_position(0, current_grappling_point.global_position)
		line2d.set_point_position(1, player.global_position)
		line2d.visible = true
	else:
		print("Player used grappling hook outside of range")

## Updates the player and chain position until the player gets to the destination
func move_player(delta: float) -> void:
	if path_follow_2d.progress_ratio < 1:
		# update player and chain position
		path_follow_2d.progress_ratio += player_speed  * delta
		player.global_position = path_follow_2d.global_position
		line2d.global_position = Vector2.ZERO
		line2d.set_point_position(1, player.global_position)
	else:
		line2d.visible = false
		path_follow_2d.progress_ratio = 0
		player.is_in_grappling_hook = false
