From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/ARM fixes for 4.3-rc2
Date: Sun, 13 Sep 2015 11:56:34 +0100
Message-ID: <1442141798-19191-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Spyridakis <a.spyridakis@virtualopensystems.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

This is the KVM/ARM pull request for Linux 4.3-rc2. Not much so far,
just a small set of fixes.

Thanks!

        M.

The following changes since commit 054167b3d55127feb64978eddf3f9f3a84fe493b:

  arm: KVM: keep arm vfp/simd exit handling consistent with arm64 (2015-08-19 22:27:58 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.3-rc2

for you to fetch changes up to 0c0672922dcc70ffba11d96385e98e42fb3ae08d:

  arm/arm64: KVM: Fix PSCI affinity info return value for non valid cores (2015-09-04 17:02:48 +0100)

----------------------------------------------------------------
KVM/ARM changes for 4.3-rc2

- Fix timer interrupt injection after the rework
  that went in during the merge window
- Reset the timer to zero on reboot
- Make sure the TCR_EL2 RES1 bits are really set to 1
- Fix a PSCI affinity bug for non-existing vcpus

----------------------------------------------------------------
Alexander Spyridakis (1):
      arm/arm64: KVM: Fix PSCI affinity info return value for non valid cores

Christoffer Dall (2):
      arm/arm64: KVM: vgic: Move active state handling to flush_hwstate
      arm/arm64: KVM: arch timer: Reset CNTV_CTL to 0

Mark Rutland (1):
      arm64: KVM: set {v,}TCR_EL2 RES1 bits

 arch/arm/kvm/psci.c              | 12 ++++++++----
 arch/arm64/include/asm/kvm_arm.h | 10 +++++++---
 virt/kvm/arm/arch_timer.c        |  8 ++++++++
 virt/kvm/arm/vgic.c              | 42 +++++++++++++++++++++++++---------------
 4 files changed, 49 insertions(+), 23 deletions(-)
