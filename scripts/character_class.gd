extends Node
class_name CharacterClass
var max_hp:=100
var hp:=100
var block:=0
"""Initializers for the class"""
func set_hp(new_hp:int):
	max_hp=new_hp
	hp=new_hp
"""General"""
func get_hp():
	return hp
func lose_hp(damage:int):
	damage-=block
	if damage!=0:
		hp-=damage
	if hp<=0:
		print("You lost")
func gain_hp(heal:int):
	hp+=heal
	if(hp>max_hp):
		hp=max_hp
