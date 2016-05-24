From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 00/59] KVM/ARM Changes for v4.7 take 2
Date: Tue, 24 May 2016 11:08:54 +0200
Message-ID: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 511D349B49
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DuCe1FHU1TUU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:23 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8B29499A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:22 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id n129so118526519wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:09:55 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here's another set of changes for v4.7.

This set of changes include the new vgic, which is a reimplementation of
our horribly broken legacy vgic implementation.  The two implementations
will live side-by-side (with the new being the configured default) for
one kernel release and then we'll remove the legacy one.

Also fixes a non-critical issue with virtual abort injection to guests.

The following changes since commit 06485053244480f5f403d8f89b8617bd7d549113:

  kvm: arm64: Enable hardware updates of the Access Flag for Stage 2 page tables (2016-05-09 22:23:08 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4-7-take2

for you to fetch changes up to 35a2d58588f0992627e74b447ccab21570544c86:

  KVM: arm/arm64: vgic-new: Synchronize changes to active state (2016-05-20 16:26:38 +0200)


Thanks,
-Christoffer


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

Christoffer Dall (12):
      KVM: arm/arm64: Remove the IRQ field from struct irq_phys_map
      KVM: arm/arm64: Move timer IRQ map to latest possible time
      KVM: arm/arm64: Get rid of vgic_cpu->nr_lr
      KVM: arm/arm64: Fix MMIO emulation data handling
      KVM: arm/arm64: Export mmio_read/write_bus
      KVM: arm/arm64: Provide functionality to pause and resume a guest
      KVM: arm/arm64: vgic-new: Add data structure definitions
      KVM: arm/arm64: vgic-new: Add acccessor to new struct vgic_irq instance
      KVM: arm/arm64: vgic-new: Implement virtual IRQ injection
      KVM: arm/arm64: vgic-new: Add IRQ sorting
      KVM: arm/arm64: vgic-new: Export register access interface
      KVM: arm/arm64: vgic-new: Synchronize changes to active state

Eric Auger (12):
      KVM: arm/arm64: vgic-new: Implement kvm_vgic_vcpu_pending_irq
      KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM device ops registration
      KVM: arm/arm64: vgic-new: vgic_kvm_device: KVM_DEV_ARM_VGIC_GRP_NR_IRQS
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

Matt Evans (1):
      kvm: arm64: Fix EC field in inject_abt64

 arch/arm/include/asm/kvm_host.h     |   6 +
 arch/arm/include/asm/kvm_mmio.h     |   3 +
 arch/arm/kvm/Kconfig                |   7 +
 arch/arm/kvm/Makefile               |  11 +
 arch/arm/kvm/arm.c                  |  37 ++-
 arch/arm/kvm/mmio.c                 |  24 +-
 arch/arm64/include/asm/kvm_host.h   |   6 +
 arch/arm64/include/asm/kvm_mmio.h   |   3 +
 arch/arm64/kvm/Kconfig              |   7 +
 arch/arm64/kvm/Makefile             |  12 +
 arch/arm64/kvm/inject_fault.c       |   2 +-
 include/kvm/arm_arch_timer.h        |  11 +-
 include/kvm/arm_vgic.h              |  20 +-
 include/kvm/vgic/vgic.h             | 246 ++++++++++++++
 include/linux/irqchip/arm-gic-v3.h  |   6 +
 include/linux/irqchip/arm-gic.h     |   2 +
 virt/kvm/arm/arch_timer.c           |  68 ++--
 virt/kvm/arm/hyp/timer-sr.c         |   5 +-
 virt/kvm/arm/hyp/vgic-v2-sr.c       |  17 +-
 virt/kvm/arm/pmu.c                  |  25 +-
 virt/kvm/arm/vgic-v2.c              |   4 +-
 virt/kvm/arm/vgic-v3.c              |   8 +-
 virt/kvm/arm/vgic.c                 |  86 ++---
 virt/kvm/arm/vgic/vgic-init.c       | 452 ++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-irqfd.c      |  52 +++
 virt/kvm/arm/vgic/vgic-kvm-device.c | 431 +++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v2.c    | 446 ++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 455 ++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c       | 526 ++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h       | 150 +++++++++
 virt/kvm/arm/vgic/vgic-v2.c         | 352 ++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c         | 330 +++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c            | 619 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            | 131 ++++++++
 34 files changed, 4404 insertions(+), 156 deletions(-)
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
