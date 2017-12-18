From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 0/5] KVM/ARM Fixes for v4.15 - Round 2
Date: Mon, 18 Dec 2017 11:00:52 +0100
Message-ID: <20171218100057.7839-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo and Radim,

Here's another handful of fixes for KVM/ARM for v4.15.  They fix:
 - A bug in our handling of SPE state for non-vhe systems
 - A bug that causes hyp unmapping to go off limits and crash the system on
   shutdown
 - Three timer fixes that were introduced as part of the timer optimizations
   for v4.15


The following changes since commit 50c4c4e268a2d7a3e58ebb698ac74da0de40ae36:

  Linux 4.15-rc3 (2017-12-10 17:56:26 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvm-arm-fixes-for-v4.15-2

for you to fetch changes up to 0eb7c33cadf6b2f1a94e58ded8b0eb89b4eba382:

  KVM: arm/arm64: Fix timer enable flow (2017-12-18 10:53:24 +0100)


Thanks,
-Christoffer

Christoffer Dall (2):
      KVM: arm/arm64: Properly handle arch-timer IRQs after vtimer_save_state
      KVM: arm/arm64: Fix timer enable flow

Julien Thierry (1):
      arm64: kvm: Prevent restoring stale PMSCR_EL1 for vcpu

Marc Zyngier (2):
      KVM: arm/arm64: Fix HYP unmapping going off limits
      KVM: arm/arm64: timer: Don't set irq as forwarded if no usable GIC

 arch/arm64/kvm/hyp/debug-sr.c |  3 +++
 include/kvm/arm_arch_timer.h  |  2 +-
 virt/kvm/arm/arch_timer.c     | 40 ++++++++++++++++++++++++----------------
 virt/kvm/arm/arm.c            |  2 +-
 virt/kvm/arm/mmu.c            | 10 ++++------
 5 files changed, 33 insertions(+), 24 deletions(-)
