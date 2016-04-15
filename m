From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 0/7] KVM: arm/arm64: Rework arch timer IRQ interface
Date: Fri, 15 Apr 2016 15:04:00 +0100
Message-ID: <1460729047-6346-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

currently the VGIC uses a linked list of irq_phys_map entries to store
mappings between virtual interrupts and mapped physical interrupts.
The virtual arch timer (as so far the only user of this feature) uses
a pointer to an allocated list entry to talk to the VGIC on several
occassions when handling mapped IRQs.
This is not only unneeded, but also exposes the (private) implementation
details of storing this mapping to other parts of the code, which will
cause issues with the new VGIC implementation.
So this series makes the irq_phys_map private to the VGIC
implementation, which improves abstraction and allows the new VGIC to
come without nasty hacks.

Based on 4.6-rc3.

Cheers,
Andre.

Andre Przywara (6):
  KVM: arm/arm64: remove unneeded map parameter for vgic_update_irq_pending()
  KVM: arm/arm64: directly pass virtual IRQ number on injecting mapped IRQ
  KVM: arm/arm64: directly pass virtual IRQ number on kvm_vgic_map_is_active()
  KVM: arm/arm64: directly pass virtual IRQ number on kvm_vgic_unmap_phys_irq()
  KVM: arm/arm64: remove irq_phys_map from the arch timer
  KVM: arm/arm64: remove irq_phys_map pointer from kvm_vgic_map_phys_irq()

Christoffer Dall (1):
  KVM: arm/arm64: Remove the IRQ field from struct irq_phys_map

 include/kvm/arm_arch_timer.h |  4 +--
 include/kvm/arm_vgic.h       | 10 +++----
 virt/kvm/arm/arch_timer.c    | 40 ++++++++++++++++++--------
 virt/kvm/arm/vgic.c          | 67 +++++++++++++++-----------------------------
 4 files changed, 58 insertions(+), 63 deletions(-)

-- 
2.7.3

