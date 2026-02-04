class_name InputComponent 
extends Node

@export var body: Player
var move_dir: Vector3 = Vector3.ZERO
var jump_pressed := false
var grab_held := false
var grab_released := false

func update() -> void:
	move_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_dir.y = 0.0
	move_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	jump_pressed = Input.is_action_just_pressed("jump")
	grab_held = Input.is_action_pressed("grab")
	grab_released = Input.is_action_just_released("grab")
