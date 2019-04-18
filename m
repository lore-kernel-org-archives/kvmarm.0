From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v2 00/14] KVM: arm64: SVE cleanups
Date: Thu, 18 Apr 2019 17:06:57 +0100
Message-ID: <1555603631-8107-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E538C4A4B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:07:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e-YmVz9j5nTf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Apr 2019 12:07:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D8D14A494
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Apr 2019 12:07:18 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This series contains some cleanups applicable to the SVE KVM support
patches merged into kvmarm/next.  These arose from Andrew Jones'
review.

Apart from some minor changes to error codes and checking, these are
mostly cosmetic / sytlistic changes only.

The patches are based on
git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
5d8d4af24460 ("arm64: KVM: Fix system register enumeration")

This series in git:
git://linux-arm.org/linux-dm.git sve-kvm-fixes/v2/head
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm-fixes/v2/head

Tested with qemu and kvmtool on ThunderX2, and with kvmtool on the Arm
Fast model (to exercise SVE support).

Some additional manual testing was done to exercise the updated error
behaviours when accessing the SVE registers via ioctl.

Dave Martin (14):
  arm64/sve: Clarify vq map semantics
  KVM: arm/arm64: Demote kvm_arm_init_arch_resources() to just set up
    SVE
  KVM: arm: Make vcpu finalization stubs into inline functions
  KVM: arm64/sve: sys_regs: Demote redundant vcpu_has_sve() checks to
    WARNs
  KVM: arm64/sve: Clean up UAPI register ID definitions
  KVM: arm64/sve: Miscellaneous tidyups in guest.c
  KVM: arm64/sve: Make register ioctl access errors more consistent
  KVM: arm64/sve: WARN when avoiding divide-by-zero in
    sve_reg_to_region()
  KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS array sizing
  KVM: arm64/sve: Explain validity checks in set_sve_vls()
  KVM: arm/arm64: Clean up vcpu finalization function parameter naming
  KVM: Clarify capability requirements for KVM_ARM_VCPU_FINALIZE
  KVM: Clarify KVM_{SET,GET}_ONE_REG error code documentation
  KVM: arm64: Clarify access behaviour for out-of-range SVE register
    slice IDs

 Documentation/virtual/kvm/api.txt | 24 ++++++-----
 arch/arm/include/asm/kvm_host.h   | 13 ++++--
 arch/arm64/include/asm/fpsimd.h   |  4 --
 arch/arm64/include/asm/kvm_host.h |  4 +-
 arch/arm64/include/uapi/asm/kvm.h | 32 ++++++++++----
 arch/arm64/kernel/fpsimd.c        |  7 ++-
 arch/arm64/kvm/guest.c            | 91 +++++++++++++++++++++++----------------
 arch/arm64/kvm/reset.c            |  6 +--
 arch/arm64/kvm/sys_regs.c         |  4 +-
 virt/kvm/arm/arm.c                |  2 +-
 10 files changed, 116 insertions(+), 71 deletions(-)

-- 
2.1.4

@@@@

Dave Martin (14):
  arm64/sve: Clarify vq map semantics
  KVM: arm/arm64: Demote kvm_arm_init_arch_resources() to just set up
    SVE
  KVM: arm: Make vcpu finalization stubs into inline functions
  KVM: arm64/sve: sys_regs: Demote redundant vcpu_has_sve() checks to
    WARNs
  KVM: arm64/sve: Clean up UAPI register ID definitions
  KVM: arm64/sve: Miscellaneous tidyups in guest.c
  KVM: arm64/sve: Make register ioctl access errors more consistent
  KVM: arm64/sve: WARN when avoiding divide-by-zero in
    sve_reg_to_region()
  KVM: arm64/sve: Simplify KVM_REG_ARM64_SVE_VLS array sizing
  KVM: arm64/sve: Explain validity checks in set_sve_vls()
  KVM: arm/arm64: Clean up vcpu finalization function parameter naming
  KVM: Clarify capability requirements for KVM_ARM_VCPU_FINALIZE
  KVM: Clarify KVM_{SET,GET}_ONE_REG error code documentation
  KVM: arm64: Clarify access behaviour for out-of-range SVE register
    slice IDs

 Documentation/virtual/kvm/api.txt | 34 +++++++++------
 arch/arm/include/asm/kvm_host.h   | 13 ++++--
 arch/arm64/include/asm/fpsimd.h   |  4 --
 arch/arm64/include/asm/kvm_host.h |  4 +-
 arch/arm64/include/uapi/asm/kvm.h | 37 ++++++++++++----
 arch/arm64/kernel/fpsimd.c        |  7 ++-
 arch/arm64/kvm/guest.c            | 89 +++++++++++++++++++++++----------------
 arch/arm64/kvm/reset.c            |  6 +--
 arch/arm64/kvm/sys_regs.c         |  4 +-
 virt/kvm/arm/arm.c                |  2 +-
 10 files changed, 125 insertions(+), 75 deletions(-)

-- 
2.1.4
