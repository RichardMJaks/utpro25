extends AudioStreamPlayer

var menuMusic = load("res://Game/Audio/Music/background_music.mp3")
var gameMusic = load("res://Game/Audio/Music/Kevin MacLeod - Thatched Villagers.mp3")

var previousScene
var nextTrack
var state # fade_out, fade_in
var timeElapsed: float = 0

var levels = ["LevelLeigur", "LevelLinda", "LevelVanakurat", "VolleyballLevel"]

func _ready() -> void:
	volume_db = linear_to_db(0)
	get_tree().connect("tree_changed", _on_tree_changed)

func _on_tree_changed():
	var scene = get_tree().current_scene
	if (scene == null): return
	
	var currentScene = scene.name
	if (currentScene == previousScene): return
	print(str(previousScene) + " -> " + str(currentScene))
	
	if (currentScene == "MainMenu" && previousScene != "Settings"):
		playMusic(menuMusic)
	
	if (currentScene in levels && not previousScene in levels):
		playMusic(gameMusic)
	
	previousScene = currentScene

func playMusic(track):
	nextTrack = track
	state = "fade_out"
	timeElapsed = 0

func _process(delta: float) -> void:
	timeElapsed += delta
	
	if (state == "fade_out"):
		var volume = max(db_to_linear(volume_db) - delta, 0)
		volume_db = linear_to_db(volume)
		if (volume <= 0):
			state = "fade_in"
			stream = nextTrack
			play()
	
	elif (state == "fade_in"):
		var volume = min(db_to_linear(volume_db) + delta, 1)
		volume_db = linear_to_db(volume)
