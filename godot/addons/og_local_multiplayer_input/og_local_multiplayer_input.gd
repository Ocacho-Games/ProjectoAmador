@tool
extends EditorPlugin

const AUTOLOAD_NAME = "OGLocalMultiplayerInput"

func _enter_tree():
    add_autoload_singleton(AUTOLOAD_NAME, "code/autoloads/og_s_input_mapping_generator.gd")

func _exit_tree():
    remove_autoload_singleton(AUTOLOAD_NAME)