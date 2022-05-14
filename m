Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D55C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 14 May 2022 10:25:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C045A4A10E;
	Sat, 14 May 2022 06:25:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tBsM4Fpzwirc; Sat, 14 May 2022 06:25:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91A3049EAC;
	Sat, 14 May 2022 06:25:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE6240BA9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 May 2022 06:25:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qvt-9w5qQsEO for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 May 2022 06:25:49 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 288E540B91
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 May 2022 06:25:49 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D933BB80159;
 Sat, 14 May 2022 10:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E328C340EE;
 Sat, 14 May 2022 10:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652523946;
 bh=e1S3dxyGDf3cOMw0omur5o6WDCMulV39GN1NJ3sB41o=;
 h=From:To:Cc:Subject:Date:From;
 b=TNgXCIJo8bM9xV8wfoRX6PnfnCD4RapWP3ap+O1Q5LjWUDVgnLtT6FG5LeYLjSCYR
 bmX6v3VDPSsBpng3gSMp16XaLPvNU5t48TyysBQ1wFcSTZyAJLRg9QjgE9A/58e0i+
 Gdrw2BODnEFEkXrSIGp9AzztBWncRs0o6uav9/xqgzB14OoIOLl51JgdnPj67s1lvj
 Lc3ONGwpqHPxldNWSqw32PrDO4co/9zYW+9PoLUdHG7dL9TCeVtb2wVd2IixS/a7/F
 yn2R9FJSwhtfCG81iPt1hAk7LbOSN0md/28iO8yMCEaUjIqlnNdzsOpWdd5fJlxrXE
 uxuAdjmD7BA4Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1npoxz-00BIGF-Qp; Sat, 14 May 2022 11:25:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: vgic-v3: List M1 Pro/Max as requiring the SEIS
 workaround
Date: Sat, 14 May 2022 11:25:24 +0100
Message-Id: <20220514102524.3188730-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org,
 catalin.marinas@arm.com, marcan@marcan.st, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, marcan@marcan.st
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

Unsusprisingly, Apple M1 Pro/Max have the exact same defect as the
original M1 and generate random SErrors in the host when a guest
tickles the GICv3 CPU interface the wrong way.

Add the part numbers for both the CPU types found in these two
new implementations, and add them to the hall of shame. This also
applies to the Ultra version, as it is composed of 2 Max SoCs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 8 ++++++++
 arch/arm64/kvm/vgic/vgic-v3.c    | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index ff8f4511df71..60647bdc0b09 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -118,6 +118,10 @@
 
 #define APPLE_CPU_PART_M1_ICESTORM	0x022
 #define APPLE_CPU_PART_M1_FIRESTORM	0x023
+#define APPLE_CPU_PART_M1_ICESTORM_PRO	0x024
+#define APPLE_CPU_PART_M1_FIRESTORM_PRO	0x025
+#define APPLE_CPU_PART_M1_ICESTORM_MAX	0x028
+#define APPLE_CPU_PART_M1_FIRESTORM_MAX	0x029
 
 #define MIDR_CORTEX_A53 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
@@ -164,6 +168,10 @@
 #define MIDR_HISI_TSV110 MIDR_CPU_MODEL(ARM_CPU_IMP_HISI, HISI_CPU_PART_TSV110)
 #define MIDR_APPLE_M1_ICESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM)
 #define MIDR_APPLE_M1_FIRESTORM MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM)
+#define MIDR_APPLE_M1_ICESTORM_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM_PRO)
+#define MIDR_APPLE_M1_FIRESTORM_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM_PRO)
+#define MIDR_APPLE_M1_ICESTORM_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_ICESTORM_MAX)
+#define MIDR_APPLE_M1_FIRESTORM_MAX MIDR_CPU_MODEL(ARM_CPU_IMP_APPLE, APPLE_CPU_PART_M1_FIRESTORM_MAX)
 
 /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
 #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b549af8b1dc2..826ff6f2a4e7 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -612,6 +612,10 @@ early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
 static const struct midr_range broken_seis[] = {
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
 	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
 	{},
 };
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
