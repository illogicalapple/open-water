extends Node

func _ready():
	_on_timer_timeout()
	$Timer.start()

func _on_timer_timeout():
	$AudioStreamPlayer.play()

func _on_audio_stream_player_finished():
	$Timer.start()
