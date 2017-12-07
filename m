From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 19/36] KVM: arm64: Unify non-VHE host/guest sysreg save and
 restore functions
Date: Thu,  7 Dec 2017 18:06:13 +0100
Message-ID: <20171207170630.592-20-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 274B649DA0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id woLEfla4lvGN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:03:56 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CAA749DBB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:03:56 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id g75so14431423wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:07:12 -0800 (PST)
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

There is no need to have multiple identical functions with different
names for saving host and guest state.  When saving and restoring state
for the host and guest, the state is the same for both contexts, and
that's why we have the kvm_cpu_context structure.  Delete one
version and rename the other into simply save/restore.

Reviewed-by: Andrew Jones <drjones@redhat.com>
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
index 9e5bc490ef0f..c3e1a9c65bc1 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -400,7 +400,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state_nvhe(host_ctxt);
+	__sysreg_save_state_nvhe(host_ctxt);
 
 	__activate_traps(vcpu);
 	__activate_vm(kern_hyp_va(vcpu->kvm));
@@ -413,7 +413,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state_nvhe(guest_ctxt);
+	__sysreg_restore_state_nvhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	do {
@@ -423,7 +423,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
-	__sysreg_save_guest_state_nvhe(guest_ctxt);
+	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
@@ -431,7 +431,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
 
-	__sysreg_restore_host_state_nvhe(host_ctxt);
+	__sysreg_restore_state_nvhe(host_ctxt);
 
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
@@ -456,7 +456,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
-		__sysreg_restore_host_state_nvhe(__host_ctxt);
+		__sysreg_restore_state_nvhe(__host_ctxt);
 	}
 
 	/*
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 268c1cd25459..a12112494f75 100644
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
