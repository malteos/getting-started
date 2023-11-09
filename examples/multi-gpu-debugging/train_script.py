import os
import torch
from torch import nn

local_rank = int(os.environ["LOCAL_RANK"])

class SomeModel(torch.nn.Module):
    def __init__(self):
        super().__init__()

        self.layer = nn.Linear(16, 32, bias=True)

    def forward(self, x):
        return self.layer(x)

model = SomeModel()

# model = torch.nn.parallel.DistributedDataParallel(model,
#                                                   device_ids=[local_rank],
#                                                   output_device=local_rank)

w = torch.ones((16,32))
w.to(local_rank)

print("done")