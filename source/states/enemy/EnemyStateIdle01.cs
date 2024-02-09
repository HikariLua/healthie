using Godot;
using Godot.Collections;

public partial class EnemyStateIdle01 : State
{
	[Export] private CharacterBody2D character;
	[Export] private MotionComponent motion;

	[Export] private Timer idleTimer;
	[Export] private double idleDuration = 2;

	[Export] private bool flips = true;

	public override void _Ready()
	{
		base._Ready();
		idleTimer.Timeout += onIdleTimerTimeout;
	}

	public override void OnEnter(Dictionary message = null)
	{
		idleTimer.Start(idleDuration);
		motion.TwoDirectionAnimation(animationPlayer, "idle");

		character.Velocity = new Vector2(0, character.Velocity.Y);
	}

	public override void PhysicsUpdate(double delta)
	{
		motion.TwoDirectionAnimation(animationPlayer, "idle");

		float newY = (float)motion.ApplyGravity(
			character,
			delta
		);

		character.Velocity = new Vector2(character.Velocity.X, newY);

		character.MoveAndSlide();
	}

	private void onIdleTimerTimeout()
	{
		stateMachine.TransitionState("EnemyStateRoam01");
	}

	public override void OnExit()
	{
		idleTimer.Stop();

		if (flips)
		{
			motion.LookingDirection *= -1;
		}
	}
}
