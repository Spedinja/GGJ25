extends Node

# @export var tracks : Array[Music]

@export var base_tracks : Array[Music]
@export var cafe_tracks : Array[Music]
@export var sky_tracks : Array[Music]

@export var bubble_sounds : Array[Music]
@export var cat_pet_sounds : Array[Music]

@onready var base_audio_player = $base_audio_player
@onready var cafe_audio_player = $cafe_audio_player
@onready var sky_audio_player = $sky_audio_player

@onready var bubble_sfx_player = $bubble_sfx
@onready var cat_pet_sfx_player = $cat_pet_sfx
@onready var other_sfx_player = $other_sfx

var level_up_sfx = "res://sfx/MachineUpgrade.mp3"
#var cat_pet_sound = "res://sfx/PetTheCat.mp3"

signal music_changed

var cafe : bool = false

var base_playlist = []
var cafe_playlist = []
var sky_playlist = []

var song_name : String

func _ready():
	create_playlist()
	play_random_song()
	base_audio_player.finished.connect(on_audio_player_finished)
	SignalManager.bubble_popped.connect(on_bubble_popped)
	SignalManager.machine_level_up.connect(on_level_up)
	SignalManager.pet_cat.connect(pet_cat)

func create_playlist():
	base_playlist = [] + base_tracks
	cafe_playlist = [] + cafe_tracks
	sky_playlist = [] + sky_tracks

func play_random_song():
	var song_index = randi_range(0, base_playlist.size()-1)
	print(song_index)
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

func on_location_switch():
	cafe = not cafe
	if cafe:
		cross_fade(cafe_audio_player,sky_audio_player)
	else:
		cross_fade(sky_audio_player,cafe_audio_player)

func cross_fade(from, to):
	var music_fade_out_tween = create_tween().set_ease(Tween.EaseType.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	music_fade_out_tween.tween_property(from, "volume_db", -80,2)
	var music_fade_in_tween = create_tween().set_ease(Tween.EaseType.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	music_fade_in_tween.tween_property(to, "volume_db", 0,2)
	

func on_bubble_popped():
	print("blub")
	var bubble_index = randi_range(0, bubble_sounds.size()-1)
	bubble_sfx_player.stream = load(bubble_sounds[bubble_index].file_path)
	bubble_sfx_player.play()

func on_level_up():
	other_sfx_player.stream = load(level_up_sfx)
	other_sfx_player.play()

func pet_cat():
	var pet_index = randi_range(0, bubble_sounds.size()-1)
	cat_pet_sfx_player.stream = load(cat_pet_sounds[pet_index].file_path)	
	#cat_pet_sfx_player.stream = load(cat_pet_sounds)
	cat_pet_sfx_player.play()
	print("meow")
