use godot::classes::Node2D;
use godot::prelude::*;

#[derive(GodotClass)]
#[class(init, base=Node2D)]
pub struct ProjectileManager {
    #[var]
    #[init(val = Node2D::new_alloc())]
    entry_point: Gd<Node2D>,

    base: Base<Node2D>,
}

#[godot_api]
impl ProjectileManager {
    #[func]
    pub fn spawn_projectile(&mut self, projectile: Gd<Node2D>) {
        self.entry_point
            .call_deferred("add_child", &[projectile.to_variant()]);
    }
}
