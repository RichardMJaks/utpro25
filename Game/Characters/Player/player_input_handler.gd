extends InputHandler


func set_dir() -> int:
    @warning_ignore("narrowing_conversion")
    return Input.get_axis("m_left", "m_right")

func set_bounce() -> bool:
    return Input.is_action_just_pressed("a_bounce")