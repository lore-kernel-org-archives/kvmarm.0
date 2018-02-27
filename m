From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 22/40] KVM: arm64: Don't save the host ELR_EL2 and SPSR_EL2
 on VHE systems
Date: Tue, 27 Feb 2018 12:34:11 +0100
Message-ID: <20180227113429.637-23-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DF9E49DDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:30:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MEcCY6wi+G9I for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 06:30:17 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C399049E94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:28:10 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id w128so17470192wmw.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 03:35:04 -0800 (PST)
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

On non-VHE systems we need to save the ELR_EL2 and SPSR_EL2 so that we can
return to the host in EL1 in the same state and location where we issued a
hypercall to EL2, but on VHE ELR_EL2 and SPSR_EL2 are not useful because we
never enter a guest as a result of an exception entry that would be directly
handled by KVM. The kernel entry code already saves ELR_EL1/SPSR_EL1 on
exception entry, which is enough.  Therefore, factor out these registers into
separate save/restore functions, making it easy to exclude them from the VHE
world-switch path later on.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
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
