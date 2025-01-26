extends DialogBox

func add_lines(arr: Array[Array] = []) -> void:
	arr.append_array([
		[TALKER.P1, "Leiger! Leiger, kuuled?"],
		[TALKER.P2, "Mida?"],
		[TALKER.P1, "Mis sa mu kapsastele õige peeretasid?"],
		[TALKER.P2, "Ise sa peeretasid!"],
		[TALKER.P1, "Või mina peeretasin? Ah nii!"]
	])

	super(arr)
