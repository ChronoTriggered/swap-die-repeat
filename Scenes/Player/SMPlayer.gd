extends "res://StateMachine.gd"

func _ready():
	add_state("jump")
	add_state("fall")
	add_state("move")
	add_state("idle")
	pass # Replace with function body.
	
	
	
func _state_logic(delta):
	pass
func get_transition(delta):
	return null
func _enter_state(new_state,old_state):
	pass
func _exit_state(old_state,new_state):
	pass
func set_state(new_state):
	previous_state=state
	state=new_state
	
	if previous_state!=null:
		_exit_state(previous_state,new_state)
	if new_state!=null:
		_enter_state(new_state,previous_state)
