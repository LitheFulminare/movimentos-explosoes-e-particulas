class_name DebugHUD
extends CanvasLayer

@export var velocity_x_label: Label
@export var velocity_y_label: Label

func update_velocity_x(value: float) -> void:
	velocity_x_label.text = "Velocity X: " + str(value)
	
func update_velocity_y(value: float) -> void:
	velocity_y_label.text = "Velocity Y: " + str(snapped(value, 0.01))
