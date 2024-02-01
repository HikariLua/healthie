using Godot;
using Godot.Collections;

public partial class PlayerStateAttackAir : State
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
	}

	public override void PhysicsUpdate(double delta)
	{
		motion.InputDirection = motion.UpdateInputDirection();
		motion.LookingDirection = motion.InputDirection;

		float newY = (float)motion.ApplyGravity(character, delta);
		float newX = (float)motion.MoveX(
			motion.MaxSpeed,
			motion.InputDirection.X
		);

		character.Velocity = new Vector2(newX, character.Velocity.Y);
		character.Velocity = new Vector2(character.Velocity.X, newY);

		if (character.IsOnFloor())
		{
			character.Velocity = new Vector2(0, character.Velocity.Y);

		}

		character.MoveAndSlide();
	}

	private void onAnimationPlayerFinished(StringName _animName)
	{
		if (stateMachine.ActiveState != this)
		{
			return;
		}

		if (motion.InputDirection.X != 0 && !character.IsOnFloor())
		{
			stateMachine.TransitionState("PlayerStateFall");
			return;
		}
		else if (motion.InputDirection.X != 0 && character.IsOnFloor())
		{
			stateMachine.TransitionState("PlayerStateRun");
			return;
		}

		stateMachine.TransitionState("PlayerStateIdle");
	}
}
