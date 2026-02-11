class_name InputComponent 
extends Node

@export var body: Player
var move_dir: Vector3 = Vector3.ZERO
var jump_pressed := false
var grab_held := false
var grab_released := false
var move_left_held := false
var move_right_held := false
var move_forward_held := false
var move_backward_held := false

func update() -> void:
	move_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_dir.y = 0.0
	move_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	jump_pressed = Input.is_action_just_pressed("jump")
	grab_held = Input.is_action_pressed("grab")
	grab_released = Input.is_action_just_released("grab")
	move_forward_held = Input.is_action_pressed("move_forward")
	move_backward_held = Input.is_action_pressed("move_backward")
	move_left_held = Input.is_action_pressed("move_left")
	move_right_held = Input.is_action_pressed("move_right")
