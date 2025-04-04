extends Resource
class_name Spawner

var bubbleValue: float
var currentLvl = -1
var currModifier
var isUnlocked: bool  = false
@export var arrStats: Array[float]
@export var bubble_scene: PackedScene
var toUpdate: bool = false
