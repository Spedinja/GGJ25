extends Node

# @export var tracks : Array[Music]

@export_category("Music")
@export var base_tracks : Array[AudioStream]
@export var cafe_tracks : Array[AudioStream]
@export var sky_tracks : Array[AudioStream]

@export_category("SFX")
## Sounds that play when a Bubble is popped.
@export var bubble_sounds : Array[AudioStream]
## Sounds that play when a Cat is pet.
@export var cat_pet_sounds : Array[AudioStream]
## Sound that plays when a Bubble Machine is Upgraded.
@export var level_up_sfx: AudioStream
## Sound that plays when a Bubble Machine is Unlocked.
@export var unlock_sfx: AudioStream
## Sound that plays when a Bubble Machine cannot be Upgraded.
@export var cant_upgrade_sfx: AudioStream
## Sound that plays when a Bubble Machine cannot be Unlocked.
@export var cant_unlock_sfx: AudioStream

@onready var base_audio_player = $base_audio_player
@onready var cafe_audio_player = $cafe_audio_player
@onready var sky_audio_player = $sky_audio_player

@onready var bubble_sfx_player = $bubble_sfx
@onready var cat_pet_sfx_player = $cat_pet_sfx
@onready var other_sfx_player = $other_sfx

#var cat_pet_sound = "res://sfx/PetTheCat.mp3"

signal music_changed

var cafe : bool = false

var base_playlist = []
var cafe_playlist = []
var sky_playlist = []

#var song_name : String

func _ready():
	create_playlist()
	play_random_song()
	base_audio_player.finished.connect(on_audio_player_finished)
	SignalManager.bubble_popped.connect(on_bubble_popped)
	SignalManager.machine_unlocked.connect(on_machine_unlock)
	SignalManager.machine_level_up.connect(on_level_up)
	SignalManager.pet_cat.connect(pet_cat)
	SignalManager.cant_upgrade.connect(cant_upgrade)
	SignalManager.cant_unlock.connect(cant_unlock)
	

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
	base_audio_player.stream = base_playlist[song_index]
	cafe_audio_player.stream = cafe_playlist[song_index]
	sky_audio_player.stream = sky_playlist[song_index]
	base_audio_player.play()
	cafe_audio_player.play()
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
	music_fade_in_tween.tween_property(to, "volume_db", -2,2)

func on_bubble_popped():
	#print("blub")
	#var bubble_index = randi_range(0, bubble_sounds.size()-1)
	#bubble_sfx_player.stream = bubble_sounds[bubble_index]
	bubble_sfx_player.play()

func on_machine_unlock():
	print("Unlocked new Machine")
	other_sfx_player.stream = unlock_sfx
	other_sfx_player.play()
	#on_level_up()

func on_level_up():
	other_sfx_player.stream = level_up_sfx
	other_sfx_player.play()

func pet_cat():
	var pet_index = randi_range(0, bubble_sounds.size()-1)
	cat_pet_sfx_player.stream = cat_pet_sounds[pet_index]
	#cat_pet_sfx_player.stream = load(cat_pet_sounds)
	cat_pet_sfx_player.play()
	print("meow")

func cant_upgrade():
	print("Cannot Upgrade this Bubble Machine")
	other_sfx_player.stream = cant_upgrade_sfx
	other_sfx_player.play()

func cant_unlock():
	print("Cannot Unlock this Bubble Machine")
	other_sfx_player.stream = cant_unlock_sfx
	other_sfx_player.play()
