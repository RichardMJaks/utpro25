extends DialogBox

func add_lines(arr: Array[Array] = []) -> void:
	arr.append_array([
		[TALKER.P2, "Töll! Tule seia ja tee aed korda!"],
		[TALKER.P1, "Ei mina viitsi tulla Linda. Tee ise!"],
		[TALKER.P2, "Sina lõhkusid, sina teed..."],
		[TALKER.P1, "Sul on kolm poega, las nemad teevad."],
		[TALKER.P2, "Ma veel näitan sulle kolme poega!"]
	])

	super(arr)

