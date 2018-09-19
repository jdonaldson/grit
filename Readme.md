# Grit : Grid-based  Logging Using Git
![Jeff Bridges](https://i.imgur.com/hWToGc7.jpg)

Grit is a tool to enable easier checkpointing of complex workflows such as ML
model development.  Grit is written in Haxe, and contains some simple command line tools,
as well as log helper implementations in python, java, cpp, js, lua, and php.

# Background

Traditionally, model development involves adjusting model parameters in an
automated (or semi-automated) fashion, either by a form of [gradient
descent](https://en.wikipedia.org/wiki/Gradient_descent),
or some other form of optimization.

Additionally, there are
[hyperparameters](https://en.wikipedia.org/wiki/Hyperparameter_optimization) for
given model configurations, and these parameters are typically tuned and tweaked
based on the known problem context.

Finally, there are countless feature engineering combinations, architecture
changes, and many other adjustments that lack a formal name.  Grit deals with
specifically with tracking and logging these adjustments. Rather than performing
[grid
search](https://en.wikipedia.org/wiki/Hyperparameter_optimization#Approaches)
over model parameters, Grit will log arbitrary model metrics over given commits,
enabling a fine grained overview of which model configurations produced which
performance characteristics at which check points.


