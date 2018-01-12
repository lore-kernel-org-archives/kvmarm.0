From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 22/41] KVM: arm64: Unify non-VHE host/guest sysreg save and
 restore functions
Date: Fri, 12 Jan 2018 13:07:28 +0100
Message-ID: <20180112120747.27999-23-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F4B249DF1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FJLmWVVzpxBC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 07:03:36 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49C2949DFD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 07:03:35 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id 141so11314482wme.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 04:08:25 -0800 (PST)
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

There is no need to have multiple identical functions with different
names for saving host and guest state.  When saving and restoring state
for the host and guest, the state is the same for both contexts, and
that's why we have the kvm_cpu_context structure.  Delete one
version and rename the other into simply save/restore.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h |  6 ++----
 arch/arm64/kvm/hyp/switch.c      | 10 +++++-----
 arch/arm64/kvm/hyp/sysreg-sr.c   | 18 ++----------------
 3 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 998152da9b66..3f54c55f77a1 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -132,10 +132,8 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
 
-void __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt);
-void __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt);
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt);
 void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index b6edb6aaa298..2e04d404ac82 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -396,7 +396,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state_nvhe(host_ctxt);
+	__sysreg_save_state_nvhe(host_ctxt);
 
 	__activate_traps(vcpu);
 	__activate_vm(kern_hyp_va(vcpu->kvm));
@@ -409,7 +409,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state_nvhe(guest_ctxt);
+	__sysreg_restore_state_nvhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	do {
@@ -419,7 +419,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-	__sysreg_save_guest_state_nvhe(guest_ctxt);
+	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
@@ -427,7 +427,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
 
-	__sysreg_restore_host_state_nvhe(host_ctxt);
+	__sysreg_restore_state_nvhe(host_ctxt);
 
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
@@ -452,7 +452,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
-		__sysreg_restore_host_state_nvhe(__host_ctxt);
+		__sysreg_restore_state_nvhe(__host_ctxt);
 	}
 
 	/*
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 5cbde1016303..baa243a010b3 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -75,14 +75,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
 }
 
-void __hyp_text __sysreg_save_host_state_nvhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_save_el1_state(ctxt);
-	__sysreg_save_common_state(ctxt);
-	__sysreg_save_user_state(ctxt);
-}
-
-void __hyp_text __sysreg_save_guest_state_nvhe(struct kvm_cpu_context *ctxt)
+void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
@@ -148,14 +141,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
 }
 
-void __hyp_text __sysreg_restore_host_state_nvhe(struct kvm_cpu_context *ctxt)
-{
-	__sysreg_restore_el1_state(ctxt);
-	__sysreg_restore_common_state(ctxt);
-	__sysreg_restore_user_state(ctxt);
-}
-
-void __hyp_text __sysreg_restore_guest_state_nvhe(struct kvm_cpu_context *ctxt)
+void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
-- 
2.14.2
