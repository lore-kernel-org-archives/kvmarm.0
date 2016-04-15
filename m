From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Fri, 15 Apr 2016 18:11:11 +0100
Message-ID: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

this is a rework of the new VGIC series.
Many thanks to all reviewers, especially Christoffer.
Major changes include a dependency on a new, separate arch_timer rework
series [1], a total rework of the MMIO dispatching, which now uses much
less kvm_io_bus devices, the proper handling of enabling and disabling
the distributor and the much more elaborate handling of activating an
IRQ via the MMIO interface.
Also the patches have been rearranged a bit in the world switch area
and for the GICv3 MMIO handling to be more logical and avoid stub
functions that get populated only later.

Minor changes are:
- removal of vgic_cpu->nr_lr in favour of kvm_vgic_global_state
- refinements in the virtual IRQ queueing function
- introduction of a separate vgic_clear_lr() function
- the removal of the vgic_v[23]_irq_change_affinity functions
- caring about SGI injection on SGIPENDR writes
- removing locks for atomic reads in the MMIO handlers
- removal of ITS stub functions
- introducing vgic_irq_is_sgi()
- many comment fixes

The simple arch_timer rework in the RFC series has been replaced with
a separate rework series [1]. Also there is new preparatory patch from
Christoffer which gets rid of reading the number of LRs from the
vgic_cpu structure. The MMIO data write back fix has also been replaced
with a more sophisticated version.

I refrained from merging vgic_v[23]_populate_lr() and
vgic_v[23]_process_maintenance(), respectively. Having taken a closer
look it does not appear worthwhile to me to unify the implementations.

Topics which I couldn't manage to address due to timing restraints are:
- proper PHYS_CPUID masking when populating GICv2 LRs
- proper handling of priorites on injection, also filtering(?)
- proper endianess handling in the MMIO framework (not in the VGIC)
- handling corner cases when clearing the active state via MMIO
- cleanup of register region description with new MMIO framework

This series is now based on v4.6-rc3 plus the arch_timer rework[1].

A git tree containing this series and the prerequisites can be found on
linux-arm.org:

git://linux-arm.org/linux-ap.git	branch: vgic-new/v1
http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/vgic-new/v1

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

The new implementation is build around a struct vgic_irq data data
structure, which holds all information about a virtual interrupt.
Interruts which should be injected are hold in a per-VCPU list, this
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

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-April/422580.html

Andre Przywara (24):
  KVM: arm/arm64: pmu: abstract access to number of SPIs
  KVM: arm/arm64: vgic-new: Add MMIO handling framework
  KVM: arm/arm64: vgic-new: Export register access interface
  KVM: arm/arm64: vgic-new: Add CTLR, TYPER and IIDR handlers
  KVM: arm/arm64: vgic-new: Add ENABLE registers handlers
  KVM: arm/arm64: vgic-new: Add PENDING registers handlers
  KVM: arm/arm64: vgic-new: Add PRIORITY registers handlers
  KVM: arm/arm64: vgic-new: Add ACTIVE registers handlers
  KVM: arm/arm64: vgic-new: Add CONFIG registers handlers
  KVM: arm/arm64: vgic-new: Add TARGET registers handlers
  KVM: arm/arm64: vgic-new: Add SGIR register handler
  KVM: arm/arm64: vgic-new: Add SGIPENDR register handlers
  KVM: arm/arm64: vgic-new: Add GICv3 MMIO handling framework
  KVM: arm/arm64: vgic-new: Add GICv3 CTLR, IIDR, TYPER handlers
  KVM: arm/arm64: vgic-new: Add GICv3 redistributor IIDR, TYPER handlers
  KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register handler
  KVM: arm/arm64: vgic-new: Add GICv3 IROUTER register handlers
  KVM: arm/arm64: vgic-new: Add GICv3 SGI system register trap handler
  KVM: arm/arm64: vgic-new: Add userland access to VGIC dist registers
  KVM: arm/arm64: vgic-new: Add GICH_VMCR accessors
  KVM: arm/arm64: vgic-new: Add userland GIC CPU interface access
  KVM: arm/arm64: vgic-new: Wire up irqfd injection
  KVM: arm/arm64: vgic-new: implement mapped IRQ handling
  KVM: arm/arm64: vgic-new: enable build

Christoffer Dall (6):
  KVM: arm/arm64: Get rid of vgic_cpu->nr_lr
  KVM: arm/arm64: Fix MMIO emulation data handling
  KVM: arm/arm64: vgic-new: Add data structure definitions
  KVM: arm/arm64: vgic-new: Add acccessor to new struct vgic_irq
    instance
  KVM: arm/arm64: vgic-new: Implement virtual IRQ injection
  KVM: arm/arm64: vgic-new: Add IRQ sorting

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

Marc Zyngier (3):
  KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework
  KVM: arm/arm64: vgic-new: Add GICv2 world switch backend
  KVM: arm/arm64: vgic-new: Add GICv3 world switch backend

 arch/arm/kvm/Kconfig                |    7 +
 arch/arm/kvm/Makefile               |   10 +
 arch/arm/kvm/mmio.c                 |   14 +-
 arch/arm64/kvm/Kconfig              |    7 +
 arch/arm64/kvm/Makefile             |   10 +
 include/kvm/arm_vgic.h              |   10 +-
 include/kvm/vgic/vgic.h             |  250 +++++++
 virt/kvm/arm/hyp/vgic-v2-sr.c       |   17 +-
 virt/kvm/arm/pmu.c                  |    2 +-
 virt/kvm/arm/vgic-v2.c              |    4 +-
 virt/kvm/arm/vgic.c                 |   19 +-
 virt/kvm/arm/vgic/vgic-v2.c         |  355 +++++++++
 virt/kvm/arm/vgic/vgic-v3.c         |  333 +++++++++
 virt/kvm/arm/vgic/vgic.c            |  617 +++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |  138 ++++
 virt/kvm/arm/vgic/vgic_init.c       |  446 +++++++++++
 virt/kvm/arm/vgic/vgic_irqfd.c      |   51 ++
 virt/kvm/arm/vgic/vgic_kvm_device.c |  522 +++++++++++++
 virt/kvm/arm/vgic/vgic_mmio.c       | 1411 +++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic_mmio.h       |   53 ++
 20 files changed, 4242 insertions(+), 34 deletions(-)
 create mode 100644 include/kvm/vgic/vgic.h
 create mode 100644 virt/kvm/arm/vgic/vgic-v2.c
 create mode 100644 virt/kvm/arm/vgic/vgic-v3.c
 create mode 100644 virt/kvm/arm/vgic/vgic.c
 create mode 100644 virt/kvm/arm/vgic/vgic.h
 create mode 100644 virt/kvm/arm/vgic/vgic_init.c
 create mode 100644 virt/kvm/arm/vgic/vgic_irqfd.c
 create mode 100644 virt/kvm/arm/vgic/vgic_kvm_device.c
 create mode 100644 virt/kvm/arm/vgic/vgic_mmio.c
 create mode 100644 virt/kvm/arm/vgic/vgic_mmio.h

-- 
2.7.3

