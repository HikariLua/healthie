using Godot;
using Godot.Collections;

public partial class PlayerStateAttack : State
{
	[Export] private CharacterBody2D character;
	[Export] private AudioStreamPlayer2D attackSFX;

	[Export] private MotionComponent motion;
	[Export] private CombatComponent combat;

	private PackedScene projectileScene = GD.Load<PackedScene>(
		"res://scenes/projectiles/player_projectile.tscn"
	);

	public override void _Ready()
	{
		base._Ready();
		animationPlayer.AnimationFinished += onAnimationPlayerFinished;
	}

	public override void OnEnter(Dictionary _message = null)
	{
		PlayerProjectile projectile =
			(PlayerProjectile)projectileScene.Instantiate();

		float newX = motion.LookingDirection.X;
		projectile.Direction = new Vector2(newX, projectile.Direction.Y);

		projectile.GlobalPosition = character.GlobalPosition;
		projectile.Damage = combat.Damage;

		Node root = GetTree().Root;
		root.CallDeferred("add_child", projectile);

		motion.TwoDirectionAnimation(animationPlayer, "attack");

		attackSFX.Play();

		character.Velocity = Vector2.Zero;
	}

	public override void PhysicsUpdate(double delta)
	{
		float newY = (float)motion.ApplyGravity(character, delta);
		character.Velocity = new Vector2(character.Velocity.X, newY);

		character.MoveAndSlide();
	}

	private void onAnimationPlayerFinished(StringName _animName)
	{
		if (stateMachine.ActiveState != this)
		{
			return;
		}

		stateMachine.TransitionState("PlayerStateIdle");
	}
}
