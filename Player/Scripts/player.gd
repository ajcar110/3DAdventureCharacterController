class_name Player

extends CharacterBody3D

@export var visuals: Node3D
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var camera_component: CameraComponent
@export var wall_run_component: WallRunComponent
@export var gravity_component: GravityComponent
@export var rail_grinding_component: RailGrindComponent
@export var animation_player: AnimationPlayer
@export var debug_component: Node

var wall_running:= false
var grinding := false

var state: BasePlayerState = PlayerStates.IDLE

func _ready():
	state.enter(self)
	
func _physics_process(delta):
	input_component.update()
	debug_component.update()
	
	## ALL MOVEMENT COMPONENTS MUST UPDATE IN FUNCTION TO ADJUST BY CAMERA
	modify_directions_by_camera_angle()
	
	##dependent info shared between components
	rail_grinding_component.wants_dismount = input_component.jump_pressed
	gravity_component.near_wall = wall_run_component.wall_nearby()
	gravity_component.near_wall_normal = wall_run_component.wall_normal
	
	## State Logic##
	state.validate_state(self)
	state.tic(self,delta)
	

	if visuals.rotation_degrees.z != 0: #Altered by wall running
		visuals.rotation_degrees.z = 0
		visuals.position = Vector3.UP
	
	elif rail_grinding_component.grind_shape_cast.is_colliding():
		rail_grinding_component.rail_grinding(delta)
		rail_grinding_component.grind_timer(delta)
		
	if grinding and not rail_grinding_component.grind_shape_cast.is_colliding():
		rail_grinding_component.detach_from_rail()
		
	gravity_component.tik(delta)
	move_and_slide()


## Reads Directional Input for Player, Modifies it based on Camera
## and returns the Result
func get_move_input()-> Vector3:
	var input_dir = Vector2(input_component.move_dir.x,input_component.move_dir.z)
	var direction: Vector3
	direction = (camera_component.global_basis * input_component.move_dir)
	direction = Vector3(direction.x,0,direction.z).normalized() * input_dir.length()
	return direction

func get_horizontal_velocity() -> float:
	return Vector2(velocity.x, velocity.z).length()

func change_state_to(next_state: BasePlayerState):
	state.exit(self)
	state = next_state
	state.enter(self)
	

func modify_directions_by_camera_angle():
	var modified_direction = get_move_input()
	
	wall_run_component.direction = modified_direction
	movement_component.move_dir = modified_direction
	gravity_component.mov_dir = modified_direction
