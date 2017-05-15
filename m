From: James Morse <james.morse@arm.com>
Subject: [PATCH 05/11] arm64: KVM: Stop save/restoring host tpidr_el1 on VHE
Date: Mon, 15 May 2017 18:43:53 +0100
Message-ID: <20170515174400.29735-6-james.morse@arm.com>
References: <20170515174400.29735-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2D0408EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:42:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fo4D9xqq1hbj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 May 2017 13:42:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B149740C36
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 13:42:41 -0400 (EDT)
In-Reply-To: <20170515174400.29735-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that a VHE host uses tpidr_el2 for the cpu offset we no longer
need KVM to save/restore tpidr_el1. Move this from the 'common' code
into the non-vhe code. While we're at it, on VHE we don't need to
save the ELR or SPSR as kernel_entry in entry.S will have pushed these
onto the kernel stack, and will restore them from there. Move these
to the non-vhe code as we need them to get back to the host.

Finally remove the always-copy-tpidr we hid in the stage2 setup
code, cpufeature's enable callback will do this for VHE, we only
need KVM to do it for non-vhe. Add the copy into kvm-init instead.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/hyp-init.S      |  4 ++++
 arch/arm64/kvm/hyp/s2-setup.c  |  3 ---
 arch/arm64/kvm/hyp/sysreg-sr.c | 16 ++++++++--------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 839425c24b1c..b8219801bb28 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -119,6 +119,10 @@ __do_hyp_init:
 	kern_hyp_va	x2
 	msr	vbar_el2, x2
 
+	/* copy tpidr_el1 into tpidr_el2 for use by HYP */
+	mrs	x1, tpidr_el1
+	msr	tpidr_el2, x1
+
 	/* Hello, World! */
 	eret
 ENDPROC(__kvm_hyp_init)
diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
index eb401dbb285e..b81f4091c909 100644
--- a/arch/arm64/kvm/hyp/s2-setup.c
+++ b/arch/arm64/kvm/hyp/s2-setup.c
@@ -84,8 +84,5 @@ u32 __hyp_text __init_stage2_translation(void)
 
 	write_sysreg(val, vtcr_el2);
 
-	/* copy tpidr_el1 into tpidr_el2 for use by HYP */
-	write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
-
 	return parange;
 }
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 934137647837..c54cc2afb92b 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -27,8 +27,8 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
 /*
  * Non-VHE: Both host and guest must save everything.
  *
- * VHE: Host must save tpidr*_el[01], actlr_el1, mdscr_el1, sp0, pc,
- * pstate, and guest must save everything.
+ * VHE: Host must save tpidr*_el0, actlr_el1, mdscr_el1, sp_el0,
+ * and guest must save everything.
  */
 
 static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
@@ -36,11 +36,8 @@ static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
 	ctxt->sys_regs[TPIDR_EL0]	= read_sysreg(tpidr_el0);
 	ctxt->sys_regs[TPIDRRO_EL0]	= read_sysreg(tpidrro_el0);
-	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
 	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
 	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
-	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
-	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
 }
 
 static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
@@ -62,10 +59,13 @@ static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
 	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(amair);
 	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(cntkctl);
 	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
+	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
 
 	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
 	ctxt->gp_regs.elr_el1		= read_sysreg_el1(elr);
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1]= read_sysreg_el1(spsr);
+	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
+	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
 }
 
 static hyp_alternate_select(__sysreg_call_save_host_state,
@@ -89,11 +89,8 @@ static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctx
 	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
 	write_sysreg(ctxt->sys_regs[TPIDR_EL0],	  tpidr_el0);
 	write_sysreg(ctxt->sys_regs[TPIDRRO_EL0], tpidrro_el0);
-	write_sysreg(ctxt->sys_regs[TPIDR_EL1],	  tpidr_el1);
 	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
 	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
-	write_sysreg_el2(ctxt->gp_regs.regs.pc,	  elr);
-	write_sysreg_el2(ctxt->gp_regs.regs.pstate, spsr);
 }
 
 static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
@@ -115,10 +112,13 @@ static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
 	write_sysreg_el1(ctxt->sys_regs[AMAIR_EL1],	amair);
 	write_sysreg_el1(ctxt->sys_regs[CNTKCTL_EL1], 	cntkctl);
 	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
+	write_sysreg(ctxt->sys_regs[TPIDR_EL1],		tpidr_el1);
 
 	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
 	write_sysreg_el1(ctxt->gp_regs.elr_el1,		elr);
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],spsr);
+	write_sysreg_el2(ctxt->gp_regs.regs.pc,		elr);
+	write_sysreg_el2(ctxt->gp_regs.regs.pstate,	spsr);
 }
 
 static hyp_alternate_select(__sysreg_call_restore_host_state,
-- 
2.10.1
