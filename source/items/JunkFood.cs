using Godot;
using Godot.Collections;

public partial class JunkFood : Area2D
{
    [Export] private Sprite2D sprite;
    [Export] private bool isRandom = true;

    [Export] private double speed = 0;
    [Export] private Vector2 direction = Vector2.Zero;
    [Export] private VisibleOnScreenNotifier2D visibleScreen;

    private Timer timer = new Timer();
    private int maxFrames;

    public override void _Ready()
    {
        maxFrames = sprite.Hframes * sprite.Vframes;

        this.AddChild(timer);
        timer.OneShot = true;
        timer.Timeout += selfDestroy;

        visibleScreen.ScreenExited += onVisibleOnScreenExited;
        this.AreaEntered += onArea2DEntered;

        if (isRandom)
        {
            sprite.Frame = GD.RandRange(0, maxFrames - 1);
        }

        if (speed == 0)
        {
            this.SetPhysicsProcess(false);
        }
        else
        {
            timer.Start(10);
        }
    }

    public override void _PhysicsProcess(double delta)
    {
        this.Position += (direction * (float)speed) * (float)delta;

        if (HasOverlappingBodies())
        {
            Array<Node2D> bodies = GetOverlappingBodies();

            checkCannon(bodies);
        }
    }

    private void checkCannon(Array<Node2D> bodies)
    {
        foreach (Node2D body in bodies)
        {
            if (!body.IsInGroup("cannon"))
            {
                selfDestroy();
                return;
            }
        }
    }

    private void selfDestroy()
    {
        timer.Stop();
        QueueFree();
    }

    private void onArea2DEntered(Area2D _area)
    {
        selfDestroy();
    }

    private void onVisibleOnScreenExited()
    {
        if (speed != 0)
        {
            selfDestroy();
        }
    }
}
