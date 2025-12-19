use godot::{classes::AudioStreamPlayer};
use godot::prelude::*;

#[derive(GodotClass)]
#[class(init, base=Node)]
pub struct GlobalMusic {
    #[export]
    music_list: Array<Gd<AudioStreamPlayer>>,

}

#[godot_api]
impl GlobalMusic {
    #[func]
    pub fn play(&mut self, music: Gd<AudioStreamPlayer>) {
        if music.is_playing() {
            return;
        }

        for mut item in self.music_list.iter_shared() {
            if item == music {
                continue
            }

            item.stop()
        }
    }
}