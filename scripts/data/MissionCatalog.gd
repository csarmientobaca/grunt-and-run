extends RefCounted
class_name MissionCatalog

const CONTRACTS := [
	{
		"location_id": "dark_forest",
		"location_name": "Dark Forest",
		"contract_id": "goblin_shaman_wolf_fat",
		"giver_id": "goblin_shaman",
		"giver_name": "Goblin Shaman",
		"faction": "goblin",
		"title": "Bring Wolf Fat",
		"location_hint": "Wolves roam the Dark Forest.",
		"requirements": [
			{
				"item_id": "wolf_fat",
				"item_name": "Wolf Fat",
				"quantity": 3,
			},
		],
		"reward": {
			"gold": 12,
			"items": ["minor_healing_charm"],
			"reputation": {
				"goblin_shaman": 5,
			},
		},
	},
	{
		"location_id": "dark_forest",
		"location_name": "Dark Forest",
		"contract_id": "castle_quartermaster_recover_supplies",
		"giver_id": "castle_quartermaster",
		"giver_name": "Castle Quartermaster",
		"faction": "human",
		"title": "Recover Lost Supplies",
		"location_hint": "Supply crates were lost along the old forest road.",
		"requirements": [
			{
				"item_id": "lost_supply_crate",
				"item_name": "Lost Supply Crate",
				"quantity": 1,
			},
		],
		"reward": {
			"gold": 15,
			"items": ["field_ration"],
			"reputation": {
				"castle_quartermaster": 5,
			},
		},
	},
	{
		"location_id": "outside_castle",
		"location_name": "Outside Castle",
		"contract_id": "captain_guard_tokens",
		"giver_id": "knight_captain",
		"giver_name": "Knight Captain",
		"faction": "human",
		"title": "Collect Guard Tokens",
		"location_hint": "Tokens are carried by patrols outside the castle.",
		"requirements": [
			{
				"item_id": "guard_token",
				"item_name": "Guard Token",
				"quantity": 2,
			},
		],
		"reward": {
			"gold": 18,
			"items": ["gate_pass"],
			"reputation": {
				"knight_captain": 6,
			},
		},
	},
	{
		"location_id": "lost_caverns",
		"location_name": "Lost Caverns",
		"contract_id": "human_wizard_cave_crystals",
		"giver_id": "human_wizard",
		"giver_name": "Human Wizard",
		"faction": "human",
		"title": "Gather Cave Crystals",
		"location_hint": "Crystals grow in the damp tunnels of the Lost Caverns.",
		"requirements": [
			{
				"item_id": "cave_crystal",
				"item_name": "Cave Crystal",
				"quantity": 2,
			},
		],
		"reward": {
			"gold": 25,
			"items": ["minor_regen_flask"],
			"reputation": {
				"human_wizard": 7,
			},
		},
	},
]


static func get_available_contracts() -> Array:
	return CONTRACTS.duplicate(true)
