extends Node3D

var time: Dictionary = {
	"hour": 7,
	"minute": 0,
	"am": true
}
var multiplayer_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

@onready var menu: Control = $MenuControl

# join multiplayer room
func _on_join_pressed():
	var port = str($MenuControl/Menu/Port.text).to_int()
	var ip = str($MenuControl/Menu/IP.text)
	multiplayer_peer.create_client(ip, port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false

# multiplayer host
func _on_host_pressed():
	var port = str($MenuControl/Menu/Port.text).to_int()
	multiplayer_peer.create_server(port)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
	menu.visible = false
	add_player_character()

# adds a character
func add_player_character(id=1):
	var character = preload("res://player_character/player_character.tscn").instantiate()
	character.name = str(id)
	add_child(character)
	
