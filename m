From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 00/26] KVM/ARM Changes for v4.15
Date: Tue,  7 Nov 2017 11:47:33 +0100
Message-ID: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64AC749D21
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nFSzO0xLf2F6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 05:46:16 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 282F549D14
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:16 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id r196so2841144wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Nov 2017 02:48:10 -0800 (PST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here is the first round of KVM/ARM Changes for v4.15.  I will follow up
with a second pull request based on tip:irq/core containing the KVM/ARM
side of the GICv4 support.

Changes in this pull requestinclude:
 - Optimized arch timer handling for KVM/ARM
 - Improvements to the VGIC ITS code and introduction of an ITS reset
   ioctl
 - Unification of the 32-bit fault injection logic
 - More exact external abort matching logic

The following changes since commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f:

  Linux 4.14-rc4 (2017-10-08 20:53:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-v4.15

for you to fetch changes up to a2b83133339067c1b27f902e32506ab2871e2320:

  KVM: arm/arm64: fix the incompatible matching for external abort (2017-11-06 16:23:20 +0100)

Thanks,
Christoffer


Christoffer Dall (19):
  arm64: Implement arch_counter_get_cntpct to read the physical counter
  arm64: Use physical counter for in-kernel reads when booted in EL2
  KVM: arm/arm64: Guard kvm_vgic_map_is_active against !vgic_initialized
  KVM: arm/arm64: Support calling vgic_update_irq_pending from irq
    context
  KVM: arm/arm64: Check that system supports split eoi/deactivate
  KVM: arm/arm64: Make timer_arm and timer_disarm helpers more generic
  KVM: arm/arm64: Rename soft timer to bg_timer
  KVM: arm/arm64: Move timer/vgic flush/sync under disabled irq
  KVM: arm/arm64: Use separate timer for phys timer emulation
  KVM: arm/arm64: Move timer save/restore out of the hyp code
  KVM: arm/arm64: Set VCPU affinity for virt timer irq
  KVM: arm/arm64: Avoid timer save/restore in vcpu entry/exit
  KVM: arm/arm64: Support EL1 phys timer register access in set/get reg
  KVM: arm/arm64: Use kvm_arm_timer_set/get_reg for guest register traps
  KVM: arm/arm64: Move phys_timer_emulate function
  KVM: arm/arm64: Avoid phys timer emulation in vcpu entry/exit
  KVM: arm/arm64: Get rid of kvm_timer_flush_hwstate
  KVM: arm/arm64: Rework kvm_timer_should_fire
  arm/arm64: KVM: Load the timer state when enabling the timer

Dongjiu Geng (1):
  KVM: arm/arm64: fix the incompatible matching for external abort

Eric Auger (4):
  KVM: arm/arm64: vgic-its: Remove kvm_its_unmap_device
  KVM: arm/arm64: vgic-its: Free caches when GITS_BASER Valid bit is
    cleared
  KVM: arm/arm64: Document KVM_DEV_ARM_ITS_CTRL_RESET
  KVM: arm/arm64: vgic-its: Implement KVM_DEV_ARM_ITS_CTRL_RESET

Marc Zyngier (1):
  KVM: arm/arm64: Unify 32bit fault injection

wanghaibin (1):
  KVM: arm/arm64: vgic-its: New helper functions to free the caches

 Documentation/virtual/kvm/devices/arm-vgic-its.txt |  20 +
 arch/arm/include/asm/kvm_asm.h                     |   2 +
 arch/arm/include/asm/kvm_emulate.h                 |  38 +-
 arch/arm/include/asm/kvm_hyp.h                     |   4 +-
 arch/arm/include/uapi/asm/kvm.h                    |   7 +
 arch/arm/kvm/emulate.c                             | 139 -------
 arch/arm/kvm/hyp/switch.c                          |   7 +-
 arch/arm64/include/asm/arch_timer.h                |   8 +-
 arch/arm64/include/asm/kvm_asm.h                   |   2 +
 arch/arm64/include/asm/kvm_emulate.h               |   5 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   4 +-
 arch/arm64/include/asm/timex.h                     |   2 +-
 arch/arm64/include/uapi/asm/kvm.h                  |   7 +
 arch/arm64/kvm/hyp/switch.c                        |   6 +-
 arch/arm64/kvm/inject_fault.c                      |  74 +---
 arch/arm64/kvm/sys_regs.c                          |  41 +-
 drivers/clocksource/arm_arch_timer.c               |  35 +-
 drivers/irqchip/irq-gic-v3.c                       |   8 +-
 drivers/irqchip/irq-gic.c                          |   6 +-
 include/kvm/arm_arch_timer.h                       |  26 +-
 virt/kvm/arm/aarch32.c                             |  97 ++++-
 virt/kvm/arm/arch_timer.c                          | 452 ++++++++++++++-------
 virt/kvm/arm/arm.c                                 |  45 +-
 virt/kvm/arm/hyp/timer-sr.c                        |  74 ++--
 virt/kvm/arm/vgic/vgic-its.c                       | 199 ++++-----
 virt/kvm/arm/vgic/vgic-mmio-v2.c                   |  22 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                   |  17 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      |  44 +-
 virt/kvm/arm/vgic/vgic-v2.c                        |   5 +-
 virt/kvm/arm/vgic/vgic-v3.c                        |  12 +-
 virt/kvm/arm/vgic/vgic.c                           |  62 +--
 virt/kvm/arm/vgic/vgic.h                           |   3 +-
 32 files changed, 838 insertions(+), 635 deletions(-)

-- 
2.14.2
