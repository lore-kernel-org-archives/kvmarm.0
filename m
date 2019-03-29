From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 00/27] KVM: arm64: SVE guest support
Date: Fri, 29 Mar 2019 13:00:25 +0000
Message-ID: <1553864452-15080-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 785104A319
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:01:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y5U7XwtIvbA9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Mar 2019 09:01:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C13584A2F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Mar 2019 09:01:00 -0400 (EDT)
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

This series implements support for allowing KVM guests to use the Arm
Scalable Vector Extension (SVE), superseding the previous v6 series [1].

The patches are also available on a branch for reviewer convenience. [2]

The patches are based on v5.1-rc2.

This series addresses a couple of minor review comments received on v6
and otherwise applies reviewer tags only.  The code differences
between v6 and this series consist of minor cosmetic fixups only.

Draft kvmtool patches were posted separately [3], [4].

For a description of minor updates, see the individual patches.


Thanks go to Julien Thierry and Julian Grall for their review efforts,
and to Zhang Lei for testing the series -- many thanks for their help
in getting the series to this point!


Reviewers' attention is drawn to the following patches, which have no
Reviewed-by/Acked-by.  Please take a look if you have a moment.

 * Patch 11 (KVM: arm64: Support runtime sysreg visibility filtering)

   Previously Reviewed-by Julien Thierry, but this version of the
   patch contains some minor rework suggested by Mark Rutland during
   the v5 review [5].

 * Patch 15 (KVM: arm64: Add missing #include of <linux/string.h>
   in guest.c)

   (Trivial patch.)

 * Patch 26: (KVM: Document errors for KVM_GET_ONE_REG and
   KVM_SET_ONE_REG)

   (Documentation only.)

 * Patch 27: KVM: arm64/sve: Document KVM API extensions for SVE

   (Documentation only.)


Known issues: none


Testing status:

 * Lightweight testing on the Arm Fast Model, primarily to exercise the
   new vcpu finalization API.

   Ran sve-stress testing for several days on v6 on the Arm Fast Model,
   with no errors observed.

 * ThunderX2: basic testing of arm64 defconfig, including booting guests
   (no SVE support on this hardware).

   Some stress testing with fpsimd-stress (to be published separately)
   and paranoia, with no problems observed over several days.

   This testing was done on v6.

 * aarch32 host testing has only been done in v5 so far.  arch/arm
   changes between v5 and v7 are minimal.  I plan to redo sanity-check
   testing after this posting.

   
[1] Previous series:
[PATCH v5 00/26] KVM: arm64: SVE guest support
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-March/thread.html

(Note, the subject line for this posting was incorrect.  It should have
read: [PATCH v6 00/27] KVM: arm64: SVE guest support)

[2] This series in git:
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm/v7/head
git://linux-arm.org/linux-dm.git sve-kvm/v7/head

[3] [PATCH kvmtool v2 0/3] arm64: Basic SVE guest support
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-March/035198.html

[4]
git://linux-arm.org/kvmtool-dm.git sve-linuxv6/v2/head
http://linux-arm.org/git?p=kvmtool-dm.git;a=shortlog;h=refs/heads/sve-linuxv6/v2/head

[5]
Mark Rutland Re: [PATCH v5 12/26] KVM: arm64: Support runtime sysreg
visibility filtering
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-February/034718.html

Dave Martin (27):
  KVM: Documentation: Document arm64 core registers in detail
  arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on task state flush
  KVM: arm64: Delete orphaned declaration for __fpsimd_enabled()
  KVM: arm64: Refactor kvm_arm_num_regs() for easier maintenance
  KVM: arm64: Add missing #includes to kvm_host.h
  arm64/sve: Clarify role of the VQ map maintenance functions
  arm64/sve: Check SVE virtualisability
  arm64/sve: Enable SVE state tracking for non-task contexts
  KVM: arm64: Add a vcpu flag to control SVE visibility for the guest
  KVM: arm64: Propagate vcpu into read_id_reg()
  KVM: arm64: Support runtime sysreg visibility filtering
  KVM: arm64/sve: System register context switch and access support
  KVM: arm64/sve: Context switch the SVE registers
  KVM: Allow 2048-bit register access via ioctl interface
  KVM: arm64: Add missing #include of <linux/string.h> in guest.c
  KVM: arm64: Factor out core register ID enumeration
  KVM: arm64: Reject ioctl access to FPSIMD V-regs on SVE vcpus
  KVM: arm64/sve: Add SVE support to register access ioctl interface
  KVM: arm64: Enumerate SVE register indices for KVM_GET_REG_LIST
  arm64/sve: In-kernel vector length availability query interface
  KVM: arm/arm64: Add hook for arch-specific KVM initialisation
  KVM: arm/arm64: Add KVM_ARM_VCPU_FINALIZE ioctl
  KVM: arm64/sve: Add pseudo-register for the guest's vector lengths
  KVM: arm64/sve: Allow userspace to enable SVE for vcpus
  KVM: arm64: Add a capability to advertise SVE support
  KVM: Document errors for KVM_GET_ONE_REG and KVM_SET_ONE_REG
  KVM: arm64/sve: Document KVM API extensions for SVE

 Documentation/virtual/kvm/api.txt | 156 +++++++++++++++
 arch/arm/include/asm/kvm_host.h   |   6 +
 arch/arm64/include/asm/fpsimd.h   |  33 +++-
 arch/arm64/include/asm/kvm_host.h |  43 ++++-
 arch/arm64/include/asm/kvm_hyp.h  |   1 -
 arch/arm64/include/asm/sysreg.h   |   3 +
 arch/arm64/include/uapi/asm/kvm.h |  22 +++
 arch/arm64/kernel/cpufeature.c    |   2 +-
 arch/arm64/kernel/fpsimd.c        | 172 ++++++++++++-----
 arch/arm64/kernel/signal.c        |   5 -
 arch/arm64/kvm/fpsimd.c           |  17 +-
 arch/arm64/kvm/guest.c            | 394 +++++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/switch.c       |  74 +++++--
 arch/arm64/kvm/reset.c            | 135 ++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 130 +++++++++++--
 arch/arm64/kvm/sys_regs.h         |  25 +++
 include/uapi/linux/kvm.h          |   5 +
 virt/kvm/arm/arm.c                |  22 +++
 18 files changed, 1115 insertions(+), 130 deletions(-)

-- 
2.1.4
