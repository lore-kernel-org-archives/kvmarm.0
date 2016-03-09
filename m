From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 41/95] arm64: KVM: VHE: Use unified system register accessors
Date: Wed,  9 Mar 2016 07:30:35 +0000
Message-ID: <1457508689-19672-42-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDB0A49B37
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DmTaR5jQL5FT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:33:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA9449B2F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:33:41 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Use the recently introduced unified system register accessors for
those sysregs that behave differently depending on VHE being in
use or not.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 84 +++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 61bad17..7d7d757 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -37,34 +37,34 @@ static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
 	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
 	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
-	ctxt->gp_regs.regs.pc		= read_sysreg(elr_el2);
-	ctxt->gp_regs.regs.pstate	= read_sysreg(spsr_el2);
+	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
+	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
 }
 
 static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MPIDR_EL1]	= read_sysreg(vmpidr_el2);
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
-	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg(sctlr_el1);
-	ctxt->sys_regs[CPACR_EL1]	= read_sysreg(cpacr_el1);
-	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg(ttbr0_el1);
-	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg(ttbr1_el1);
-	ctxt->sys_regs[TCR_EL1]		= read_sysreg(tcr_el1);
-	ctxt->sys_regs[ESR_EL1]		= read_sysreg(esr_el1);
-	ctxt->sys_regs[AFSR0_EL1]	= read_sysreg(afsr0_el1);
-	ctxt->sys_regs[AFSR1_EL1]	= read_sysreg(afsr1_el1);
-	ctxt->sys_regs[FAR_EL1]		= read_sysreg(far_el1);
-	ctxt->sys_regs[MAIR_EL1]	= read_sysreg(mair_el1);
-	ctxt->sys_regs[VBAR_EL1]	= read_sysreg(vbar_el1);
-	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg(contextidr_el1);
-	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg(amair_el1);
-	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg(cntkctl_el1);
+	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(sctlr);
+	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(cpacr);
+	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(ttbr0);
+	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(ttbr1);
+	ctxt->sys_regs[TCR_EL1]		= read_sysreg_el1(tcr);
+	ctxt->sys_regs[ESR_EL1]		= read_sysreg_el1(esr);
+	ctxt->sys_regs[AFSR0_EL1]	= read_sysreg_el1(afsr0);
+	ctxt->sys_regs[AFSR1_EL1]	= read_sysreg_el1(afsr1);
+	ctxt->sys_regs[FAR_EL1]		= read_sysreg_el1(far);
+	ctxt->sys_regs[MAIR_EL1]	= read_sysreg_el1(mair);
+	ctxt->sys_regs[VBAR_EL1]	= read_sysreg_el1(vbar);
+	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(contextidr);
+	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(amair);
+	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(cntkctl);
 	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
 	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
 
 	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
-	ctxt->gp_regs.elr_el1		= read_sysreg(elr_el1);
-	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg(spsr_el1);
+	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
+	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
 }
 
 void __hyp_text __sysreg_save_host_state(struct kvm_cpu_context *ctxt)
@@ -86,34 +86,34 @@ static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctx
 	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
 	write_sysreg(ctxt->sys_regs[TPIDR_EL1],	  tpidr_el1);
 	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
-	write_sysreg(ctxt->gp_regs.regs.pc,	  elr_el2);
-	write_sysreg(ctxt->gp_regs.regs.pstate,	  spsr_el2);
+	write_sysreg_el2(ctxt->gp_regs.regs.pc,	  elr);
+	write_sysreg_el2(ctxt->gp_regs.regs.pstate, spsr);
 }
 
 static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 {
-	write_sysreg(ctxt->sys_regs[MPIDR_EL1],	  vmpidr_el2);
-	write_sysreg(ctxt->sys_regs[CSSELR_EL1],  csselr_el1);
-	write_sysreg(ctxt->sys_regs[SCTLR_EL1],	  sctlr_el1);
-	write_sysreg(ctxt->sys_regs[CPACR_EL1],	  cpacr_el1);
-	write_sysreg(ctxt->sys_regs[TTBR0_EL1],	  ttbr0_el1);
-	write_sysreg(ctxt->sys_regs[TTBR1_EL1],	  ttbr1_el1);
-	write_sysreg(ctxt->sys_regs[TCR_EL1],	  tcr_el1);
-	write_sysreg(ctxt->sys_regs[ESR_EL1],	  esr_el1);
-	write_sysreg(ctxt->sys_regs[AFSR0_EL1],	  afsr0_el1);
-	write_sysreg(ctxt->sys_regs[AFSR1_EL1],	  afsr1_el1);
-	write_sysreg(ctxt->sys_regs[FAR_EL1],	  far_el1);
-	write_sysreg(ctxt->sys_regs[MAIR_EL1],	  mair_el1);
-	write_sysreg(ctxt->sys_regs[VBAR_EL1],	  vbar_el1);
-	write_sysreg(ctxt->sys_regs[CONTEXTIDR_EL1], contextidr_el1);
-	write_sysreg(ctxt->sys_regs[AMAIR_EL1],	  amair_el1);
-	write_sysreg(ctxt->sys_regs[CNTKCTL_EL1], cntkctl_el1);
-	write_sysreg(ctxt->sys_regs[PAR_EL1],	  par_el1);
-	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
-
-	write_sysreg(ctxt->gp_regs.sp_el1,	sp_el1);
-	write_sysreg(ctxt->gp_regs.elr_el1,	elr_el1);
-	write_sysreg(ctxt->gp_regs.spsr[KVM_SPSR_EL1], spsr_el1);
+	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
+	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
+	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	sctlr);
+	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	cpacr);
+	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	ttbr0);
+	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	ttbr1);
+	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	tcr);
+	write_sysreg_el1(ctxt->sys_regs[ESR_EL1],	esr);
+	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL1],	afsr0);
+	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL1],	afsr1);
+	write_sysreg_el1(ctxt->sys_regs[FAR_EL1],	far);
+	write_sysreg_el1(ctxt->sys_regs[MAIR_EL1],	mair);
+	write_sysreg_el1(ctxt->sys_regs[VBAR_EL1],	vbar);
+	write_sysreg_el1(ctxt->sys_regs[CONTEXTIDR_EL1],contextidr);
+	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL1],	amair);
+	write_sysreg_el1(ctxt->sys_regs[CNTKCTL_EL1], 	cntkctl);
+	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
+	write_sysreg(ctxt->sys_regs[MDSCR_EL1],		mdscr_el1);
+
+	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
+	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
+	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
 }
 
 void __hyp_text __sysreg_restore_host_state(struct kvm_cpu_context *ctxt)
-- 
2.1.4
