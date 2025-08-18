extends Node

var debug_hud: DebugHUD
var debug_hud_scene: PackedScene = preload("res://Components/HUD/Debug HUD.tscn")

func _ready() -> void:
	debug_hud = debug_hud_scene.instantiate()
	add_child(debug_hud)
