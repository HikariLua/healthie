using Godot;
using Godot.Collections;

public partial class PlayerStateRun : State
{
    [Export] private CharacterBody2D character;
    [Export] private MotionComponent motion;

    public override void OnEnter(Dictionary _message = null)
    {
        motion.TwoDirectionAnimation(animationPlayer, "run");
    }

    public override void PhysicsUpdate(double delta)
    {
        motion.InputDirection = motion.UpdateInputDirection();
        motion.LookingDirection = motion.InputDirection;

        motion.TwoDirectionAnimation(animationPlayer, "run");

        float newY = (float)motion.ApplyGravity(character, delta);
        float newX = (float)motion.MoveX(
            motion.MaxSpeed,
            motion.InputDirection.X
        );

        character.Velocity = new Vector2(newX, character.Velocity.Y);
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
            Dictionary dict = new Dictionary{
                {"coyote", true}
            };

            stateMachine.TransitionState(
                "PlayerStateFall",
                dict
            );
        }
        else if (motion.InputDirection.X == 0)
        {
            stateMachine.TransitionState("PlayerStateIdle");
        }
        else if (Input.IsActionJustPressed("attack"))
        {
            stateMachine.TransitionState("PlayerStateAttack");
        }
    }
}
