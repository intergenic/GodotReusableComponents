class_name FiniteStateMachine
extends Node

#Add to a node that is the child of the player (or other intended target)
#All states should be children nodes of this

signal transitioned_to(s) #Emit new state name
signal transitioned_from(s) #Emits old state name

@export var default: State

var states = {}
var current_state = null
var prev_state: String = ""
var fsm_parent: Node

func _ready() -> void:
	fsm_parent = get_parent()
	
	for child in get_children():
		add_state(child)
	
	transition_to(default.state_name)


func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state != null:
		current_state.physics_update(delta)


func get_current_state() -> String:
	if current_state != null:
		return current_state.state_name
	return ""


func add_state(state: State) -> void:
	states[state.state_name] = state
	states.connect("exit_state", _on_exit)


func transition_to(new_state: String) -> void:
	if states.has(new_state):
		if current_state != null:
			prev_state = current_state.state_name
		current_state = states[new_state]
		current_state.enter({"fsm_parent" = fsm_parent})
		
		emit_signal("transitioned_from", prev_state)
		emit_signal("transitioned_to", new_state)
		
	else:
		print("Failed to transition to state:" + new_state)
		print("Defaulting to default state")
		if current_state != null:
			prev_state = current_state.state_name
		current_state = states[default.state_name]
		current_state.enter({"fsm_parent" = fsm_parent})


func _on_exit(to_state: String = "") -> void:
	if to_state == "":
		transition_to(default.state_name)
	else:
		transition_to(to_state)
