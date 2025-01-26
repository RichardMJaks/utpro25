extends DialogBox

func add_lines(arr: Array[Array] = []) -> void:
	arr.append_array([
		[TALKER.P1, "Vanapagan! Mis teed seal?"],
		[TALKER.P2, "Ei midagi."],
		[TALKER.P1, "Või ei midagi?"],
		[TALKER.P1, "Küll ma sind tean!"],
		[TALKER.P1, "Küllap sa seal pahategusid sepitsed!"],
		[TALKER.P2, "Ei, vägilane, ei!"]
	])

	super(arr)

