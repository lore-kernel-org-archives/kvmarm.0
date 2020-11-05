Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9F0C4741F
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 12:57:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3881820A8B
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 12:57:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3881820A8B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B63B34B772;
	Thu,  5 Nov 2020 07:57:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id riRIcCr7vWZI; Thu,  5 Nov 2020 07:57:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EB1F4B7EE;
	Thu,  5 Nov 2020 07:57:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 854E04B728
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 07:57:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mZxRyPFhLnKp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 07:57:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF574B727
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 07:57:13 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E69AD142F;
 Thu,  5 Nov 2020 04:57:12 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4869E3F73C;
 Thu,  5 Nov 2020 04:57:11 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Ard Biesheuvel <ardb@kernel.org>, Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 4/5] arm64: Add support for SMCCC TRNG entropy source
Date: Thu,  5 Nov 2020 12:56:55 +0000
Message-Id: <20201105125656.25259-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201105125656.25259-1-andre.przywara@arm.com>
References: <20201105125656.25259-1-andre.przywara@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
 Mark Brown <broonie@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The ARM architected TRNG firmware interface, described in ARM spec
DEN0098, defines an ARM SMCCC based interface to a true random number
generator, provided by firmware.
This can be discovered via the SMCCC >=v1.1 interface, and provides
up to 192 bits of entropy per call.

Hook this SMC call into arm64's arch_get_random_*() implementation,
coming to the rescue when the CPU does not implement the ARM v8.5 RNG
system registers.

For the detection, we piggy back on the PSCI/SMCCC discovery (which gives
us the conduit to use (hvc/smc)), then try to call the
ARM_SMCCC_TRNG_VERSION function, which returns -1 if this interface is
not implemented.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/include/asm/archrandom.h | 53 ++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/archrandom.h b/arch/arm64/include/asm/archrandom.h
index abe07c21da8e..03744f688ca1 100644
--- a/arch/arm64/include/asm/archrandom.h
+++ b/arch/arm64/include/asm/archrandom.h
@@ -4,13 +4,24 @@
 
 #ifdef CONFIG_ARCH_RANDOM
 
+#include <linux/arm-smccc.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <asm/cpufeature.h>
 
+#define ARM_SMCCC_TRNG_MIN_VERSION	0x10000UL
+
+extern bool smccc_trng_available;
+
 static inline bool __init smccc_probe_trng(void)
 {
-	return false;
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_VERSION, &res);
+	if ((s32)res.a0 < 0)
+		return false;
+
+	return res.a0 >= ARM_SMCCC_TRNG_MIN_VERSION;
 }
 
 static inline bool __arm64_rndr(unsigned long *v)
@@ -43,26 +54,52 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
 
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
+	struct arm_smccc_res res;
+
 	/*
 	 * Only support the generic interface after we have detected
 	 * the system wide capability, avoiding complexity with the
 	 * cpufeature code and with potential scheduling between CPUs
 	 * with and without the feature.
 	 */
-	if (!cpus_have_const_cap(ARM64_HAS_RNG))
-		return false;
+	if (cpus_have_const_cap(ARM64_HAS_RNG))
+		return __arm64_rndr(v);
 
-	return __arm64_rndr(v);
-}
+	if (smccc_trng_available) {
+		arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND64, 64, &res);
+		if ((int)res.a0 < 0)
+			return false;
 
+		*v = res.a3;
+		return true;
+	}
+
+	return false;
+}
 
 static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
+	struct arm_smccc_res res;
 	unsigned long val;
-	bool ok = arch_get_random_seed_long(&val);
 
-	*v = val;
-	return ok;
+	if (cpus_have_const_cap(ARM64_HAS_RNG)) {
+		if (arch_get_random_seed_long(&val)) {
+			*v = val;
+			return true;
+		}
+		return false;
+	}
+
+	if (smccc_trng_available) {
+		arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND64, 32, &res);
+		if ((int)res.a0 < 0)
+			return false;
+
+		*v = res.a3 & GENMASK(31, 0);
+		return true;
+	}
+
+	return false;
 }
 
 static inline bool __init __early_cpu_has_rndr(void)
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
