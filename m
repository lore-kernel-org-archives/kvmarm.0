From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 00/25] KVM: arm64: SVE guest support
Date: Thu, 17 Jan 2019 20:33:14 +0000
Message-ID: <1547757219-19439-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Julien Grall <Julien.Grall@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This series implements support for allowing KVM guests to use the Arm
Scalable Vector Extension (SVE).

The patches are also available on a branch for reviewer convenience. [1]

The patches are based on v5.0-rc2.

They depend on another small series currently under review [2] that does
a bit of relevant refactoring (as well as fixing an anomaly not directly
related to this series).  A base branch [3] is provided so that
reviewers don't need to hunt down both series independently.


This is series includes a redesign (hopefully the last) of the user API
the KVM userspace to enable and manipulate SVE for guests.  The final
patch gives an overview, though in fact there is not now much to say,
which is probably a good sign.

For a description of minor updates, see the individual patches.

Some basic functionality testing and stress-testing has been done, using
a hacked-up kvmtool (patches to be posted separately). Note:
**There may be a bug** somewhere related to the handling of ZCR_EL1.
See "Known issues" below for details.

Major changes:

 * API for enabling SVE and configuring the set of vector lengths in the
   guest completely redesigned (as implemented in patches 20-24).

   These changes introduce an ioctl sequencing restriction that I can't
   easily see how to avoid.  However, this restriction shouldn't affect
   current userspace since it only determines interactions involving
   SVE-related ioctls for now.

Reviewers may want to focus on the following patches initially:

 * 1      no Reviewed-by
 * 6-7    no Reviewed-by
 * 8      updated (bugfix)
 * 11-13  no Reviewed-by
 * 14     updated (bugfix), no Reviewed-by
 * 16-18  no Reviewed-by
 * 20-24  new (implementing the new API)
 * 25     updated (rewrote documentation), no Reviewed-by
   
Known issues:

 * SVE state corruption has been in the host when running on the ARM
   Fast Model.

   After some experimentation, it appears that ZCR_EL1 (accessed as
   ZCR_EL12 from KVM host context) may be affecting SVE operations in
   the host, even though IIUC it architecturally should not do so
   (either when running at EL2, or at EL0 with HCR_EL2.TGE set).

   This could be a bug in the model, or some missing synchronisation or
   a bad assumption in my patches.

   In particular, if I deliberately write ZCR_EL12 when back in the host
   [4], the precise value set seems to determine the vector length
   somewhere else in the host (assuming ZCR_EL2 is not set more
   restrictively).

 * Unneeded register slices for ioctl access to the SVE registers are
   not enumerated via KVM_GET_REG_LIST, but KVM_{GET,SET}_ONE_REG will
   succeed for them, with read-as-zero write-ignore semantics.

   The idea is that userspace that relies on KVM_GET_REG_LIST to
   determine what to save and restore should not be told to save or
   restore more data than strictly required, while still permitting a
   very simple implementation that dumbly saves/restores all possible
   slices unconditionally (albeit at extra runtime cost).

   This is partly historical, and partly for "convenience".

   I'm not sure whether this behaviour is a bug or a feature.

   If somebody has a strong view, I'd be happy to strictly forbid access
   to the surplus slices.

   Implementations may be tempted to access only slice 0 (which is the
   only relevant slice for the SVE architecture today).  There's not a
   huge amount we can do about this.  Perhaps we should reset the guest
   SVE regs with junk data instead of zeros as a guard against this.

 * There is no nice way to figure out how many SVE register slices to
   read/write via ioctl, other than KVM_GET_REG_LIST.  Userspace needs
   to know the maximum vector length supported for the vcpu (either by
   choosing it, or buy reading KVM_REG_ARM64_SVE_VLS and identifying the
   highest set bit in there), and then divide by the slice size,
   rounding up.

   If anyone has an idea about what to add to the headers for this (if
   anything), please shout.

 * kvmtool support is not mature: some hacks I have that at least permit
   testing will be posted separately.  qemu userspace support is
   nonexistent.

 * Bisect-tested for build only, in a few relevant configs.

 * No run-bisect-testing or review of sparse output has been performed
   on this series yet.


[1] This series in git:
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm/v4/head
git://linux-arm.org/linux-dm.git sve-kvm/v4/head

[2] [PATCH 0/3] Fix KVM_GET_REG_LIST invalid register ID regression
https://lists.cs.columbia.edu/pipermail/kvmarm/2018-December/033710.html

[3] Base of this series in git:
http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve-kvm/v4/base
git://linux-arm.org/linux-dm.git sve-kvm/v4/base

[4] [RFC PATCH v3 00/24] KVM: arm64: SVE guest support
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-December/620140.html

[5] Hack that seems to mess up the SVE vector length in the host, for
reasons I don't yet understand:

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 9cc57d4..d85e052 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -114,9 +114,11 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		fpsimd_save();
 		fpsimd_flush_cpu_state();
 
-		if (guest_has_sve)
+		if (guest_has_sve) {
 			vcpu->arch.ctxt.sys_regs[ZCR_EL1] =
 				read_sysreg_s(SYS_ZCR_EL12);
+			write_sysreg_s(6, SYS_ZCR_EL12);
+		}
 	} else if (host_has_sve) {
 		/*
 		 * The FPSIMD/SVE state in the CPU has not been touched, and we


Dave Martin (25):
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
  KVM: arm64: Support runtime sysreg filtering for KVM_GET_REG_LIST
  KVM: arm64/sve: System register context switch and access support
  KVM: arm64/sve: Context switch the SVE registers
  KVM: Allow 2048-bit register access via ioctl interface
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

 Documentation/virtual/kvm/api.txt |  85 ++++++++++
 arch/arm/include/asm/kvm_host.h   |   4 +
 arch/arm64/include/asm/fpsimd.h   |  33 +++-
 arch/arm64/include/asm/kvm_host.h |  22 ++-
 arch/arm64/include/asm/kvm_hyp.h  |   1 -
 arch/arm64/include/asm/sysreg.h   |   3 +
 arch/arm64/include/uapi/asm/kvm.h |  13 ++
 arch/arm64/kernel/cpufeature.c    |   2 +-
 arch/arm64/kernel/fpsimd.c        | 172 ++++++++++++++------
 arch/arm64/kernel/signal.c        |   5 -
 arch/arm64/kvm/fpsimd.c           |  16 +-
 arch/arm64/kvm/guest.c            | 329 +++++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/switch.c       |  69 ++++++--
 arch/arm64/kvm/reset.c            |  95 ++++++++++-
 arch/arm64/kvm/sys_regs.c         | 144 +++++++++++++++--
 arch/arm64/kvm/sys_regs.h         |  15 +-
 include/uapi/linux/kvm.h          |   2 +
 virt/kvm/arm/arm.c                |   8 +
 18 files changed, 897 insertions(+), 121 deletions(-)

-- 
2.1.4
