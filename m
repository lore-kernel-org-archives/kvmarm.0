Return-Path: <SRS0=dNnP=JG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91436C433ED
	for <kvmarm@archiver.kernel.org>; Fri,  9 Apr 2021 15:21:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E5BAA610F9
	for <kvmarm@archiver.kernel.org>; Fri,  9 Apr 2021 15:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5BAA610F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61A6E4BB90;
	Fri,  9 Apr 2021 11:21:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 87JyT2ZSmeBZ; Fri,  9 Apr 2021 11:21:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E73B4BB8F;
	Fri,  9 Apr 2021 11:21:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 272254BB90
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Apr 2021 11:21:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uEd0zdP3bIo8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Apr 2021 11:21:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D298F4BB8D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Apr 2021 11:21:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 507821063;
 Fri,  9 Apr 2021 08:21:32 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BE483F694;
 Fri,  9 Apr 2021 08:21:31 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/2] KVM: arm64: Don't print warning when trapping SPE
 registers
Date: Fri,  9 Apr 2021 16:21:53 +0100
Message-Id: <20210409152154.198566-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409152154.198566-1-alexandru.elisei@arm.com>
References: <20210409152154.198566-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

KVM sets up MDCR_EL2 to trap accesses to the SPE buffer and sampling
control registers and it relies on the fact that KVM injects an undefined
exception for unknown registers. This mechanism of injecting undefined
exceptions also prints a warning message for the host kernel; for example,
when a guest tries to access PMSIDR_EL1:

[    2.691830] kvm [142]: Unsupported guest sys_reg access at: 80009e78 [800003c5]
[    2.691830]  { Op0( 3), Op1( 0), CRn( 9), CRm( 9), Op2( 7), func_read },

This is unnecessary, because KVM has explicitly configured trapping of
those registers and is well aware of their existence. Prevent the warning
by adding the SPE registers to the list of registers that KVM emulates.
The access function will inject the undefined exception.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/sysreg.h |  2 ++
 arch/arm64/kvm/sys_regs.c       | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d4a5fca984c3..43bca834c477 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -283,6 +283,8 @@
 #define SYS_PMSIRR_EL1_INTERVAL_MASK	0xffffffUL
 
 /* Filtering controls */
+#define SYS_PMSNEVFR_EL1		sys_reg(3, 0, 9, 9, 1)
+
 #define SYS_PMSFCR_EL1			sys_reg(3, 0, 9, 9, 4)
 #define SYS_PMSFCR_EL1_FE_SHIFT		0
 #define SYS_PMSFCR_EL1_FT_SHIFT		1
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4f2f1e3145de..402cd11aa4fc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1501,6 +1501,19 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_FAR_EL1), access_vm_reg, reset_unknown, FAR_EL1 },
 	{ SYS_DESC(SYS_PAR_EL1), NULL, reset_unknown, PAR_EL1 },
 
+	{ SYS_DESC(SYS_PMSCR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSNEVFR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSICR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSIRR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSFCR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSEVFR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSLATFR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMSIDR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMBLIMITR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMBPTR_EL1), undef_access },
+	{ SYS_DESC(SYS_PMBSR_EL1), undef_access },
+	/* PMBIDR_EL1 is not trapped */
+
 	{ PMU_SYS_REG(SYS_PMINTENSET_EL1),
 	  .access = access_pminten, .reg = PMINTENSET_EL1 },
 	{ PMU_SYS_REG(SYS_PMINTENCLR_EL1),
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
