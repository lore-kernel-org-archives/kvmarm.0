From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Tue, 14 Jul 2015 15:06:02 +0300
Message-ID: <cover.1436874248.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This patch set brings back functionality which was broken in v4.1. The
overall goal is to eventually enable using virtual timer too, but for now
changes affect only a possibility to run KVM itself. The guest currently
has to use another timer because there's no API to propagate interrupts
from in-kernel virtual timer to the interrupt controller emulated in
userspace.

v1=>v2:
- Do not use defensive approach in patch 0001. Use correct conditions in
  callers instead
- Added ARM64-specific code, without which attempt to run a VM ends in a
  HYP crash because of unset vGIC save/restore function pointers

Christoffer Dall: I decided to leave original approach of 0002 as it is,
because:
- It is much simpler to implement than doing changes inside both probe
  functions.
- These are all use cases for vgic_present flag. Nothing else is going to
  rely on it. IMHO this switch is very short and stylish :) If you don't
  like two error codes, we could change -ENXIO to -ENODEV where appropriate,
  this change would be small enough.
Actually i tried to discuss some things with you, but you stopped replying,
therefore i respin in order to revive the thing. On top of this i have
complete implementation of API which allows to emulate GIC in userspace by
qemu, and now i can run any virtual machine, including generic timer, on
vGIC-less machine. RasPI-2 is expected to benefit too.

Pavel Fedin (3):
  KVM: arm: Fix NULL pointer dereference if KVM is used without
    in-kernel irqchip
  KVM: arm: Detect vGIC presence at runtime
  KVM: arm64: Introduce default dummy save/restore functions

 arch/arm/include/asm/kvm_host.h   |  5 +++++
 arch/arm/kvm/arm.c                | 24 +++++++++++++++++++++---
 arch/arm64/include/asm/kvm_asm.h  |  1 +
 arch/arm64/include/asm/kvm_host.h |  8 ++++++++
 arch/arm64/kvm/vgic-v2-switch.S   |  5 +++++
 virt/kvm/arm/vgic.c               |  2 ++
 6 files changed, 42 insertions(+), 3 deletions(-)

-- 
2.4.4

