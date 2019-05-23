Return-Path: <SRS0=jV2N=TX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D649CC282DD
	for <kvmarm@archiver.kernel.org>; Thu, 23 May 2019 10:35:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9825A2177E
	for <kvmarm@archiver.kernel.org>; Thu, 23 May 2019 10:35:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9825A2177E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 445084A500;
	Thu, 23 May 2019 06:35:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yb69Q9Nb8QSR; Thu, 23 May 2019 06:35:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7BB14A501;
	Thu, 23 May 2019 06:35:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C854A4A4C2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 May 2019 06:35:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ohQGB9xOPgwG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 May 2019 06:35:35 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5D34A4F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 May 2019 06:35:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04C95341;
 Thu, 23 May 2019 03:35:35 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E58CD3F718;
 Thu, 23 May 2019 03:35:32 -0700 (PDT)
From: Sudeep Holla <sudeep.holla@arm.com>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 06/15] arm64: KVM/VHE: enable the use PMSCR_EL12 on VHE
 systems
Date: Thu, 23 May 2019 11:34:53 +0100
Message-Id: <20190523103502.25925-7-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Currently, we are just using PMSCR_EL1 in the host for non VHE systems.
We already have the {read,write}_sysreg_el*() accessors for accessing
particular ELs' sysregs in the presence of VHE.

Lets just define PMSCR_EL12 and start making use of it here which will
access the right register on both VHE and non VHE systems. This change
is required to add SPE guest support on VHE systems.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 1 +
 arch/arm64/kvm/hyp/debug-sr.c    | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index f61378b77c9f..782955db61dd 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -103,6 +103,7 @@
 #define afsr1_EL12              sys_reg(3, 5, 5, 1, 1)
 #define esr_EL12                sys_reg(3, 5, 5, 2, 0)
 #define far_EL12                sys_reg(3, 5, 6, 0, 0)
+#define SYS_PMSCR_EL12          sys_reg(3, 5, 9, 9, 0)
 #define mair_EL12               sys_reg(3, 5, 10, 2, 0)
 #define amair_EL12              sys_reg(3, 5, 10, 3, 0)
 #define vbar_EL12               sys_reg(3, 5, 12, 0, 0)
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index 50009766e5e5..fa51236ebcb3 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -89,8 +89,8 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
 		return;
 
 	/* Yes; save the control register and disable data generation */
-	*pmscr_el1 = read_sysreg_s(SYS_PMSCR_EL1);
-	write_sysreg_s(0, SYS_PMSCR_EL1);
+	*pmscr_el1 = read_sysreg_el1_s(SYS_PMSCR);
+	write_sysreg_el1_s(0, SYS_PMSCR);
 	isb();
 
 	/* Now drain all buffered data to memory */
@@ -107,7 +107,7 @@ static void __hyp_text __debug_restore_spe_nvhe(u64 pmscr_el1)
 	isb();
 
 	/* Re-enable data generation */
-	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
+	write_sysreg_el1_s(pmscr_el1, SYS_PMSCR);
 }
 
 static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
