class_name TrapezeComponent
extends Node3D

@onready var trapeze_shape:ShapeCast3D = $TrapezeShapeCast


func attatch_player(player: Player) -> void:
	var bar: TrapezeBar = trapeze_shape.get_collider(0).owner
	player.global_position = bar.player_position_marker.global_position
	find_correct_direction(player,bar)


func find_correct_direction(player: Player, bar: TrapezeBar):
	var player_forward = -player.global_transform.basis.z.normalized()
	var bar_forward = -bar.global_transform.basis.z.normalized()
	var dot_product = player_forward.dot(bar_forward)
	if dot_product >= 0.0:
		player.look_at(bar.player_front_marker.global_position)
	if dot_product < 0.0:
		player.look_at(bar.player_back_marker.global_position)
