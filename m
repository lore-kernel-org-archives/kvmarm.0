From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 0/4] KVM: arm/arm64: vgic: Use raw_spinlock for locks taken in IRQ context
Date: Mon, 26 Nov 2018 18:26:43 +0000
Message-ID: <1543256807-9768-1-git-send-email-julien.thierry@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, Christoffer.Dall@arm.com, linux-arm-kernel@lists.infradead.org, linux-rt-users@vger.kernel.org, tglx@linutronix.de, rostedt@goodmis.org, bigeasy@linutronix.de, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

While testing KVM running on PREEMPT_RT, starting guest could simply
freeze the machine. This is because we are using spinlocks for VGIC
locks, which is invalid in the VGIC case since the locks must be take
with interrupts disabled.

The solution is to use raw_spinlock instead of spinlocks.

Replacing those locks also highlighted an issue where we attempt to
cond_resched with interrupts disabled.

Patch 1 fixes the cond_resched issue.
Patch 2-4 replace the VGIC spinlocks with raw_spinlocks

Changes since v1[1]:
- Rebase on v4.20-rc4
- Add Christoffer's Acked-by
- Fix potential lock up when waiting for vcpus to halt

[1] https://lkml.org/lkml/2018/11/19/776

Cheers,

Julien

-->

Julien Thierry (4):
  KVM: arm/arm64: vgic: Do not cond_resched_lock() with IRQs disabled
  KVM: arm/arm64: vgic: Make vgic_irq->irq_lock a raw_spinlock
  KVM: arm/arm64: vgic: Make vgic_dist->lpi_list_lock a raw_spinlock
  KVM: arm/arm64: vgic: Make vgic_cpu->ap_list_lock a raw_spinlock

 include/kvm/arm_vgic.h           |   6 +-
 virt/kvm/arm/vgic/vgic-debug.c   |   4 +-
 virt/kvm/arm/vgic/vgic-init.c    |   8 +--
 virt/kvm/arm/vgic/vgic-its.c     |  22 +++----
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  14 ++---
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  12 ++--
 virt/kvm/arm/vgic/vgic-mmio.c    |  70 ++++++++++-----------
 virt/kvm/arm/vgic/vgic-v2.c      |   4 +-
 virt/kvm/arm/vgic/vgic-v3.c      |   8 +--
 virt/kvm/arm/vgic/vgic.c         | 130 +++++++++++++++++++--------------------
 10 files changed, 135 insertions(+), 143 deletions(-)

--
1.9.1
