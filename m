Return-Path: <SRS0=mTc3=YM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E158FCA9EAB
	for <kvmarm@archiver.kernel.org>; Sat, 19 Oct 2019 09:55:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A1DF222CC
	for <kvmarm@archiver.kernel.org>; Sat, 19 Oct 2019 09:55:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nt2VeCab"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A1DF222CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 537294AA78;
	Sat, 19 Oct 2019 05:55:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cjKD1gWd9mBF; Sat, 19 Oct 2019 05:55:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D5084AAA9;
	Sat, 19 Oct 2019 05:55:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F6504A948
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Oct 2019 05:55:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nG3UG4UPnWmz for <kvmarm@lists.cs.columbia.edu>;
 Sat, 19 Oct 2019 05:55:40 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A59D4AA98
 for <kvmarm@lists.cs.columbia.edu>; Sat, 19 Oct 2019 05:55:39 -0400 (EDT)
Received: from big-swifty.lan (78.163-31-62.static.virginmediabusiness.co.uk
 [62.31.163.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6253F222D2;
 Sat, 19 Oct 2019 09:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1571478938;
 bh=/BHwWAb8kea1kN6CGDZVKU3zOASIcTMHmEllourGtwM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Nt2VeCabzxc0pbTpxeH9OCZsa/doEDq5b0S3kx1dh0zgew5lOfs0BZSS10XrMJGxF
 ATKHsPCMXuH64Z+pzkieG6fJbLo0A/4ZqJ2mp2HtoB4jQL2UqhS5kgpzDnWKhh0a7t
 E3o9P/0JxOICBWnkSwABYA1U25SPUUnH7DRQ+jno=
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 4/5] arm64: KVM: Prevent speculative S1 PTW when restoring
 vcpu context
Date: Sat, 19 Oct 2019 10:55:20 +0100
Message-Id: <20191019095521.31722-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191019095521.31722-1-maz@kernel.org>
References: <20191019095521.31722-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

When handling erratum 1319367, we must ensure that the page table
walker cannot parse the S1 page tables while the guest is in an
inconsistent state. This is done as follows:

On guest entry:
- TCR_EL1.EPD{0,1} are set, ensuring that no PTW can occur
- all system registers are restored, except for TCR_EL1 and SCTLR_EL1
- stage-2 is restored
- SCTLR_EL1 and TCR_EL1 are restored

On guest exit:
- SCTLR_EL1.M and TCR_EL1.EPD{0,1} are set, ensuring that no PTW can occur
- stage-2 is disabled
- All host system registers are restored

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/switch.c    | 31 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c | 35 ++++++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 69e10b29cbd0..5765b17c38c7 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -118,6 +118,20 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 	}
 
 	write_sysreg(val, cptr_el2);
+
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
+		struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
+
+		isb();
+		/*
+		 * At this stage, and thanks to the above isb(), S2 is
+		 * configured and enabled. We can now restore the guest's S1
+		 * configuration: SCTLR, and only then TCR.
+		 */
+		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+		isb();
+		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+	}
 }
 
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
@@ -156,6 +170,23 @@ static void __hyp_text __deactivate_traps_nvhe(void)
 {
 	u64 mdcr_el2 = read_sysreg(mdcr_el2);
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
+		u64 val;
+
+		/*
+		 * Set the TCR and SCTLR registers in the exact opposite
+		 * sequence as __activate_traps_nvhe (first prevent walks,
+		 * then force the MMU on). A generous sprinkling of isb()
+		 * ensure that things happen in this exact order.
+		 */
+		val = read_sysreg_el1(SYS_TCR);
+		write_sysreg_el1(val | TCR_EPD1_MASK | TCR_EPD0_MASK, SYS_TCR);
+		isb();
+		val = read_sysreg_el1(SYS_SCTLR);
+		write_sysreg_el1(val | SCTLR_ELx_M, SYS_SCTLR);
+		isb();
+	}
+
 	__deactivate_traps_common();
 
 	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 7ddbc849b580..fb97547bfa79 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -117,12 +117,26 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[MPIDR_EL1],		vmpidr_el2);
 	write_sysreg(ctxt->sys_regs[CSSELR_EL1],	csselr_el1);
-	write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+
+	if (!cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
+		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+	} else	if (!ctxt->__hyp_running_vcpu) {
+		/*
+		 * Must only be done for guest registers, hence the context
+		 * test. We'recoming from the host, so SCTLR.M is already
+		 * set. Pairs with __activate_traps_nvhe().
+		 */
+		write_sysreg_el1((ctxt->sys_regs[TCR_EL1] |
+				  TCR_EPD1_MASK | TCR_EPD0_MASK),
+				 SYS_TCR);
+		isb();
+	}
+
 	write_sysreg(ctxt->sys_regs[ACTLR_EL1],		actlr_el1);
 	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	SYS_CPACR);
 	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
 	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
-	write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
 	write_sysreg_el1(ctxt->sys_regs[ESR_EL1],	SYS_ESR);
 	write_sysreg_el1(ctxt->sys_regs[AFSR0_EL1],	SYS_AFSR0);
 	write_sysreg_el1(ctxt->sys_regs[AFSR1_EL1],	SYS_AFSR1);
@@ -135,6 +149,23 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	write_sysreg(ctxt->sys_regs[PAR_EL1],		par_el1);
 	write_sysreg(ctxt->sys_regs[TPIDR_EL1],		tpidr_el1);
 
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367) &&
+	    ctxt->__hyp_running_vcpu) {
+		/*
+		 * Must only be done for host registers, hence the context
+		 * test. Pairs with __deactivate_traps_nvhe().
+		 */
+		isb();
+		/*
+		 * At this stage, and thanks to the above isb(), S2 is
+		 * deconfigured and disabled. We can now restore the host's
+		 * S1 configuration: SCTLR, and only then TCR.
+		 */
+		write_sysreg_el1(ctxt->sys_regs[SCTLR_EL1],	SYS_SCTLR);
+		isb();
+		write_sysreg_el1(ctxt->sys_regs[TCR_EL1],	SYS_TCR);
+	}
+
 	write_sysreg(ctxt->gp_regs.sp_el1,		sp_el1);
 	write_sysreg_el1(ctxt->gp_regs.elr_el1,		SYS_ELR);
 	write_sysreg_el1(ctxt->gp_regs.spsr[KVM_SPSR_EL1],SYS_SPSR);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
