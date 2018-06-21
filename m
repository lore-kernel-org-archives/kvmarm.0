From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 00/16] KVM: arm64: Initial support for SVE guests
Date: Thu, 21 Jun 2018 15:57:24 +0100
Message-ID: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Peter Maydell <peter.maydell@linaro.org>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This series implements basic support for allowing KVM guests to use the
Arm Scalable Vector Extension (SVE).

The patches is based on torvalds/master f5b7769e (Revert "debugfs:
inode: debugfs_create_dir uses mode permission from parent") plus the
patches from [1].

Issues / missing features:

 * No way for userspace to determine or control the set of vector
   lengths exposed to the guest.  This needs to be fixed for
   snapshotting/migration of guests to work reliably.

   An ioctl needs to be added for this (dropped from this series
   because I consider it lower-priority than the core support).

 * No documentation update yet (I'd like to get the interfaces
   finalised before I put too much effort into writing that...)

 * Patch 14 (SVE register ioctl() access core) may be too complicated
   in its handling of backwards compatibility for the FPSIMD regs:
   It might be simpler to use nvcpu->arch.ctxt.gp_regs.fp_regs.vregs[]
   as a bounce buffer rather than trying to redirect uaccess directly
   to the appropriate locations in vcpu->sve_state.

   I'd be interested in people's comments on this.

 * kvmtool/qemu updates are needed to enable creation of SVE-enabled
   guests (to be discussed separately).


Brief notes on the patches:

 * Patches 1-4 are miscellaneous preliminary cleanups.

 * Patch 5 adds new arch vcpu init/teardown hooks due to the lack of
   an obvious place to free a vcpu's SVE state buffer.  This may want
   a rethink, because the allocation part has now ended up in
   kvm_reset_vcpu() instead of the new init hook.

 * Patches 6-12 implement the core SVE support for guests (of which
   patch 8-9 refactor the sysregs code to support conditional hiding
   of the SVE-related registers).

 * Patches 13-15 implement ioctl() access for the new SVE registers.

 * Patch 16 exposes the new functionality to userspace, allowing
   SVE-enabled vcpus to be created.


This series is somewhat tested on Arm Juno r0 and the Arm Fast Model
(with/without SVE support).  arch/arm builds, but I've not booted
it -- only some trivial refactoring in this series affects arch/arm.

Cheers
---Dave


[1] [PATCH v2 0/4] KVM: arm64: FPSIMD/SVE fixes for 4.17 [sic]
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-June/584281.html

Dave Martin (16):
  arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on task state flush
  KVM: arm64: Delete orphaned declaration for __fpsimd_enabled()
  KVM: arm64: Refactor kvm_arm_num_regs() for easier maintenance
  KVM: arm64: Add missing #include of <linux/bitmap.h> to kvm_host.h
  KVM: arm: Add arch init/uninit hooks
  arm64/sve: Determine virtualisation-friendly vector lengths
  arm64/sve: Enable SVE state tracking for non-task contexts
  KVM: arm64: Support dynamically hideable system registers
  KVM: arm64: Allow ID registers to by dynamically read-as-zero
  KVM: arm64: Add a vcpu flag to control SVE visibility for the guest
  KVM: arm64/sve: System register context switch and access support
  KVM: arm64/sve: Context switch the SVE registers
  KVM: Allow 2048-bit register access via KVM_{GET,SET}_ONE_REG
  KVM: arm64/sve: Add SVE support to register access ioctl interface
  KVM: arm64: Enumerate SVE register indices for KVM_GET_REG_LIST
  KVM: arm64/sve: Report and enable SVE API extensions for userspace

 arch/arm/include/asm/kvm_host.h   |   4 +-
 arch/arm64/include/asm/fpsimd.h   |   4 +-
 arch/arm64/include/asm/kvm_host.h |  18 ++-
 arch/arm64/include/asm/kvm_hyp.h  |   1 -
 arch/arm64/include/asm/sysreg.h   |   3 +
 arch/arm64/include/uapi/asm/kvm.h |  11 ++
 arch/arm64/kernel/cpufeature.c    |   2 +-
 arch/arm64/kernel/fpsimd.c        | 131 +++++++++++++---
 arch/arm64/kernel/signal.c        |   5 -
 arch/arm64/kvm/fpsimd.c           |   7 +-
 arch/arm64/kvm/guest.c            | 321 +++++++++++++++++++++++++++++++++++---
 arch/arm64/kvm/hyp/switch.c       |  43 +++--
 arch/arm64/kvm/hyp/sysreg-sr.c    |   5 +
 arch/arm64/kvm/reset.c            |  14 ++
 arch/arm64/kvm/sys_regs.c         |  73 ++++++---
 arch/arm64/kvm/sys_regs.h         |  22 +++
 include/uapi/linux/kvm.h          |   1 +
 virt/kvm/arm/arm.c                |  13 +-
 18 files changed, 587 insertions(+), 91 deletions(-)

-- 
2.1.4
