From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 00/26] KVM/ARM: Add support for GICv4
Date: Fri, 27 Oct 2017 15:28:29 +0100
Message-ID: <20171027142855.21584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00E96406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:27:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f2kaG+myppjU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 10:27:44 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52EFC406BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:27:44 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
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
is mostly the KVM-specific part. I've lifted two of Eric's patches
(having slightly changed one of them) as they form the base of this
series.

The stack has now been quite heavily bashed on a Huawei D05 box using
an Intel I350 Ethernet card and passing a VF into the guest, using
QEMU as the setup userspace (although this platform needs workarounds
that I've pushed out separately). It has also been *very lightly*
tested on an arm64 model, with a PCI virtio block device passed from
the host to a guest (using kvmtool and Jean-Philippe Brucker's
excellent VFIO support patches[2]).

I've pushed out a branch based on 4.14-rc6 containing the dependencies:

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/gicv4-kvm

* From v4:
   - Fixed bug where a newly mapped VLPI could fire without having had
     its properties setup yet. Oops.
   - Changed the error code on attempt to save an ITS using VLPIs to
     -ACCES, and documented the new error code.
   - Dropped the patch trying to prevent a mix of GICv3 and GICv4
     CPUs. This is a broken configuration, and trying to detect it
     without making a mess is hard.
   - Added the patch disabling setting the doorbell affinity from
     userspace as part of this series
   - Rebased the series on 4.14-rc6, but it should apply just the
     same on something older

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

[1] https://static.docs.arm.com/ihi0069/c/IHI0069C_gic_architecture_specification.pdf
[2] http://www.spinics.net/lists/kvm/msg151823.html

Eric Auger (2):
  KVM: arm/arm64: register irq bypass consumer on ARM/ARM64
  KVM: arm/arm64: vgic: restructure kvm_vgic_(un)map_phys_irq

Marc Zyngier (24):
  irqchip/gic-v3-its: Setup VLPI properties at map time
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
  KVM: arm/arm64: GICv4: Use pending_last as a scheduling hint
  KVM: arm/arm64: GICv4: Add doorbell interrupt handling
  KVM: arm/arm64: GICv4: Use the doorbell interrupt as an unblocking
    source
  KVM: arm/arm64: GICv4: Hook vPE scheduling into vgic flush/sync
  KVM: arm/arm64: GICv4: Enable virtual cpuif if VLPIs can be delivered
  KVM: arm/arm64: GICv4: Prevent a VM using GICv4 from being saved
  KVM: arm/arm64: GICv4: Prevent userspace from changing doorbell
    affinity
  KVM: arm/arm64: GICv4: Enable VLPI support
  KVM: arm/arm64: GICv4: Theory of operations

 Documentation/admin-guide/kernel-parameters.txt    |   4 +
 Documentation/virtual/kvm/devices/arm-vgic-its.txt |   2 +
 arch/arm/kvm/Kconfig                               |   5 +
 arch/arm/kvm/Makefile                              |   1 +
 arch/arm64/kvm/Kconfig                             |   3 +
 arch/arm64/kvm/Makefile                            |   1 +
 drivers/irqchip/irq-gic-v3-its.c                   |  19 +-
 include/kvm/arm_vgic.h                             |  41 ++-
 include/linux/irqchip/arm-gic-v4.h                 |   2 +
 virt/kvm/arm/arch_timer.c                          |  24 +-
 virt/kvm/arm/arm.c                                 |  48 ++-
 virt/kvm/arm/hyp/vgic-v3-sr.c                      |   9 +-
 virt/kvm/arm/vgic/vgic-init.c                      |   9 +
 virt/kvm/arm/vgic/vgic-its.c                       | 193 +++++++----
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   |   5 +
 virt/kvm/arm/vgic/vgic-v3.c                        |  14 +
 virt/kvm/arm/vgic/vgic-v4.c                        | 365 +++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c                           |  67 +++-
 virt/kvm/arm/vgic/vgic.h                           |  10 +
 19 files changed, 710 insertions(+), 112 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-v4.c

-- 
2.11.0
