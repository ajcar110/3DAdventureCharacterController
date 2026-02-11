class_name GravityComponent
extends Node

@export var body: Player
@export var visuals: Node3D

@export_subgroup("Jump")
@export var jump_height: float = 6 ## how high the player will jump on one jump
@export var time_to_jump_peak: float = 1 ## how long the player takes to reach max jump
@export var time_to_fall: float = 1 ## how long it takes the player to return to starting height
@export var time_to_wall_fall: float = 2 ## how long it takes the player to slide down a wall
@export var time_to_wall_drop: float = 1 ## how long it takes the player to drop to the bottom of a wall if no Horizontal velocity is present
@export var max_jumps: int = 1 ## maximum times the player can jump before landing
@export var max_fall_speed: float = -40.0

@onready var jump_gravity: float = (-2.0 * jump_height) / ( time_to_jump_peak * time_to_jump_peak)
@onready var fall_gravity: float = (-2.0 * jump_height) / ( time_to_fall * time_to_fall)
@onready var wall_gravity: float = (-2.0 * jump_height) / (time_to_wall_fall * time_to_wall_fall)
@onready var wall_drop_gravity: float = (-2.0 * jump_height) / (time_to_wall_drop * time_to_wall_drop)
@export var null_gravity: float = 100000.0 ## Super high so that it never effects fall speed when used for checks "like 0.0 would"
@onready var jump_velocity: float = (2.0 * jump_height) / time_to_jump_peak
@onready var wall_jump_velocity: float = jump_height / time_to_jump_peak



var can_air_jump: = true
var can_wall_jump: = true
var mov_dir := Vector3.ZERO
var near_wall := false
var near_wall_normal

func _ready():
	PlayerSignals.rail_complete.connect(jump)

func tik(delta: float):
	
	if body.is_on_floor():
		can_air_jump = true
		can_wall_jump = true


		#Gravity
	if body.velocity.y > max_fall_speed and current_gravity(body.state) != null_gravity:
		body.velocity.y += current_gravity(body.state) * delta
	elif current_gravity(body.state) == null_gravity:
		body.velocity.y = 0.0
	else:
		return
func jump():
	body.velocity.y = jump_velocity
	visuals.rotation_degrees.z = 0
	visuals.position = Vector3.ZERO

func wall_jump():
	body.velocity.x = near_wall_normal.x * wall_jump_velocity
	body.velocity.z = near_wall_normal.z * wall_jump_velocity
	body.velocity += -body.global_transform.basis.z * jump_velocity
	

## Returns a float based on players current conditions
func current_gravity(state) -> float:
	match state:
		PlayerStates.IDLE:
			return jump_gravity
		PlayerStates.WALK:
			return jump_gravity
		PlayerStates.RUN:
			return jump_gravity
		PlayerStates.JUMP:
			return jump_gravity
		PlayerStates.FALL:
			return jump_gravity
		PlayerStates.GRIND:
			return null_gravity
			
		PlayerStates.GRINDJUMP:
			return jump_gravity
			
		PlayerStates.TRAPIDLESTATE:
			return null_gravity
	return fall_gravity


func validate_jump(state: BasePlayerState) -> bool:
	match state:
		PlayerStates.IDLE:
			return true
		PlayerStates.WALK:
			return true
		PlayerStates.RUN:
			return true
		PlayerStates.JUMP:
			return can_air_jump
		PlayerStates.FALL:
			return can_air_jump
		PlayerStates.GRIND:
			return true
		PlayerStates.TRAPIDLESTATE:
			return true
	return false
