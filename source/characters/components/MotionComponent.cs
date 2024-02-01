using Godot;

public partial class MotionComponent : Node
{
    [Export] public double JumpVelocity = -32 * 8.7;
    [Export] public double MaxSpeed = 92;
    [Export] public double MaxFallSpeed = 200;

    [Export] private Vector2 initialLookingDirection = Vector2.Right;

    private Vector2 lookingDirection;
    public Vector2 LookingDirection
    {
        get { return lookingDirection; }
        set { lookingDirection = SetLookingDirection(value); }
    }

    public Vector2 InputDirection = Vector2.Zero;
    public double Gravity = (double)ProjectSettings.GetSetting(
        "physics/2d/default_gravity"
    );

    public override void _Ready()
    {
        LookingDirection = initialLookingDirection;
    }

    public Vector2 UpdateInputDirection()
    {
        Vector2 NewInputDirection = new Vector2(
            Input.GetAxis("left", "right"),
            Input.GetAxis("up", "down")
        );

        return NewInputDirection.Round();
    }

    public double ApplyGravity(CharacterBody2D body, double delta)
    {
        if (body.IsOnFloor())
        {
            return body.Velocity.Y;
        }

        return Mathf.MoveToward(
            body.Velocity.Y,
            MaxFallSpeed,
            Gravity * delta
        );

    }

    public double MoveX(double speed, double direction)
    {
        return speed * direction;
    }

    public void TwoDirectionAnimation(
        AnimationPlayer animationPlayer,
        string animationPrefix
    )
    {
        string suffix = LookingDirection.X < 0 ? "-left" : "-right";
        string newAnimation = animationPrefix + suffix;

        if (newAnimation == animationPlayer.CurrentAnimation)
        {
            return;
        }

        animationPlayer.Play(newAnimation);
    }

    private Vector2 SetLookingDirection(Vector2 value)
    {
        if (value.X == 0)
        {
            return LookingDirection;
        }

        return value;
    }
}
