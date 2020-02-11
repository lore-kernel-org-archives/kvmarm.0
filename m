Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33071C35242
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:52:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA5D020848
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="rqo6v8mW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA5D020848
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C744ACFA;
	Tue, 11 Feb 2020 12:52:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Lj3aQfgQFGuA; Tue, 11 Feb 2020 12:52:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78A754AECB;
	Tue, 11 Feb 2020 12:52:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC5140456
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:52:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xt9sLA6afD-c for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 12:52:37 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1EA6B4AEE1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:52:37 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 533C420661;
 Tue, 11 Feb 2020 17:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581443556;
 bh=BuazaigYiOjbw5OaE0ORfLHMkxH+BvQZJ5Hej8ql+c8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=rqo6v8mWLi2mt25ST/XQVirargdmB+2vIAEAWzqahpkBU7fm62xg5sdMjZEshKMFd
 bRuR2+k6ll7CzKzFCndRg9N3HtclCooo0U7QN8wCmhh1G5Ga7mUOdU7JHqMqhR6uXz
 FesE2+uURoDm2sNXe3rHhVEs/FDilbt4aSHjyLYA=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j1Zfl-004O7k-NB; Tue, 11 Feb 2020 17:50:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 28/94] KVM: arm64: nv: Emulate EL12 register accesses from
 the virtual EL2
Date: Tue, 11 Feb 2020 17:48:32 +0000
Message-Id: <20200211174938.27809-29-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

From: Jintack Lim <jintack.lim@linaro.org>

With HCR_EL2.NV bit set, accesses to EL12 registers in the virtual EL2
trap to EL2. Handle those traps just like we do for EL1 registers.

One exception is CNTKCTL_EL12. We don't trap on CNTKCTL_EL1 for non-VHE
virtual EL2 because we don't have to. However, accessing CNTKCTL_EL12
will trap since it's one of the EL12 registers controlled by HCR_EL2.NV
bit.  Therefore, add a handler for it and don't treat it as a
non-trap-registers when preparing a shadow context.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2ce85d5e7111..dd4f8fe143ba 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2057,6 +2057,23 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CNTVOFF_EL2), access_rw, reset_val, CNTVOFF_EL2, 0 },
 	{ SYS_DESC(SYS_CNTHCTL_EL2), access_rw, reset_val, CNTHCTL_EL2, 0 },
 
+	{ SYS_DESC(SYS_SCTLR_EL12), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
+	{ SYS_DESC(SYS_CPACR_EL12), access_rw, reset_val, CPACR_EL1, 0 },
+	{ SYS_DESC(SYS_TTBR0_EL12), access_vm_reg, reset_unknown, TTBR0_EL1 },
+	{ SYS_DESC(SYS_TTBR1_EL12), access_vm_reg, reset_unknown, TTBR1_EL1 },
+	{ SYS_DESC(SYS_TCR_EL12), access_vm_reg, reset_val, TCR_EL1, 0 },
+	{ SYS_DESC(SYS_SPSR_EL12), access_spsr},
+	{ SYS_DESC(SYS_ELR_EL12), access_elr},
+	{ SYS_DESC(SYS_AFSR0_EL12), access_vm_reg, reset_unknown, AFSR0_EL1 },
+	{ SYS_DESC(SYS_AFSR1_EL12), access_vm_reg, reset_unknown, AFSR1_EL1 },
+	{ SYS_DESC(SYS_ESR_EL12), access_vm_reg, reset_unknown, ESR_EL1 },
+	{ SYS_DESC(SYS_FAR_EL12), access_vm_reg, reset_unknown, FAR_EL1 },
+	{ SYS_DESC(SYS_MAIR_EL12), access_vm_reg, reset_unknown, MAIR_EL1 },
+	{ SYS_DESC(SYS_AMAIR_EL12), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
+	{ SYS_DESC(SYS_VBAR_EL12), access_rw, reset_val, VBAR_EL1, 0 },
+	{ SYS_DESC(SYS_CONTEXTIDR_EL12), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
+	{ SYS_DESC(SYS_CNTKCTL_EL12), access_rw, reset_val, CNTKCTL_EL1, 0 },
+
 	{ SYS_DESC(SYS_SP_EL2), NULL, reset_unknown, SP_EL2 },
 };
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
