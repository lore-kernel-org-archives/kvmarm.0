From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 0/2] KVM/ARM Fixes for v4.6-rc2
Date: Fri,  1 Apr 2016 11:07:25 +0200
Message-ID: <1459501647-20726-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,

The following changes since commit f55532a0c0b8bb6148f4e07853b876ef73bc69ca:

  Linux 4.6-rc1 (2016-03-26 16:03:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvm-arm-for-4.6-rc2

for you to fetch changes up to 5f5560b1c5f3a80e91c6babb2da34a51943bbdec:

  arm64: KVM: Register CPU notifiers when the kernel runs at HYP (2016-03-31 10:27:28 +0200)

The pull contains two small patches that fix a bug that corrupts stage-2
translationson 16-bit VMID equipped systems and fixCPU PM and Hotplug after
the EL2 init code has been moved to C.

Thanks,
-Christoffer

---

James Morse (1):
      arm64: KVM: Register CPU notifiers when the kernel runs at HYP

Suzuki K Poulose (1):
      arm64: kvm: 4.6-rc1: Fix VTCR_EL2 VS setting

 arch/arm/kvm/arm.c               | 52 +++++++++++++++++++++++++---------------
 arch/arm64/include/asm/kvm_arm.h |  4 +++-
 arch/arm64/include/asm/sysreg.h  |  3 +++
 arch/arm64/kvm/hyp/s2-setup.c    |  6 +++--
 4 files changed, 43 insertions(+), 22 deletions(-)
