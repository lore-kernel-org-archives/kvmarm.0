From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH REPOST] KVM: arm64: Treat FPEXC32_EL2 as a regular guest
 system register
Date: Tue, 11 Dec 2018 18:48:16 +0000
Message-ID: <1544554096-23451-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C04314A2B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 13:48:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id szd37Il6C2Ek for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 13:48:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21D694A200
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 13:48:24 -0500 (EST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently FPEXC32_EL2 is handled specially when context-switching.

However, FPEXC has no architectural effect when running in AArch64.
The only case where an arm64 host may execute in AArch32 is when
running compat user code at EL0: the architecture explicitly
documents FPEXC as having no effect in this case either when the
kernel (EL2 in the VHE case; otherwise EL1) is AArch64.

So, we can just handle FPEXC32_EL2 (which is the AArch64 alias for
this register) as a regular AArch32-only system register and switch
it without any special handling or synchronisation.

This allows some gnarly special-case code to be eliminated from
hyp.  The extra isb() in __activate_traps_fpsimd32() is dropped
too: for the reasons explained above arm64 never required this
anyway.

Note that the comment in the deleted __activate_traps_fpsimd32()
function about the need to inhibit traps to EL1 is only meaningful
if the guest's value for FPEXC is not restored (thus potentially
causing an unexpected trap to EL1 in the guest unless we're careful
to set the EN bit).  This arises from the treatment of FPEXC32_EL2
as if it were part of the the FPSIMD state to be switched lazily,
whereas it is really more natural to consider it as part of the EL1
system register state to be switched eagerly at the appropriate
times.

In fact, we explicitly don't care about seeing any trap until the
guest accesses the FPSIMD registers for real, provided that the
guest sees the behaviour it expects.  So ensuring that the guest's
view of FPEXC is alawys up to date (as implemented by this patch)
should be sufficient.  Since we always had to write FPEXC32_EL2
anyway (in order to work around the possibility of not restoring it
properly for the guest) this should not add significant cost.  In
any case, this patch moves any cost off the hyp switch critical
path, to vcpu_load/put().

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Alexander Graf <agraf@suse.de>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

**Build-tested only**

This is a repost of an otherwise unmodified patch discussed previously
[1].  It turned out that I had confused myself: I planned to move the
FPEXC32_EL2 save/restore to the vcpu_load/put() path, but this was
precisely what the patch already implemented.

Changes since RFC:

 * Removed inaccurate comment concerning the historical reason for the
   current FPEXC32_EL2 handling behaviour from the commit message.

 * Added the paragraphs about the implications of making the FPEXC
   restore non-lazy, to the commit message.


[1] [RFC PATCH] KVM: arm64: Treat FPEXC32_EL2 as a regular guest system register
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-September/599985.html

---
 arch/arm64/kvm/hyp/switch.c    | 45 ++----------------------------------------
 arch/arm64/kvm/hyp/sysreg-sr.c |  2 ++
 2 files changed, 4 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 7cc175c..583fcd7 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -43,32 +43,6 @@ static bool __hyp_text update_fp_enabled(struct kvm_vcpu *vcpu)
 	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
 }
 
-/* Save the 32-bit only FPSIMD system register state */
-static void __hyp_text __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
-{
-	if (!vcpu_el1_is_32bit(vcpu))
-		return;
-
-	vcpu->arch.ctxt.sys_regs[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
-}
-
-static void __hyp_text __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * We are about to set CPTR_EL2.TFP to trap all floating point
-	 * register accesses to EL2, however, the ARM ARM clearly states that
-	 * traps are only taken to EL2 if the operation would not otherwise
-	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
-	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
-	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
-	 * it will cause an exception.
-	 */
-	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd()) {
-		write_sysreg(1 << 30, fpexc32_el2);
-		isb();
-	}
-}
-
 static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
 {
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
@@ -98,10 +72,8 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
 	val &= ~CPACR_EL1_ZEN;
-	if (!update_fp_enabled(vcpu)) {
+	if (!update_fp_enabled(vcpu))
 		val &= ~CPACR_EL1_FPEN;
-		__activate_traps_fpsimd32(vcpu);
-	}
 
 	write_sysreg(val, cpacr_el1);
 
@@ -116,10 +88,8 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
-	if (!update_fp_enabled(vcpu)) {
+	if (!update_fp_enabled(vcpu))
 		val |= CPTR_EL2_TFP;
-		__activate_traps_fpsimd32(vcpu);
-	}
 
 	write_sysreg(val, cptr_el2);
 }
@@ -366,11 +336,6 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
 
 	__fpsimd_restore_state(&vcpu->arch.ctxt.gp_regs.fp_regs);
 
-	/* Skip restoring fpexc32 for AArch64 guests */
-	if (!(read_sysreg(hcr_el2) & HCR_RW))
-		write_sysreg(vcpu->arch.ctxt.sys_regs[FPEXC32_EL2],
-			     fpexc32_el2);
-
 	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
 
 	return true;
@@ -522,9 +487,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
-		__fpsimd_save_fpexc32(vcpu);
-
 	__debug_switch_to_host(vcpu);
 
 	return exit_code;
@@ -580,9 +542,6 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
-		__fpsimd_save_fpexc32(vcpu);
-
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 68d6f7c..9eaac8c 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -212,6 +212,7 @@ void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 
 	sysreg[DACR32_EL2] = read_sysreg(dacr32_el2);
 	sysreg[IFSR32_EL2] = read_sysreg(ifsr32_el2);
+	sysreg[FPEXC32_EL2] = read_sysreg(fpexc32_el2);
 
 	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
 		sysreg[DBGVCR32_EL2] = read_sysreg(dbgvcr32_el2);
@@ -234,6 +235,7 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 
 	write_sysreg(sysreg[DACR32_EL2], dacr32_el2);
 	write_sysreg(sysreg[IFSR32_EL2], ifsr32_el2);
+	write_sysreg(sysreg[FPEXC32_EL2], fpexc32_el2);
 
 	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
 		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
-- 
2.1.4
