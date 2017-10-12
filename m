From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 09/37] KVM: arm64: Move debug dirty flag calculation out of
 world switch
Date: Thu, 12 Oct 2017 12:41:13 +0200
Message-ID: <20171012104141.26902-10-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0713F49D43
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IpeVPGM0Q5Am for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:11 -0400 (EDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 00D1049D7B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:10 -0400 (EDT)
Received: by mail-wm0-f42.google.com with SMTP id i124so11856472wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:41:55 -0700 (PDT)
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

There is no need to figure out inside the world-switch if we should
save/restore the debug registers or not, we can might as well do that in
the higher level debug setup code, making it easier to optimize down the
line.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/debug.c        | 9 +++++++++
 arch/arm64/kvm/hyp/debug-sr.c | 6 ------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index dbadfaf..62550de19 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -193,6 +193,15 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 	if (trap_debug)
 		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
 
+	/*
+	 * If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY is set, perform
+	 * a full save/restore cycle.
+	 */
+	if ((vcpu_sys_reg(vcpu, MDSCR_EL1) & DBG_MDSCR_KDE) ||
+	    (vcpu_sys_reg(vcpu, MDSCR_EL1) & DBG_MDSCR_MDE))
+		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
+
+
 	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_sys_reg(vcpu, MDSCR_EL1));
 }
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index f5154ed..0fc0758 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -172,12 +172,6 @@ void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 
 void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
 {
-	/* If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY is set, perform
-	 * a full save/restore cycle. */
-	if ((vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_KDE) ||
-	    (vcpu->arch.ctxt.sys_regs[MDSCR_EL1] & DBG_MDSCR_MDE))
-		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
-
 	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
 			   kern_hyp_va(vcpu->arch.host_cpu_context));
 	__debug_save_spe()(&vcpu->arch.host_debug_state.pmscr_el1);
-- 
2.9.0
