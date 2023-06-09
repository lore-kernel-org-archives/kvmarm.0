Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F763200CB
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16996C433A4;
	Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686327731;
	bh=cs9s6WrxAIG0+qz4uZPPdbaqmFHbrYSMu2k9xtlONS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxU4S4Xqx6/s5brOCf2JFyo06CtYeU1W553io0CAztdF4tmCDFFrhOxm04+SbhH1G
	 6YLboUHMii5D1cOkLnEbK0PshdppJOoNiljkp+WxXlIL3tF8eY7VpnCoZ5EXQ1rwtl
	 AWPxaqpXPle3CVVs0G7aaI85UuFSgqpzD9obv4o5+W/2IcOBtmgzMIHsnLBl2RsznS
	 g+jfp2hAqBNo/IANbdY2HRjNCovvjqKmoDYHKOhtDw/BG/xMGcP6/VbCeWf9HDBq3M
	 dMuDTGIIaD+K10gGrKRHg7y6jEg77qp+JNTIofVlgrIq2c7jTdfEkpTXDQPimIoXin
	 RV5Cm1T0on9vA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q7esL-0048L7-1x;
	Fri, 09 Jun 2023 17:22:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 03/17] arm64: Turn kaslr_feature_override into a generic SW feature override
Date: Fri,  9 Jun 2023 17:21:46 +0100
Message-Id: <20230609162200.2024064-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Disabling KASLR from the command line is implemented as a feature
override. Repaint it slightly so that it can further be used as
more generic infrastructure for SW override purposes.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  4 ++++
 arch/arm64/kernel/cpufeature.c      |  2 ++
 arch/arm64/kernel/idreg-override.c  | 16 ++++++----------
 arch/arm64/kernel/kaslr.c           |  6 +++---
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 6bf013fb110d..bc1009890180 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -15,6 +15,8 @@
 #define MAX_CPU_FEATURES	128
 #define cpu_feature(x)		KERNEL_HWCAP_ ## x
 
+#define ARM64_SW_FEATURE_OVERRIDE_NOKASLR	0
+
 #ifndef __ASSEMBLY__
 
 #include <linux/bug.h>
@@ -925,6 +927,8 @@ extern struct arm64_ftr_override id_aa64smfr0_override;
 extern struct arm64_ftr_override id_aa64isar1_override;
 extern struct arm64_ftr_override id_aa64isar2_override;
 
+extern struct arm64_ftr_override arm64_sw_feature_override;
+
 u32 get_kvm_ipa_limit(void);
 void dump_cpu_features(void);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7d7128c65161..2d2b7bb5fa0c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -664,6 +664,8 @@ struct arm64_ftr_override __ro_after_init id_aa64smfr0_override;
 struct arm64_ftr_override __ro_after_init id_aa64isar1_override;
 struct arm64_ftr_override __ro_after_init id_aa64isar2_override;
 
+struct arm64_ftr_override arm64_sw_feature_override;
+
 static const struct __ftr_reg_entry {
 	u32			sys_id;
 	struct arm64_ftr_reg 	*reg;
diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 370ab84fd06e..8c93b6198bf5 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -138,15 +138,11 @@ static const struct ftr_set_desc smfr0 __initconst = {
 	},
 };
 
-extern struct arm64_ftr_override kaslr_feature_override;
-
-static const struct ftr_set_desc kaslr __initconst = {
-	.name		= "kaslr",
-#ifdef CONFIG_RANDOMIZE_BASE
-	.override	= &kaslr_feature_override,
-#endif
+static const struct ftr_set_desc sw_features __initconst = {
+	.name		= "arm64_sw",
+	.override	= &arm64_sw_feature_override,
 	.fields		= {
-		FIELD("disabled", 0, NULL),
+		FIELD("nokaslr", ARM64_SW_FEATURE_OVERRIDE_NOKASLR, NULL),
 		{}
 	},
 };
@@ -158,7 +154,7 @@ static const struct ftr_set_desc * const regs[] __initconst = {
 	&isar1,
 	&isar2,
 	&smfr0,
-	&kaslr,
+	&sw_features,
 };
 
 static const struct {
@@ -175,7 +171,7 @@ static const struct {
 	  "id_aa64isar1.api=0 id_aa64isar1.apa=0 "
 	  "id_aa64isar2.gpa3=0 id_aa64isar2.apa3=0"	   },
 	{ "arm64.nomte",		"id_aa64pfr1.mte=0" },
-	{ "nokaslr",			"kaslr.disabled=1" },
+	{ "nokaslr",			"arm64_sw.nokaslr=1" },
 };
 
 static int __init parse_nokaslr(char *unused)
diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index e7477f21a4c9..5d4ce7f5f157 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -23,8 +23,6 @@
 u64 __ro_after_init module_alloc_base;
 u16 __initdata memstart_offset_seed;
 
-struct arm64_ftr_override kaslr_feature_override __initdata;
-
 static int __init kaslr_init(void)
 {
 	u64 module_range;
@@ -36,7 +34,9 @@ static int __init kaslr_init(void)
 	 */
 	module_alloc_base = (u64)_etext - MODULES_VSIZE;
 
-	if (kaslr_feature_override.val & kaslr_feature_override.mask & 0xf) {
+	if (cpuid_feature_extract_unsigned_field(arm64_sw_feature_override.val &
+						 arm64_sw_feature_override.mask,
+						 ARM64_SW_FEATURE_OVERRIDE_NOKASLR)) {
 		pr_info("KASLR disabled on command line\n");
 		return 0;
 	}
-- 
2.34.1

