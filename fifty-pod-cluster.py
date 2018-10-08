from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import numpy as np
import ray
import time

ray.init("10.20.0.51:6379")
#ray.init(num_cpus=4, ignore_reinit_error=True)

@ray.remote
class Foo(object):
    def __init__(self):
        self.counter = 0

    def reset(self):
        self.counter = 0

    def increment(self):
        time.sleep(0.5)
        self.counter += 1
        return self.counter

Foos = [Foo.remote() for _ in range(20)]



time.sleep(2.0)


# Reset the actor state so that we can run this cell multiple times without
# changing the results.
for f in Foos:
    f.reset.remote()

# We want to parallelize this code. However, it is not straightforward to
# make "increment" a remote function, because state is shared (the value of
# "self.counter") between subsequent calls to "increment". In this case, it
# makes sense to use actors.
results = []
start_time = time.time()
for _ in range(5):
    for f in Foos:
        results.append(f.increment.remote())

results = ray.get(results)
end_time = time.time()
duration = end_time - start_time

print(results)
print(duration)

#assert results == [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]

#assert duration < 3, ('The experiments ran in {} seconds. This is too '
#                      'slow.'.format(duration))
#assert duration > 2.5, ('The experiments ran in {} seconds. This is too '
#                        'fast.'.format(duration))

print('Success! The example took {} seconds.'.format(duration))
