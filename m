From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 26/36] KVM: arm64: Defer saving/restoring system registers
 to vcpu load/put on VHE
Date: Thu,  7 Dec 2017 18:06:20 +0100
Message-ID: <20171207170630.592-27-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1522B49D36
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o5gBZSpFCAhL for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:04:07 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1119449D14
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:07 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id 9so14262956wme.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:07:23 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Some system registers do not affect the host kernel's execution and can
therefore be loaded when we are about to run a VCPU and we don't have to
restore the host state to the hardware before the time when we are
actually about to return to userspace or schedule out the VCPU thread.

The EL1 system registers and the userspace state registers, which only
affect EL0 execution, do not affect the host kernel's execution.

The 32-bit system registers are not used by a VHE host kernel and
therefore don't need to be saved/restored on every entry/exit to/from
the guest, but can be deferred to vcpu_load and vcpu_put, respectively.

We have already prepared the trap handling code which accesses any of
these registers to directly access the registers on the physical CPU or
to sync the registers when needed.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c    |  6 ------
 arch/arm64/kvm/hyp/sysreg-sr.c | 46 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c3e1a9c65bc1..2ac8af354de0 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -359,11 +359,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	__vgic_restore_state(vcpu);
 
-	/*
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 */
-	__sysreg32_restore_state(vcpu);
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
@@ -375,7 +370,6 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
-	__sysreg32_save_state(vcpu);
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 479de0f0dd07..65abf1aeba59 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -25,8 +25,12 @@
 /*
  * Non-VHE: Both host and guest must save everything.
  *
- * VHE: Host must save tpidr*_el0, actlr_el1, mdscr_el1, sp_el0,
- * and guest must save everything.
+ * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and pstate,
+ * which are handled as part of the el2 return state) on every switch.
+ * tpidr_el0, tpidrro_el0, and actlr_el1 only need to be switched when going
+ * to host userspace or a different VCPU.  EL1 registers only need to be
+ * switched when potentially going to run a different VCPU.  The latter two
+ * classes are handled as part of kvm_arch_vcpu_load and kvm_arch_vcpu_put.
  */
 
 static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
@@ -90,14 +94,11 @@ void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_save_common_state(ctxt);
-	__sysreg_save_user_state(ctxt);
 }
 
 void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
-	__sysreg_save_user_state(ctxt);
 	__sysreg_save_el2_return_state(ctxt);
 }
 
@@ -163,14 +164,11 @@ void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_restore_common_state(ctxt);
-	__sysreg_restore_user_state(ctxt);
 }
 
 void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
-	__sysreg_restore_user_state(ctxt);
 	__sysreg_restore_el2_return_state(ctxt);
 }
 
@@ -236,6 +234,26 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
+	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
+
+	if (!has_vhe())
+		return;
+
+	__sysreg_save_user_state(host_ctxt);
+
+
+	/*
+	 * Load guest EL1 and user state
+	 *
+	 * We must restore the 32-bit state before the sysregs, thanks
+	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 */
+	__sysreg32_restore_state(vcpu);
+	__sysreg_restore_user_state(guest_ctxt);
+	__sysreg_restore_el1_state(guest_ctxt);
+
+	vcpu->arch.sysregs_loaded_on_cpu = true;
 }
 
 /**
@@ -264,6 +282,18 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 		__fpsimd_restore_state(&host_ctxt->gp_regs.fp_regs);
 		vcpu->arch.guest_vfp_loaded = 0;
 	}
+
+	if (!has_vhe())
+		return;
+
+	__sysreg_save_el1_state(guest_ctxt);
+	__sysreg_save_user_state(guest_ctxt);
+	__sysreg32_save_state(vcpu);
+
+	/* Restore host user state */
+	__sysreg_restore_user_state(host_ctxt);
+
+	vcpu->arch.sysregs_loaded_on_cpu = false;
 }
 
 void __hyp_text __kvm_set_tpidr_el2(u64 tpidr_el2)
-- 
2.14.2
