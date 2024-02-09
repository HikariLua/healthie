using Godot;
using Godot.Collections;

public partial class EnemyStateRoam01 : State
{
    [Export] private CharacterBody2D character;
    [Export] private MotionComponent motion;

    [Export] private Timer roamTimer;
    [Export] private double roamDuration = 4;

    public override void _Ready()
    {
        base._Ready();
        roamTimer.Timeout += onRoamTimerTimeout;
    }

    public override void OnEnter(Dictionary message = null)
    {
        roamTimer.Start(roamDuration);
        motion.TwoDirectionAnimation(animationPlayer, "run");
    }

    public override void PhysicsUpdate(double delta)
    {
        motion.TwoDirectionAnimation(animationPlayer, "run");

        float newX = (float)motion.MoveX(
            motion.MaxSpeed,
            motion.LookingDirection.X
        );

        float newY = (float)motion.ApplyGravity(
            character,
            delta
        );

        character.Velocity = new Vector2(newX, newY);

        character.MoveAndSlide();

        checkWalls();
    }

    private void checkWalls()
    {
        if (character.IsOnWall())
        {
            motion.LookingDirection *= -1;
            character.GlobalPosition += motion.LookingDirection;
        }
    }

    private void onRoamTimerTimeout()
    {
        stateMachine.TransitionState("EnemyStateIdle01");
    }
}
