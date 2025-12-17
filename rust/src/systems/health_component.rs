use godot::classes::{Area2D, Node};
use godot::prelude::*;

#[derive(GodotClass)]
#[class(init, base=Node)]
pub struct HealthComponent {
    #[export]
    #[init(val = 6)]
    max_health: i64,

    lifes: i64,

    health_points: i64,

    base: Base<Node>
}

/*#[godot_api]
impl INode2D for HealthComponent {
    >>>>>>- SAVELOAD -<<<<<<<<<
}*/

#[godot_api]
impl HealthComponent {
    #[signal]
    fn damage_taken(previous_hp: i64, attacker_hitbox: Gd<Area2D>);
    #[signal]
    fn life_changed(previous_life: i64);

    #[func]
    fn set_lifes(&mut self, new_lifes: i64) {
        self.base_mut().emit_signal("life_changed", &[Variant::from(new_lifes)]);
        
        self.lifes = new_lifes

        // <<<<<<<- Lógica do SAVELOAD ->>>>>>>>
    }

    #[func]
    fn take_damage(&mut self, attacker_hitbox: Gd<Area2D>) {
        let mut previous_health = self.health_points;
        //self.health_points = self.health_points - attacker_hitbox.damage;

        self.base_mut().emit_signal(
            "damage_taken", 
            &[Variant::from(previous_health), Variant::from(attacker_hitbox)]);
    }

    #[func]
    fn _on_hurtbox_area_entered(&mut self, area: Gd<Area2D>) {
        self.take_damage(area);
    }
}