extends Node

const NAKAMA_HOST := "127.0.0.1"
const NAKAMA_PORT := 7350
const NAKAMA_SCHEME := "http"
const SERVER_KEY := "defaultkey"
const DEVICE_ID := "grunt-and-run-godot-smoke-test"

var _client: NakamaClient
var _session: NakamaSession


func _ready() -> void:
	print("")
	print("=== Nakama SDK smoke test started ===")

	_client = Nakama.create_client(SERVER_KEY, NAKAMA_HOST, NAKAMA_PORT, NAKAMA_SCHEME)
	_session = await _authenticate_device()
	if _session == null:
		return

	var character_result: Dictionary = await _rpc("get_character")
	if _is_character_not_found(character_result):
		print("GET CHARACTER: character_not_found; creating Test Hero.")
		character_result = await _rpc("create_character", {
			"name": "Test Hero",
			"race": "human",
			"class": "warrior",
		})
		print("CREATE CHARACTER RESULT")
		print(_pretty(character_result))
	else:
		print("GET CHARACTER RESULT")
		print(_pretty(character_result))

	var dashboard_result: Dictionary = await _rpc("get_dashboard")
	print("GET DASHBOARD RESULT")
	print(_pretty(dashboard_result))

	print("=== Nakama SDK smoke test complete ===")


func _authenticate_device() -> NakamaSession:
	print("SDK AUTH device_id=%s" % DEVICE_ID)
	var session: NakamaSession = await _client.authenticate_device_async(DEVICE_ID)
	if session.is_exception():
		print("SMOKE TEST FAILED: authentication failed.")
		print(session.get_exception())
		return null

	print("AUTH OK")
	print("user_id: %s" % session.user_id)
	print("username: %s" % session.username)
	print("created: %s" % session.created)
	return session


func _rpc(rpc_name: String, payload: Dictionary = {}) -> Dictionary:
	print("SDK RPC %s" % rpc_name)

	var payload_text: Variant = null
	if not payload.is_empty():
		payload_text = JSON.stringify(payload)

	var response: Variant = await _client.rpc_async(_session, rpc_name, payload_text)
	if response.is_exception():
		var exception: NakamaException = response.get_exception()
		return {
			"error": exception.message,
			"status_code": exception.status_code,
			"grpc_status_code": exception.grpc_status_code,
		}

	var rpc_response: NakamaAPI.ApiRpc = response
	return _parse_rpc_payload(rpc_response.payload)


func _parse_rpc_payload(payload_text: String) -> Dictionary:
	var parsed: Variant = JSON.parse_string(payload_text)
	if parsed is Dictionary:
		var parsed_dict: Dictionary = parsed
		return parsed_dict
	return {"payload": payload_text, "parsed": parsed}


func _is_character_not_found(result: Dictionary) -> bool:
	var message := str(result.get("message", "")).to_lower()
	var error := str(result.get("error", "")).to_lower()
	var body := str(result.get("body", "")).to_lower()

	return (
		message.contains("character_not_found")
		or error.contains("character_not_found")
		or body.contains("character_not_found")
	)


func _pretty(value: Variant) -> String:
	return JSON.stringify(value, "\t")
