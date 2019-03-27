Made using Godot 3.0.5

A Petri Network implementation.

When you run it, the _ready() function assembles a basic network using custom functions. 

It creates two places, one transition between them, and two connections (from one place INTO the connection, from the connection into the second place.)

It then puts a single token on the first place.

The network then start cicling trough all of its Transition nodes (once per second), checking if they are avaliable. If they are, the are executed!

You can follow the progress of everything through text output. Though it IS better to check the whole code for a better idea of where everything is.