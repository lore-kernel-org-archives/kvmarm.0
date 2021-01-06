Return-Path: <SRS0=pXP7=GJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6572AC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 10:35:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB6272310E
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jan 2021 10:35:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB6272310E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7137D4B345;
	Wed,  6 Jan 2021 05:35:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pg4KxCFoGkzi; Wed,  6 Jan 2021 05:35:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F5C24B346;
	Wed,  6 Jan 2021 05:35:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71EC54B35E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 05:35:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ubOPDOmoz7As for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jan 2021 05:35:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57ED84B358
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 05:35:06 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0753FED1;
 Wed,  6 Jan 2021 02:35:06 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 253543F719;
 Wed,  6 Jan 2021 02:35:04 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Marc Zyngier <maz@kernel.org>
Subject: [PATCH v6 2/5] firmware: smccc: Introduce SMCCC TRNG framework
Date: Wed,  6 Jan 2021 10:34:50 +0000
Message-Id: <20210106103453.152275-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210106103453.152275-1-andre.przywara@arm.com>
References: <20210106103453.152275-1-andre.przywara@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Theodore Ts'o <tytso@mit.edu>, Linus Walleij <linus.walleij@linaro.org>,
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
 Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The ARM DEN0098 document describe an SMCCC based firmware service to
deliver hardware generated random numbers. Its existence is advertised
according to the SMCCC v1.1 specification.

Add a (dummy) call to probe functions implemented in each architecture
(ARM and arm64), to determine the existence of this interface.
For now this return false, but this will be overwritten by each
architecture's support patch.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm/include/asm/archrandom.h   | 10 ++++++++++
 arch/arm64/include/asm/archrandom.h | 12 ++++++++++++
 drivers/firmware/smccc/smccc.c      |  6 ++++++
 3 files changed, 28 insertions(+)
 create mode 100644 arch/arm/include/asm/archrandom.h

diff --git a/arch/arm/include/asm/archrandom.h b/arch/arm/include/asm/archrandom.h
new file mode 100644
index 000000000000..a8e84ca5c2ee
--- /dev/null
+++ b/arch/arm/include/asm/archrandom.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARCHRANDOM_H
+#define _ASM_ARCHRANDOM_H
+
+static inline bool __init smccc_probe_trng(void)
+{
+	return false;
+}
+
+#endif /* _ASM_ARCHRANDOM_H */
diff --git a/arch/arm64/include/asm/archrandom.h b/arch/arm64/include/asm/archrandom.h
index ffb1a40d5475..abe07c21da8e 100644
--- a/arch/arm64/include/asm/archrandom.h
+++ b/arch/arm64/include/asm/archrandom.h
@@ -8,6 +8,11 @@
 #include <linux/kernel.h>
 #include <asm/cpufeature.h>
 
+static inline bool __init smccc_probe_trng(void)
+{
+	return false;
+}
+
 static inline bool __arm64_rndr(unsigned long *v)
 {
 	bool ok;
@@ -79,5 +84,12 @@ arch_get_random_seed_long_early(unsigned long *v)
 }
 #define arch_get_random_seed_long_early arch_get_random_seed_long_early
 
+#else /* !CONFIG_ARCH_RANDOM */
+
+static inline bool __init smccc_probe_trng(void)
+{
+	return false;
+}
+
 #endif /* CONFIG_ARCH_RANDOM */
 #endif /* _ASM_ARCHRANDOM_H */
diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
index 00c88b809c0c..d52bfc5ed5e4 100644
--- a/drivers/firmware/smccc/smccc.c
+++ b/drivers/firmware/smccc/smccc.c
@@ -5,16 +5,22 @@
 
 #define pr_fmt(fmt) "smccc: " fmt
 
+#include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/arm-smccc.h>
+#include <asm/archrandom.h>
 
 static u32 smccc_version = ARM_SMCCC_VERSION_1_0;
 static enum arm_smccc_conduit smccc_conduit = SMCCC_CONDUIT_NONE;
 
+bool __ro_after_init smccc_trng_available = false;
+
 void __init arm_smccc_version_init(u32 version, enum arm_smccc_conduit conduit)
 {
 	smccc_version = version;
 	smccc_conduit = conduit;
+
+	smccc_trng_available = smccc_probe_trng();
 }
 
 enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
