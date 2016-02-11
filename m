From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 11/23] arm64: KVM: VHE: Split save/restore of registers
 shared between guest and host
Date: Thu, 11 Feb 2016 18:39:52 +0000
Message-ID: <1455216004-19499-12-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABF0949AC1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YRckhK6Bzo8f for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5267A49B6A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:31 -0500 (EST)
In-Reply-To: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

A handful of system registers are still shared between host and guest,
even while using VHE (tpidr*_el[01] and actlr_el1).

Also, some of the vcpu state (sp_el0, PC and PSTATE) must be
save/restored on entry/exit, as they are used on the host as well.

In order to facilitate the introduction of a VHE-specific sysreg
save/restore, make move the access to these registers to their
own save/restore functions.

No functional change.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 48 +++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index bd5b543..61bad17 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -23,13 +23,29 @@
 
 #include "hyp.h"
 
-/* ctxt is already in the HYP VA space */
+/*
+ * Non-VHE: Both host and guest must save everything.
+ *
+ * VHE: Host must save tpidr*_el[01], actlr_el1, sp0, pc, pstate, and
+ * guest must save everything.
+ */
+
+static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
+	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
+	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
+	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
+	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
+	ctxt->gp_regs.regs.pc		= read_sysreg(elr_el2);
+	ctxt->gp_regs.regs.pstate	= read_sysreg(spsr_el2);
+}
+
 static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
 	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg(sctlr_el1);
-	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
 	ctxt->sys_regs[CPACR_EL1]	= read_sysreg(cpacr_el1);
 	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg(ttbr0_el1);
 	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg(ttbr1_el1);
@@ -41,17 +57,11 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 	ctxt->sys_regs[MAIR_EL1]	= read_sysreg(mair_el1);
 	ctxt->sys_regs[VBAR_EL1]	= read_sysreg(vbar_el1);
 	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg(contextidr_el1);
-	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
-	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
-	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
 	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg(amair_el1);
 	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg(cntkctl_el1);
 	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
 	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
 
-	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
-	ctxt->gp_regs.regs.pc		= read_sysreg(elr_el2);
-	ctxt->gp_regs.regs.pstate	= read_sysreg(spsr_el2);
 	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
 	ctxt->gp_regs.elr_el1		= read_sysreg(elr_el1);
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg(spsr_el1);
@@ -60,11 +70,24 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_save_state(ctxt);
+	__sysreg_save_common_state(ctxt);
 }
 
 void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_save_state(ctxt);
+	__sysreg_save_common_state(ctxt);
+}
+
+static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
+{
+	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
+	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
+	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
+	write_sysreg(ctxt->sys_regs[TPIDR_EL1],	  tpidr_el1);
+	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
+	write_sysreg(ctxt->gp_regs.regs.pc,	  elr_el2);
+	write_sysreg(ctxt->gp_regs.regs.pstate,	  spsr_el2);
 }
 
 static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
@@ -72,7 +95,6 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],	  vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],  csselr_el1);
 	write_sysreg(ctxt->sys_regs[SCTLR_EL1],	  sctlr_el1);
-	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
 	write_sysreg(ctxt->sys_regs[CPACR_EL1],	  cpacr_el1);
 	write_sysreg(ctxt->sys_regs[TTBR0_EL1],	  ttbr0_el1);
 	write_sysreg(ctxt->sys_regs[TTBR1_EL1],	  ttbr1_el1);
@@ -84,17 +106,11 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->sys_regs[MAIR_EL1],	  mair_el1);
 	write_sysreg(ctxt->sys_regs[VBAR_EL1],	  vbar_el1);
 	write_sysreg(ctxt->sys_regs[CONTEXTIDR_EL1], contextidr_el1);
-	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
-	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
-	write_sysreg(ctxt->sys_regs[TPIDR_EL1],	  tpidr_el1);
 	write_sysreg(ctxt->sys_regs[AMAIR_EL1],	  amair_el1);
 	write_sysreg(ctxt->sys_regs[CNTKCTL_EL1], cntkctl_el1);
 	write_sysreg(ctxt->sys_regs[PAR_EL1],	  par_el1);
 	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
 
-	write_sysreg(ctxt->gp_regs.regs.sp,	sp_el0);
-	write_sysreg(ctxt->gp_regs.regs.pc,	elr_el2);
-	write_sysreg(ctxt->gp_regs.regs.pstate,	spsr_el2);
 	write_sysreg(ctxt->gp_regs.sp_el1,	sp_el1);
 	write_sysreg(ctxt->gp_regs.elr_el1,	elr_el1);
 	write_sysreg(ctxt->gp_regs.spsr[KVM_SPSR_EL1], spsr_el1);
@@ -103,11 +119,13 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_restore_state(ctxt);
+	__sysreg_restore_common_state(ctxt);
 }
 
 void __hyp_text __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt)
 {
 	__sysreg_restore_state(ctxt);
+	__sysreg_restore_common_state(ctxt);
 }
 
 void __hyp_text __sysreg32_save_state(struct kvm_vcpu *vcpu)
-- 
2.1.4
