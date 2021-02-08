Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D953C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 10:04:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2D1A064E99
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 10:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D1A064E99
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC9984B55E;
	Mon,  8 Feb 2021 05:04:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tFJ3USpBNhVU; Mon,  8 Feb 2021 05:04:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E12D4B56D;
	Mon,  8 Feb 2021 05:04:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC7704B552
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 05:04:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6eJ53rOLEXTG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 05:04:15 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D39A4B53C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 05:04:15 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DC4AC64E87;
 Mon,  8 Feb 2021 10:04:13 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l93JA-00Ck14-4f; Mon, 08 Feb 2021 09:58:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH v7 22/23] arm64: cpufeatures: Allow disabling of Pointer Auth
 from the command-line
Date: Mon,  8 Feb 2021 09:57:31 +0000
Message-Id: <20210208095732.3267263-23-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208095732.3267263-1-maz@kernel.org>
References: <20210208095732.3267263-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 dbrazdil@google.com, alexandru.elisei@arm.com, ardb@kernel.org,
 jingzhangos@google.com, pajay@qti.qualcomm.com, psodagud@codeaurora.org,
 sramana@codeaurora.org, marcan@marcan.st, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 Ajay Patil <pajay@qti.qualcomm.com>, kernel-team@android.com,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

In order to be able to disable Pointer Authentication  at runtime,
whether it is for testing purposes, or to work around HW issues,
let's add support for overriding the ID_AA64ISAR1_EL1.{GPI,GPA,API,APA}
fields.

This is further mapped on the arm64.nopauth command-line alias.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Brazdil <dbrazdil@google.com>
Tested-by: Srinivas Ramana <sramana@codeaurora.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  3 +++
 arch/arm64/include/asm/cpufeature.h             |  1 +
 arch/arm64/kernel/cpufeature.c                  |  4 +++-
 arch/arm64/kernel/idreg-override.c              | 16 ++++++++++++++++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 7599fd0f1ad7..f9cb28a39bd0 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -376,6 +376,9 @@
 	arm64.nobti	[ARM64] Unconditionally disable Branch Target
 			Identification support
 
+	arm64.nopauth	[ARM64] Unconditionally disable Pointer Authentication
+			support
+
 	ataflop=	[HW,M68k]
 
 	atarimouse=	[HW,MOUSE] Atari Mouse
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 30917b9a760b..61177bac49fa 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -820,6 +820,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
 
 extern struct arm64_ftr_override id_aa64mmfr1_override;
 extern struct arm64_ftr_override id_aa64pfr1_override;
+extern struct arm64_ftr_override id_aa64isar1_override;
 
 u32 get_kvm_ipa_limit(void);
 void dump_cpu_features(void);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7fbeab497adb..3bce87a03717 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -559,6 +559,7 @@ static const struct arm64_ftr_bits ftr_raz[] = {
 
 struct arm64_ftr_override __ro_after_init id_aa64mmfr1_override;
 struct arm64_ftr_override __ro_after_init id_aa64pfr1_override;
+struct arm64_ftr_override __ro_after_init id_aa64isar1_override;
 
 static const struct __ftr_reg_entry {
 	u32			sys_id;
@@ -604,7 +605,8 @@ static const struct __ftr_reg_entry {
 
 	/* Op1 = 0, CRn = 0, CRm = 6 */
 	ARM64_FTR_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0),
-	ARM64_FTR_REG(SYS_ID_AA64ISAR1_EL1, ftr_id_aa64isar1),
+	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64ISAR1_EL1, ftr_id_aa64isar1,
+			       &id_aa64isar1_override),
 
 	/* Op1 = 0, CRn = 0, CRm = 7 */
 	ARM64_FTR_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0),
diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index d691e9015c62..dffb16682330 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -46,6 +46,18 @@ static const struct ftr_set_desc pfr1 __initconst = {
 	},
 };
 
+static const struct ftr_set_desc isar1 __initconst = {
+	.name		= "id_aa64isar1",
+	.override	= &id_aa64isar1_override,
+	.fields		= {
+	        { "gpi", ID_AA64ISAR1_GPI_SHIFT },
+	        { "gpa", ID_AA64ISAR1_GPA_SHIFT },
+	        { "api", ID_AA64ISAR1_API_SHIFT },
+	        { "apa", ID_AA64ISAR1_APA_SHIFT },
+		{}
+	},
+};
+
 extern struct arm64_ftr_override kaslr_feature_override;
 
 static const struct ftr_set_desc kaslr __initconst = {
@@ -62,6 +74,7 @@ static const struct ftr_set_desc kaslr __initconst = {
 static const struct ftr_set_desc * const regs[] __initconst = {
 	&mmfr1,
 	&pfr1,
+	&isar1,
 	&kaslr,
 };
 
@@ -72,6 +85,9 @@ static const struct {
 	{ "kvm-arm.mode=nvhe",		"id_aa64mmfr1.vh=0" },
 	{ "kvm-arm.mode=protected",	"id_aa64mmfr1.vh=0" },
 	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },
+	{ "arm64.nopauth",
+	  "id_aa64isar1.gpi=0 id_aa64isar1.gpa=0 "
+	  "id_aa64isar1.api=0 id_aa64isar1.apa=0"	   },
 	{ "nokaslr",			"kaslr.disabled=1" },
 };
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
