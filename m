From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 00/10] kvmtool: arm64: GICv3 guest support
Date: Fri,  3 Jul 2015 12:26:28 +0100
Message-ID: <1435922798-14375-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

only very minor changes (patch 7 and 10) compared to v4:
Any failure in instantiating a VCPU now makes kvmtool abort, so
requesting more VCPUs than the selected kernel's VGIC emulation
can handle will let the user know immediately ;-)
Also I removed the unneeded initialization of the irqchip type
to GICv2.
Will, can you apply this series?

Cheers,
Andre.

-----
Since Linux 3.19 the kernel can emulate a GICv3 for KVM guests.
This allows more than 8 VCPUs in a guest and enables in-kernel irqchip
for non-backwards-compatible GICv3 implementations.

This series updates kvmtool to support this feature.
The first half of the series is mostly from Marc and supports some
newer features of the virtual GIC which we later depend on. The second
part enables support for a guest GICv3 by adding a new command line
parameter (--irqchip=).

We now use the KVM_CREATE_DEVICE interface to create a virtual GIC
and only fall back to the now legacy KVM_CREATE_IRQCHIP call if the
former is not supported by the kernel.
Also we use two new features the KVM_CREATE_DEVICE interface
introduces:
* We now set the number of actually used interrupts to avoid
  allocating too many of them without ever using them.
* We tell the kernel explicitly that we are finished with the GIC
  initialisation. This is a requirement for future VGIC versions.

The final three patches introduce virtual GICv3 support, so on
supported hardware (and given kernel support) the user can ask KVM to
emulate a GICv3, lifting the 8 VCPU limit of KVM. This is done by
specifying "--irqchip=gicv3" on the command line.
For the time being the kernel only supports a virtual GICv3 on ARM64,
but as the GIC is shared in kvmtool, I had to add the macro
definitions to not break the build on ARM.

This series goes on top of the new official stand-alone repo hosted
on Will's kernel.org git [1].
Find a branch with those patches included at my repo [2].

[1] git://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git
[2] git://linux-arm.org/kvmtool.git (branch gicv3/v5)
    http://www.linux-arm.org/git?p=kvmtool.git;a=log;h=refs/heads/gicv3/v5

Andre Przywara (6):
  arm: finish VGIC initialisation explicitly
  arm: simplify MMIO dispatching
  limit number of VCPUs on demand
  arm: prepare for instantiating different IRQ chip devices
  arm: add support for supplying GICv3 redistributor addresses
  arm: use new irqchip parameter to create different vGIC types

Marc Zyngier (4):
  AArch64: Reserve two 64k pages for GIC CPU interface
  AArch{32,64}: use KVM_CREATE_DEVICE & co to instanciate the GIC
  irq: add irq__get_nr_allocated_lines
  AArch{32,64}: dynamically configure the number of GIC interrupts

 arm/aarch32/arm-cpu.c                    |   2 +-
 arm/aarch64/arm-cpu.c                    |   2 +-
 arm/aarch64/include/kvm/kvm-arch.h       |   2 +-
 arm/gic.c                                | 189 +++++++++++++++++++++++++++++--
 arm/include/arm-common/gic.h             |   9 +-
 arm/include/arm-common/kvm-arch.h        |  19 ++--
 arm/include/arm-common/kvm-config-arch.h |   9 +-
 arm/include/arm-common/kvm-cpu-arch.h    |  14 ++-
 arm/kvm-cpu.c                            |  16 ---
 arm/kvm.c                                |   6 +-
 include/kvm/irq.h                        |   1 +
 irq.c                                    |   5 +
 12 files changed, 225 insertions(+), 49 deletions(-)

-- 
2.3.5

