extends Node
class_name item_class
#Will be like the cost the item has in a shop post fight
#In case the item is discovered
func _init(tp:String='dart',rare:String='common',c:int=5,no_c:bool=false,in_inventory:bool=false)->void:
	"""Initialized type rarity cost and no_cost"""
	self.type=tp
	self.rarity=rare
	self.cost=c
	self.no_cost=no_c
	self.inventory=in_inventory
func set_cost(c:int):
	self.cost=c
func set_no_cost(no_c:bool):
	self.no_cost=no_c
func switch_in_inventory():
	self.inventory=!self.inventory
