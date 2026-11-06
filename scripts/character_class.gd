class_name CharacterClass extends Node
var max_hp:=100
var hp:=100
var block:=0
#The buff and debuff numbers are how many turns they are active for
var buff:=0
var debuff:=0
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
func add_hp(heal:int):
	hp+=heal
	if(hp>max_hp):
		hp=max_hp
func add_block(b:int):
	block+=b
func set_block(b:int):
	block=b
func time_buff(turns:int):
	"""Flat 1.25x buff to self"""
	buff+=turns
func time_debuff(turns:int):
	"""Flat -1.25x/*.8 buff to self"""
	debuff+=turns
func actions(a:Array[String],power:Array[int],targets:Array[CharacterClass])->void:
	"""Takes a list that dictates the actions the character should carry out
	and then works to have an inside list of a string and a string of a number that is an int
	the string dictates the action type and the number string the value
	of the type use int() to change it"""
	#This is because of Gdscript not allowing lists of lists of different types
	for i in range(len(a)):
		if a[i]=='attack':#This needs an enemy so weird to add
			if buff>0:
				power[i]=round(power[i]*1.25)
			if debuff>0:
				power[i]=round(power[i]*.8)
			targets[i].lose_hp(power[i])
		if(a[i]=='block'):
			add_block(power[i])
		if(a[i]=='heal'):
			add_hp(round(power[i]*.25))
		if(a[i]=='buff'):
			"""Buffs to check for/add later on
			damage, block, etc."""
			time_buff(round(power[i]/4))
		if(a[i]=='debuff'):#This needs an enemy so weird to add
			"""Might add an equal and opposite debuff for every buff there is"""
			targets[i].time_debuff(round(power[i]/4))
	if buff!=0:
		buff-=1
	if debuff!=0:
		debuff-=1
	"""Could code it so that the player and enemy removes each others armour at
	end of their turn"""
