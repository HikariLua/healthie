use godot::prelude::*;

struct Healthie;

mod components;
mod systems;

#[gdextension]
unsafe impl ExtensionLibrary for Healthie {}
