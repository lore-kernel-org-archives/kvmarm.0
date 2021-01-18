Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB02C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 10:00:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FB0D22B49
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 10:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FB0D22B49
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0AF24B230;
	Mon, 18 Jan 2021 05:00:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id er5AWfwz-Bod; Mon, 18 Jan 2021 05:00:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F21474B2AB;
	Mon, 18 Jan 2021 05:00:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F145C4B228
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 05:00:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YBMQVhCGIQqe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 05:00:30 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26F1E4B296
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 05:00:29 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4EB4722ADC;
 Mon, 18 Jan 2021 10:00:28 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l1R72-008RhD-7u; Mon, 18 Jan 2021 09:46:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH v4 19/21] arm64: cpufeatures: Allow disabling of BTI from the
 command-line
Date: Mon, 18 Jan 2021 09:45:31 +0000
Message-Id: <20210118094533.2874082-20-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210118094533.2874082-1-maz@kernel.org>
References: <20210118094533.2874082-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

In order to be able to disable BTI at runtime, whether it is
for testing purposes, or to work around HW issues, let's add
support for overriding the ID_AA64PFR1_EL1.BTI field.

This is further mapped on the arm64.nobti command-line alias.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  3 +++
 arch/arm64/include/asm/cpufeature.h             |  2 ++
 arch/arm64/kernel/cpufeature.c                  |  5 ++++-
 arch/arm64/kernel/idreg-override.c              | 12 ++++++++++++
 arch/arm64/mm/mmu.c                             |  2 +-
 5 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2786fd39a047..7599fd0f1ad7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -373,6 +373,9 @@
 	arcrimi=	[HW,NET] ARCnet - "RIM I" (entirely mem-mapped) cards
 			Format: <io>,<irq>,<nodeID>
 
+	arm64.nobti	[ARM64] Unconditionally disable Branch Target
+			Identification support
+
 	ataflop=	[HW,M68k]
 
 	atarimouse=	[HW,MOUSE] Atari Mouse
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 80a5f423444e..d3e0f6dd43c4 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -816,6 +816,8 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
 
 extern u64 id_aa64mmfr1_val;
 extern u64 id_aa64mmfr1_mask;
+extern u64 id_aa64pfr1_val;
+extern u64 id_aa64pfr1_mask;
 
 u32 get_kvm_ipa_limit(void);
 void dump_cpu_features(void);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5b9343d2e9f0..f223171a7c34 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -557,6 +557,8 @@ static const struct arm64_ftr_bits ftr_raz[] = {
 
 u64 id_aa64mmfr1_val;
 u64 id_aa64mmfr1_mask;
+u64 id_aa64pfr1_val;
+u64 id_aa64pfr1_mask;
 
 static const struct __ftr_reg_entry {
 	u32			sys_id;
@@ -592,7 +594,8 @@ static const struct __ftr_reg_entry {
 
 	/* Op1 = 0, CRn = 0, CRm = 4 */
 	ARM64_FTR_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0),
-	ARM64_FTR_REG(SYS_ID_AA64PFR1_EL1, ftr_id_aa64pfr1),
+	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64PFR1_EL1, ftr_id_aa64pfr1,
+			       &id_aa64pfr1_val, &id_aa64pfr1_mask),
 	ARM64_FTR_REG(SYS_ID_AA64ZFR0_EL1, ftr_id_aa64zfr0),
 
 	/* Op1 = 0, CRn = 0, CRm = 5 */
diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 143fe7b8e3ce..a9e3ed193fd4 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -33,6 +33,16 @@ static const struct reg_desc mmfr1 __initdata = {
 	},
 };
 
+static const struct reg_desc pfr1 __initdata = {
+	.name		= "id_aa64pfr1",
+	.val		= &id_aa64pfr1_val,
+	.mask		= &id_aa64pfr1_mask,
+	.fields		= {
+	        { "bt", ID_AA64PFR1_BT_SHIFT },
+		{}
+	},
+};
+
 extern u64 kaslr_feature_val;
 extern u64 kaslr_feature_mask;
 
@@ -50,6 +60,7 @@ static const struct reg_desc kaslr __initdata = {
 
 static const struct reg_desc * const regs[] __initdata = {
 	&mmfr1,
+	&pfr1,
 	&kaslr,
 };
 
@@ -59,6 +70,7 @@ static const struct {
 } aliases[] __initdata = {
 	{ "kvm-arm.mode=nvhe",		"id_aa64mmfr1.vh=0" },
 	{ "kvm-arm.mode=protected",	"id_aa64mmfr1.vh=0" },
+	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },
 	{ "nokaslr",			"kaslr.disabled=1" },
 };
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index ae0c3d023824..617e704c980b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -628,7 +628,7 @@ static bool arm64_early_this_cpu_has_bti(void)
 	if (!IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
 		return false;
 
-	pfr1 = read_sysreg_s(SYS_ID_AA64PFR1_EL1);
+	pfr1 = __read_sysreg_by_encoding(SYS_ID_AA64PFR1_EL1);
 	return cpuid_feature_extract_unsigned_field(pfr1,
 						    ID_AA64PFR1_BT_SHIFT);
 }
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
