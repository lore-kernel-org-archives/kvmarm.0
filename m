From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 34/85] KVM: arm64: Unify non-VHE host/guest sysreg save and
 restore functions
Date: Wed, 28 Mar 2018 13:52:03 +0100
Message-ID: <20180328125254.31380-35-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F16440259
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fOA6e8s1vTgQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 08:50:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77D674A055
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:47:16 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

There is no need to have multiple identical functions with different
names for saving host and guest state.  When saving and restoring state
for the host and guest, the state is the same for both contexts, and
that's why we have the kvm_cpu_context structure.  Delete one
version and rename the other into simply save/restore.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  6 ++----
 arch/arm64/kvm/hyp/switch.c      | 10 +++++-----
 arch/arm64/kvm/hyp/sysreg-sr.c   | 18 ++----------------
 3 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 23c09d9af343..2b1fda90dde4 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -131,10 +131,8 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
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
index fd845dda007a..ec31e447dd7f 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -429,7 +429,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_host_state_nvhe(host_ctxt);
+	__sysreg_save_state_nvhe(host_ctxt);
 
 	__activate_traps(vcpu);
 	__activate_vm(kern_hyp_va(vcpu->kvm));
@@ -442,7 +442,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_guest_state_nvhe(guest_ctxt);
+	__sysreg_restore_state_nvhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
 	do {
@@ -464,7 +464,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	fp_enabled = __fpsimd_enabled();
 
-	__sysreg_save_guest_state_nvhe(guest_ctxt);
+	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
@@ -472,7 +472,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
 
-	__sysreg_restore_host_state_nvhe(host_ctxt);
+	__sysreg_restore_state_nvhe(host_ctxt);
 
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
@@ -502,7 +502,7 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
-		__sysreg_restore_host_state_nvhe(__host_ctxt);
+		__sysreg_restore_state_nvhe(__host_ctxt);
 	}
 
 	/*
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 18801ab56e8b..d35b3aa680ab 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -78,14 +78,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 		ctxt->sys_regs[DISR_EL1] = read_sysreg_s(SYS_VDISR_EL2);
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
@@ -154,14 +147,7 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 		write_sysreg_s(ctxt->sys_regs[DISR_EL1], SYS_VDISR_EL2);
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
