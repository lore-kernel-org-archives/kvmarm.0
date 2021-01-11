Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833EFC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:39:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DB08225AB
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 13:39:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DB08225AB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C42884B302;
	Mon, 11 Jan 2021 08:39:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xhd3+r3Z9iXN; Mon, 11 Jan 2021 08:39:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3DB74B313;
	Mon, 11 Jan 2021 08:39:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 584404B308
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:39:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oqn4ki-SasPQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 08:39:03 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAB724B30C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 08:39:00 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E503822472;
 Mon, 11 Jan 2021 13:38:59 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kyxFL-006gPD-B7; Mon, 11 Jan 2021 13:28:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
Subject: [PATCH v3 18/21] arm64: Move "nokaslr" over to the early cpufeature
 infrastructure
Date: Mon, 11 Jan 2021 13:28:08 +0000
Message-Id: <20210111132811.2455113-19-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111132811.2455113-1-maz@kernel.org>
References: <20210111132811.2455113-1-maz@kernel.org>
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

Given that the early cpufeature infrastructure has borrowed quite
a lot of code from the kaslr implementation, let's reimplement
the matching of the "nokaslr" option with it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/idreg-override.c | 17 ++++++++++++++
 arch/arm64/kernel/kaslr.c          | 37 +++---------------------------
 2 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 1db54878b2c4..143fe7b8e3ce 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -33,8 +33,24 @@ static const struct reg_desc mmfr1 __initdata = {
 	},
 };
 
+extern u64 kaslr_feature_val;
+extern u64 kaslr_feature_mask;
+
+static const struct reg_desc kaslr __initdata = {
+	.name		= "kaslr",
+#ifdef CONFIG_RANDOMIZE_BASE
+	.val		= &kaslr_feature_val,
+	.mask		= &kaslr_feature_mask,
+#endif
+	.fields		= {
+		{ "disabled", 0 },
+		{}
+	},
+};
+
 static const struct reg_desc * const regs[] __initdata = {
 	&mmfr1,
+	&kaslr,
 };
 
 static const struct {
@@ -43,6 +59,7 @@ static const struct {
 } aliases[] __initdata = {
 	{ "kvm-arm.mode=nvhe",		"id_aa64mmfr1.vh=0" },
 	{ "kvm-arm.mode=protected",	"id_aa64mmfr1.vh=0" },
+	{ "nokaslr",			"kaslr.disabled=1" },
 };
 
 static int __init find_field(const char *cmdline, const struct reg_desc *reg,
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index 5fc86e7d01a1..dcc4a5aadbe2 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -51,39 +51,8 @@ static __init u64 get_kaslr_seed(void *fdt)
 	return ret;
 }
 
-static __init bool cmdline_contains_nokaslr(const u8 *cmdline)
-{
-	const u8 *str;
-
-	str = strstr(cmdline, "nokaslr");
-	return str == cmdline || (str > cmdline && *(str - 1) == ' ');
-}
-
-static __init bool is_kaslr_disabled_cmdline(void *fdt)
-{
-	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE)) {
-		int node;
-		const u8 *prop;
-
-		node = fdt_path_offset(fdt, "/chosen");
-		if (node < 0)
-			goto out;
-
-		prop = fdt_getprop(fdt, node, "bootargs", NULL);
-		if (!prop)
-			goto out;
-
-		if (cmdline_contains_nokaslr(prop))
-			return true;
-
-		if (IS_ENABLED(CONFIG_CMDLINE_EXTEND))
-			goto out;
-
-		return false;
-	}
-out:
-	return cmdline_contains_nokaslr(CONFIG_CMDLINE);
-}
+u64 kaslr_feature_val __initdata;
+u64 kaslr_feature_mask __initdata;
 
 /*
  * This routine will be executed with the kernel mapped at its default virtual
@@ -126,7 +95,7 @@ u64 __init kaslr_early_init(void)
 	 * Check if 'nokaslr' appears on the command line, and
 	 * return 0 if that is the case.
 	 */
-	if (is_kaslr_disabled_cmdline(fdt)) {
+	if (kaslr_feature_val & kaslr_feature_mask & 0xf) {
 		kaslr_status = KASLR_DISABLED_CMDLINE;
 		return 0;
 	}
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
