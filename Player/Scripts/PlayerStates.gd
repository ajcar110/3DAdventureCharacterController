extends Node


var IDLE := IdleState.new()
var WALK := WalkState.new()
var RUN := WalkState.new()
var FALL := FallState.new()
var JUMP := JumpState.new()
var AIRJUMP := AirJumpState.new()
var GRIND := GrindState.new()
var GRINDJUMP := GrindJumpState.new()
var TRAPIDLESTATE := TrapezeIdleState.new()
var TRAPJUMPSTATE := TrapezeJumpState.new()
