class_name State
extends Node

var entity: Node2D
var entity_sprite: Node2D
var state_machine: StateMachine


## Called when the state is entered
func enter_state():
	pass

## Called every frame
func do_process(delta):
	pass

## Called every physics frame
func do_physics_process(delta):
	pass

## Called when the state is exited
func exit_state():
	pass

func set_state(state_name: String):
	state_machine.set_state(state_name)
