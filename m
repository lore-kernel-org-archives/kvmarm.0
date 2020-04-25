Return-Path: <SRS0=i7fx=6J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80AFDC55186
	for <kvmarm@archiver.kernel.org>; Sat, 25 Apr 2020 09:43:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E420820714
	for <kvmarm@archiver.kernel.org>; Sat, 25 Apr 2020 09:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pm7FFlsm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E420820714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B5034B248;
	Sat, 25 Apr 2020 05:43:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KJys6uc5PEhu; Sat, 25 Apr 2020 05:43:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0BB4B2A0;
	Sat, 25 Apr 2020 05:43:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C48D44B28E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 05:43:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RqW-oHP1iffD for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Apr 2020 05:43:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AEDD4B248
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Apr 2020 05:43:32 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 39A5220704;
 Sat, 25 Apr 2020 09:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587807811;
 bh=zvYrOISsqhXXkpkz+TnXeLEkWvfF6n0Y6JOs4aslC1Y=;
 h=From:To:Cc:Subject:Date:From;
 b=pm7FFlsmPkKp8TRBVHkn7sGO3WZwHKBkL8zyVIh59CSu7eHk0PQR6xoxnHgrJ9R3W
 eBrixxYSdRgIQCGCUKDbX396hH8AFk7mfOL5+aXT8Uzid50aBKXjUcyyeIyLxPzcjk
 yWzPZsttMPHCgUNPvCnNH8FICm+EU7luhE5eU8cY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jSHLN-006HA5-DN; Sat, 25 Apr 2020 10:43:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Save/restore sp_el0 as part of __guest_enter
Date: Sat, 25 Apr 2020 10:43:21 +0100
Message-Id: <20200425094321.162752-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

We currently save/restore sp_el0 in C code. This is a bit unsafe,
as a lot of the C code expects 'current' to be accessible from
there (and the opportunity to run kernel code in HYP is specially
great with VHE).

Instead, let's move the save/restore of sp_el0 to the assembly
code (in __guest_enter), making sure that sp_el0 is correct
very early on when we exit the guest, and is preserved as long
as possible to its host value when we enter the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/entry.S     | 23 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c | 17 +++--------------
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index d22d0534dd600..90186cf6473e0 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -18,6 +18,7 @@
 
 #define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
 #define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
+#define CPU_SP_EL0_OFFSET	(CPU_XREG_OFFSET(30) + 8)
 
 	.text
 	.pushsection	.hyp.text, "ax"
@@ -47,6 +48,16 @@
 	ldp	x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
 .endm
 
+.macro save_sp_el0 ctxt, tmp
+	mrs	\tmp,	sp_el0
+	str	\tmp,	[\ctxt, #CPU_SP_EL0_OFFSET]
+.endm
+
+.macro restore_sp_el0 ctxt, tmp
+	ldr	\tmp,	  [\ctxt, #CPU_SP_EL0_OFFSET]
+	msr	sp_el0, \tmp
+.endm
+
 /*
  * u64 __guest_enter(struct kvm_vcpu *vcpu,
  *		     struct kvm_cpu_context *host_ctxt);
@@ -60,6 +71,9 @@ SYM_FUNC_START(__guest_enter)
 	// Store the host regs
 	save_callee_saved_regs x1
 
+	// Save the host's sp_el0
+	save_sp_el0	x1, x2
+
 	// Now the host state is stored if we have a pending RAS SError it must
 	// affect the host. If any asynchronous exception is pending we defer
 	// the guest entry. The DSB isn't necessary before v8.2 as any SError
@@ -83,6 +97,9 @@ alternative_else_nop_endif
 	// when this feature is enabled for kernel code.
 	ptrauth_switch_to_guest x29, x0, x1, x2
 
+	// Restore the guest's sp_el0
+	restore_sp_el0 x29, x0
+
 	// Restore guest regs x0-x17
 	ldp	x0, x1,   [x29, #CPU_XREG_OFFSET(0)]
 	ldp	x2, x3,   [x29, #CPU_XREG_OFFSET(2)]
@@ -130,6 +147,9 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Store the guest regs x18-x29, lr
 	save_callee_saved_regs x1
 
+	// Store the guest's sp_el0
+	save_sp_el0	x1, x2
+
 	get_host_ctxt	x2, x3
 
 	// Macro ptrauth_switch_to_guest format:
@@ -139,6 +159,9 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// when this feature is enabled for kernel code.
 	ptrauth_switch_to_host x1, x2, x3, x4, x5
 
+	// Restore the hosts's sp_el0
+	restore_sp_el0 x2, x3
+
 	// Now restore the host regs
 	restore_callee_saved_regs x2
 
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 75b1925763f16..6d2df9fe0b5d2 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -15,8 +15,9 @@
 /*
  * Non-VHE: Both host and guest must save everything.
  *
- * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and pstate,
- * which are handled as part of the el2 return state) on every switch.
+ * VHE: Host and guest must save mdscr_el1 and sp_el0 (and the PC and
+ * pstate, which are handled as part of the el2 return state) on every
+ * switch (sp_el0 is being dealt with in the assembly code).
  * tpidr_el0 and tpidrro_el0 only need to be switched when going
  * to host userspace or a different VCPU.  EL1 registers only need to be
  * switched when potentially going to run a different VCPU.  The latter two
@@ -26,12 +27,6 @@
 static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[MDSCR_EL1]	= read_sysreg(mdscr_el1);
-
-	/*
-	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
-	 * therefore be saved/restored on every entry/exit to/from the guest.
-	 */
-	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
 }
 
 static void __hyp_text __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
@@ -99,12 +94,6 @@ NOKPROBE_SYMBOL(sysreg_save_guest_state_vhe);
 static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MDSCR_EL1],	  mdscr_el1);
-
-	/*
-	 * The host arm64 Linux uses sp_el0 to point to 'current' and it must
-	 * therefore be saved/restored on every entry/exit to/from the guest.
-	 */
-	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
 }
 
 static void __hyp_text __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
