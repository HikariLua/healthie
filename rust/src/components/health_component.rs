use godot::classes::{Area2D, Node};
use godot::prelude::*;
use godot::tools::try_get_autoload_by_name;
use crate::systems::SaveLoad;

#[derive(GodotClass)]
#[class(init, base=Node)]
pub struct HealthComponent {
    #[export]
    #[init(val = 6)]
    max_health: i32,

    #[export]
    hurtbox: OnEditor<Gd<Area2D>>,

    #[export]    
    #[var(get, set = set_lifes)]
    lifes: i32,

    #[var]
    health_points: i32,
        
    base: Base<Node>
}

#[godot_api]
impl INode for HealthComponent {
    fn ready(&mut self) {
        self.hurtbox.signals().area_entered().connect_other(self, Self::on_hurtbox_area_entered);
        
        /*let health_node = self.base().clone();
        self.hurtbox.connect(
            "area_entered", 
            &Callable::from_object_method(&health_node, "on_hurtbox_area_entered")
        );*/
    }
}

#[godot_api]
impl HealthComponent {
    #[signal]
    fn damage_taken(previous_hp: i32, attacker_hitbox: Gd<Area2D>);
    #[signal]
    fn life_changed(previous_life: i32);

    #[func]
    fn set_lifes(&mut self, new_lifes: i32) {
        self.base_mut().emit_signal("life_changed", &[Variant::from(new_lifes)]);
        
        self.lifes = new_lifes;

        let mut saveload = try_get_autoload_by_name::<SaveLoad>("SaveLoadAutoload").unwrap();

        saveload.bind_mut().save_to_next_scene("player".into(), vdict! {"lifes": self.lifes});

    }

    #[func]
    fn take_damage(&mut self, attacker_hitbox: Gd<Area2D>) {
        let previous_health = self.health_points;
        //self.health_points = self.health_points - attacker_hitbox.damage;

        self.base_mut().emit_signal(
            "damage_taken", 
            &[Variant::from(previous_health), Variant::from(attacker_hitbox)]);
    }

    #[func]
    fn on_hurtbox_area_entered(&mut self, area: Gd<Area2D>) {
        self.take_damage(area);
    }
}