Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11629C55ABD
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 14:13:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E9EC216C4
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 14:13:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="O98f5jh1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E9EC216C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED5864B934;
	Tue, 10 Nov 2020 09:13:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G39hUBW7T2fm; Tue, 10 Nov 2020 09:13:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26B5C4B9B5;
	Tue, 10 Nov 2020 09:13:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7F74B8F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 09:13:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AarLNTvoRs3A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 09:13:17 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D8A484B912
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 09:13:16 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DBDF820825;
 Tue, 10 Nov 2020 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605017596;
 bh=AaEmnUUc/m5rPRgMVUlzTP7zCIYmOa/6NPk0n9WQRZ8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=O98f5jh1Su6JXXdAGghUyHG0fOZH1I2o62/Xm2L1HPFoGa9kSv62a5uD+DYYFn73v
 z2TLFhkZ1qfHgsXRJeBcuyQS3ljXJtj8fUTLJ4k0GZbncv8RIz/MzeX+mdhoQJmd2y
 jGIvZ+gxhqVvmzV9V18jLh6FgoNOXZRa/avwPq+4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kcUOY-009T8Q-29; Tue, 10 Nov 2020 14:13:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 3/3] KVM: arm64: Handle SCXTNUM_ELx traps
Date: Tue, 10 Nov 2020 14:13:08 +0000
Message-Id: <20201110141308.451654-4-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110141308.451654-1-maz@kernel.org>
References: <20201110141308.451654-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, liangpeng10@huawei.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com
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

As the kernel never sets HCR_EL2.EnSCXT, accesses to SCXTNUM_ELx
will trap to EL2. Let's handle that as gracefully as possible
by injecting an UNDEF exception into the guest. This is consistent
with the guest's view of ID_AA64PFR0_EL1.CSV2 being at most 1.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 4 ++++
 arch/arm64/kvm/sys_regs.c       | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 174817ba119c..e2ef4c2edf06 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -372,6 +372,8 @@
 #define SYS_CONTEXTIDR_EL1		sys_reg(3, 0, 13, 0, 1)
 #define SYS_TPIDR_EL1			sys_reg(3, 0, 13, 0, 4)
 
+#define SYS_SCXTNUM_EL1			sys_reg(3, 0, 13, 0, 7)
+
 #define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
 
 #define SYS_CCSIDR_EL1			sys_reg(3, 1, 0, 0, 0)
@@ -404,6 +406,8 @@
 #define SYS_TPIDR_EL0			sys_reg(3, 3, 13, 0, 2)
 #define SYS_TPIDRRO_EL0			sys_reg(3, 3, 13, 0, 3)
 
+#define SYS_SCXTNUM_EL0			sys_reg(3, 3, 13, 0, 7)
+
 /* Definitions for system register interface to AMU for ARMv8.4 onwards */
 #define SYS_AM_EL0(crm, op2)		sys_reg(3, 3, 13, (crm), (op2))
 #define SYS_AMCR_EL0			SYS_AM_EL0(2, 0)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6155285b2f9b..ea1ef71c1394 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1640,6 +1640,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CONTEXTIDR_EL1), access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
 	{ SYS_DESC(SYS_TPIDR_EL1), NULL, reset_unknown, TPIDR_EL1 },
 
+	{ SYS_DESC(SYS_SCXTNUM_EL1), undef_access },
+
 	{ SYS_DESC(SYS_CNTKCTL_EL1), NULL, reset_val, CNTKCTL_EL1, 0},
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
@@ -1668,6 +1670,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
 	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
 
+	{ SYS_DESC(SYS_SCXTNUM_EL0), undef_access },
+
 	{ SYS_DESC(SYS_AMCR_EL0), undef_access },
 	{ SYS_DESC(SYS_AMCFGR_EL0), undef_access },
 	{ SYS_DESC(SYS_AMCGCR_EL0), undef_access },
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
