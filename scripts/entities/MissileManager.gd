extends Node

export (PackedScene) var missile

func _on_Player_fire_missile(spawn_position, target_position):
    print_debug("Firing missile")
    var spawned_missile = missile.instance()
    get_tree().get_root().add_child(spawned_missile)
    spawned_missile.position = spawn_position
    spawned_missile.look_at(target_position)

