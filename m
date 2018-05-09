From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v7 07/16] KVM: arm64: Repurpose vcpu_arch.debug_flags for
 general-purpose flags
Date: Wed,  9 May 2018 17:12:56 +0100
Message-ID: <1525882385-29181-8-git-send-email-Dave.Martin@arm.com>
References: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 635404A0CC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 May 2018 12:04:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O0vmdpmfmJHz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 May 2018 12:04:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 410F4401CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 May 2018 12:04:00 -0400 (EDT)
In-Reply-To: <1525882385-29181-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

In struct vcpu_arch, the debug_flags field is used to store
debug-related flags about the vcpu state.

Since we are about to add some more flags related to FPSIMD and
SVE, it makes sense to add them to the existing flags field rather
than adding new fields.  Since there is only one debug_flags flag
defined so far, there is plenty of free space for expansion.

In preparation for adding more flags, this patch renames the
debug_flags field to simply "flags", and updates comments
appropriately.

The flag definitions are also moved to <asm/kvm_host.h>, since
their presence in <asm/kvm_asm.h> was for purely historical
reasons:  these definitions are not used from asm any more, and not
very likely to be as more Hyp asm is migrated to C.

KVM_ARM64_DEBUG_DIRTY_SHIFT has not been used since commit
1ea66d27e7b0 ("arm64: KVM: Move away from the assembly version of
the world switch"), so this patch gets rid of that too.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

---

Changes since v6:

 * Move vcpu_arch flags definitions to kvm_host.h.

   These are not used from asm any more, so it makes sense for them to be
   defined alongside the relevant structure field.

   (Commit message updated to reflect this change.)
---
 arch/arm64/include/asm/kvm_asm.h  | 3 ---
 arch/arm64/include/asm/kvm_host.h | 7 +++++--
 arch/arm64/kvm/debug.c            | 8 ++++----
 arch/arm64/kvm/hyp/debug-sr.c     | 6 +++---
 arch/arm64/kvm/hyp/sysreg-sr.c    | 4 ++--
 arch/arm64/kvm/sys_regs.c         | 9 ++++-----
 6 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f6648a3..f62ccbf 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -30,9 +30,6 @@
 /* The hyp-stub will return this for any kvm_call_hyp() call */
 #define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
-#define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
-#define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
-
 /* Translate a kernel address of @sym into its equivalent linear mapping */
 #define kvm_ksym_ref(sym)						\
 	({								\
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 469de8a..146c167 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -216,8 +216,8 @@ struct kvm_vcpu_arch {
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
-	/* Guest debug state */
-	u64 debug_flags;
+	/* Miscellaneous vcpu state flags */
+	u64 flags;
 
 	/*
 	 * We maintain more than a single set of debug registers to support
@@ -293,6 +293,9 @@ struct kvm_vcpu_arch {
 	bool sysregs_loaded_on_cpu;
 };
 
+/* vcpu_arch flags field values: */
+#define KVM_ARM64_DEBUG_DIRTY		(1 << 0)
+
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
 
 /*
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index a1f4ebd..00d4223 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -103,7 +103,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
  *
  * Additionally, KVM only traps guest accesses to the debug registers if
  * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
- * flag on vcpu->arch.debug_flags).  Since the guest must not interfere
+ * flag on vcpu->arch.flags).  Since the guest must not interfere
  * with the hardware state when debugging the guest, we must ensure that
  * trapping is enabled whenever we are debugging the guest using the
  * debug registers.
@@ -111,7 +111,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
 
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
-	bool trap_debug = !(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY);
+	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
 	unsigned long mdscr;
 
 	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
@@ -184,7 +184,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 
 			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
-			vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
+			vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 			trap_debug = true;
 
 			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
@@ -206,7 +206,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
-		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
+		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 
 	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 3e717f6..5000976 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -163,7 +163,7 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (!has_vhe())
 		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
 
-	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
+	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
 	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
@@ -185,7 +185,7 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	if (!has_vhe())
 		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
 
-	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
+	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
 	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
@@ -196,7 +196,7 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	__debug_save_state(vcpu, guest_dbg, guest_ctxt);
 	__debug_restore_state(vcpu, host_dbg, host_ctxt);
 
-	vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
+	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
 u32 __hyp_text __kvm_get_mdcr_el2(void)
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index b3894df..35bc168 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -196,7 +196,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
 	sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
 
-	if (has_vhe() || vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
 		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
 }
 
@@ -218,7 +218,7 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(sysreg[DACR32_EL2], dacr32_el2);
 	write_sysreg(sysreg[IFSR32_EL2], ifsr32_el2);
 
-	if (has_vhe() || vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
 		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6e3b969..a436373 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -31,7 +31,6 @@
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
-#include <asm/kvm_asm.h>
 #include <asm/kvm_coproc.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
@@ -338,7 +337,7 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 {
 	if (p->is_write) {
 		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
-		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
+		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 	} else {
 		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
 	}
@@ -369,7 +368,7 @@ static void reg_to_dbg(struct kvm_vcpu *vcpu,
 	}
 
 	*dbg_reg = val;
-	vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
+	vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 }
 
 static void dbg_to_reg(struct kvm_vcpu *vcpu,
@@ -1441,7 +1440,7 @@ static bool trap_debug32(struct kvm_vcpu *vcpu,
 {
 	if (p->is_write) {
 		vcpu_cp14(vcpu, r->reg) = p->regval;
-		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
+		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 	} else {
 		p->regval = vcpu_cp14(vcpu, r->reg);
 	}
@@ -1473,7 +1472,7 @@ static bool trap_xvr(struct kvm_vcpu *vcpu,
 		val |= p->regval << 32;
 		*dbg_reg = val;
 
-		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
+		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
 	} else {
 		p->regval = *dbg_reg >> 32;
 	}
-- 
2.1.4
