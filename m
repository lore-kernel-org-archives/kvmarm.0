Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92543C5518F
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B8DE221EB
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yhYsqogU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B8DE221EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAB584B160;
	Wed, 22 Apr 2020 08:21:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mtQY2UYrEcim; Wed, 22 Apr 2020 08:21:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C25D04B196;
	Wed, 22 Apr 2020 08:21:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 290994B13A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fFMpVy5grgDF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 08:21:19 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 448494B185
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:21:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 74E7C217BA;
 Wed, 22 Apr 2020 12:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587558071;
 bh=3DfBWnjoftiMKEV8n/oHnQrUy1AFUy0M8vMHJgyQgDQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=yhYsqogUMKn1g1v2Sg8c0LVBe/0g412wtS5WOpM16KFnv/oHZxPEPa4/aVevGTgx7
 P3vgJn9VM6Uunn+F6jlqCmZFBjfHuJQPJAjOhnMhvLsiYDX0kDsAQIBO1ZyD/AOxsH
 vXOImoveedTfP49+iiNvTL2nWhQdg8iDzyDjOq2k=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRE3t-005UI7-3d; Wed, 22 Apr 2020 13:01:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 11/26] KVM: arm64: Add missing reset handlers for PMU emulation
Date: Wed, 22 Apr 2020 13:00:35 +0100
Message-Id: <20200422120050.3693593-12-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>
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

As we're about to become a bit more harsh when it comes to the lack of
reset callbacks, let's add the missing PMU reset handlers. Note that
these only cover *CLR registers that were always covered by their *SET
counterpart, so there is no semantic change here.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 46f218982df8c..c9443960b36e4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1553,7 +1553,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
 	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
-	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, NULL, PMINTENSET_EL1 },
+	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
@@ -1592,8 +1592,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_PMCR_EL0), access_pmcr, reset_pmcr, PMCR_EL0 },
 	{ SYS_DESC(SYS_PMCNTENSET_EL0), access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
-	{ SYS_DESC(SYS_PMCNTENCLR_EL0), access_pmcnten, NULL, PMCNTENSET_EL0 },
-	{ SYS_DESC(SYS_PMOVSCLR_EL0), access_pmovs, NULL, PMOVSSET_EL0 },
+	{ SYS_DESC(SYS_PMCNTENCLR_EL0), access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
+	{ SYS_DESC(SYS_PMOVSCLR_EL0), access_pmovs, reset_unknown, PMOVSSET_EL0 },
 	{ SYS_DESC(SYS_PMSWINC_EL0), access_pmswinc, reset_unknown, PMSWINC_EL0 },
 	{ SYS_DESC(SYS_PMSELR_EL0), access_pmselr, reset_unknown, PMSELR_EL0 },
 	{ SYS_DESC(SYS_PMCEID0_EL0), access_pmceid },
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
