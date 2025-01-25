extends Node

@export var tracks : Array[Music]

@export var base_tracks : Array[Music]
@export var cafe_tracks : Array[Music]
@export var sky_tracks : Array[Music]

@onready var base_audio_player = $base_audio_player
@onready var cafe_audio_player = $cafe_audio_player
@onready var sky_audio_player = $sky_audio_player

signal music_changed

var cafe : bool = true

var base_playlist = []
var cafe_playlist = []
var sky_playlist = []

var song_name : String

func _ready():
	create_playlist()
	play_random_song()
	base_audio_player.finished.connect(on_audio_player_finished)

func create_playlist():
	base_playlist = [] + base_tracks
	cafe_playlist = [] + cafe_tracks
	sky_playlist = [] + sky_tracks

func play_random_song():
	var song_index = randi_range(0, base_playlist.size()-1)
	var song = base_playlist[song_index]
	
	music_changed.emit()
	play_song(song_index)
	
	base_playlist.erase(song_index)
	cafe_playlist.erase(song_index)
	sky_playlist.erase(song_index)
	
	# used, so all songs in the playlist are played
	# once before the playlist gets randomized again
	if base_playlist.is_empty():
		create_playlist()

func play_song(song_index):
	base_audio_player.stream = load(base_playlist[song_index].file_path)
	base_audio_player.play()
	cafe_audio_player.stream = load(cafe_playlist[song_index].file_path)
	cafe_audio_player.play()
	sky_audio_player.stream = load(sky_playlist[song_index].file_path)
	sky_audio_player.play()

func on_audio_player_finished():
	play_random_song()

func on_location_switch(from,to):
	var music_fade_out_tween = create_tween().set_ease(Tween.EaseType.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	music_fade_out_tween.tween_property(from, "volume_db", -80,1)
	var music_fade_in_tween = create_tween().set_ease(Tween.EaseType.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	music_fade_in_tween.tween_property(to, "volume_db", -6,1)
	
func _input(event):
	if event is InputEventMouseButton:
		if cafe:
			on_location_switch(cafe_audio_player,sky_audio_player)
		else:
			on_location_switch(sky_audio_player,cafe_audio_player)
		cafe = not cafe
		print(cafe)
