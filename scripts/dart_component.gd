extends Node3D

@export var power: float = 1.0

@onready var body: CharacterBody3D = $CharacterBody3D  # uses real node name.
#Below is where the player is can poss move later but here for now
var p:PlayerClass=PlayerClass.new()
"""Below is enemy only an example for now might take different shapes throughout a
run using random or a controlled version of random like StS"""
var e:CharacterClass=CharacterClass.new().set_hp(50)
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var launched := false

var darts_launched:int=0

func launch(launch_velocity: Vector3) -> void:
	var _lvelocity = launch_velocity;
	_lvelocity.x *= power;
	body.velocity = _lvelocity
	launched = true
	
func _physics_process(delta: float) -> void:
	if not launched:
		return
	body.velocity.y -= gravity * delta  # drop effect
	
	# Rotate the body in place, and skip cases look_at can't handle
	var dir := body.velocity.normalized()
	if body.velocity.length_squared() > 0.0001 and abs(dir.dot(Vector3.UP)) < 0.999:
		body.look_at(body.global_position + body.velocity, Vector3.UP)
	
	var collision = body.move_and_collide(body.velocity * delta)
	if collision:
		launched = false  # dart sticks where it hits
		if collision.get_collider().has_method("hit"):
			var pos:Vector3 = body.global_position;
			collision.get_collider().hit(pos)
			"""This is where you would want to have the thing using rad_bin and 
			add to both actions and power lists"""
			darts_launched+=1
			if darts_launched==3:
				#Here does the damage count and temporarily just printing the health
				print('Previous hp player'+str(p.hp))
				print('Previous hp enemy'+str(e.hp))
				var actions:Array[String]=['block','heal','attack']
				var board_val:Array[int]=[20,10,15]
				var t:=[p,p,p]
				var t2:=[e,e,e]
				var actions2:Array[String]=['buff','debuff','attack']
				var board_val2:Array[int]=[17,10,30]
				p.actions(actions,board_val,t2)
				e.actions(actions2,board_val2,t)
				print('New hp player'+str(p.hp))
				print('New hp enemy'+str(e.hp))
				darts_launched=0
			print(darts_launched)
	
	
