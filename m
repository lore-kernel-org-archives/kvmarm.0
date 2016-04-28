From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 00/54] KVM: arm/arm64: Rework virtual GIC emulation
Date: Thu, 28 Apr 2016 17:45:19 +0100
Message-ID: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this is another rework of the new VGIC series.
Most prominent changes this time include a complete rewrite of the MMIO
framework and splitting the emulation bits for GICv2 and GICv3 into
separate files (patch 20/54 and 21/54) - many thanks to Christoffer and
Marc for taking care of that.
We dropped support for userland save and restore of any GICv3 register,
as the ABI hasn't been fully agreed upon.
Also the arch_timer rework series has now been integrated (making up
the first seven patches), since it's a prerequisite for the new VGIC
and also not very useful without it.
Some fixes - especially for GICv3 emulation - have also been integrated.
The file names have been trimmed to all using dashes instead of a mixture
of dashes and underscores.
The patches that saw changes have had their changelog updated.

All the open issues that were mentioned in the last cover letter have
either been addressed or dismissed.

The series survived some testing on various hosts - both GICv2 and
GICv3, also 32-bit GICv2 hosts - and various guests.
Some basic cross-endian tests were done as well, with both 64-bit LE and
BE guests surviving boot and hackbench runs on a 64-bit BE host.
Also a 32-bit BE guest was booted successfully on a 64-bit LE host.

As this new VGIC emulation will probably become the default very shortly,
please test it full steam on whatever setup you have access to.
Any reports are warmly welcome.

This series is now based on v4.6-rc5.
A git tree containing this series can be found on linux-arm.org:

git://linux-arm.org/linux-ap.git	branch: vgic-new/v2
http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/vgic-new/v2

Cheers,
Andre.

===========================
This series is a joint effort to re-implement KVM's GIC emulation.

While the current implementation is centered around providing
efficient MMIO emulation, the hot path for most guests is actually
the guest entry and exit, which currently is rather costly.
Also the existing emulation has a global distributor lock, which
quickly becomes a bottleneck once the number of VCPUs increases.
Additionally the emulation was originally designed for GICv2, adding
GICv3 ITS emulation support to this proved to be rather painful.
Last, but not least the existing code became less and less
maintainable, with many special cases handled explicitly.

The new implementation is build around a struct vgic_irq data
structure, which holds all information about a virtual interrupt.
Interruts which should be injected are held in a per-VCPU list, this
make the entry/exit path much more efficient. Also the new structure
allows to have more fine grained locking - per IRQ and per VCPU -
getting rid of the global distributor lock.
As a result of the new design ITS emulation fits in more nicely, the
respective code will be provided as a follow-up series.

This series implements the same feature set as the existing emulation,
as a goodie we now implement priorities correctly.
To allow an easy transition with good test coverage, but still maintain
stability, both implementations live side by side, selectable via a
Kconfig option. The default is the new implementation.
If this code proves to be reliable, we will later remove the current
implementation with an extra patch set.

Please have a look at the series, review it and give the code some
serious testing (and possibly debugging). All feedback is appreciated.

Cheers,
Andre.

Andre Przywara (28):
  KVM: arm/arm64: vgic: streamline vgic_update_irq_pending() interface
  KVM: arm/arm64: vgic: avoid map in kvm_vgic_inject_mapped_irq()
  KVM: arm/arm64: vgic: avoid map in kvm_vgic_map_is_active()
  KVM: arm/arm64: vgic: avoid map in kvm_vgic_unmap_phys_irq()
  KVM: arm/arm64: arch_timer: Remove irq_phys_map
  KVM: arm/arm64: vgic: Remove irq_phys_map from interface
  KVM: arm/arm64: pmu: abstract access to number of SPIs
  KVM: arm/arm64: vgic-new: Add GICv2 MMIO handling framework
  KVM: arm/arm64: vgic-new: Add ENABLE registers handlers
  KVM: arm/arm64: vgic-new: Add PENDING registers handlers
  KVM: arm/arm64: vgic-new: Add ACTIVE registers handlers
  KVM: arm/arm64: vgic-new: Add PRIORITY registers handlers
  KVM: arm/arm64: vgic-new: Add CONFIG registers handlers
  KVM: arm/arm64: vgic-new: Add TARGET registers handlers
  KVM: arm/arm64: vgic-new: Add SGIR register handler
  KVM: arm/arm64: vgic-new: Add SGIPENDR register handlers
  KVM: arm/arm64: vgic-new: Add GICv3 MMIO handling framework
  KVM: arm/arm64: vgic-new: Add GICv3 CTLR, IIDR, TYPER handlers
  KVM: arm/arm64: vgic-new: Add GICv3 redistributor IIDR and TYPER handler
  KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register handler
  KVM: arm/arm64: vgic-new: Add GICv3 IROUTER register handlers
  KVM: arm/arm64: vgic-new: Add GICv3 SGI system register trap handler
  KVM: arm/arm64: vgic-new: Add userland access to VGIC dist registers
  KVM: arm/arm64: vgic-new: Add GICH_VMCR accessors
  KVM: arm/arm64: vgic-new: Add userland GIC CPU interface access
  KVM: arm/arm64: vgic-new: Wire up irqfd injection
  KVM: arm/arm64: vgic-new: implement mapped IRQ handling
  KVM: arm/arm64: vgic-new: enable build

Christoffer Dall (9):
  KVM: arm/arm64: Remove the IRQ field from struct irq_phys_map
  KVM: arm/arm64: Get rid of vgic_cpu->nr_lr
  KVM: arm/arm64: Fix MMIO emulation data handling
  KVM: arm/arm64: Export mmio_read/write_bus
  KVM: arm/arm64: vgic-new: Add data structure definitions
  KVM: arm/arm64: vgic-new: Add acccessor to new struct vgic_irq instance
  KVM: arm/arm64: vgic-new: Implement virtual IRQ injection
  KVM: arm/arm64: vgic-new: Add IRQ sorting
  KVM: arm/arm64: vgic-new: Export register access interface

Eric Auger (12):
  KVM: arm/arm64: vgic-new: Implement kvm_vgic_vcpu_pending_irq
  KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM device ops registration
  KVM: arm/arm64: vgic-new: vgic_kvm_device:
    KVM_DEV_ARM_VGIC_GRP_NR_IRQS
  KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_CTRL
  KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_ADDR
  KVM: arm/arm64: vgic-new: vgic_kvm_device: access to VGIC registers
  KVM: arm/arm64: vgic-new: vgic_kvm_device: implement kvm_vgic_addr
  KVM: arm/arm64: vgic-new: vgic_init: implement kvm_vgic_hyp_init
  KVM: arm/arm64: vgic-new: vgic_init: implement vgic_create
  KVM: arm/arm64: vgic-new: vgic_init: implement vgic_init
  KVM: arm/arm64: vgic-new: vgic_init: implement map_resources
  KVM: arm/arm64: vgic-new: Add vgic_v2/v3_enable

Marc Zyngier (5):
  KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework
  KVM: arm/arm64: vgic-new: Add GICv2 world switch backend
  KVM: arm/arm64: vgic-new: Add GICv3 world switch backend
  KVM: arm/arm64: vgic-new: Add MMIO handling framework
  KVM: arm/arm64: vgic-new: Add CTLR, TYPER and IIDR handlers

 arch/arm/include/asm/kvm_mmio.h     |   3 +
 arch/arm/kvm/Kconfig                |   7 +
 arch/arm/kvm/Makefile               |  11 +
 arch/arm/kvm/mmio.c                 |  24 +-
 arch/arm64/include/asm/kvm_mmio.h   |   3 +
 arch/arm64/kvm/Kconfig              |   7 +
 arch/arm64/kvm/Makefile             |  12 +
 include/kvm/arm_arch_timer.h        |   3 -
 include/kvm/arm_vgic.h              |  20 +-
 include/kvm/vgic/vgic.h             | 253 +++++++++++++++
 include/linux/irqchip/arm-gic-v3.h  |   1 +
 include/linux/irqchip/arm-gic.h     |   2 +
 virt/kvm/arm/arch_timer.c           |  43 ++-
 virt/kvm/arm/hyp/vgic-v2-sr.c       |  17 +-
 virt/kvm/arm/pmu.c                  |   2 +-
 virt/kvm/arm/vgic-v2.c              |   4 +-
 virt/kvm/arm/vgic.c                 |  86 ++---
 virt/kvm/arm/vgic/vgic-init.c       | 446 +++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-irqfd.c      |  52 +++
 virt/kvm/arm/vgic/vgic-kvm-device.c | 522 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v2.c    | 312 ++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 464 ++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c       | 523 ++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h       | 128 ++++++++
 virt/kvm/arm/vgic/vgic-v2.c         | 358 ++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c         | 335 +++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c            | 631 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            | 122 +++++++
 28 files changed, 4285 insertions(+), 106 deletions(-)
 create mode 100644 include/kvm/vgic/vgic.h
 create mode 100644 virt/kvm/arm/vgic/vgic-init.c
 create mode 100644 virt/kvm/arm/vgic/vgic-irqfd.c
 create mode 100644 virt/kvm/arm/vgic/vgic-kvm-device.c
 create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v2.c
 create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v3.c
 create mode 100644 virt/kvm/arm/vgic/vgic-mmio.c
 create mode 100644 virt/kvm/arm/vgic/vgic-mmio.h
 create mode 100644 virt/kvm/arm/vgic/vgic-v2.c
 create mode 100644 virt/kvm/arm/vgic/vgic-v3.c
 create mode 100644 virt/kvm/arm/vgic/vgic.c
 create mode 100644 virt/kvm/arm/vgic/vgic.h

-- 
2.7.3

