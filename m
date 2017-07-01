From: "Shanker Donthineni" <shankerd@codeaurora.org>
Subject: RE: [PATCH v2 00/52] irqchip: KVM: Add support for GICv4
Date: Sat, 1 Jul 2017 09:54:56 -0500
Message-ID: <00f401d2f27a$02d39bc0$087ad340$@codeaurora.org>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Reply-To: shankerd@codeaurora.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4814640D2B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Jul 2017 10:54:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8H7eaLDKpM+X for <kvmarm@lists.cs.columbia.edu>;
 Sat,  1 Jul 2017 10:54:55 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBC9F40D1A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  1 Jul 2017 10:54:54 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
Content-Language: en-us
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Marc Zyngier' <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: 'Thomas Gleixner' <tglx@linutronix.de>, 'Jason Cooper' <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

I've verified the basic GICv4 functionality with v2 series + Eric's IRQ
bypass patches on QDF2400 platform with a minor change in vgic-init.c
successfully.  Nice, I don't  see any deadlock or catastrophic issues
running on QCOM hardware. You can add my tested-by, I'll provide comments
after reviewing giant v2 series.

Tested-by: Shanker Donthineni <shankerd@codeaurora.org>

-----Original Message-----
From: linux-arm-kernel [mailto:linux-arm-kernel-bounces@lists.infradead.org]
On Behalf Of Marc Zyngier
Sent: Wednesday, June 28, 2017 10:03 AM
To: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>; Jason Cooper
<jason@lakedaemon.net>; Eric Auger <eric.auger@redhat.com>; Christoffer Dall
<christoffer.dall@linaro.org>; Thomas Gleixner <tglx@linutronix.de>; Shanker
Donthineni <shankerd@codeaurora.org>
Subject: [PATCH v2 00/52] irqchip: KVM: Add support for GICv4

Yes, it's been a long time coming, but I really wasn't looking forward to
picking this up again. Anyway...

This (monster of a) series implements full support for GICv4, bringing
direct injection of MSIs to KVM on arm and arm64, assuming you have the
right hardware (which is quite unlikely).

To get an idea of the design, I'd recommend you start with patch #32, which
tries to shed some light on the approach that I've taken. And before that,
please digest some of the GICv3/GICv4 architecture documentation[1] (less
than 800 pages!). Once you feel reasonably insane, you'll be in the right
mood to read the code.

The structure of the series is fairly simple. The initial 34 patches add
some generic support for GICv4, while the rest of the code plugs KVM into
it. This series relies on Eric Auger's irq-bypass series[2], which is a
prerequisite for this work.

The stack has been *very lightly* tested on an arm64 model, with a PCI
virtio block device passed from the host to a guest (using kvmtool and
Jean-Philippe Brucker's excellent VFIO support patches[3]). As it has never
seen any HW, I expect things to be subtly broken, so go forward and test if
you can, though I'm mostly interested in people reviewing the code at the
moment.

I've pushed out a branch based on 4.12-rc6 containing the dependencies (as
well as a couple of debug patches):

git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
kvm-arm64/gicv4-kvm

* From v1:
  - The bulk of the 30-something initial patches have seen countless
    bugs being fixed, and some key data structures have been subtly
    tweaked (or killed altogether). They are still quite similar to
    what I had in v1 though.
  - The whole KVM code is brand new and as I said above, only lightly
    tested.
  - Collected a bunch a R-bs from Thomas and Eric (many thanks, guys).

[1]
https://static.docs.arm.com/ihi0069/c/IHI0069C_gic_architecture_specificatio
n.pdf
[2] http://www.spinics.net/lists/kvm/msg151463.html
[3] http://www.spinics.net/lists/kvm/msg151823.html

Marc Zyngier (52):
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
  irqchip/gic-v3-its: Set implementation defined bit to enable VLPIs
  irqchip/gic-v4: Add per-VM VPE domain creation
  irqchip/gic-v4: Add VPE command interface
  irqchip/gic-v4: Add VLPI configuration interface
  irqchip/gic-v4: Add some basic documentation
  irqchip/gic-v4: Enable low-level GICv4 operations
  irqchip/gic-v3: Advertise GICv4 support to KVM
  KVM: arm/arm64: vgic: Move kvm_vgic_destroy call around
  KVM: arm/arm64: vITS: Add MSI translation helpers
  KVM: arm/arm64: GICv4: Add init and teardown of the vPE irq domain
  KVM: arm/arm64: GICv4: Wire init/teardown of per-VM support
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
  KVM: arm/arm64: GICv4: Add doorbell interrupt handling
  KVM: arm/arm64: GICv4: Hook vPE scheduling into vgic flush/sync
  KVM: arm/arm64: GICv4: Enable virtual cpuif if VLPIs can be delivered
  KVM: arm/arm64: GICv4: Use pending_last as a scheduling hint
  KVM: arm/arm64: GICv4: Enable VLPI support

 arch/arm/include/asm/arch_gicv3.h      |   33 +
 arch/arm/kvm/Makefile                  |    1 +
 arch/arm64/include/asm/arch_gicv3.h    |    6 +
 arch/arm64/kvm/Makefile                |    1 +
 drivers/irqchip/Makefile               |    2 +-
 drivers/irqchip/irq-gic-v3-its.c       | 1288
+++++++++++++++++++++++++++++---
 drivers/irqchip/irq-gic-v3.c           |   93 ++-
 drivers/irqchip/irq-gic-v4.c           |  209 ++++++
 include/kvm/arm_vgic.h                 |   19 +
 include/linux/irqchip/arm-gic-common.h |    2 +
 include/linux/irqchip/arm-gic-v3.h     |   84 +++
 include/linux/irqchip/arm-gic-v4.h     |  102 +++
 kernel/irq/manage.c                    |   14 +-
 virt/kvm/arm/arm.c                     |   31 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c          |    9 +-
 virt/kvm/arm/vgic/vgic-init.c          |   11 +-
 virt/kvm/arm/vgic/vgic-its.c           |  165 ++--
 virt/kvm/arm/vgic/vgic-v3.c            |    6 +
 virt/kvm/arm/vgic/vgic-v4.c            |  210 ++++++
 virt/kvm/arm/vgic/vgic.c               |    7 +
 virt/kvm/arm/vgic/vgic.h               |   10 +
 21 files changed, 2103 insertions(+), 200 deletions(-)  create mode 100644
drivers/irqchip/irq-gic-v4.c  create mode 100644
include/linux/irqchip/arm-gic-v4.h
 create mode 100644 virt/kvm/arm/vgic/vgic-v4.c

--
2.11.0


_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
