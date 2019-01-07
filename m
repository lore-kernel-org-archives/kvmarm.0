From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v3 0/3] KVM: arm/arm64: vgic: Use raw_spinlock for locks taken in IRQ context
Date: Mon,  7 Jan 2019 15:06:14 +0000
Message-ID: <1546873577-13895-1-git-send-email-julien.thierry@arm.com>
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

Changes since v2[1]:
- Rebase on v5.0-rc1
- Remove first patch from series as it has been applied

Changes since v1[2]:
- Rebase on v4.20-rc4
- Add Christoffer's Acked-by
- Fix potential lock up when waiting for vcpus to halt

[1] https://lkml.org/lkml/2018/11/27/20
[2] https://lkml.org/lkml/2018/11/19/776

Cheers,

Julien

-->

Julien Thierry (3):
  KVM: arm/arm64: vgic: Make vgic_irq->irq_lock a raw_spinlock
  KVM: arm/arm64: vgic: Make vgic_dist->lpi_list_lock a raw_spinlock
  KVM: arm/arm64: vgic: Make vgic_cpu->ap_list_lock a raw_spinlock

 include/kvm/arm_vgic.h           |   6 +-
 virt/kvm/arm/vgic/vgic-debug.c   |   4 +-
 virt/kvm/arm/vgic/vgic-init.c    |   8 +--
 virt/kvm/arm/vgic/vgic-its.c     |  22 ++++----
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  14 ++---
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  12 ++--
 virt/kvm/arm/vgic/vgic-mmio.c    |  34 +++++------
 virt/kvm/arm/vgic/vgic-v2.c      |   4 +-
 virt/kvm/arm/vgic/vgic-v3.c      |   8 +--
 virt/kvm/arm/vgic/vgic.c         | 118 +++++++++++++++++++--------------------
 10 files changed, 115 insertions(+), 115 deletions(-)

--
1.9.1
