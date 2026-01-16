use godot::classes::INode2D;
use godot::classes::Node2D;
use godot::prelude::*;

#[derive(GodotClass)]
#[class(base=Node2D)]
pub struct State {
    #[var]
    #[allow(dead_code)]
    pub transitions: VarDictionary,

    base: Base<Node2D>,
}

#[godot_api]
impl INode2D for State {
    fn init(base: Base<Node2D>) -> Self {
        Self {
            transitions: VarDictionary::new(),
            base,
        }
    }
}

#[godot_api]
impl State {
    #[func(virtual)]
    pub fn update(&mut self, _delta: f64) {}

    #[func(virtual)]
    pub fn physics_update(&mut self, _delta: f64) {}

    #[func(virtual)]
    pub fn on_enter(&mut self) {}

    #[func(virtual)]
    pub fn on_enter_with_message(&mut self, _message: VarDictionary) {}

    #[func(virtual)]
    pub fn on_exit(&mut self) {}
}
