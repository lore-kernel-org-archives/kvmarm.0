From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 00/59] irqchip: KVM: Add support for GICv4
Date: Mon, 31 Jul 2017 18:25:38 +0100
Message-ID: <20170731172637.29355-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

This (monster of a) series implements full support for GICv4, bringing
direct injection of MSIs to KVM on arm and arm64, assuming you have
the right hardware (which is quite unlikely).

To get an idea of the design, I'd recommend you start with patches #33
and #57, which try to shed some light on the approach that I've
taken. And before that, please digest some of the GICv3/GICv4
architecture documentation[1] (less than 800 pages!). Once you feel
reasonably insane, you'll be in the right mood to read the code.

The structure of the series is fairly simple. The initial 35 patches
add some generic support for GICv4, while the rest of the code plugs
KVM into it. This series relies on Eric Auger's irq-bypass series[2],
which is a prerequisite for this work, as well as a KVM fix by
Shanker. The last two patches add a quirk for the Huawei D05 box on
which I tested this code, and which is added here for completeness and
for people to test.

The stack has been *very lightly* tested on an arm64 model, with a PCI
virtio block device passed from the host to a guest (using kvmtool and
Jean-Philippe Brucker's excellent VFIO support patches[3]), as well as
the Huawei D05 box I mentionend above using an Intel I350 Ethernet
card and passing a VF into the guest. I expect things to be (not so)
subtly broken, so go forward and test if you can, though I'm mostly
interested in people reviewing the code at the moment.

I've pushed out a branch based on 4.13-rc3 containing the dependencies:

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/gicv4-kvm

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

Marc Zyngier (59):
  genirq: Let irq_set_vcpu_affinity() iterate over hierarchy
  irqchip/gic-v3: Add redistributor iterator
  irqchip/gic-v3: Add VLPI/DirectLPI discovery
  irqchip/gic-v3-its: Move LPI definitions around
  irqchip/gic-v3-its: Add probing for VLPI properties
  irqchip/gic-v3-its: Macro-ize its_send_single_command
  irqchip/gic-v3-its: Implement irq_set_irqchip_state for pending state
  irqchip/gic-v3-its: Split out property table allocation
  irqchip/gic-v3-its: Allow use of indirect VCPU tables
  irqchip/gic-v3-its: Split out pending table allocation
  irqchip/gic-v3-its: Rework LPI freeing
  irqchip/gic-v3-its: Generalize device table allocation
  irqchip/gic-v3-its: Generalize LPI configuration
  irqchip/gic-v4: Add management structure definitions
  irqchip/gic-v3-its: Add GICv4 ITS command definitions
  irqchip/gic-v3-its: Add VLPI configuration hook
  irqchip/gic-v3-its: Add VLPI map/unmap operations
  irqchip/gic-v3-its: Add VLPI configuration handling
  irqchip/gic-v3-its: Add VPE domain infrastructure
  irqchip/gic-v3-its: Add VPE irq domain allocation/teardown
  irqchip/gic-v3-its: Add VPE irq domain [de]activation
  irqchip/gic-v3-its: Add VPENDBASER/VPROPBASER accessors
  irqchip/gic-v3-its: Add VPE scheduling
  irqchip/gic-v3-its: Add VPE invalidation hook
  irqchip/gic-v3-its: Add VPE affinity changes
  irqchip/gic-v3-its: Add VPE interrupt masking
  irqchip/gic-v3-its: Support VPE doorbell invalidation even when
    !DirectLPI
  irqchip/gic-v3-its: Allow doorbell interrupts to be injected/cleared
  irqchip/gic-v3-its: Set implementation defined bit to enable VLPIs
  irqchip/gic-v4: Add per-VM VPE domain creation
  irqchip/gic-v4: Add VPE command interface
  irqchip/gic-v4: Add VLPI configuration interface
  irqchip/gic-v4: Add some basic documentation
  irqchip/gic-v4: Enable low-level GICv4 operations
  irqchip/gic-v3: Advertise GICv4 support to KVM
  KVM: arm: Select ARM_GIC_V3 and ARM_GIC_V3_ITS
  KVM: arm/arm64: vgic: Move kvm_vgic_destroy call around
  KVM: arm/arm64: vITS: Add MSI translation helpers
  KVM: arm/arm64: GICv4: Add property field and per-VM predicate
  KVM: arm/arm64: GICv4: Add init/teardown of the per-VM vPE irq domain
  KVM: arm/arm64: GICv4: Wire mapping/unmapping of VLPIs in VFIO irq
    bypass
  KVM: arm/arm64: GICv4: Handle INT command applied to a VLPI
  KVM: arm/arm64: GICv4: Unmap VLPI when freeing an LPI
  KVM: arm/arm64: GICv4: Handle MOVI applied to a VLPI
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
  KVM: arm/arm64: GICv4: Enable VLPI support
  KVM: arm/arm64: GICv4: Prevent heterogenous systems from using GICv4
  KVM: arm/arm64: GICv4: Theory of operations
  irqchip/gic-v3-its: Pass its_node pointer to each command bulder
  irqchip/gic-v3-its: Workaround Huawei D05 redistributor addressing

 Documentation/admin-guide/kernel-parameters.txt |    4 +
 arch/arm/include/asm/arch_gicv3.h               |   33 +
 arch/arm/kvm/Kconfig                            |    2 +
 arch/arm/kvm/Makefile                           |    1 +
 arch/arm64/include/asm/arch_gicv3.h             |    6 +
 arch/arm64/kvm/Makefile                         |    1 +
 drivers/irqchip/Makefile                        |    2 +-
 drivers/irqchip/irq-gic-v3-its.c                | 1421 +++++++++++++++++++++--
 drivers/irqchip/irq-gic-v3.c                    |   95 +-
 drivers/irqchip/irq-gic-v4.c                    |  224 ++++
 include/kvm/arm_vgic.h                          |   22 +
 include/linux/irqchip/arm-gic-common.h          |    2 +
 include/linux/irqchip/arm-gic-v3.h              |   86 ++
 include/linux/irqchip/arm-gic-v4.h              |  103 ++
 kernel/irq/manage.c                             |   14 +-
 virt/kvm/arm/arm.c                              |   33 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c                   |    9 +-
 virt/kvm/arm/vgic/vgic-init.c                   |    9 +
 virt/kvm/arm/vgic/vgic-its.c                    |  173 ++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                |    5 +
 virt/kvm/arm/vgic/vgic-v3.c                     |   34 +
 virt/kvm/arm/vgic/vgic-v4.c                     |  335 ++++++
 virt/kvm/arm/vgic/vgic.c                        |    7 +
 virt/kvm/arm/vgic/vgic.h                        |   11 +
 24 files changed, 2419 insertions(+), 213 deletions(-)
 create mode 100644 drivers/irqchip/irq-gic-v4.c
 create mode 100644 include/linux/irqchip/arm-gic-v4.h
 create mode 100644 virt/kvm/arm/vgic/vgic-v4.c

-- 
2.11.0
