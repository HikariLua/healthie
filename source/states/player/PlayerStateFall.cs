using Godot;
using Godot.Collections;

public partial class PlayerStateFall : State
{
	[Export] private CharacterBody2D character;
	[Export] private Timer coyoteTimer;
	[Export] private MotionComponent motion;

	[Export] private Array<RayCast2D> rayCasts;

	private bool coyote = false;

	public override void OnEnter(Dictionary message = null)
	{
		if (message != null)
		{
			if (message.ContainsKey("coyote"))
			{
				coyote = (bool)message["coyote"];
			}
			else
			{
				coyote = false;
			}
		}

		coyoteTimer.Start(0.2);

		motion.TwoDirectionAnimation(animationPlayer, "fall");
	}

	public override void PhysicsUpdate(double delta)
	{
		motion.InputDirection = motion.UpdateInputDirection();
		motion.LookingDirection = motion.InputDirection;

		motion.TwoDirectionAnimation(animationPlayer, "fall");

		double divisor = character.Velocity.Y <= 0 ? 1 : 2;

		float newY = (float)motion.ApplyGravity(character, delta / divisor);
		float newX = (float)motion.MoveX(
			motion.MaxSpeed,
			motion.InputDirection.X
		);

		character.Velocity = new Vector2(newX, character.Velocity.Y);
		character.Velocity = new Vector2(character.Velocity.X, newY);

		character.MoveAndSlide();
		checkTransitions();
	}

	private bool rayCastsColliding()
	{
		foreach (RayCast2D rayCast in rayCasts)
		{
			if (rayCast.IsColliding())
			{
				return true;
			}
		}

		return false;
	}

	private void checkTransitions()
	{
		if (Input.IsActionJustPressed("jump"))
		{
			if (coyoteTimer.TimeLeft > 0 && coyote)
			{
				stateMachine.TransitionState("PlayerStateJump");
			}
			else if (rayCastsColliding())
			{
				stateMachine.TransitionState("PlayerStateJump");
			}
		}
		else if (Input.IsActionJustPressed("attack"))
		{
			stateMachine.TransitionState("PlayerStateAttackAir");
		}
		else if (character.IsOnFloor() && motion.InputDirection.X != 0)
		{
			stateMachine.TransitionState("PlayerStateRun");
		}
		else if (character.IsOnFloor())
		{
			stateMachine.TransitionState("PlayerStateIdle");
		}
		else if (character.Velocity.Y > 0)
		{
			stateMachine.TransitionState("PlayerStateFall");
		}
	}

	public override void OnExit()
	{
		coyoteTimer.Stop();
	}
}
