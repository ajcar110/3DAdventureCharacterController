class_name GravityComponent
extends Node

@export var body: Player
@export var visuals: Node3D

@export_subgroup("Jump")
@export var jump_height: float = 6 ## how high the player will jump on the ground
@export var air_jump_height: float = 3 ## how high the player will jump in the air
@export var swim_jump_height: float = 3 ## how high the player will jump out of Swiming
@export_range(-100.0,0) var max_fall_speed: float = -40.0
@export_range(-100.0,0) var jump_gravity: float = -40.0
@export_range(-100.0,0) var fall_gravity: float = -40.0
@onready var null_gravity: float = 100000.0 ## Super high so that it never effects fall speed when used for checks "like 0.0 would"
@onready var jump_velocity: float = sqrt(abs(jump_height * jump_gravity * 2))
@onready var air_jump_velocity: float = sqrt(abs(air_jump_height * jump_gravity * 2))
@onready var swim_jump_velocity: float = sqrt(abs(swim_jump_height * jump_gravity * 2))



var can_air_jump: = true
var mov_dir := Vector3.ZERO

func _ready():
	PlayerSignals.rail_complete.connect(jump)

func tik(delta: float):
	
	if body.is_on_floor():
		can_air_jump = true



		#Gravity
	if body.velocity.y > max_fall_speed and current_gravity(body.state) != null_gravity:
		body.velocity.y += current_gravity(body.state) * delta
	elif current_gravity(body.state) == null_gravity:
		body.velocity.y = 0.0


func jump():
	body.velocity.y = jump_velocity
	visuals.rotation_degrees.z = 0
	visuals.position = Vector3.ZERO

func air_jump():
	body.velocity.y = air_jump_velocity
	visuals.rotation_degrees.z = 0
	visuals.position = Vector3.ZERO

func swim_jump():
	body.velocity.y = swim_jump_velocity
	visuals.rotation_degrees.z = 0
	visuals.position = Vector3.ZERO

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
		
		PlayerStates.AIRJUMP:
			return jump_gravity
		
		PlayerStates.FALL:
			return fall_gravity
		
		PlayerStates.GRIND:
			return null_gravity
			
		PlayerStates.GRINDJUMP:
			return jump_gravity
			
		PlayerStates.TRAPIDLE:
			return null_gravity
		
		PlayerStates.SWIMIDLE:
			return null_gravity
		
		PlayerStates.SWIMSURFACE:
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
		PlayerStates.TRAPIDLE:
			return true
		PlayerStates.TRAPJUMP:
			return can_air_jump
		PlayerStates.SWIMIDLE:
			return true
		PlayerStates.SWIMSURFACE:
			return true
	return false
