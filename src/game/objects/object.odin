package objects
import "core:fmt"

game_tree: ^GameHierarchy
game_tree_initialized := false

Vector1 :: [1]f32
Vector2 :: [2]f32
Vector3 :: [3]f32
Vector4 :: [4]f32
Color :: [4]u8
Quaternion :: quaternion128

// Normal that faces up towards the sky
NormalUp :: Vector3{0, 1, 0}

// Normal that faces down towards the ground
NormalDown :: Vector3{0, -1, 0}

// Normal that faces forward towards the screen
NormalFront :: Vector3{0, -1, 0}

// Normal that faces backward away from the screen
NormalBack :: Vector3{0, -1, 0}

// Normal that faces to the right of the screen
NormalRight :: Vector3{1, 0, 0}

// Normal that faces to the left of the screen
NormalLeft :: Vector3{-1, 0, 0}

ObjectType :: enum {
  PhysicsObject,
  NonPhysicsObject,
  Light
}

GameObject :: struct {
  id: u64,
  name: string,
  position: Vector3,
  orientation: Quaternion,

  parent: u64,
  derived: any
}

ColoredObject :: struct {
  using _: GameObject,
  color: Color
}

CubeObject :: struct {
  using _: GameObject,
  size: Vector3,
  color: Color
}

PlaneObject :: struct {
  using _: GameObject,
  size: Vector2,
  color: Color,
  normal: Vector3,
}

RectObject :: struct {
  using _: GameObject,
  size: Vector2,
  color: Color,
}

CircleObject :: struct {
  using _: GameObject,
  size: Vector2,
  color: Color
}

TextObject :: struct {
  using _: GameObject,
  font: string,
  size: i32,
  color: Color,
}


/*
  This makes the hierarchy of objects:
  GameObject
  |--CubeObject
  \--PlaneObject
*/

GameHierarchy :: struct {
  root: [dynamic]union{
    ^GameObject,
    ^RectObject,
    ^CubeObject,
    ^CircleObject,
    ^TextObject,
    ^PlaneObject,
  },
}

// Init stuff

init_game_tree :: proc() {
  game_tree = new(GameHierarchy)
  game_tree_initialized = true
}

destroy_game_tree :: proc() {
  for obj in game_tree.root {
    free(obj.(^GameObject))
  }
  free(game_tree)
}

// ==============
// Object Control
// ==============

remove_object :: proc(
  self: ^GameHierarchy,
  obj: ^GameObject
) {
  // iterate through all the hooks and find the hook with the same pointer as `hook`
  for i := 0; i <= len(self.root); i += 1 {
    if self.root[i] == obj {
      unordered_remove(&self.root, i)
      fmt.println("removed pointer ", obj, " from the GameHierarchy")
    }
  }
}

// creates a game object
// TODO: Make this add the object to an object "registry"
create_object :: proc($T: typeid) -> ^T { 
  if !game_tree_initialized {
    panic("game_tree not initialized")
  }
  obj := new(T)
  obj.derived = obj^
  append(&game_tree.root, cast(^T)obj)
  fmt.print(game_tree)
  return obj
}

// frees a game object from memory.
// TODO: Make this clear the object from an object "registry"
destroy_object :: proc(obj: ^$T) -> (ok: bool) {
  if !game_tree_initialized {
    panic("game_tree not initialized")
  }
  remove_object(game_tree, obj)
  err := free(obj)
  if err != .None do return false
  return true
}

// ==================
// End Object Control
// ==================