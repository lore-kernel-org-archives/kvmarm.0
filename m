From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 11/40] KVM: arm64: Improve debug register save/restore flow
Date: Thu, 15 Feb 2018 22:03:03 +0100
Message-ID: <20180215210332.8648-12-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
List-Id: kvmarm@lists.cs.columbia.edu

Instead of having multiple calls from the world switch path to the debug
logic, each figuring out if the dirty bit is set and if we should
save/restore the debug registers, let's just provide two hooks to the
debug save/restore functionality, one for switching to the guest
context, and one for switching to the host context, and we get the
benefit of only having to evaluate the dirty flag once on each path,
plus we give the compiler some more room to inline some of this
functionality.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v1:
     - Remove leading underscores from local variables

 arch/arm64/include/asm/kvm_hyp.h | 10 ++-----
 arch/arm64/kvm/hyp/debug-sr.c    | 56 +++++++++++++++++++++++++++-------------
 arch/arm64/kvm/hyp/switch.c      |  6 ++---
 3 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index f26f9cd70c72..aeda2a777365 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -138,14 +138,8 @@ void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
 void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
-void __debug_save_state(struct kvm_vcpu *vcpu,
-			struct kvm_guest_debug_arch *dbg,
-			struct kvm_cpu_context *ctxt);
-void __debug_restore_state(struct kvm_vcpu *vcpu,
-			   struct kvm_guest_debug_arch *dbg,
-			   struct kvm_cpu_context *ctxt);
-void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
-void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
+void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
+void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 74f71fb5e36d..3e717f66f011 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -110,16 +110,13 @@ static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
 	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
 }
 
-void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
-				   struct kvm_guest_debug_arch *dbg,
-				   struct kvm_cpu_context *ctxt)
+static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
+					  struct kvm_guest_debug_arch *dbg,
+					  struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
 
-	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
-		return;
-
 	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
 	brps = (aa64dfr0 >> 12) & 0xf;
 	wrps = (aa64dfr0 >> 20) & 0xf;
@@ -132,16 +129,13 @@ void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
 	ctxt->sys_regs[MDCCINT_EL1] = read_sysreg(mdccint_el1);
 }
 
-void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
-				      struct kvm_guest_debug_arch *dbg,
-				      struct kvm_cpu_context *ctxt)
+static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
+					     struct kvm_guest_debug_arch *dbg,
+					     struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
 
-	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
-		return;
-
 	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
 
 	brps = (aa64dfr0 >> 12) & 0xf;
@@ -155,10 +149,12 @@ void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
 }
 
-void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 {
-	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
-			   kern_hyp_va(vcpu->arch.host_cpu_context));
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	struct kvm_guest_debug_arch *host_dbg;
+	struct kvm_guest_debug_arch *guest_dbg;
 
 	/*
 	 * Non-VHE: Disable and flush SPE data generation
@@ -166,15 +162,39 @@ void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
 	 */
 	if (!has_vhe())
 		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
+
+	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
+		return;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+	host_dbg = &vcpu->arch.host_debug_state.regs;
+	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+
+	__debug_save_state(vcpu, host_dbg, host_ctxt);
+	__debug_restore_state(vcpu, guest_dbg, guest_ctxt);
 }
 
-void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	struct kvm_guest_debug_arch *host_dbg;
+	struct kvm_guest_debug_arch *guest_dbg;
+
 	if (!has_vhe())
 		__debug_restore_spe_nvhe(vcpu->arch.host_debug_state.pmscr_el1);
 
-	__debug_restore_state(vcpu, &vcpu->arch.host_debug_state.regs,
-			      kern_hyp_va(vcpu->arch.host_cpu_context));
+	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
+		return;
+
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+	host_dbg = &vcpu->arch.host_debug_state.regs;
+	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+
+	__debug_save_state(vcpu, guest_dbg, guest_ctxt);
+	__debug_restore_state(vcpu, host_dbg, host_ctxt);
 
 	vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index fbab9752a9f4..0c80d6a577ca 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -305,7 +305,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	__sysreg_save_host_state(host_ctxt);
-	__debug_cond_save_host_state(vcpu);
 
 	__activate_traps(vcpu);
 	__activate_vm(vcpu);
@@ -319,7 +318,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_guest_state(guest_ctxt);
-	__debug_restore_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
+	__debug_switch_to_guest(vcpu);
 
 	/* Jump in the fire! */
 again:
@@ -414,12 +413,11 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
 	}
 
-	__debug_save_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_cond_restore_host_state(vcpu);
+	__debug_switch_to_host(vcpu);
 
 	return exit_code;
 }
-- 
2.14.2
