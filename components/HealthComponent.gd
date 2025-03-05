class_name HealthComponent
extends Node

signal on_zero_health
signal health_updated(data)

var max_health: int
var health: int

#Sets current health and optionally makes that the new max
func set_health(n: int, is_new_max: bool = true) -> void:
	if is_new_max:
		health = n
		max_health = n
	else:
		health = clamp(n, 0, max_health)
	_health_update()


#Changes max health and adjusts current health appropriately
#If reset_health, set current health to max health
func change_max_health(new_max: int, reset_health: bool = true) -> void:
	var diff = new_max - max_health
	#If max is increasing
	if diff >= 0:
		max_health = new_max
		if reset_health:
			health = max_health
		else:
			health += diff
	else:
		#If max decreased, just ensure the current health is less than max, but
		#don't change it otherwise
		max_health = new_max
		if health >= max_health:
			health = max_health
	_health_update()


#Reduces current health by n. Clamps n to (0,health)
func take_damage(n: int) -> void:
	health -= clamp(n, 0, health)
	_health_update()


#Increases current health by n. Clamps n to 0, max_health - health
func heal_health(n: int) -> void:
	health += clamp(n, 0, max_health - health)
	_health_update()


#Call whenever health changes
func _health_update() -> void:
	emit_signal("health_updated", {"max_health" : max_health, "health" : health})
	if health <= 0:
		emit_signal("on_zero_health")
