From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Tue, 19 Mar 2019 17:51:51 +0000
Message-ID: <1553017938-710-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This series implements support for allowing KVM guests to use the Arm
Scalable Vector Extension (SVE), superseding the previous v5 series [1].

The patches are also available on a branch for reviewer convenience. [2]

The patches are based on v5.1-rc1.

The series has been reworked to remove the dependency on [3],
eliminating the ABI "fixes" but keeping the relevant cleanup/
refactoring.  (See patch 16.)

This series addresses review comments received on v5, and contains one
significant change:

 * A new ioctl KVM_ARM_VCPU_FINALIZE is added to replace the implicit
   finalization behaviour in v5.  If userspace enables SVE, it must now
   use this ioctl to finalize the vcpu configuration before KVM_RUN
   etc. or SVE register access are permitted.

For a description of minor updates, see the individual patches.


Known issues:

 * This update requires modifications to kvmtool that are not published
   yet.  I will reply to this cover letter with a link when those are
   available (hopefully within 24 hours of this posting).

   The kvmtool branch referenced by the v5 cover letter **will not
   work** with v6...  Please be patient :)


Testing status:

 * Lightweight testing on the Arm Fast Model, primarily to exercise the
   new vcpu finalization API.

   I plan to re-run stress testing once v6 is posted.  The low-level
   context switch internals in the series remain unchanged since v5, so
   it is "relatively unlikely" that new problems will crop up since the
   v5 testing.

 * ThunderX2: basic testing of arm64 defconfig, including booting guests
   (no SVE support on this hardware).

   (This was done on an interim release candidate of v6: I will redo it
   after this posting.)

 * aarch32 host testing has only been done in v5 so far.  arch/arm
   changes between v5 and v6 are minimal.  I plan to redo sanity-check
   testing after this posting.

I will reply to this cover letter when I have v6 test outcomes to
report.

   
Resolved issues:

 * The register zeroing bug observed when testing v5 has been tracked
   down to architecture noncompliance in the Arm Fast Model, which led
   to lanes of SVE registers being zeroed in some inappropriate
   situations.


[1] Previous series:
[PATCH v5 00/26] KVM: arm64: SVE guest support
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-February/034695.html

[2] This series in git:
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm/v6/head
git://linux-arm.org/linux-dm.git sve-kvm/v6/head

[3] [PATCH v2 0/2] Fix KVM_GET_REG_LIST invalid register ID regression
https://lists.cs.columbia.edu/pipermail/kvmarm/2018-December/033810.html


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
 arch/arm64/kvm/guest.c            | 387 +++++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/switch.c       |  74 ++++++--
 arch/arm64/kvm/reset.c            | 137 +++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 130 +++++++++++--
 arch/arm64/kvm/sys_regs.h         |  25 +++
 include/uapi/linux/kvm.h          |   5 +
 virt/kvm/arm/arm.c                |  22 +++
 18 files changed, 1110 insertions(+), 130 deletions(-)

-- 
2.1.4
