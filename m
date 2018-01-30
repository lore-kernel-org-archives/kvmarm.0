From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/3] Additional fixes for kvmarm/next
Date: Tue, 30 Jan 2018 13:42:03 +0100
Message-ID: <20180130124206.12262-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

A bit last minute, we have three fixes for patches already queued in
kvmarm/next related to the level-triggered mapped interrupts support.

These patches apply on kvmarm/next and are pushed to kvmarm/queue.

Thanks,
-Christoffer

Christoffer Dall (3):
  KVM: arm/arm64: Fix incorrect timer_is_pending logic
  KVM: arm/arm64: Fix userspace_irqchip_in_use counting
  KVM: arm/arm64: Fixup userspace irqchip static key optimization

 virt/kvm/arm/arch_timer.c | 38 ++++++++++++++++++--------------------
 virt/kvm/arm/arm.c        |  5 +++--
 2 files changed, 21 insertions(+), 22 deletions(-)

-- 
2.14.2
