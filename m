From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 00/23] KVM: arm64: Initial support for SVE guests
Date: Fri, 28 Sep 2018 14:39:04 +0100
Message-ID: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF1E64A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:39:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 87s-jXnvb64j for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:39:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C9BD49F94
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:39:35 -0400 (EDT)
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This series implements basic support for allowing KVM guests to use the
Arm Scalable Vector Extension (SVE).

The patches are based on v4.19-rc5.

The patches are also available on a branch for reviewer convenience. [1]

This is a significant overhaul of the previous preliminary series [2],
with the major changes outlined below, and additional minor updates in
response to review feedback (see the individual patches for those).

In the interest of getting this series out for review, 
This series is **completely untested**.

Reviewers should focus on the proposed API (but any other comments are
of course welcome!)


Major changes:

 * Reworked on top of the new KVM FPSIMD context switching model.

 * Migrated away from use of feature bits in KVM_ARM_PREFERRED_TARGET /
   KVM_VCPU_INIT to detect and enable SVE support.

   Availability is now reported via KVM_CAP_ARM_SVE, and SVE support
   is enabled and configured per-vcpu with a new ioctl
   KVM_ARM_SVE_CONFIG.

 * KVM_ARM_SVE_CONFIG also adds the ability to detect and configure
   the set of SVE vector lengths provided to the guest.

 * The ioctl register access model has been simplified.  The new SVE
   interface must now be used to access the content of the FPSIMD
   V-registers, on SVE-enabled vcpus.  The kernel no longer tries to
   emulate the KVM_REG_ARM_CORE view for these registers in this case.
   (For non-SVE-enabled vcpus, the KVM_REG_ARM_CORE interface works as
   normal.)

 * Draft documentation for the SVE extensions has been added to KVM's
   api.txt.

Known issues:

 * KVM_GET_REG_LIST enumerates the FPSIMD V-registers for SVE-enabled
   vcpus.  It shouldn't, because attempts to access these will now fail!

 * kvmtool/qemu updates are needed to enable creation of SVE-enabled
   guests (to be discussed separately).

 * Due to heavy rework, the series is currently a bit of a mess: the
   patches are not presented in a very coherent order, and one or two
   patches may even now be redundant or irrelevant.  If you spot any
   obvious inconsistencies, please shout!


[1]
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm/rfcv2
git://linux-arm.org/linux-dm.git sve-kvm/rfcv2

[2] [RFC PATCH 00/16] KVM: arm64: Initial support for SVE guests
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-June/585467.html


Dave Martin (23):
  arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on task state flush
  KVM: arm64: Delete orphaned declaration for __fpsimd_enabled()
  KVM: arm64: Refactor kvm_arm_num_regs() for easier maintenance
  KVM: arm64: Add missing #include of <linux/bitmap.h> to kvm_host.h
  KVM: arm: Add arch vcpu uninit hook
  arm64/sve: Check SVE virtualisability
  arm64/sve: Enable SVE state tracking for non-task contexts
  KVM: arm64: Add a vcpu flag to control SVE visibility for the guest
  KVM: arm64: Propagate vcpu into read_id_reg()
  KVM: arm64: Extend reset_unknown() to handle mixed RES0/UNKNOWN
    registers
  KVM: arm64: Support runtime sysreg filtering for KVM_GET_REG_LIST
  KVM: arm64/sve: System register context switch and access support
  KVM: arm64/sve: Context switch the SVE registers
  KVM: Allow 2048-bit register access via ioctl interface
  KVM: arm64/sve: Add SVE support to register access ioctl interface
  KVM: arm64: Enumerate SVE register indices for KVM_GET_REG_LIST
  arm64/sve: In-kernel vector length availability query interface
  KVM: arm64: Add arch vcpu ioctl hook
  KVM: arm64/sve: Report and enable SVE API extensions for userspace
  KVM: arm64: Add arch vm ioctl hook
  KVM: arm64/sve: allow KVM_ARM_SVE_CONFIG_QUERY on vm fd
  KVM: Documentation: Document arm64 core registers in detail
  KVM: arm64/sve: Document KVM API extensions for SVE

 Documentation/virtual/kvm/api.txt | 160 ++++++++++++++++
 arch/arm/include/asm/kvm_host.h   |  16 +-
 arch/arm64/include/asm/fpsimd.h   |  33 +++-
 arch/arm64/include/asm/kvm_host.h |  25 ++-
 arch/arm64/include/asm/kvm_hyp.h  |   1 -
 arch/arm64/include/asm/sysreg.h   |   3 +
 arch/arm64/include/uapi/asm/kvm.h |  24 +++
 arch/arm64/kernel/cpufeature.c    |   2 +-
 arch/arm64/kernel/fpsimd.c        | 163 +++++++++++-----
 arch/arm64/kernel/signal.c        |   5 -
 arch/arm64/kvm/fpsimd.c           |  16 +-
 arch/arm64/kvm/guest.c            | 391 ++++++++++++++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/switch.c       |  69 +++++--
 arch/arm64/kvm/reset.c            |  50 +++++
 arch/arm64/kvm/sys_regs.c         | 144 ++++++++++++--
 arch/arm64/kvm/sys_regs.h         |   8 +-
 include/uapi/linux/kvm.h          |   5 +
 virt/kvm/arm/arm.c                |   9 +-
 18 files changed, 1016 insertions(+), 108 deletions(-)

-- 
2.1.4
