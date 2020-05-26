Return-Path: <SRS0=x9SY=7I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD13C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 16:19:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EE6A20704
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 16:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EE6A20704
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DAFDC4B176;
	Tue, 26 May 2020 12:19:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V+tIyitU95E2; Tue, 26 May 2020 12:19:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAEAF4B164;
	Tue, 26 May 2020 12:19:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C513A4B111
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 12:19:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SKgLcxPYIt2z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 12:19:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CBEB4B108
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 12:19:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AAC755D;
 Tue, 26 May 2020 09:19:13 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F2473F52E;
 Tue, 26 May 2020 09:19:12 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] KVM: arm64: Stop save/restoring ACTLR_EL1
Date: Tue, 26 May 2020 16:18:33 +0000
Message-Id: <20200526161834.29165-3-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200526161834.29165-1-james.morse@arm.com>
References: <20200526161834.29165-1-james.morse@arm.com>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>
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

KVM sets HCR_EL2.TACR (which it calls HCR_TAC) via HCR_GUEST_FLAGS.
This means ACTLR* accesses from the guest are always trapped, and
always return the value in the sys_regs array.

The guest can't change the value of these registers, so we are
save restoring the reset value, which came from the host.

Stop save/restoring this register.

This also stops this register being affected by sysregs_loaded_on_cpu,
so we can provide 32 bit accessors that always use the in-memory copy.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kvm/hyp/sysreg-sr.c | 2 --
 arch/arm64/kvm/sys_regs.c      | 2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 75b1925763f1..57116cf3a1a5 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -44,7 +44,6 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[CSSELR_EL1]	= read_sysreg(csselr_el1);
 	ctxt->sys_regs[SCTLR_EL1]	= read_sysreg_el1(SYS_SCTLR);
-	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
 	ctxt->sys_regs[CPACR_EL1]	= read_sysreg_el1(SYS_CPACR);
 	ctxt->sys_regs[TTBR0_EL1]	= read_sysreg_el1(SYS_TTBR0);
 	ctxt->sys_regs[TTBR1_EL1]	= read_sysreg_el1(SYS_TTBR1);
@@ -133,7 +132,6 @@ static void __hyp_text __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 		isb();
 	}
 
-	write_sysreg(ctxt->sys_regs[ACTLR_EL1],		actlr_el1);
 	write_sysreg_el1(ctxt->sys_regs[CPACR_EL1],	SYS_CPACR);
 	write_sysreg_el1(ctxt->sys_regs[TTBR0_EL1],	SYS_TTBR0);
 	write_sysreg_el1(ctxt->sys_regs[TTBR1_EL1],	SYS_TTBR1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2eda539f3281..aae58513025c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -81,7 +81,6 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 	switch (reg) {
 	case CSSELR_EL1:	return read_sysreg_s(SYS_CSSELR_EL1);
 	case SCTLR_EL1:		return read_sysreg_s(SYS_SCTLR_EL12);
-	case ACTLR_EL1:		return read_sysreg_s(SYS_ACTLR_EL1);
 	case CPACR_EL1:		return read_sysreg_s(SYS_CPACR_EL12);
 	case TTBR0_EL1:		return read_sysreg_s(SYS_TTBR0_EL12);
 	case TTBR1_EL1:		return read_sysreg_s(SYS_TTBR1_EL12);
@@ -124,7 +123,6 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 	switch (reg) {
 	case CSSELR_EL1:	write_sysreg_s(val, SYS_CSSELR_EL1);	return;
 	case SCTLR_EL1:		write_sysreg_s(val, SYS_SCTLR_EL12);	return;
-	case ACTLR_EL1:		write_sysreg_s(val, SYS_ACTLR_EL1);	return;
 	case CPACR_EL1:		write_sysreg_s(val, SYS_CPACR_EL12);	return;
 	case TTBR0_EL1:		write_sysreg_s(val, SYS_TTBR0_EL12);	return;
 	case TTBR1_EL1:		write_sysreg_s(val, SYS_TTBR1_EL12);	return;
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
