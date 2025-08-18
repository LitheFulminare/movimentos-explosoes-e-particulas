extends Node

var debug_hud: DebugHUD
var debug_hud_scene: PackedScene = preload("res://Components/HUD/Debug HUD.tscn")

func _ready() -> void:
	debug_hud = debug_hud_scene.instantiate()
	add_child(debug_hud)

func update_velocity_x(value: float) -> void:
	debug_hud.update_velocity_x(value)
	
func update_velocity_y(value: float) -> void:
	debug_hud.update_velocity_y(value)
