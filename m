Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9F1C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 19:16:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDFC122280
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 19:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0pvE1sKe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDFC122280
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 610E84B556;
	Mon,  2 Nov 2020 14:16:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 81pMllocY8Ug; Mon,  2 Nov 2020 14:16:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A5BF44B5AA;
	Mon,  2 Nov 2020 14:16:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 564FB4B535
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 14:16:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id adwUa2N75eXB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 14:16:21 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37C4A4B5AA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 14:16:19 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EB1E3223BD;
 Mon,  2 Nov 2020 19:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604344578;
 bh=AtpHV5wJJBOkeD5f6w+jY11UMjEHrUBXFJL1igD+zkI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=0pvE1sKeW1L+qzNsQK/0YHwWk7u1rbm8sZJk/1krRYY3zdvKnfxWVA/QMkQhdxB4h
 0+BsdUHyad2Fb/wYGDnRPVDXBmWftY0olFVos4pYFF8Ltajkk9yoGCUi69xuEQMror
 /N649VM3KaLy3tw7GEhwmcY+ETc2XARkooFuuNew=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kZfJQ-006nxn-5p; Mon, 02 Nov 2020 19:16:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 7/8] KVM: arm64: Drop legacy copro shadow register
Date: Mon,  2 Nov 2020 19:16:08 +0000
Message-Id: <20201102191609.265711-8-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102191609.265711-1-maz@kernel.org>
References: <20201102191609.265711-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

Finally remove one of the biggest 32bit legacy: the copro shadow
mapping. We won't missit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 47 +------------------------------
 1 file changed, 1 insertion(+), 46 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2772a1421335..c527f9567713 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -201,48 +201,6 @@ enum vcpu_sysreg {
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
-/* 32bit mapping */
-#define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
-#define c0_CSSELR	(CSSELR_EL1 * 2)/* Cache Size Selection Register */
-#define c1_SCTLR	(SCTLR_EL1 * 2)	/* System Control Register */
-#define c1_ACTLR	(ACTLR_EL1 * 2)	/* Auxiliary Control Register */
-#define c1_CPACR	(CPACR_EL1 * 2)	/* Coprocessor Access Control */
-#define c2_TTBR0	(TTBR0_EL1 * 2)	/* Translation Table Base Register 0 */
-#define c2_TTBR0_high	(c2_TTBR0 + 1)	/* TTBR0 top 32 bits */
-#define c2_TTBR1	(TTBR1_EL1 * 2)	/* Translation Table Base Register 1 */
-#define c2_TTBR1_high	(c2_TTBR1 + 1)	/* TTBR1 top 32 bits */
-#define c2_TTBCR	(TCR_EL1 * 2)	/* Translation Table Base Control R. */
-#define c3_DACR		(DACR32_EL2 * 2)/* Domain Access Control Register */
-#define c5_DFSR		(ESR_EL1 * 2)	/* Data Fault Status Register */
-#define c5_IFSR		(IFSR32_EL2 * 2)/* Instruction Fault Status Register */
-#define c5_ADFSR	(AFSR0_EL1 * 2)	/* Auxiliary Data Fault Status R */
-#define c5_AIFSR	(AFSR1_EL1 * 2)	/* Auxiliary Instr Fault Status R */
-#define c6_DFAR		(FAR_EL1 * 2)	/* Data Fault Address Register */
-#define c6_IFAR		(c6_DFAR + 1)	/* Instruction Fault Address Register */
-#define c7_PAR		(PAR_EL1 * 2)	/* Physical Address Register */
-#define c7_PAR_high	(c7_PAR + 1)	/* PAR top 32 bits */
-#define c10_PRRR	(MAIR_EL1 * 2)	/* Primary Region Remap Register */
-#define c10_NMRR	(c10_PRRR + 1)	/* Normal Memory Remap Register */
-#define c12_VBAR	(VBAR_EL1 * 2)	/* Vector Base Address Register */
-#define c13_CID		(CONTEXTIDR_EL1 * 2)	/* Context ID Register */
-#define c13_TID_URW	(TPIDR_EL0 * 2)	/* Thread ID, User R/W */
-#define c13_TID_URO	(TPIDRRO_EL0 * 2)/* Thread ID, User R/O */
-#define c13_TID_PRIV	(TPIDR_EL1 * 2)	/* Thread ID, Privileged */
-#define c10_AMAIR0	(AMAIR_EL1 * 2)	/* Aux Memory Attr Indirection Reg */
-#define c10_AMAIR1	(c10_AMAIR0 + 1)/* Aux Memory Attr Indirection Reg */
-#define c14_CNTKCTL	(CNTKCTL_EL1 * 2) /* Timer Control Register (PL1) */
-
-#define cp14_DBGDSCRext	(MDSCR_EL1 * 2)
-#define cp14_DBGBCR0	(DBGBCR0_EL1 * 2)
-#define cp14_DBGBVR0	(DBGBVR0_EL1 * 2)
-#define cp14_DBGBXVR0	(cp14_DBGBVR0 + 1)
-#define cp14_DBGWCR0	(DBGWCR0_EL1 * 2)
-#define cp14_DBGWVR0	(DBGWVR0_EL1 * 2)
-#define cp14_DBGDCCINT	(MDCCINT_EL1 * 2)
-#define cp14_DBGVCR	(DBGVCR32_EL2 * 2)
-
-#define NR_COPRO_REGS	(NR_SYS_REGS * 2)
-
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
@@ -253,10 +211,7 @@ struct kvm_cpu_context {
 
 	struct user_fpsimd_state fp_regs;
 
-	union {
-		u64 sys_regs[NR_SYS_REGS];
-		u32 copro[NR_COPRO_REGS];
-	};
+	u64 sys_regs[NR_SYS_REGS];
 
 	struct kvm_vcpu *__hyp_running_vcpu;
 };
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
