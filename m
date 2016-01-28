From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/ARM updates for 4.5-rc2
Date: Thu, 28 Jan 2016 10:30:33 +0000
Message-ID: <1453977038-13516-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

Please find below the KVM/ARM updates for 4.5-rc2. Mostly fixes as a
result of Shannon's work on PMU emulation, which has outlined a few
nits here and there, plus a correctness fix from Dave.

Please pull!

Thanks,

	M.

The following changes since commit 92e963f50fc74041b5e9e744c330dca48e04f08d:

  Linux 4.5-rc1 (2016-01-24 13:06:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.5-rc2

for you to fetch changes up to 6327f35a2010c06a3bc2bfb14202a38764fb9920:

  arm64: KVM: Fix guest dead loop when register accessor returns false (2016-01-24 21:56:01 +0000)

----------------------------------------------------------------
KVM/ARM fixes for v4.5-rc2

A few random fixes, mostly coming from the PMU work by Shannon:

- fix for injecting faults coming from the guest's userspace
- cleanup for our CPTR_EL2 accessors (reserved bits)
- fix for a bug impacting perf (user/kernel discrimination)
- fix for a 32bit sysreg handling bug

----------------------------------------------------------------
Dave Martin (1):
      arm64: KVM: Obey RES0/1 reserved bits when setting CPTR_EL2

Marc Zyngier (1):
      arm64: KVM: Fix AArch64 guest userspace exception injection

Shannon Zhao (3):
      arm64: KVM: Fix wrong use of the CPSR MODE mask for 32bit guests
      arm64: KVM: Fix comments of the CP handler
      arm64: KVM: Fix guest dead loop when register accessor returns false

 arch/arm64/include/asm/kvm_arm.h     |  1 +
 arch/arm64/include/asm/kvm_emulate.h |  8 ++++++--
 arch/arm64/kvm/hyp/switch.c          |  8 ++++++--
 arch/arm64/kvm/inject_fault.c        | 38 +++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/sys_regs.c            |  9 ++++-----
 5 files changed, 52 insertions(+), 12 deletions(-)
