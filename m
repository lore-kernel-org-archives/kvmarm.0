From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 0/7] KVM: arm/arm64: Optimize arch timer register handling
Date: Sat, 10 Dec 2016 21:47:05 +0100
Message-ID: <20161210204712.21830-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We currently spend around ~400 cycles on each entry/exit to the guest
dealing with arch timer registers, even when the timer is not pending
and not doing anything.

We can do much better by moving the arch timer save/restore to the
vcpu_load and vcpu_put functions, but this means that if we don't read
back the timer state on every exit from the guest, then we have to be
able to start taking timer interrupts for the virtual timer in KVM and
handle that properly.

That has a number of funny consequences, such as having to make sure we
don't deadlock between any of the vgic code and interrupt injection
happening from an ISR.  On the plus side, being able to inject
virtual interrupts corresponding to a physical interrupt directly from
an ISR is probably a good system design change.

We also have to change the use of the physical vs. virtual counter in
the arm64 kernel to avoid having to save/restore the CNTVOFF_EL2
register on every return to the hypervisor.  The only reason I could
find for using the virtual counter for the kernel on systems with access
to the physical counter is to detect if firmware did not properly clear
CNTVOFF_EL2, and this change has to weighed against the existing check
(assuming I got this right).

On a non-VHE system (AMD Seattle) I have measured this to improve the
world-switch time by about ~100 cycles, but on an EL2 kernel (emulating
VHE behavior on the same hardware) this gives us around ~250 cycles
worth of improvement, because we can avoid the extra configuration of
trapping accesses to the physical timer from EL1 on every switch.

I'm not sure if the benefits outweigh the complexity of this patch set,
nor am I sure if I'm missing an overall better approach, hence the RFC
tag on the series.

I'm looking forward to overall comments on the approach.

These patches are based on arm64/for-next/core as of a few days ago with
Jintacks CNTHCTL_EL2 patch on top, because they give us has_vhe() in the
hyp code using static keys.

Code is also available here:
git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git timer-optimize-rfc

Thanks,
  Christoffer

Christoffer Dall (7):
  arm64: Use physical counter for in-kernel reads
  KVM: arm/arm64: Move kvm_vgic_flush_hwstate under disabled irq
  KVM: arm/arm64: Support calling vgic_update_irq_pending from irq
    context
  KVM: arm/arm64: Check that system supports split eoi/deactivate
  KVM: arm/arm64: Move timer save/restore out of hyp code where possible
  KVM: arm/arm64: Remove unnecessary timer BUG_ON operations
  KVM: arm/arm64: Guard kvm_vgic_map_is_active against !vgic_initialized

 arch/arm/include/asm/kvm_asm.h       |   2 +
 arch/arm/include/asm/kvm_hyp.h       |   4 +-
 arch/arm/kvm/arm.c                   |  17 ++-
 arch/arm/kvm/hyp/switch.c            |   5 +-
 arch/arm64/include/asm/arch_timer.h  |   6 +-
 arch/arm64/include/asm/kvm_asm.h     |   2 +
 arch/arm64/include/asm/kvm_hyp.h     |   4 +-
 arch/arm64/kvm/hyp/switch.c          |   4 +-
 drivers/clocksource/arm_arch_timer.c |   2 +-
 include/kvm/arm_arch_timer.h         |   7 +-
 virt/kvm/arm/arch_timer.c            | 222 ++++++++++++++++++++++++-----------
 virt/kvm/arm/hyp/timer-sr.c          |  32 ++---
 virt/kvm/arm/vgic/vgic-its.c         |  17 +--
 virt/kvm/arm/vgic/vgic-mmio-v2.c     |  22 ++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c     |  10 +-
 virt/kvm/arm/vgic/vgic-mmio.c        |  38 +++---
 virt/kvm/arm/vgic/vgic-v2.c          |   5 +-
 virt/kvm/arm/vgic/vgic-v3.c          |   5 +-
 virt/kvm/arm/vgic/vgic.c             |  59 ++++++----
 virt/kvm/arm/vgic/vgic.h             |   3 +-
 20 files changed, 292 insertions(+), 174 deletions(-)

-- 
2.9.0

