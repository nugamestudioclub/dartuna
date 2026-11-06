extends Node
var darts_launched:=0
var p:PlayerClass=PlayerClass.new()
"""Below is enemy only an example for now might take different shapes throughout a
run using random or a controlled version of random like StS"""
var e:CharacterClass=CharacterClass.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	e.set_hp(50)


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_hitBoard() -> void:
	"""This is where you would want to have the thing using rad_bin and 
	add to both actions and power lists"""
	darts_launched+=1
	if darts_launched==3:
		#Here does the damage count and temporarily just printing the health
		print('Previous hp player: '+str(p.hp))
		print('Previous hp enemy: '+str(e.hp))
		var actions:Array[String]=['block','heal','attack']
		var board_val:Array[int]=[20,10,15]
		var t:Array[CharacterClass]=[p,p,p]
		var t2:Array[CharacterClass]=[e,e,e]
		var actions2:Array[String]=['buff','debuff','attack']
		var board_val2:Array[int]=[17,10,30]
		p.actions(actions,board_val,t2)
		e.actions(actions2,board_val2,t)
		print('New hp player: '+str(p.hp))
		print('New hp enemy: '+str(e.hp))
		darts_launched=0
	print(darts_launched)
