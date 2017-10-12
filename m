From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 21/37] KVM: arm64: Don't save the host ELR_EL2 and SPSR_EL2 on
 VHE systems
Date: Thu, 12 Oct 2017 12:41:25 +0200
Message-ID: <20171012104141.26902-22-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AECDE49D42
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5fzPgQGI1DA9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:27 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BF0C49D63
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:27 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id l68so12075470wmd.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:11 -0700 (PDT)
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

On non-VHE systems we need to save the ELR_EL2 and SPSR_EL2 so that we
can return to the host in EL1 in the same state and location where we
issued a hypercall to EL2, but these registers don't contain anything
important on VHE, because all of the host runs in EL2.  Therefore,
exclude them when saving/restoring the host state.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index f5c1b44..354ca02 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -66,6 +66,10 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
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
@@ -75,6 +79,7 @@ void __hyp_text __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
 	__sysreg_save_user_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
 }
 
 void sysreg_save_host_state_vhe(struct kvm_cpu_context *ctxt)
@@ -88,6 +93,7 @@ void sysreg_save_guest_state_vhe(struct kvm_cpu_context *ctxt)
 	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
 	__sysreg_save_user_state(ctxt);
+	__sysreg_save_el2_return_state(ctxt);
 }
 
 static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
@@ -127,6 +133,11 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
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
@@ -136,6 +147,7 @@ void __hyp_text __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
 }
 
 void sysreg_restore_host_state_vhe(struct kvm_cpu_context *ctxt)
@@ -149,6 +161,7 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt)
 	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
+	__sysreg_restore_el2_return_state(ctxt);
 }
 
 static void __hyp_text __fpsimd32_save_state(struct kvm_cpu_context *ctxt)
-- 
2.9.0
