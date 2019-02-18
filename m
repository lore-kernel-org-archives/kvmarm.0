From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 00/26] KVM: arm64: SVE guest support
Date: Mon, 18 Feb 2019 19:52:13 +0000
Message-ID: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
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
Scalable Vector Extension (SVE), superseding the previous v4 series [1].

The patches are also available on a branch for reviewer convenience. [2]

The patches are based on v5.0-rc6.

They depend on another small series currently under review [3] that does
a bit of relevant refactoring (as well as fixing an anomaly not directly
related to this series).  A base branch [4] is provided so that
reviewers don't need to hunt down both series independently.

This series contains no major update except for the removal of multiple
register slice support in the user register access ioctls.  The ABI is
kept as-is so that this functionality can be added back in later on
if/when needed.  ioctl access to nonexistent slices now yields ENOENT,
which is more consistent with the notion of an absent register.

For a description of minor updates, see the individual patches.


Functionality testing and stress-testing has been done, using a
hacked-up kvmtool [5]:

 * Arm Fast Model: full testing of arm64 defconfig, including running
   non-SVE and SVE guests with mixtures of vector lengths.  limited
   testing of other configurations.

 * ThunderX2: basic testing of arm64 defconfig, including booting guests
   (no SVE support on this hardware).

 * Full build-bisect testing and sparse testing of every commit done
   for arm64 (defconfig, CONFIG_ARM64_SVE=n, CONFIG_KVM=n) and arm
   (multi_v7_defconfig, CONFIG_KVM=y).  One new sparse warning,
   probably spurious (see note in patch 22).


AArch32 host testing is pending.  I will ping this series with a reply
to the cover letter when that testing has been completed.

   
Known issues:

 * **Possible bug**

   SVE state corruption has been in the host when running on the Arm
   Fast Model.

   After some investigation with the model engineers, it appears that
   there may be a model bug in this area.  I have also obtained detailed
   trace of failure cases, which is also suggestive of a model bug.  No
   clear evidence has been obtained to show that there is a bug in
   Linux, so far.

   All available evidence suggests that this bug will not affect non-SVE
   hardware: the symptom is unexpected zeroing of bits 128 and above of
   the vector registers (which don't exist prior to SVE).

 * kvmtool support is not mature


[1] [RFC PATCH v4 00/24] KVM: arm64: SVE guest support
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-January/034134.html

[2] This series in git:
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm/v5/head
git://linux-arm.org/linux-dm.git sve-kvm/v5/head

[3] [PATCH v2 0/2] Fix KVM_GET_REG_LIST invalid register ID regression
https://lists.cs.columbia.edu/pipermail/kvmarm/2018-December/033810.html

[4] Base of this series in git:
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm/v5/base
git://linux-arm.org/linux-dm.git sve-kvm/v5/base

[5] [RFC PATCH 00/12] arm64: SVE guest support test hacks
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-January/034162.html


Dave Martin (26):
  KVM: Documentation: Document arm64 core registers in detail
  arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on task state flush
  KVM: arm64: Delete orphaned declaration for __fpsimd_enabled()
  KVM: arm64: Refactor kvm_arm_num_regs() for easier maintenance
  KVM: arm64: Add missing #include of <linux/bitmap.h> to kvm_host.h
  arm64/sve: Check SVE virtualisability
  arm64/sve: Clarify role of the VQ map maintenance functions
  arm64/sve: Enable SVE state tracking for non-task contexts
  KVM: arm64: Add a vcpu flag to control SVE visibility for the guest
  KVM: arm64: Propagate vcpu into read_id_reg()
  KVM: arm64: Extend reset_unknown() to handle mixed RES0/UNKNOWN
    registers
  KVM: arm64: Support runtime sysreg visibility filtering
  KVM: arm64/sve: System register context switch and access support
  KVM: arm64/sve: Context switch the SVE registers
  KVM: Allow 2048-bit register access via ioctl interface
  KVM: arm64: Add missing #include of <linux/string.h> in guest.c
  KVM: arm64: Reject ioctl access to FPSIMD V-regs on SVE vcpus
  KVM: arm64/sve: Add SVE support to register access ioctl interface
  KVM: arm64: Enumerate SVE register indices for KVM_GET_REG_LIST
  arm64/sve: In-kernel vector length availability query interface
  KVM: arm/arm64: Add hook to finalize the vcpu configuration
  KVM: arm64/sve: Add pseudo-register for the guest's vector lengths
  KVM: arm64/sve: Allow userspace to enable SVE for vcpus
  KVM: arm64: Add a capabillity to advertise SVE support
  KVM: Document errors for KVM_GET_ONE_REG and KVM_SET_ONE_REG
  KVM: arm64/sve: Document KVM API extensions for SVE

 Documentation/virtual/kvm/api.txt |  93 ++++++++++
 arch/arm/include/asm/kvm_host.h   |   4 +
 arch/arm64/include/asm/fpsimd.h   |  33 +++-
 arch/arm64/include/asm/kvm_host.h |  35 +++-
 arch/arm64/include/asm/kvm_hyp.h  |   1 -
 arch/arm64/include/asm/sysreg.h   |   3 +
 arch/arm64/include/uapi/asm/kvm.h |  22 +++
 arch/arm64/kernel/cpufeature.c    |   2 +-
 arch/arm64/kernel/fpsimd.c        | 172 +++++++++++++------
 arch/arm64/kernel/signal.c        |   5 -
 arch/arm64/kvm/fpsimd.c           |  17 +-
 arch/arm64/kvm/guest.c            | 348 +++++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/switch.c       |  69 ++++++--
 arch/arm64/kvm/reset.c            |  87 +++++++++-
 arch/arm64/kvm/sys_regs.c         | 144 ++++++++++++++--
 arch/arm64/kvm/sys_regs.h         |  24 ++-
 include/uapi/linux/kvm.h          |   2 +
 virt/kvm/arm/arm.c                |   8 +
 18 files changed, 944 insertions(+), 125 deletions(-)

-- 
2.1.4
