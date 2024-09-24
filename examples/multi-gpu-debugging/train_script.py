import os
import torch
from torch import nn

local_rank = int(os.environ["LOCAL_RANK"])
local_device = torch.device(f"cuda:{local_rank}")

device_ids = [f"cuda:{rank}" for rank in range(torch.cuda.device_count())]

# some simple variable
w = torch.ones((16, 32))
w = w.to(local_device)

print(f"{local_rank=} {w.device}")

# a simple model
# class SomeModel(torch.nn.Module):
#     def __init__(self):
#         super().__init__()

#         self.layer = nn.Linear(16, 32, bias=True)

#     def forward(self, x):
#         return self.layer(x)


# model = SomeModel()
# model = model.to(local_device)
# model = torch.nn.parallel.DistributedDataParallel(
#     model, device_ids=[local_rank], output_device=local_device
# )

print("done")
