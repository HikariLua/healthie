using Godot;
using Godot.Collections;

public partial class PlayerStateDie : State
{
    [Export] private CharacterBody2D character;
    [Export] private MotionComponent motion;
    [Export] private CollectableComponent collectable;
    [Export] private HealthComponent health;

    [Export] private AudioStreamPlayer2D dieSFX;

    [Export] private CollisionShape2D hurtboxCollision;
    [Export] private CollisionShape2D collectableCollision;

    private PackedScene deathScreenScene = GD.Load<PackedScene>(
        "res://scenes/screens/death_screen.tscn"
    );

    private TransitionScreen transitionScreen;

    public override void _Ready()
    {
        base._Ready();

        transitionScreen = GetNode<TransitionScreen>("/root/TransitionScreen");
    }

    public override void OnEnter(Dictionary message = null)
    {
        dieSFX.Play();

        if (health.Lives > 0)
        {
            health.Lives -= 1;

            Node root = GetTree().Root;
            root.CallDeferred("add_child", deathScreenScene.Instantiate());

            transitionScreen.ReloadScene(this.GetTree());
        }
        else
        {
            transitionScreen.TransitionTo(
                "res://scenes/screens/game_over_screen.tscn",
                this.GetTree()
            );
        }

        collectable.CollectSequence = -100;

        hurtboxCollision.SetDeferred("disabled", true);
        collectableCollision.SetDeferred("disabled", true);

        motion.TwoDirectionAnimation(animationPlayer, "die");
    }

    public override void PhysicsUpdate(double delta)
    {
        float newY = (float)motion.ApplyGravity(character, delta);
        character.Velocity = new Vector2(0, newY);

        character.MoveAndSlide();
    }
}
