using Godot;
using Godot.Collections;

public partial class StateMachine : Node
{
    [Export]
    private State InitialState;

    public State ActiveState;

    public override void _Ready()
    {
        ActiveState = InitialState;
        ActiveState.OnEnter();
    }

    public override void _Process(double delta)
    {
        ActiveState.Update(delta);
    }

    public override void _PhysicsProcess(double delta)
    {
        ActiveState.PhysicsUpdate(delta);
    }

    public void TransitionState(string targetState, Dictionary message = null)
    {
        if (!HasNode(targetState))
        {
            return;
        }

        ActiveState.OnExit();

        ActiveState = GetNode<State>(targetState);

        ActiveState.OnEnter(message);
    }
}
