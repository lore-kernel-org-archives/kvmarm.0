From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 00/26] KVM/ARM: Add support for GICv4
Date: Fri,  6 Oct 2017 16:33:35 +0100
Message-ID: <20171006153401.5481-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This series implements full support for GICv4 in KVM, bringing direct
injection of MSIs to arm and arm64, assuming you have the right
hardware (which is quite unlikely).

To get an idea of the design, I'd recommend you start with commit
7954907bedaf as well as patch #26, which try to shed some light on the
approach that I've taken. And before that, please digest some of the
GICv3/GICv4 architecture documentation[1] (less than 800 pages!). Once
you feel reasonably insane, you'll be in the right mood to read the
code (no, I didn't bother changing the above, I already hit LWN/QotW
once).

Now that the low-level irqchip code has been merged, what we have here
is only the KVM-specific part. I've lifted two of Eric's patches
(having slightly changed one of them) as they form the base of this
series.

The stack has been *very lightly* tested on an arm64 model, with a PCI
virtio block device passed from the host to a guest (using kvmtool and
Jean-Philippe Brucker's excellent VFIO support patches[3]), as well as
on a Huawei D05 box using an Intel I350 Ethernet card and passing a VF
into the guest. So far, things are solid enough (although some HW need
workarounds that I'll address separately).

I've pushed out a branch based on 4.14-rc3 containing the dependencies:

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/gicv4-kvm

* From v3:
   - Lots of cleanups following Christoffer's review
   - Got rid of all of the irqchip code (well, merged it)
   - Picked the minimal set of patches from Eric to get this working
   - Prevent VM save if using GICv4
   - Rebased on top of 4.14-rc3

* From v2:
  - Lots of fixes all over the map (the doorbell code was amazingly
    wrong, both at the GICv4 level and in KVM)
  - KVM GICv4 enablement is now gated by a command-line option and
    defaults to off
  - Now properly deals with ordering of vITS creation
  - Some debugging features
  - More documentation so that I can forget what this is all about
  - Huawei D05 quirks

* From v1:
  - The bulk of the 30-something initial patches have seen countless
    bugs being fixed, and some key data structures have been subtly
    tweaked (or killed altogether). They are still quite similar to
    what I had in v1 though.
  - The whole KVM code is brand new and as I said above, only lightly
    tested.
  - Collected a bunch a R-bs from Thomas and Eric (many thanks, guys).

[1] https://static.docs.arm.com/ihi0069/c/IHI0069C_gic_architecture_specification.pfd
[2] http://www.spinics.net/lists/kvm/msg151463.html
[3] http://www.spinics.net/lists/kvm/msg151823.html

Eric Auger (2):
  KVM: arm/arm64: register irq bypass consumer on ARM/ARM64
  KVM: arm/arm64: vgic: restructure kvm_vgic_(un)map_phys_irq

Marc Zyngier (24):
  KVM: arm: Select ARM_GIC_V3 and ARM_GIC_V3_ITS
  KVM: arm/arm64: vgic: Move kvm_vgic_destroy call around
  KVM: arm/arm64: vITS: Add MSI translation helpers
  KVM: arm/arm64: vITS: Add a helper to update the affinity of an LPI
  KVM: arm/arm64: GICv4: Add property field and per-VM predicate
  KVM: arm/arm64: GICv4: Add init/teardown of the per-VM vPE irq domain
  KVM: arm/arm64: GICv4: Wire mapping/unmapping of VLPIs in VFIO irq
    bypass
  KVM: arm/arm64: GICv4: Handle INT command applied to a VLPI
  KVM: arm/arm64: GICv4: Unmap VLPI when freeing an LPI
  KVM: arm/arm64: GICv4: Propagate affinity changes to the physical ITS
  KVM: arm/arm64: GICv4: Handle CLEAR applied to a VLPI
  KVM: arm/arm64: GICv4: Handle MOVALL applied to a vPE
  KVM: arm/arm64: GICv4: Propagate property updates to VLPIs
  KVM: arm/arm64: GICv4: Handle INVALL applied to a vPE
  KVM: arm/arm64: GICv4: Propagate VLPI properties at map time
  KVM: arm/arm64: GICv4: Use pending_last as a scheduling hint
  KVM: arm/arm64: GICv4: Add doorbell interrupt handling
  KVM: arm/arm64: GICv4: Use the doorbell interrupt as an unblocking
    source
  KVM: arm/arm64: GICv4: Hook vPE scheduling into vgic flush/sync
  KVM: arm/arm64: GICv4: Enable virtual cpuif if VLPIs can be delivered
  KVM: arm/arm64: GICv4: Prevent a VM using GICv4 from being saved
  KVM: arm/arm64: GICv4: Enable VLPI support
  KVM: arm/arm64: GICv4: Prevent heterogenous systems from using GICv4
  KVM: arm/arm64: GICv4: Theory of operations

 Documentation/admin-guide/kernel-parameters.txt |   4 +
 arch/arm/kvm/Kconfig                            |   5 +
 arch/arm/kvm/Makefile                           |   1 +
 arch/arm64/kvm/Kconfig                          |   3 +
 arch/arm64/kvm/Makefile                         |   1 +
 include/kvm/arm_vgic.h                          |  41 ++-
 include/linux/irqchip/arm-gic-v3.h              |   2 +
 virt/kvm/arm/arch_timer.c                       |  24 +-
 virt/kvm/arm/arm.c                              |  48 +++-
 virt/kvm/arm/hyp/vgic-v3-sr.c                   |   9 +-
 virt/kvm/arm/vgic/vgic-init.c                   |   9 +
 virt/kvm/arm/vgic/vgic-its.c                    | 195 ++++++++-----
 virt/kvm/arm/vgic/vgic-mmio-v3.c                |   5 +
 virt/kvm/arm/vgic/vgic-v3.c                     |  39 ++-
 virt/kvm/arm/vgic/vgic-v4.c                     | 361 ++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c                        |  67 ++++-
 virt/kvm/arm/vgic/vgic.h                        |  12 +
 17 files changed, 713 insertions(+), 113 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-v4.c

-- 
2.14.1
