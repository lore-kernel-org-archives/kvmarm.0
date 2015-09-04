From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 0/8] Rework architected timer and forwarded IRQs handling
Date: Fri,  4 Sep 2015 21:40:42 +0200
Message-ID: <1441395650-19663-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The architected timer integration with the VGIC had some shortcomings in
that certain guest operations weren't fully supported.

This series tries to address these problems in providing level-triggered
semantics for the arch timer and VGIC integration and seeks to clarify
the behavior when setting/clearing the active state on the physical
distributor.

It also fixes a few other bugs in the VGIC code and finally adds support
for edge-triggered forwarded interrupts.

The edge-triggered forwarded interrupts code is untested but probably
better to clearly do something wrong and raise a warning.

Changes since v1:
 - Sent out bug fixes for active state and UEFI reset as separate
   patches.
 - Fixed various spelling nits
 - Rewrote proposed documentation file trying to address Eric's and
   Marc's comments
 - Rewrote kvm_timer_update_irq and kvm_timer_update_state according to
   Marc's suggestion (thanks!)
 - Added additional patch to support edge-triggered forwarded
   interrupts.

Christoffer Dall (8):
  KVM: Add kvm_arch_vcpu_{un}blocking callbacks
  arm/arm64: KVM: arch_timer: Only schedule soft timer on vcpu_block
  arm/arm64: KVM: vgic: Factor out level irq processing on guest exit
  arm/arm64: KVM: Implement GICD_ICFGR as RO for PPIs
  arm/arm64: KVM: Use appropriate define in VGIC reset code
  arm/arm64: KVM: Add forwarded physical interrupts documentation
  arm/arm64: KVM: Rework the arch timer to use level-triggered semantics
  arm/arm64: KVM: Support edge-triggered forwarded interrupts

 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 181 +++++++++++++++++++++
 arch/arm/kvm/arm.c                                 |  21 ++-
 arch/mips/include/asm/kvm_host.h                   |   2 +
 arch/powerpc/include/asm/kvm_host.h                |   2 +
 arch/s390/include/asm/kvm_host.h                   |   2 +
 arch/x86/include/asm/kvm_host.h                    |   3 +
 include/kvm/arm_arch_timer.h                       |   4 +-
 include/kvm/arm_vgic.h                             |   3 -
 include/linux/kvm_host.h                           |   2 +
 virt/kvm/arm/arch_timer.c                          | 150 +++++++++++------
 virt/kvm/arm/vgic.c                                | 163 +++++++++----------
 virt/kvm/kvm_main.c                                |   3 +
 12 files changed, 398 insertions(+), 138 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt

-- 
2.1.2.330.g565301e.dirty

