From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 22/40] KVM: arm64: Don't save the host ELR_EL2 and SPSR_EL2 on VHE systems
Date: Thu, 15 Feb 2018 22:03:14 +0100
Message-ID: <20180215210332.8648-23-christoffer.dall@linaro.org>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180215210332.8648-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Dave Martin <Dave.Martin@arm.com>, Julien Grall <julien.grall@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Yury Norov <ynorov@caviumnetworks.com>
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
index d35b3aa680ab..906606dc4e2c 100644
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
 
@@ -83,6 +87,7 @@ void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
 	__sysreg_save_user_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
 }
 
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
@@ -96,6 +101,7 @@ void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
 	__sysreg_save_user_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
 }
 
 static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
@@ -140,6 +146,11 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
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
 
@@ -152,6 +163,7 @@ void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
 }
 
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
@@ -165,6 +177,7 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
 }
 
 void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
-- 
2.14.2
