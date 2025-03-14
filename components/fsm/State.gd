class_name State
extends Node

#Use as a base class for all states used with the FiniteStateMachine

var state_name: String

#Equivalent to _process(delta)
func update(_delta: float) -> void:
	pass

#Equivalent to _physics_process(delta)
func physics_update(_delta: float) -> void:
	pass

#Called when the state becomes active
func enter(data: Dictionary = {}) -> void:
	pass
