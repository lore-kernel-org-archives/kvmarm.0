From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 20/41] KVM: arm64: Introduce separate VHE/non-VHE sysreg
 save/restore functions
Date: Fri, 12 Jan 2018 13:07:26 +0100
Message-ID: <20180112120747.27999-21-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AFC849DBC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yIEBups-lAuO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:35 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6731049DDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:32 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id 81so2108495wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:23 -0800 (PST)
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
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

As we are about to handle system registers quite differently between VHE
and non-VHE systems.  In preparation for that, we need to split some of
the handling functions between VHE and non-VHE functionality.

For now, we simply copy the non-VHE functions, but we do change the use
of static keys for VHE and non-VHE functionality now that we have
separate functions.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 12 ++++++++----
 arch/arm64/kvm/hyp/switch.c      | 20 ++++++++++----------
 arch/arm64/kvm/hyp/sysreg-sr.c   | 40 ++++++++++++++++++++++++++++++++--------
 3 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index a0e5a7038237..998152da9b66 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -132,10 +132,14 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
 
-void __sysreg_save_host_state(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_host_state(struct kvm_cpu_context *ctxt);
-void __sysreg_save_guest_state(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
+void __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt);
+void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt);
+void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt);
+void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
+void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
 void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 6175fcb33ed2..42e0123ecd69 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -348,7 +348,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state(host_ctxt);
+	sysreg_save_host_state_vhe(host_ctxt);
 
 	__activate_traps(vcpu);
 	__activate_vm(vcpu->kvm);
@@ -360,7 +360,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state(guest_ctxt);
+	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	do {
@@ -370,13 +370,13 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-	__sysreg_save_guest_state(guest_ctxt);
+	sysreg_save_guest_state_vhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
 
-	__sysreg_restore_host_state(host_ctxt);
+	sysreg_restore_host_state_vhe(host_ctxt);
 
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
@@ -400,7 +400,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state(host_ctxt);
+	__sysreg_save_host_state_nvhe(host_ctxt);
 
 	__activate_traps(vcpu);
 	__activate_vm(kern_hyp_va(vcpu->kvm));
@@ -413,7 +413,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state(guest_ctxt);
+	__sysreg_restore_guest_state_nvhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	do {
@@ -423,7 +423,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-	__sysreg_save_guest_state(guest_ctxt);
+	__sysreg_save_guest_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
@@ -431,7 +431,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
 
-	__sysreg_restore_host_state(host_ctxt);
+	__sysreg_restore_host_state_nvhe(host_ctxt);
 
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
@@ -456,7 +456,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
-		__sysreg_restore_host_state(__host_ctxt);
+		__sysreg_restore_host_state_nvhe(__host_ctxt);
 	}
 
 	/*
@@ -479,7 +479,7 @@ static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
 	__deactivate_traps(vcpu);
-	__sysreg_restore_host_state(host_ctxt);
+	sysreg_restore_host_state_vhe(host_ctxt);
 
 	panic(__hyp_panic_string,
 	      spsr,  elr,
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 72cdbc1f678b..5cbde1016303 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -75,15 +75,27 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
 }
 
-void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
+void __hyp_text __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_el1_state(ctxt);
+	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
+}
+
+void __hyp_text __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_el1_state(ctxt);
+	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
+}
+
+void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
 {
-	if (!has_vhe())
-		__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
 	__sysreg_save_user_state(ctxt);
 }
 
-void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
+void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
@@ -136,15 +148,27 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
 }
 
-void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
+void __hyp_text __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_el1_state(ctxt);
+	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
+}
+
+void __hyp_text __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_el1_state(ctxt);
+	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
+}
+
+void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
 {
-	if (!has_vhe())
-		__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
 }
 
-void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
+void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
-- 
2.14.2
