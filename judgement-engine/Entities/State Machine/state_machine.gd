## Handles the states of the entity it is a child of. Holds the current behavior state and is able to change the state of the entity. To work, the state machine must have children that extend class State.
class_name StateMachine
extends Node

## The string name of the State node that will automatically be entered when the _ready() function is called. If left blank, will default to the first child of the state machine.
@export var default_state: String
## Reference to the entity. Gives States access to the entity. If left blank, will default to the state machine's parent
@export var entity: CharacterBody2D
## Reference to the entity's sprite. Gives States access to the entity's sprite so they can play animations.
@export var entity_sprite: Node2D

var current_state: State

func _ready():
	if !entity:
		entity = get_parent()
	
	if !default_state and get_child(0):
		default_state = get_child(0).name
	
	for state in get_children():
		state.entity = entity
		state.entity_sprite = entity_sprite
		state.state_machine = self
	
	set_state(default_state)

func set_state(state_name: String):
	if !get_node(state_name):
		print("Invalid state: '" + state_name + "' on entity: " + str(get_parent()))
		return
	
	if current_state:
		current_state.exit_state()
	
	current_state = get_node(state_name)
	
	current_state.enter_state()

func _process(delta):
	if current_state:
		current_state.do_process(delta)

func _physics_process(delta):
	if current_state:
		current_state.do_physics_process(delta)
	
	entity.move_and_slide()
