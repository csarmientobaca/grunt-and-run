extends Node2D

const CHARACTER_CREATION_SCENE := "res://scenes/character_creation/CharacterCreation.tscn"
const DASHBOARD_SCENE := "res://scenes/dashboard/Dashboard.tscn"


func _ready() -> void:
	print("")
	print("=== Boot started ===")
	print("Connecting to Nakama...")

	var authenticated: bool = await NakamaService.connect_and_authenticate()
	if not authenticated:
		print("BOOT FAILED: could not authenticate with Nakama.")
		return

	print("Checking profile state...")
	var profile_state: Dictionary = await NakamaService.get_profile_state()
	GameState.set_profile_state(profile_state)
	print("PROFILE STATE")
	print(NakamaService.pretty(profile_state))

	var next_screen: String = str(profile_state.get("next_screen", ""))
	match next_screen:
		"character_creation":
			print("Next scene: Character Creation")
			_go_to_scene_if_exists(CHARACTER_CREATION_SCENE)
		"dashboard":
			print("Next scene: Dashboard")
			_go_to_scene_if_exists(DASHBOARD_SCENE)
		_:
			print("BOOT FAILED: unknown next_screen '%s'." % next_screen)


func _go_to_scene_if_exists(scene_path: String) -> void:
	if not ResourceLoader.exists(scene_path):
		print("Scene not created yet: %s" % scene_path)
		print("=== Boot complete ===")
		return

	var error: Error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		print("Failed to change scene to %s. Error: %s" % [scene_path, error])
