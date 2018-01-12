From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 23/41] KVM: arm64: Don't save the host ELR_EL2 and SPSR_EL2 on VHE systems
Date: Fri, 12 Jan 2018 13:07:29 +0100
Message-ID: <20180112120747.27999-24-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On non-VHE systems we need to save the ELR_EL2 and SPSR_EL2 so that we can
return to the host in EL1 in the same state and location where we issued a
hypercall to EL2, but on VHE ELR_EL2 and SPSR_EL2 are not useful because we
never enter a guest as a result of an exception entry that would be directly
handled by KVM. The kernel entry code already saves ELR_EL1/SPSR_EL1 on
exception entry, which is enough.  Therefore, factor out these registers into
separate save/restore functions, making it easy to exclude them from the VHE
world-switch path later on.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index baa243a010b3..1f2d5e9343b0 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -71,6 +71,10 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
 	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
+}
+
+static void __hyp_text __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
+{
 	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
 	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
 }
@@ -80,6 +84,7 @@ void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
 	__sysreg_save_user_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
 }
 
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
@@ -93,6 +98,7 @@ void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
 	__sysreg_save_user_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
 }
 
 static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
@@ -137,6 +143,11 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
 	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
+}
+
+static void __hyp_text
+__sysreg_restore_el2_return_state(struct kvm_cpu_context *ctxt)
+{
 	write_sysreg_el2(ctxt->gp_regs.regs.pc,		elr);
 	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
 }
@@ -146,6 +157,7 @@ void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
 }
 
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
@@ -159,6 +171,7 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
 }
 
 static void __hyp_text __fpsimd32_save_state(struct kvm_cpu_context *ctxt)
-- 
2.14.2
