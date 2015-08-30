From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/9] Rework architected timer and fix UEFI reset
Date: Sun, 30 Aug 2015 15:54:17 +0200
Message-ID: <1440942866-23802-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The architected timer integration with the vgic had some shortcomings in
that certain guests (one being UEFI) weren't fully supported.

In fixing this I also found that we are scheduling the hrtimer for the
virtual timer way too often, with a potential performance overhead.

This series tries to address these problems in proviging level-triggered
semantics for the arch timer and vgic intergration and seeks to clarify
the behavior when setting/clearing the active state on the physical
distributor.

Series based on kvmarm/next and also available at:
https://git.linaro.org/people/christoffer.dall/linux-kvm-arm.git timer-rework

Christoffer Dall (9):
  KVM: Add kvm_arch_vcpu_{un}blocking callbacks
  arm/arm64: KVM: arch_timer: Only schedule soft timer on vcpu_block
  arm/arm64: KVM: vgic: Factor out level irq processing on guest exit
  arm/arm64: Implement GICD_ICFGR as RO for PPIs
  arm/arm64: KVM: Use appropriate define in VGIC reset code
  arm/arm64: KVM: Add mapped interrupts documentation
  arm/arm64: KVM: vgic: Move active state handling to flush_hwstate
  arm/arm64: KVM: Rework the arch timer to use level-triggered semantics
  arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0

 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt |  59 ++++++
 arch/arm/kvm/arm.c                                 |  21 ++-
 arch/mips/include/asm/kvm_host.h                   |   2 +
 arch/powerpc/include/asm/kvm_host.h                |   2 +
 arch/s390/include/asm/kvm_host.h                   |   2 +
 arch/x86/include/asm/kvm_host.h                    |   3 +
 include/kvm/arm_arch_timer.h                       |   4 +-
 include/kvm/arm_vgic.h                             |   3 -
 include/linux/kvm_host.h                           |   2 +
 virt/kvm/arm/arch_timer.c                          | 160 +++++++++++-----
 virt/kvm/arm/vgic.c                                | 201 +++++++++++----------
 virt/kvm/kvm_main.c                                |   3 +
 12 files changed, 308 insertions(+), 154 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt

-- 
2.1.2.330.g565301e.dirty

