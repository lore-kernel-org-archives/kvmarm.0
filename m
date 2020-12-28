Return-Path: <SRS0=gyiM=GA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E16C433E9
	for <kvmarm@archiver.kernel.org>; Mon, 28 Dec 2020 11:20:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEE1C229C5
	for <kvmarm@archiver.kernel.org>; Mon, 28 Dec 2020 11:20:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEE1C229C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FE6D4B20C;
	Mon, 28 Dec 2020 06:20:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZMETZaG9jrLH; Mon, 28 Dec 2020 06:20:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11CA74B22C;
	Mon, 28 Dec 2020 06:20:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7694B192
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Dec 2020 06:20:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xxvFY-feEyjX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Dec 2020 06:20:07 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E35534B1AF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Dec 2020 06:20:05 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0F460229C4;
 Mon, 28 Dec 2020 11:20:05 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1ktq6L-0048wX-5e; Mon, 28 Dec 2020 10:50:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 11/17] arm64: cpufeature: Add an early command-line cpufeature
 override facility
Date: Mon, 28 Dec 2020 10:49:52 +0000
Message-Id: <20201228104958.1848833-12-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228104958.1848833-1-maz@kernel.org>
References: <20201228104958.1848833-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, dbrazdil@google.com, alexandru.elisei@arm.com,
 ardb@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
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

In order to be able to override CPU features at boot time,
let's add a command line parser that matches options of the
form "cpureg.feature=value", and store the corresponding
value into the override val/mask pair.

No features are currently defined, so no expected change in
functionnality.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/Makefile         |   2 +-
 arch/arm64/kernel/head.S           |   1 +
 arch/arm64/kernel/idreg-override.c | 112 +++++++++++++++++++++++++++++
 3 files changed, 114 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kernel/idreg-override.c

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 86364ab6f13f..2262f0392857 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -17,7 +17,7 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   return_address.o cpuinfo.o cpu_errata.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
 			   smp.o smp_spin_table.o topology.o smccc-call.o	\
-			   syscall.o proton-pack.o
+			   syscall.o proton-pack.o idreg-override.o
 
 targets			+= efi-entry.o
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index d74e5f84042e..b3c4dd04f74b 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -435,6 +435,7 @@ SYM_FUNC_START_LOCAL(__primary_switched)
 
 	mov	x0, x21				// pass FDT address in x0
 	bl	early_fdt_map			// Try mapping the FDT early
+	bl	init_shadow_regs
 	bl	switch_to_vhe
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 	bl	kasan_early_init
diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
new file mode 100644
index 000000000000..98fc664c2504
--- /dev/null
+++ b/arch/arm64/kernel/idreg-override.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Early cpufeature override framework
+ *
+ * Copyright (C) 2020 Google LLC
+ * Author: Marc Zyngier <maz@kernel.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/libfdt.h>
+
+#include <asm/cacheflush.h>
+#include <asm/setup.h>
+
+struct reg_desc {
+	const char * const	name;
+	u64 * const		val;
+	u64 * const		mask;
+	struct {
+		const char * const	name;
+		u8			 shift;
+	} 			fields[];
+};
+
+static const struct reg_desc * const regs[] __initdata = {
+};
+
+static int __init find_field(const char *cmdline, const struct reg_desc *reg,
+			     int f, u64 *v)
+{
+	char buf[256], *str;
+	size_t len;
+
+	snprintf(buf, ARRAY_SIZE(buf), "%s.%s=", reg->name, reg->fields[f].name);
+
+	str = strstr(cmdline, buf);
+	if (!(str == cmdline || (str > cmdline && *(str - 1) == ' ')))
+		return -1;
+
+	str += strlen(buf);
+	len = strcspn(str, " ");
+	len = min(len, ARRAY_SIZE(buf) - 1);
+	strncpy(buf, str, len);
+	buf[len] = 0;
+
+	return kstrtou64(buf, 0, v);
+}
+
+static void __init match_options(const char *cmdline)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		int f;
+
+		for (f = 0; regs[i]->fields[f].name; f++) {
+			u64 v;
+
+			if (find_field(cmdline, regs[i], f, &v))
+				continue;
+
+			*regs[i]->val  |= (v & 0xf) << regs[i]->fields[f].shift;
+			*regs[i]->mask |= 0xfUL << regs[i]->fields[f].shift;
+		}
+	}
+}
+
+static __init void parse_cmdline(void)
+{
+	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE)) {
+		const u8 *prop;
+		void *fdt;
+		int node;
+
+		fdt = get_early_fdt_ptr();
+		if (!fdt)
+			goto out;
+
+		node = fdt_path_offset(fdt, "/chosen");
+		if (node < 0)
+			goto out;
+
+		prop = fdt_getprop(fdt, node, "bootargs", NULL);
+		if (!prop)
+			goto out;
+
+		match_options(prop);
+
+		if (!IS_ENABLED(CONFIG_CMDLINE_EXTEND))
+			return;
+	}
+
+out:
+	match_options(CONFIG_CMDLINE);
+}
+
+void __init init_shadow_regs(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		*regs[i]->val  = 0;
+		*regs[i]->mask = 0;
+	}
+
+	parse_cmdline();
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		__flush_dcache_area(regs[i]->val, sizeof(*regs[i]->val));
+		__flush_dcache_area(regs[i]->mask, sizeof(*regs[i]->mask));
+	}
+}
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
