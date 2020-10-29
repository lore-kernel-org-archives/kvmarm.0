Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F150C55179
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 17:24:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D949A206CB
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 17:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qz0o8Qs6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D949A206CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1365E4B608;
	Thu, 29 Oct 2020 13:24:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rblffxl8X5aM; Thu, 29 Oct 2020 13:24:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E30684B609;
	Thu, 29 Oct 2020 13:24:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 973484B605
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 13:24:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NWBf7bE33P1v for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 13:24:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E1EC4B289
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 13:24:27 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 30652206CB;
 Thu, 29 Oct 2020 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603992266;
 bh=gfxtWHBGo7NtfP7tLPK6RFZyeD7tCsd/8WBmZ+nR6YY=;
 h=From:To:Cc:Subject:Date:From;
 b=Qz0o8Qs612ufqKClnWj5umhRrwTci7gM4hnRQjVEiEngEZTKd1kT2bJkOJZTZnmRd
 cYpPPMcTZPPWQ8qifnSDSbJRDyBlL4iufRqh/FGZPu0aLgFdpXkFMz2igZQPLDc+bi
 2kvULfEEvoSwm5EV7cccDt4jDS//UDtakQZfcIcc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYBex-005VVb-Py; Thu, 29 Oct 2020 17:24:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: Fix AArch32 handling of DBGD{CCINT,
 SCRext} and DBGVCR
Date: Thu, 29 Oct 2020 17:24:09 +0000
Message-Id: <20201029172409.2768336-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, stable@vger.kernel.org
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

The DBGD{CCINT,SCRext} and DBGVCR register entries in the cp14 array
are missing their target register, resulting in all accesses being
targetted at the guard sysreg (indexed by __INVALID_SYSREG__).

Point the emulation code at the actual register entries.

Cc: stable@vger.kernel.org
Fixes: bdfb4b389c8d ("arm64: KVM: add trap handlers for AArch32 debug registers")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/sys_regs.c         | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0fdd3e4fe60e..993cbc616ea2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -239,6 +239,7 @@ enum vcpu_sysreg {
 #define cp14_DBGWCR0	(DBGWCR0_EL1 * 2)
 #define cp14_DBGWVR0	(DBGWVR0_EL1 * 2)
 #define cp14_DBGDCCINT	(MDCCINT_EL1 * 2)
+#define cp14_DBGVCR	(DBGVCR32_EL2 * 2)
 
 #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f7415c9dbcd9..26c7c25f8a6d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1816,9 +1816,9 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 1), Op2( 0), trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(1),
 	/* DBGDCCINT */
-	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), trap_debug32, NULL, cp14_DBGDCCINT },
 	/* DBGDSCRext */
-	{ Op1( 0), CRn( 0), CRm( 2), Op2( 2), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 2), Op2( 2), trap_debug32, NULL, cp14_DBGDSCRext },
 	DBG_BCR_BVR_WCR_WVR(2),
 	/* DBGDTR[RT]Xint */
 	{ Op1( 0), CRn( 0), CRm( 3), Op2( 0), trap_raz_wi },
@@ -1833,7 +1833,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 6), Op2( 2), trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(6),
 	/* DBGVCR */
-	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug32, NULL, cp14_DBGVCR },
 	DBG_BCR_BVR_WCR_WVR(7),
 	DBG_BCR_BVR_WCR_WVR(8),
 	DBG_BCR_BVR_WCR_WVR(9),
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
