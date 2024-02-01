using Godot;
using Godot.Collections;

/// Base state class to control character's behavior
public partial class State : Node
{
    [Export] protected AnimationPlayer animationPlayer;

    protected StateMachine stateMachine;

    public override void _Ready()
    {
        stateMachine = FindParent("StateMachine") as StateMachine;
    }

    public virtual void Update(double delta) { }
    public virtual void PhysicsUpdate(double delta) { }
    public virtual void OnEnter(Dictionary message = null) { }
    public virtual void OnExit() { }
}
