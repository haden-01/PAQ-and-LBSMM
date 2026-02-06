
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on 20260206

@author: Yuanmiao Lin
"""

import torch
import torch.nn as nn
from torch.autograd import Function
import numpy as np

class DoReFaLike_Quant_Function(Function):
    @staticmethod
    def forward(ctx, x, bits, train=True):
        tanh = torch.tanh(x).float()
        y = tanh / torch.max(torch.abs(tanh)).detach()
        delta = 2 ** (bits - 1) - 1
        _y = torch.round(y * delta)

        out_c, in_c, h, w = _y.shape

        #N:M pruning setting
        group_size = 8  # M 
        required_zeros = 4 # N

        _y_modified = _y.clone()

        if in_c < group_size:
            return _y / delta  # If the input channel count is less than the group size, we apply direct dequantization without pruning.

        # reshape for grouping
        g = in_c // group_size
        _y_grouped = _y_modified[:, :g*group_size, :, :].view(out_c, g, group_size, h, w)

        # count zeros per group
        zero_mask = (_y_grouped == 0)
        zero_count = zero_mask.sum(dim=2)  # shape: [out_c, g, h, w]

        # Identify groups requiring pruning (those with fewer than 4 zeros).
        mask_to_fix = zero_count < required_zeros

        # Apply N:M pruning.
        for idx in torch.nonzero(mask_to_fix, as_tuple=False):
            o, g_idx, i, j = idx.tolist()
            group = _y_grouped[o, g_idx, :, i, j]
            abs_vals = torch.abs(group)
            abs_vals[group == 0] = float('inf')  

            k = required_zeros - (group == 0).sum().item()
            _, indices = torch.topk(abs_vals, k=k, largest=False)
            group[indices] = 0
            _y_grouped[o, g_idx, :, i, j] = group

        # reshape back
        _y_modified[:, :g*group_size, :, :] = _y_grouped.view(out_c, g*group_size, h, w)

        return _y_modified / delta

    @staticmethod
    def backward(ctx, grad):
        x_grad     = grad
        bits_grad  = None
        train_grad = None
        return x_grad, bits_grad, train_grad

class DoReFaLike_Quantizer(nn.Module):
    def __init__(self,
                 x,bits = 8):
        super(DoReFaLike_Quantizer, self).__init__()

        self.bits  = bits
        self.quant = DoReFaLike_Quant_Function.apply

    def forward(self, x):
        y = self.quant(x, self.bits, self.train)
        return y

    def extra_repr(self):
        return 'bits={}'.format(self.bits)



if __name__ == '__main__':
    torch.manual_seed(0)

    conv = nn.Conv2d(in_channels=32, out_channels=1, kernel_size=1, stride=1, padding=1, bias=False)
    param = conv.weight  # shape: [1, 32, 3, 3]

    print("Unquantized floating-point weights:")
    print(param[0, :, :, :])  

    quantizer = DoReFaLike_Quantizer(param,bits=8)
    param_quant0 = quantizer(param)

    print("quantized floating-point weights:")
    print(param[0, :, :, :])  


