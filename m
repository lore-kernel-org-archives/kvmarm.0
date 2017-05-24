From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 00/10] ARM/ARM64 Direct EOI setup for VFIO wired interrupts
Date: Wed, 24 May 2017 22:13:13 +0200
Message-ID: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This series allows to optimize the deactivation of virtual interrupts
associated to vfio device wired physical interrupts (non MSI).

This is a revival of "[PATCH v4 00/13] ARM IRQ forward control based on
IRQ bypass manager" (https://lkml.org/lkml/2015/11/19/351) whose development
was stalled due to dependency on new VGIC design and drop of priority.

Without that optimization the deactivation of the physical IRQ is performed
by the host. Also for level sensitive interrupts, The VFIO driver disables
the physical IRQ. The deactivation of the virtual IRQ by the guest is trapped
and the physical IRQ gets re-enabled at that time.

The ARM GIC supports direct EOI for virtual interrupts directly mapped
 to physical interrupts. When this mode is set, the host does not
deactivate the physical interrupt anymore, but simply drops the
interrupt priority on EOI. When the guest deactivates the virtual IRQ,
the GIC automatically deactivates the physical IRQ. This avoids a world
switch on deactivation.

This series sets direct EOI mode on ARM/ARM64 for shared peripheral
interrupts. This relies on a negotiation between the vfio driver and
KVM/irqfd though the irq bypass manager.

The setup sequence is:

preamble:
- disable the physical IRQ
- halt guest execution
forwarding setting:
- program the VFIO driver for forwarding (select the right physical
  interrupt handler)
- program the VGIC and IRQCHIP for forwarding
postamble:
- resume guest execution
- enable the physical IRQ

When destroying the optimized path the following sequence is executed:
- preamble
- unset forwarding at VGIC and IRQCHIP level
- unset forwarding at VFIO level
- postamble

The injection still is based on irqfd triggering. For level sensitive
interrupts though, the resamplefd is not triggered anymore since
deactivation is not trapped by KVM.

This was tested with:
- AMD Seattle xgmac platform device assignment
- Cavium ThunderX PCIe device assignment with pci=nomsi (INTx)
- Also MSI non regression was tested on ARM

The series can be fount at:
https://github.com/eauger/linux/tree/v4.12-rc2-deoi-v5

It is based on 4.12-rc2

Best Regards

Eric

Eric Auger (10):
  vfio: platform: Add automasked field to vfio_platform_irq
  VFIO: platform: Introduce direct EOI interrupt handler
  VFIO: platform: Direct EOI irq bypass for ARM/ARM64
  VFIO: pci: Add automasked field to vfio_pci_irq_ctx
  VFIO: pci: Introduce direct EOI INTx interrupt handler
  irqbypass: Add a private field in the producer
  VFIO: pci: Direct EOI irq bypass for ARM/ARM64
  KVM: arm/arm64: vgic: Handle unshared mapped interrupts
  KVM: arm/arm64: vgic: Implement forwarding setting
  KVM: arm/arm64: register DEOI irq bypass consumer on ARM/ARM64

 arch/arm/kvm/Kconfig                             |   3 +
 arch/arm64/kvm/Kconfig                           |   3 +
 drivers/vfio/pci/Kconfig                         |   4 +
 drivers/vfio/pci/Makefile                        |   1 +
 drivers/vfio/pci/vfio_pci_intrs.c                |  78 +++++++++---
 drivers/vfio/pci/vfio_pci_irq_bypass.c           | 134 ++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h              |  35 ++++++
 drivers/vfio/platform/Kconfig                    |   5 +
 drivers/vfio/platform/Makefile                   |   2 +-
 drivers/vfio/platform/vfio_platform_irq.c        |  53 ++++++--
 drivers/vfio/platform/vfio_platform_irq_bypass.c | 114 +++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h    |  26 ++++
 include/kvm/arm_vgic.h                           |   9 +-
 include/linux/irqbypass.h                        |   2 +
 virt/kvm/arm/arch_timer.c                        |   3 +-
 virt/kvm/arm/arm.c                               |  42 +++++++
 virt/kvm/arm/vgic/vgic.c                         | 149 ++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h                         |   9 +-
 18 files changed, 632 insertions(+), 40 deletions(-)
 create mode 100644 drivers/vfio/pci/vfio_pci_irq_bypass.c
 create mode 100644 drivers/vfio/platform/vfio_platform_irq_bypass.c

-- 
2.5.5
