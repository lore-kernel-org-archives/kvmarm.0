From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 00/28] KVM/ARM Changes for v4.16
Date: Wed, 31 Jan 2018 10:34:39 +0100
Message-ID: <20180131093507.22219-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B356F49DF3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jan 2018 04:29:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bg0swia4SSNo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Jan 2018 04:29:34 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BB4B49D14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jan 2018 04:29:33 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id b21so6583132wme.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jan 2018 01:35:14 -0800 (PST)
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

Apologies for getting this pull request to you rather late; there were a
number of issues that I wanted to make sure we could fix properly before
including some of the changes in this pull request.

The changes for this version include icache invalidation optimizations
(improving VM startup time), support for forwarded level-triggered
interrupts (improved performance for timers and passthrough platform
devices), a small fix for power-management notifiers, and some cosmetic
changes.

The following changes since commit 50c4c4e268a2d7a3e58ebb698ac74da0de40ae36:

  Linux 4.15-rc3 (2017-12-10 17:56:26 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-for-v4.16

for you to fetch changes up to cd15d2050c044ca9525ba165e9073ac8e036b8d0:

  KVM: arm/arm64: Fixup userspace irqchip static key optimization (2018-01-31 10:10:49 +0100)

Thanks,
-Christoffer

Andrew Jones (1):
  arm64: KVM: Hide PMU from guests when disabled

Christoffer Dall (15):
  KVM: arm/arm64: Remove redundant preemptible checks
  KVM: arm/arm64: Factor out functionality to get vgic mmio
    requester_vcpu
  KVM: arm/arm64: Don't cache the timer IRQ level
  KVM: arm/arm64: vgic: Support level-triggered mapped interrupts
  KVM: arm/arm64: Support a vgic interrupt line level sample function
  KVM: arm/arm64: Support VGIC dist pend/active changes for mapped IRQs
  KVM: arm/arm64: Provide a get_input_level for the arch timer
  KVM: arm/arm64: Avoid work when userspace iqchips are not used
  KVM: arm/arm64: Delete outdated forwarded irq documentation
  Revert "arm64: KVM: Hide PMU from guests when disabled"
  arm64: mm: Add additional parameter to uaccess_ttbr0_enable
  arm64: mm: Add additional parameter to uaccess_ttbr0_disable
  KVM: arm/arm64: Fix incorrect timer_is_pending logic
  KVM: arm/arm64: Fix userspace_irqchip_in_use counting
  KVM: arm/arm64: Fixup userspace irqchip static key optimization

James Morse (1):
  KVM: arm/arm64: Handle CPU_PM_ENTER_FAILED

Luis de Bethencourt (1):
  KVM: arm/arm64: Fix trailing semicolon

Marc Zyngier (9):
  KVM: arm/arm64: Detangle kvm_mmu.h from kvm_hyp.h
  KVM: arm/arm64: Split dcache/icache flushing
  arm64: KVM: Add invalidate_icache_range helper
  arm: KVM: Add optimized PIPT icache flushing
  arm64: KVM: PTE/PMD S2 XN bit definition
  KVM: arm/arm64: Limit icache invalidation to prefetch aborts
  KVM: arm/arm64: Only clean the dcache on translation fault
  KVM: arm/arm64: Preserve Exec permission across R/W permission faults
  KVM: arm/arm64: Drop vcpu parameter from guest cache maintenance
    operartions

Vasyl Gomonovych (1):
  KVM: arm: Use PTR_ERR_OR_ZERO()

 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 187 ---------------------
 arch/arm/include/asm/kvm_emulate.h                 |   2 +-
 arch/arm/include/asm/kvm_host.h                    |   2 +
 arch/arm/include/asm/kvm_hyp.h                     |   3 +-
 arch/arm/include/asm/kvm_mmu.h                     |  99 +++++++++--
 arch/arm/include/asm/pgtable.h                     |   4 +-
 arch/arm/kvm/hyp/switch.c                          |   1 +
 arch/arm/kvm/hyp/tlb.c                             |   1 +
 arch/arm64/include/asm/asm-uaccess.h               |  12 +-
 arch/arm64/include/asm/assembler.h                 |  21 +++
 arch/arm64/include/asm/cacheflush.h                |   7 +
 arch/arm64/include/asm/kvm_host.h                  |   2 +
 arch/arm64/include/asm/kvm_hyp.h                   |   1 -
 arch/arm64/include/asm/kvm_mmu.h                   |  36 +++-
 arch/arm64/include/asm/pgtable-hwdef.h             |   2 +
 arch/arm64/include/asm/pgtable-prot.h              |   4 +-
 arch/arm64/kvm/hyp/debug-sr.c                      |   1 +
 arch/arm64/kvm/hyp/switch.c                        |   1 +
 arch/arm64/kvm/hyp/tlb.c                           |   1 +
 arch/arm64/lib/clear_user.S                        |   2 +-
 arch/arm64/lib/copy_from_user.S                    |   2 +-
 arch/arm64/lib/copy_in_user.S                      |   2 +-
 arch/arm64/lib/copy_to_user.S                      |   2 +-
 arch/arm64/mm/cache.S                              |  36 ++--
 arch/arm64/xen/hypercall.S                         |   4 +-
 include/kvm/arm_arch_timer.h                       |   2 +
 include/kvm/arm_vgic.h                             |  13 +-
 virt/kvm/arm/arch_timer.c                          | 137 ++++++++-------
 virt/kvm/arm/arm.c                                 |  63 ++++---
 virt/kvm/arm/hyp/vgic-v2-sr.c                      |   1 +
 virt/kvm/arm/mmu.c                                 |  64 ++++++-
 virt/kvm/arm/vgic/vgic-its.c                       |   4 +-
 virt/kvm/arm/vgic/vgic-mmio.c                      | 115 ++++++++++---
 virt/kvm/arm/vgic/vgic-v2.c                        |  29 ++++
 virt/kvm/arm/vgic/vgic-v3.c                        |  29 ++++
 virt/kvm/arm/vgic/vgic.c                           |  41 ++++-
 virt/kvm/arm/vgic/vgic.h                           |   8 +
 37 files changed, 579 insertions(+), 362 deletions(-)
 delete mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt

-- 
2.14.2
