extends Node
class_name item_class
var rarity:="common"
#Will be like the cost the item has in a shop post fight
var cost:=5
#In case the item is discovered
var no_cost:=true
var type:="dart"
func set_type(tp:String):
	"""Sets type whic can be dart, glove, or maybe others"""
	type=tp
func set_rarity(rare:String):
	"""Sets rarity can either be common, uncommon, and rare"""
	rarity=rare
func set_cost(c:int):
	cost=c
func set_no_cost(c:bool):
	no_cost=c
