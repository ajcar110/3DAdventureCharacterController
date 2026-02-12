class_name SwimComponent
extends Node3D

@onready var player: Player = $".."

func _on_deep_water_detector_area_entered(area):
	print("DeepWater Entered")


func _on_deep_water_detector_area_exited(area):
	print("DeepWater Exited")



func _on_surface_water_detector_area_entered(area):
	if player.state != PlayerStates.SWIMIDLE:
		player.change_state_to(PlayerStates.SWIMIDLE)

func _on_surface_water_detector_area_exited(area):
	print("Off WaterSurface")
