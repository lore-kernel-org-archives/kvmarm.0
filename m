From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 39/95] arm64: KVM: VHE: Differenciate host/guest sysreg save/restore
Date: Wed,  9 Mar 2016 07:30:33 +0000
Message-ID: <1457508689-19672-40-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

With ARMv8, host and guest share the same system register file,
making the save/restore procedure completely symetrical.
With VHE, host and guest now have different requirements, as they
use different sysregs.

In order to prepare for this, add split sysreg save/restore functions
for both host and guest. No functional changes yet.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp.h       |  6 ++++--
 arch/arm64/kvm/hyp/switch.c    | 10 +++++-----
 arch/arm64/kvm/hyp/sysreg-sr.c | 24 ++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index 744c919..5dfa883 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -153,8 +153,10 @@ void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
 void __timer_save_state(struct kvm_vcpu *vcpu);
 void __timer_restore_state(struct kvm_vcpu *vcpu);
 
-void __sysreg_save_state(struct kvm_cpu_context *ctxt);
-void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
+void __sysreg_save_host_state(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_host_state(struct kvm_cpu_context *ctxt);
+void __sysreg_save_guest_state(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
 void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index f0e7bdf..68f3cba 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -102,7 +102,7 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg_save_state(host_ctxt);
+	__sysreg_save_host_state(host_ctxt);
 	__debug_cond_save_host_state(vcpu);
 
 	__activate_traps(vcpu);
@@ -116,7 +116,7 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 	 * to Cortex-A57 erratum #852523.
 	 */
 	__sysreg32_restore_state(vcpu);
-	__sysreg_restore_state(guest_ctxt);
+	__sysreg_restore_guest_state(guest_ctxt);
 	__debug_restore_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
 
 	/* Jump in the fire! */
@@ -125,7 +125,7 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 
 	fp_enabled = __fpsimd_enabled();
 
-	__sysreg_save_state(guest_ctxt);
+	__sysreg_save_guest_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_save_state(vcpu);
 	__vgic_save_state(vcpu);
@@ -133,7 +133,7 @@ static int __hyp_text __guest_run(struct kvm_vcpu *vcpu)
 	__deactivate_traps(vcpu);
 	__deactivate_vm(vcpu);
 
-	__sysreg_restore_state(host_ctxt);
+	__sysreg_restore_host_state(host_ctxt);
 
 	if (fp_enabled) {
 		__fpsimd_save_state(&guest_ctxt->gp_regs.fp_regs);
@@ -165,7 +165,7 @@ void __hyp_text __noreturn __hyp_panic(void)
 		host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
 		__deactivate_traps(vcpu);
 		__deactivate_vm(vcpu);
-		__sysreg_restore_state(host_ctxt);
+		__sysreg_restore_host_state(host_ctxt);
 	}
 
 	/* Call panic for real */
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 42563098..bd5b543 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -24,7 +24,7 @@
 #include "hyp.h"
 
 /* ctxt is already in the HYP VA space */
-void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
+static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
@@ -57,7 +57,17 @@ void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg(spsr_el1);
 }
 
-void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
+void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_state(ctxt);
+}
+
+void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_save_state(ctxt);
+}
+
+static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],	  vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],  csselr_el1);
@@ -90,6 +100,16 @@ void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->gp_regs.spsr[KVM_SPSR_EL1], spsr_el1);
 }
 
+void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_state(ctxt);
+}
+
+void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
+{
+	__sysreg_restore_state(ctxt);
+}
+
 void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	u64 *spsr, *sysreg;
-- 
2.1.4

