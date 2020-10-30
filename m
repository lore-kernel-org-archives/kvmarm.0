Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0986EC55178
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87ED320727
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 16:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJBw+RAx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87ED320727
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24BD64B235;
	Fri, 30 Oct 2020 12:40:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cOQsAKkCoH6c; Fri, 30 Oct 2020 12:40:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 322614B560;
	Fri, 30 Oct 2020 12:40:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22E604B2E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l5WdJemC0CpU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 12:40:29 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD2744B21C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 12:40:28 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D2AFD20727;
 Fri, 30 Oct 2020 16:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604076028;
 bh=HtWWeoMKIGDHZfzIKVlwwzCwnmFm0Tolm4f/tzLXjoA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GJBw+RAxHSAGWD48A9sm79c8bn3CFyg6udALKrOlt6HuL2+weMRIfkN2ydw09d6xN
 RWoHmaPTdhqvIS0cbxuS9YqJI3Vd56ckzpUDxrvx85PkremgqZ3ZOVunpHgXmQB7CG
 0UkEEAqRfRv/C8S4EVdZwabDf2EZQsT5tWULNaCg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kYXRy-005noK-2K; Fri, 30 Oct 2020 16:40:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 05/12] KVM: arm64: Fix AArch32 handling of DBGD{CCINT,
 SCRext} and DBGVCR
Date: Fri, 30 Oct 2020 16:40:10 +0000
Message-Id: <20201030164017.244287-6-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com,
 james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com,
 qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com,
 will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, stable@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Will Deacon <will@kernel.org>, Qais Yousef <qais.yousef@arm.com>
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

Fixes: bdfb4b389c8d ("arm64: KVM: add trap handlers for AArch32 debug registers")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201029172409.2768336-1-maz@kernel.org
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/sys_regs.c         | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0aecbab6a7fb..781d029b8aa8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -239,6 +239,7 @@ enum vcpu_sysreg {
 #define cp14_DBGWCR0	(DBGWCR0_EL1 * 2)
 #define cp14_DBGWVR0	(DBGWVR0_EL1 * 2)
 #define cp14_DBGDCCINT	(MDCCINT_EL1 * 2)
+#define cp14_DBGVCR	(DBGVCR32_EL2 * 2)
 
 #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3c203cb8c103..983994f01a63 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1881,9 +1881,9 @@ static const struct sys_reg_desc cp14_regs[] = {
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
@@ -1898,7 +1898,7 @@ static const struct sys_reg_desc cp14_regs[] = {
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
