using Godot;
using Godot.Collections;

public partial class PlayerStateIdle : State
{
    [Export] private CharacterBody2D character;
    [Export] private MotionComponent motion;

    public override void OnEnter(Dictionary _message = null)
    {
        motion.TwoDirectionAnimation(animationPlayer, "idle");
    }

    public override void PhysicsUpdate(double delta)
    {
        motion.InputDirection = motion.UpdateInputDirection();
        motion.LookingDirection = motion.InputDirection;

        float newY = (float)motion.ApplyGravity(character, delta);

        character.Velocity = new Vector2(0, character.Velocity.Y);
        character.Velocity = new Vector2(character.Velocity.X, newY);

        character.MoveAndSlide();
        checkTransitions();
    }

    private void checkTransitions()
    {
        if (Input.IsActionJustPressed("jump") && character.IsOnFloor())
        {
            stateMachine.TransitionState("PlayerStateJump");
        }
        else if (character.Velocity.Y > 0)
        {
            stateMachine.TransitionState("PlayerStateFall");
        }
        else if (motion.InputDirection.X != 0)
        {
            stateMachine.TransitionState("PlayerStateRun");
        }
        else if (Input.IsActionJustPressed("attack"))
        {
            stateMachine.TransitionState("PlayerStateAttack");
        }
    }
}
