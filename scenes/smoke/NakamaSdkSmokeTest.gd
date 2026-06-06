extends Node


func _ready() -> void:
	print("")
	print("=== Nakama SDK smoke test started ===")

	var authenticated: bool = await NakamaService.connect_and_authenticate()
	if not authenticated:
		return

	var character_result: Dictionary = await NakamaService.get_character()
	if NakamaService.is_character_not_found(character_result):
		print("GET CHARACTER: character_not_found; creating Test Hero.")
		character_result = await NakamaService.create_character("Test Hero", "human", "warrior")
		print("CREATE CHARACTER RESULT")
		print(NakamaService.pretty(character_result))
	else:
		print("GET CHARACTER RESULT")
		print(NakamaService.pretty(character_result))

	var dashboard_result: Dictionary = await NakamaService.get_dashboard()
	print("GET DASHBOARD RESULT")
	print(NakamaService.pretty(dashboard_result))

	print("=== Nakama SDK smoke test complete ===")
