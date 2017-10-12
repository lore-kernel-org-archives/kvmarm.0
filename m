From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 19/37] KVM: arm64: Introduce separate VHE/non-VHE sysreg
 save/restore functions
Date: Thu, 12 Oct 2017 12:41:23 +0200
Message-ID: <20171012104141.26902-20-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0761B49D44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xyqa+JqF0epa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:25 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9F7749D63
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:24 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id m72so11979123wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:09 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
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

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 12 ++++++++----
 arch/arm64/kvm/hyp/switch.c      | 20 ++++++++++----------
 arch/arm64/kvm/hyp/sysreg-sr.c   | 40 ++++++++++++++++++++++++++++++++--------
 3 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index a0e5a70..998152d 100644
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
index b98b73b..7c4d430 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -330,7 +330,7 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state(host_ctxt);
+	sysreg_save_host_state_vhe(host_ctxt);
 
 	__activate_traps(vcpu);
 	__activate_vm(vcpu);
@@ -342,7 +342,7 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state(guest_ctxt);
+	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	/* Jump in the fire! */
@@ -353,13 +353,13 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (fixup_guest_exit(vcpu, &exit_code))
 		goto again;
 
-	__sysreg_save_guest_state(guest_ctxt);
+	sysreg_save_guest_state_vhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
 
-	__sysreg_restore_host_state(host_ctxt);
+	sysreg_restore_host_state_vhe(host_ctxt);
 
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
@@ -383,7 +383,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state(host_ctxt);
+	__sysreg_save_host_state_nvhe(host_ctxt);
 
 	__activate_traps(vcpu);
 	__activate_vm(vcpu);
@@ -396,7 +396,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state(guest_ctxt);
+	__sysreg_restore_guest_state_nvhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	/* Jump in the fire! */
@@ -407,7 +407,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (fixup_guest_exit(vcpu, &exit_code))
 		goto again;
 
-	__sysreg_save_guest_state(guest_ctxt);
+	__sysreg_save_guest_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
@@ -415,7 +415,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
 
-	__sysreg_restore_host_state(host_ctxt);
+	__sysreg_restore_host_state_nvhe(host_ctxt);
 
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
@@ -440,7 +440,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
-		__sysreg_restore_host_state(__host_ctxt);
+		__sysreg_restore_host_state_nvhe(__host_ctxt);
 	}
 
 	/*
@@ -463,7 +463,7 @@ static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
 	__deactivate_traps_vhe();
-	__sysreg_restore_host_state(host_ctxt);
+	sysreg_restore_host_state_vhe(host_ctxt);
 
 	panic(__hyp_panic_string,
 	      spsr,  elr,
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index b55c4ad..d8c42de 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -70,15 +70,27 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
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
@@ -126,15 +138,27 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
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
2.9.0
