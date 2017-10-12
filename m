From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 17/37] KVM: arm64: Move userspace system registers into
 separate function
Date: Thu, 12 Oct 2017 12:41:21 +0200
Message-ID: <20171012104141.26902-18-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DBA249D78
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LQrByNQNtivG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:21 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BF4D949D31
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:21 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id i124so11857870wmf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:06 -0700 (PDT)
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

There's a semantic difference between the EL1 registers that control
operation of a kernel running in EL1 and EL1 registers that only control
userspace execution in EL0.  Since we can defer saving/restoring the
latter, move them into their own function.

We also take this chance to rename the function saving/restoring the
remaining system register to make it clear this function deals with
the EL1 system registers.

No functional change.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index c4a3714..193c2b0 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -34,14 +34,18 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
 
 static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
+	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
+	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
+}
+
+static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
+{
 	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
 	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
 	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
-	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
-	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
 }
 
-static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
+static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
@@ -70,31 +74,37 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 }
 
 static hyp_alternate_select(__sysreg_call_save_host_state,
-			    __sysreg_save_state, __sysreg_do_nothing,
+			    __sysreg_save_el1_state, __sysreg_do_nothing,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
 void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_call_save_host_state()(ctxt);
 	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
 }
 
 void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_save_state(ctxt);
+	__sysreg_save_el1_state(ctxt);
 	__sysreg_save_common_state(ctxt);
+	__sysreg_save_user_state(ctxt);
 }
 
 static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
-	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
-	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
 	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
 	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
 }
 
-static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
+static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
+{
+	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  	actlr_el1);
+	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  	tpidr_el0);
+	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], 	tpidrro_el0);
+}
+
+static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
@@ -123,19 +133,21 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 }
 
 static hyp_alternate_select(__sysreg_call_restore_host_state,
-			    __sysreg_restore_state, __sysreg_do_nothing,
+			    __sysreg_restore_el1_state, __sysreg_do_nothing,
 			    ARM64_HAS_VIRT_HOST_EXTN);
 
 void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_call_restore_host_state()(ctxt);
 	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
 }
 
 void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_restore_state(ctxt);
+	__sysreg_restore_el1_state(ctxt);
 	__sysreg_restore_common_state(ctxt);
+	__sysreg_restore_user_state(ctxt);
 }
 
 static void __hyp_text __fpsimd32_save_state(struct kvm_cpu_context *ctxt)
-- 
2.9.0
