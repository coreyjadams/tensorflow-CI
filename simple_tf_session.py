import tensorflow as tf

# Build a graph.
a = tf.constant(5.0)
b = tf.constant(6.0)
c = a * b

# Launch the graph in a session.
sess = tf.Session()

# Evaluate the tensor `c`.
c_eval = sess.run(c)

assert (c_eval == 5.*6.)

print("Success: tensorflow session succeeded")