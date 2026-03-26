class_name AudioInstance
extends Node2D

var audio_player: AudioStreamPlayer2D

func _init(audio_sample: String) -> void:
	audio_player = AudioStreamPlayer2D.new()
