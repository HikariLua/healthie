using Godot;
using Godot.Collections;

public partial class PlayerStateJump : State
{
    [Export] private CharacterBody2D character;
    [Export] private AudioStreamPlayer2D jumpSfx;
    [Export] private MotionComponent motion;

    private double minJumpVelocity;

    public override void _Ready()
    {
        base._Ready();
        minJumpVelocity = motion.JumpVelocity / 2;
    }

    public override void OnEnter(Dictionary _message = null)
    {
        motion.TwoDirectionAnimation(animationPlayer, "jump");

        float newY = (float)motion.JumpVelocity;
        character.Velocity = new Vector2(character.Velocity.X, newY);

        jumpSfx.Play();
    }

    public override void PhysicsUpdate(double delta)
    {
        motion.InputDirection = motion.UpdateInputDirection();
        motion.LookingDirection = motion.InputDirection;

        motion.TwoDirectionAnimation(animationPlayer, "jump");

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

    private void regulateJump()
    {
        if (character.Velocity.Y < minJumpVelocity)
        {
            float newY = (float)minJumpVelocity;
            character.Velocity = new Vector2(character.Velocity.X, newY);
        }
    }

    private void checkTransitions()
    {
        if (Input.IsActionJustPressed("attack"))
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
}
