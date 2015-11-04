From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 00/21] KVM/ARM Changes for v4.4-rc1
Date: Wed,  4 Nov 2015 15:49:39 +0100
Message-ID: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

Here is the set of changes for v4.4.  Some of the commits listed here were
already merged as fixes for v4.3, but since they are not in kvm/next yet, they
show up here.  Let me know if you want me to handle this differently somehow.

As usual, there's a lot of churn in the vgic and timer code, and then there are
number of smaller tweaks and adjustments.  Nothing major this time around.  For
a detailed description, see below.

The following changes since commit 920552b213e3dc832a874b4e7ba29ecddbab31bc:

  KVM: disable halt_poll_ns as default for s390x (2015-09-25 10:31:30 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.4

for you to fetch changes up to 26caea7693cb99833fe4ecc544c842289d6b3f69:

  KVM: arm/arm64: Merge vgic_set_lr() and vgic_sync_lr_elrsr() (2015-11-04 15:29:49 +0100)


Thanks,
-Christoffer

----------------------------------------------------------------
KVM/ARM Changes for v4.4-rc1

Includes a number of fixes for the arch-timer, introducing proper
level-triggered semantics for the arch-timers, a series of patches to
synchronously halt a guest (prerequisite for IRQ forwarding), some tracepoint
improvements, a tweak for the EL2 panic handlers, some more VGIC cleanups
getting rid of redundant state, and finally a stylistic change that gets rid of
some ctags warnings.

Christoffer Dall (10):
  KVM: Add kvm_arch_vcpu_{un}blocking callbacks
  arm/arm64: KVM: arch_timer: Only schedule soft timer on vcpu_block
  arm/arm64: KVM: vgic: Factor out level irq processing on guest exit
  arm/arm64: KVM: Implement GICD_ICFGR as RO for PPIs
  arm/arm64: KVM: Use appropriate define in VGIC reset code
  arm/arm64: KVM: Add forwarded physical interrupts documentation
  arm/arm64: KVM: Rework the arch timer to use level-triggered semantics
  arm/arm64: KVM: Support edge-triggered forwarded interrupts
  arm/arm64: KVM: Improve kvm_exit tracepoint
  arm/arm64: KVM: Add tracepoints for vgic and timer

Eric Auger (4):
  KVM: arm/arm64: rename pause into power_off
  KVM: arm/arm64: check power_off in kvm_arch_vcpu_runnable
  KVM: arm/arm64: check power_off in critical section before VCPU run
  KVM: arm/arm64: implement kvm_arm_[halt,resume]_guest

Mark Rutland (1):
  arm64: kvm: restore EL1N SP for panic

Michal Marek (1):
  KVM: arm: Do not indent the arguments of DECLARE_BITMAP

Pavel Fedin (4):
  KVM: arm/arm64: Fix vGIC documentation
  KVM: arm/arm64: Optimize away redundant LR tracking
  KVM: arm/arm64: Clean up vgic_retire_lr() and surroundings
  KVM: arm/arm64: Merge vgic_set_lr() and vgic_sync_lr_elrsr()

Wei Huang (1):
  arm/arm64: KVM : Enable vhost device selection under KVM config menu

 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt | 187 +++++++++++++
 Documentation/virtual/kvm/devices/arm-vgic.txt     |  18 +-
 arch/arm/include/asm/kvm_arm.h                     |  20 ++
 arch/arm/include/asm/kvm_host.h                    |   5 +-
 arch/arm/kvm/Kconfig                               |   2 +
 arch/arm/kvm/arm.c                                 |  76 +++--
 arch/arm/kvm/psci.c                                |  10 +-
 arch/arm/kvm/trace.h                               |  10 +-
 arch/arm64/include/asm/kvm_arm.h                   |  16 ++
 arch/arm64/include/asm/kvm_host.h                  |   5 +-
 arch/arm64/kvm/Kconfig                             |   2 +
 arch/arm64/kvm/hyp.S                               |   8 +
 arch/mips/include/asm/kvm_host.h                   |   2 +
 arch/powerpc/include/asm/kvm_host.h                |   2 +
 arch/s390/include/asm/kvm_host.h                   |   2 +
 arch/x86/include/asm/kvm_host.h                    |   3 +
 include/kvm/arm_arch_timer.h                       |   4 +-
 include/kvm/arm_vgic.h                             |  16 +-
 include/linux/kvm_host.h                           |   2 +
 virt/kvm/arm/arch_timer.c                          | 173 ++++++++----
 virt/kvm/arm/trace.h                               |  63 +++++
 virt/kvm/arm/vgic-v2.c                             |   6 +-
 virt/kvm/arm/vgic-v3.c                             |   6 +-
 virt/kvm/arm/vgic.c                                | 308 ++++++++-------------
 virt/kvm/kvm_main.c                                |   3 +
 25 files changed, 646 insertions(+), 303 deletions(-)
 create mode 100644 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt
 create mode 100644 virt/kvm/arm/trace.h

-- 
2.1.2.330.g565301e.dirty

