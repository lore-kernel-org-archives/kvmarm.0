From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 07/13] arm64: KVM: split debug save restore across vm/traps
 activation
Date: Thu, 28 Feb 2019 16:07:29 +0000
Message-ID: <20190228160737.3323-8-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9DFC4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bUwq-RlWptId for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E5D34A42E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:12 -0500 (EST)
In-Reply-To: <20190228160737.3323-1-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

If we enable profiling buffer controls at EL1 generate a trap exception
to EL2, it also changes profiling buffer to use EL1&0 stage 1 translation
regime in case of VHE. To support SPE both in the guest and host, we
need to first stop profiling and flush the profiling buffers before
we activate/switch vm or enable/disable the traps.

In prepartion to do that, lets split the debug save restore functionality
into 4 steps:
1. debug_save_host_context - saves the host context
2. debug_restore_guest_context - restore the guest context
3. debug_save_guest_context - saves the guest context
4. debug_restore_host_context - restores the host context

Lets rename existing __debug_switch_to_{host,guest} to make sure it's
aligned to the above and just add the place holders for new ones getting
added here as we need them to support SPE in guests.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  6 ++++--
 arch/arm64/kvm/hyp/debug-sr.c    | 25 ++++++++++++++++---------
 arch/arm64/kvm/hyp/switch.c      | 12 ++++++++----
 3 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index a4a6f6deef89..0deea8c75f77 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -163,8 +163,10 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
 void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
-void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
-void __debug_switch_to_host(struct kvm_vcpu *vcpu);
+void __debug_save_host_context(struct kvm_vcpu *vcpu);
+void __debug_restore_guest_context(struct kvm_vcpu *vcpu);
+void __debug_save_guest_context(struct kvm_vcpu *vcpu);
+void __debug_restore_host_context(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index fa51236ebcb3..618884df1dc4 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -149,20 +149,13 @@ static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
 }
 
-void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_restore_guest_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	/*
-	 * Non-VHE: Disable and flush SPE data generation
-	 * VHE: The vcpu can run, but it can't hide.
-	 */
-	if (!has_vhe())
-		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
-
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
@@ -175,7 +168,7 @@ void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
 }
 
-void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -199,6 +192,20 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
+void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Non-VHE: Disable and flush SPE data generation
+	 * VHE: The vcpu can run, but it can't hide.
+	 */
+	if (!has_vhe())
+		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
+}
+
+void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
+{
+}
+
 u32 __hyp_text __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 08e2a01188ac..3054b8b8f037 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -472,6 +472,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	sysreg_save_host_state_vhe(host_ctxt);
+	__debug_save_host_context(vcpu);
 
 	/*
 	 * ARM erratum 1165522 requires us to configure both stage 1 and
@@ -488,7 +489,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 
 	sysreg_restore_guest_state_vhe(guest_ctxt);
-	__debug_switch_to_guest(vcpu);
+	__debug_restore_guest_context(vcpu);
 
 	__set_guest_arch_workaround_state(vcpu);
 
@@ -502,6 +503,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__set_host_arch_workaround_state(vcpu);
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
+	__debug_save_guest_context(vcpu);
 
 	__deactivate_traps(vcpu);
 
@@ -510,7 +512,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_context(vcpu);
 
 	return exit_code;
 }
@@ -530,6 +532,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	__sysreg_save_state_nvhe(host_ctxt);
+	__debug_save_host_context(vcpu);
 
 	__activate_vm(kern_hyp_va(vcpu->kvm));
 	__activate_traps(vcpu);
@@ -543,7 +546,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 */
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
-	__debug_switch_to_guest(vcpu);
+	__debug_restore_guest_context(vcpu);
 
 	__set_guest_arch_workaround_state(vcpu);
 
@@ -557,6 +560,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__set_host_arch_workaround_state(vcpu);
 
 	__sysreg_save_state_nvhe(guest_ctxt);
+	__debug_save_guest_context(vcpu);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
@@ -573,7 +577,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_context(vcpu);
 
 	return exit_code;
 }
-- 
2.17.1
