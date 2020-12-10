Return-Path: <SRS0=L5kI=FO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD04C4167B
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 16:04:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5840523EF3
	for <kvmarm@archiver.kernel.org>; Thu, 10 Dec 2020 16:04:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5840523EF3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDD4A4B2A2;
	Thu, 10 Dec 2020 11:04:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NZsUdT1PCwI2; Thu, 10 Dec 2020 11:04:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDD154B2AE;
	Thu, 10 Dec 2020 11:04:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2ADB04B2B5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 11:04:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PCGfC493oS8b for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Dec 2020 11:04:45 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 574574B293
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Dec 2020 11:04:43 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 75A3723F37;
 Thu, 10 Dec 2020 16:04:42 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1knONl-0008Di-4D; Thu, 10 Dec 2020 16:01:29 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v3 57/66] KVM: arm64: nv: Add include containing the VNCR_EL2
 offsets
Date: Thu, 10 Dec 2020 15:59:53 +0000
Message-Id: <20201210160002.1407373-58-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
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

VNCR_EL2 points to a page containing a number of system registers
accessed by a guest hypervisor when ARMv8.4-NV is enabled.

Let's document the offsets in that page, as we are going to use
this layout.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/vncr_mapping.h | 73 +++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h

diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
new file mode 100644
index 000000000000..64c46d658fc8
--- /dev/null
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * System register offsets in the VNCR page
+ * All offsets are *byte* displacements!
+ */
+
+#ifndef __ARM64_VNCR_MAPPING_H__
+#define __ARM64_VNCR_MAPPING_H__
+
+#define VNCR_VTTBR_EL2          0x020
+#define VNCR_VTCR_EL2           0x040
+#define VNCR_VMPIDR_EL2         0x050
+#define VNCR_CNTVOFF_EL2        0x060
+#define VNCR_HCR_EL2            0x078
+#define VNCR_HSTR_EL2           0x080
+#define VNCR_VPIDR_EL2          0x088
+#define VNCR_TPIDR_EL2          0x090
+#define VNCR_VNCR_EL2           0x0B0
+#define VNCR_CPACR_EL1          0x100
+#define VNCR_CONTEXTIDR_EL1     0x108
+#define VNCR_SCTLR_EL1          0x110
+#define VNCR_ACTLR_EL1          0x118
+#define VNCR_TCR_EL1            0x120
+#define VNCR_AFSR0_EL1          0x128
+#define VNCR_AFSR1_EL1          0x130
+#define VNCR_ESR_EL1            0x138
+#define VNCR_MAIR_EL1           0x140
+#define VNCR_AMAIR_EL1          0x148
+#define VNCR_MDSCR_EL1          0x158
+#define VNCR_SPSR_EL1           0x160
+#define VNCR_CNTV_CVAL_EL0      0x168
+#define VNCR_CNTV_CTL_EL0       0x170
+#define VNCR_CNTP_CVAL_EL0      0x178
+#define VNCR_CNTP_CTL_EL0       0x180
+#define VNCR_SCXTNUM_EL1        0x188
+#define VNCR_ZCR_EL1            0x1E0
+#define VNCR_TTBR0_EL1          0x200
+#define VNCR_TTBR1_EL1          0x210
+#define VNCR_FAR_EL1            0x220
+#define VNCR_ELR_EL1            0x230
+#define VNCR_SP_EL1             0x240
+#define VNCR_VBAR_EL1           0x250
+#define VNCR_ICH_LR0_EL2        0x400
+//      VNCR_ICH_LRN_EL2(n)     VNCR_ICH_LR0_EL2+8*((n) & 7)
+#define VNCR_ICH_AP0R0_EL2      0x480
+//      VNCR_ICH_AP0RN_EL2(n)   VNCR_ICH_AP0R0_EL2+8*((n) & 3)
+#define VNCR_ICH_AP1R0_EL2      0x4A0
+//      VNCR_ICH_AP1RN_EL2(n)   VNCR_ICH_AP1R0_EL2+8*((n) & 3)
+#define VNCR_ICH_HCR_EL2        0x4C0
+#define VNCR_ICH_VMCR_EL2       0x4C8
+#define VNCR_VDISR_EL2          0x500
+#define VNCR_PMBLIMITR_EL1      0x800
+#define VNCR_PMBPTR_EL1         0x810
+#define VNCR_PMBSR_EL1          0x820
+#define VNCR_PMSCR_EL1          0x828
+#define VNCR_PMSEVFR_EL1        0x830
+#define VNCR_PMSICR_EL1         0x838
+#define VNCR_PMSIRR_EL1         0x840
+#define VNCR_PMSLATFR_EL1       0x848
+#define VNCR_TRFCR_EL1          0x880
+#define VNCR_MPAM1_EL1          0x900
+#define VNCR_MPAMHCR_EL2        0x930
+#define VNCR_MPAMVPMV_EL2       0x938
+#define VNCR_MPAMVPM0_EL2       0x940
+#define VNCR_MPAMVPM1_EL2       0x948
+#define VNCR_MPAMVPM2_EL2       0x950
+#define VNCR_MPAMVPM3_EL2       0x958
+#define VNCR_MPAMVPM4_EL2       0x960
+#define VNCR_MPAMVPM5_EL2       0x968
+#define VNCR_MPAMVPM6_EL2       0x970
+#define VNCR_MPAMVPM7_EL2       0x978
+
+#endif /* __ARM64_VNCR_MAPPING_H__ */
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
