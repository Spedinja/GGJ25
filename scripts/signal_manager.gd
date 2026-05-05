extends Node

signal bubble_popped(value)
signal money_changed(value)
signal machine_unlocked
signal machine_level_up
signal move_to_bubbles
signal move_to_shop
signal pet_cat
signal SaveLoad_ShopUpdate

signal cant_upgrade
signal cant_unlock

signal fully_upgraded_everything

var tutorial_completed: bool = false

var ingame: bool = false
