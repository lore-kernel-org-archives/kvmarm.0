From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 00/56] KVM: arm/arm64: Rework virtual GIC emulation
Date: Mon, 16 May 2016 10:52:48 +0100
Message-ID: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0137C48529
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:51:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JfkagOKeMTr9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:51:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D99F410B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:51:06 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

a new update for the new VGIC series.
A lot of fixes this time: comments fixed, clarified and updated, some
no longer needed code pieces from the old VGIC have been removed.
The MMIO dispatching has been improved to allow only the access types
that are mandatory in the spec, so 32-bit accesses only for most registers
with some additionally accessible by byte or 64-bit accesses as well.
This allows for some simplification in many handler functions.
The vgic_queue_irq_unlock() function was reworked a bit and is now used
by the set-active handler as well. The clear-active handler has been
extended to basically halt the guest and make sure we clear the respective
active bit in the LR (and not only in our structure). There is a new patch
introducing the KVM core bits of this feature.
Also we now detect when the redistributor and distributor regions overlap
and complain about it.
As this series is now based on kvmarm/next, we also gained the firmware
independent probing feature, which is in turn also used in this series.
This should enable ACPI machines.
A more detailed changelog can be found in the respective patches.

As this new VGIC emulation will probably become the default very shortly,
please test it full steam on whatever setup you have access to.
Any reports are warmly welcome.

This series is now based on kvmarm/next, which will be merged shortly into
Linus' kernel.
A git tree containing this series can be found on linux-arm.org:

git://linux-arm.org/linux-ap.git	branch: vgic-new/v4
http://www.linux-arm.org/git?p=linux-ap.git;a=log;h=refs/heads/vgic-new/v4

Cheers,
Andre.

===========================
This series is a joint effort to re-implement KVM's GIC emulation.
Many patches as in here have been effectively authored by multiple
people and authorship isn't clear in every case, especially since
many of the patches have been stashed together or splitted apart in
the process. So take the Author: tag with a grain of salt.

While the current VGIC implementation is centered around providing
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

Andre Przywara (29):
  KVM: arm/arm64: vgic: streamline vgic_update_irq_pending() interface
  KVM: arm/arm64: vgic: avoid map in kvm_vgic_inject_mapped_irq()
  KVM: arm/arm64: vgic: avoid map in kvm_vgic_map_is_active()
  KVM: arm/arm64: vgic: avoid map in kvm_vgic_unmap_phys_irq()
  KVM: arm/arm64: arch_timer: Remove irq_phys_map
  KVM: arm/arm64: vgic: Remove irq_phys_map from interface
  KVM: arm/arm64: pmu: abstract access to number of SPIs
  KVM: arm/arm64: move GICv2 emulation defines into arm-gic-v3.h
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
  KVM: arm/arm64: vgic-new: Add GICv3 redistributor IIDR and TYPER
    handler
  KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register handler
  KVM: arm/arm64: vgic-new: Add GICv3 IROUTER register handlers
  KVM: arm/arm64: vgic-new: Add GICv3 SGI system register trap handler
  KVM: arm/arm64: vgic-new: Add userland access to VGIC dist registers
  KVM: arm/arm64: vgic-new: Add GICH_VMCR accessors
  KVM: arm/arm64: vgic-new: Add userland GIC CPU interface access
  KVM: arm/arm64: vgic-new: Wire up irqfd injection
  KVM: arm/arm64: vgic-new: implement mapped IRQ handling
  KVM: arm/arm64: vgic-new: enable build

Christoffer Dall (10):
  KVM: arm/arm64: Remove the IRQ field from struct irq_phys_map
  KVM: arm/arm64: Get rid of vgic_cpu->nr_lr
  KVM: arm/arm64: Fix MMIO emulation data handling
  KVM: arm/arm64: Export mmio_read/write_bus
  KVM: arm/arm64: Provide functionality to pause and resume a guest
  KVM: arm/arm64: vgic-new: Add data structure definitions
  KVM: arm/arm64: vgic-new: Add acccessor to new struct vgic_irq
    instance
  KVM: arm/arm64: vgic-new: Implement virtual IRQ injection
  KVM: arm/arm64: vgic-new: Add IRQ sorting
  KVM: arm/arm64: vgic-new: Export register access interface

Eric Auger (12):
  KVM: arm/arm64: vgic-new: Implement kvm_vgic_vcpu_pending_irq
  KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM device ops registration
  KVM: arm/arm64: vgic-new: vgic_kvm_device:
    KVM_DEV_ARM_VGIC_GRP_NR_IRQS
  KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_CTRL
  KVM: arm/arm64: vgic-new: vgic_kvm_device: implement kvm_vgic_addr
  KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_ADDR
  KVM: arm/arm64: vgic-new: vgic_kvm_device: access to VGIC registers
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

 arch/arm/include/asm/kvm_host.h     |   4 +
 arch/arm/include/asm/kvm_mmio.h     |   3 +
 arch/arm/kvm/Kconfig                |   7 +
 arch/arm/kvm/Makefile               |  11 +
 arch/arm/kvm/arm.c                  |  25 +-
 arch/arm/kvm/mmio.c                 |  24 +-
 arch/arm64/include/asm/kvm_host.h   |   4 +
 arch/arm64/include/asm/kvm_mmio.h   |   3 +
 arch/arm64/kvm/Kconfig              |   7 +
 arch/arm64/kvm/Makefile             |  12 +
 include/kvm/arm_arch_timer.h        |   3 -
 include/kvm/arm_vgic.h              |  20 +-
 include/kvm/vgic/vgic.h             | 246 +++++++++++++++
 include/linux/irqchip/arm-gic-v3.h  |   6 +
 include/linux/irqchip/arm-gic.h     |   2 +
 virt/kvm/arm/arch_timer.c           |  42 ++-
 virt/kvm/arm/hyp/vgic-v2-sr.c       |  17 +-
 virt/kvm/arm/pmu.c                  |  25 +-
 virt/kvm/arm/vgic-v2.c              |   4 +-
 virt/kvm/arm/vgic-v3.c              |   8 +-
 virt/kvm/arm/vgic.c                 |  86 ++---
 virt/kvm/arm/vgic/vgic-init.c       | 452 ++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-irqfd.c      |  52 +++
 virt/kvm/arm/vgic/vgic-kvm-device.c | 426 +++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v2.c    | 446 ++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 451 ++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c       | 499 +++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h       | 138 ++++++++
 virt/kvm/arm/vgic/vgic-v2.c         | 352 +++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c         | 330 +++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c            | 615 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            | 131 ++++++++
 32 files changed, 4314 insertions(+), 137 deletions(-)
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
2.8.2
