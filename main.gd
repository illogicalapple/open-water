extends Node3D

var time: Dictionary = {
	"hour": 7,
	"minute": 0,
	"am": true
}
var multiplayer_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

@onready var menu: VBoxContainer = $Menu

# join multiplayer room
func _on_join_pressed():
	var port = str($Menu/Port.text).to_int()
	multiplayer_peer.create_client("localhost", port) # always localhost, must change that
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false

# multiplayer host
func _on_host_pressed():
	var port = str($Menu/Port.text).to_int()
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
	menu.visible = false
	add_player_character()
	$TimeSet.start()

# adds a character
func add_player_character(id=1):
	var character = preload("res://player_character/player_character.tscn").instantiate()
	character.name = str(id)
	add_child(character)
	

# change the time
func _on_time_set_timeout():
	time.minute += 1
	if time.minute > 59:
		time.minute = 0
		time.hour += 1
		if time.hour > 11:
			time.hour = 0
			time.am = not time.am
	$GUI.change_time(time)
	rpc("change_time", time) # not the best way of doing this, i couldn't figure out rset until recently

@rpc
func change_time(new_time):
	$GUI.change_time(new_time) # changes the time!
	time = new_time
