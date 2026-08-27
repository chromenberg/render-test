package hook
import "core:fmt"
import "base:runtime"

NO_NAME :: "NoNameAssigned"

HookCallback :: #type proc(args: ..any)

Hook :: struct {
  callback: HookCallback,
  once: bool,
  // A name of the hook, helps to state what the hook is for
  name: Maybe(string)
}

HookStore :: struct {
  hooks: [dynamic]^Hook,
}

HookFailedToAppendError :: proc() {
  panic("Failed to append a hook into the hook store")
}

create_hook :: proc(
  callback: HookCallback,
  once: bool,
  name: Maybe(string)
) -> ^Hook {
  hook := new(Hook)
  
  hook.callback = callback
  hook.once = once
  hook.name = name
  
  return hook
}

add_hook :: proc(
  self: ^HookStore,
  hook: ^Hook
) -> ^Hook {
  appended, err := append(&self.hooks, hook)
  
  if err != nil {
    HookFailedToAppendError()
  }
  
  return hook
}

remove_hook :: proc(
  self: ^HookStore,
  hook: ^Hook
) {
  // iterate through all the hooks and find the hook with the same pointer as `hook`
  for i := 0; i < len(self.hooks); {
    if self.hooks[i] == hook {
      unordered_remove(&self.hooks, i)
      fmt.println("removed pointer ", hook, " from the hook store")
    }
  }
}

run_hooks :: proc(self: ^HookStore, args: ..any) {
  for hook in self.hooks {
    hook.callback(..args) // Call the hook callback

    if hook.once { // If the hook has the once flag, we remove it after calling
      remove_hook(self, hook)
    }
  }
}

create_hook_store :: proc() -> ^HookStore {
  ctx := context
  store := new(HookStore, context.allocator)

  return store
}

destroy_hook_store :: proc(store: ^HookStore) {
  free(store, context.allocator)
}
