extends Node
class_name ChildHealth

var hs: HealthSystem

func init(health_system: HealthSystem):
	hs = health_system

func take_damage(damage: int):
	if hs:
		hs.take_damage(damage)
