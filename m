Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C22184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6FAC433C1;
	Sat, 12 Nov 2022 15:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266287;
	bh=O479OlWxQlP74Ne+q8QmHhWov5l92g3kBPrk6sJp1JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkTxB4QvIvxvo9iksKcfgmJvpsF/bRYNH9Q6M/ik9Z2J1imFpt3vUJDfrS7jRLkOq
	 s/XLzBzx517SkuxM6N7gvESxCh17iEsHY0dIrG6s8G8w1FRPvb02vPpGx9IcMsHcXp
	 wnn2QLrsZ3SGHLupH+kbpzvkiMKMYF1x12XyKUmh451VKkAsiFOVeyva+ImpPEoPFW
	 ySnBHbdJovn2NCsE5E7nF2tcp7SlesW97fXP9122KnEgtuJ2k/8+J2eF7KuppeFTx7
	 lrmSbjJdB1WLEMXOmUTjFjjwi1kReIMltc/4S2q6xVaz1COG62tLPEmBE6u5Rdfy/X
	 H9brrH9f8MsSQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 08/14] arm64/cpufeature: Detect PE support for FEAT_NMI
Date: Sat, 12 Nov 2022 15:17:02 +0000
Message-Id: <20221112151708.175147-9-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4893; i=broonie@kernel.org; h=from:subject; bh=O479OlWxQlP74Ne+q8QmHhWov5l92g3kBPrk6sJp1JQ=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7jtV/Rkdbsu27JRK51hyoRZNdNVJAJmvc6MojBN G5DChXSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+47QAKCRAk1otyXVSH0JlSB/ 9m2heteHxMt9CACZdOZpKh4P0GYn7Jo/IK1ZikNZtjRB3ZxywC3hS62TD4KvmGlylmRZ1v7Hn9hI6e c62LzuOIQb/SM1rGFzlS2vVWTsjLVk2USyIM28QA5E0+k6bMD9XkuflsvONrFDLvF9+nioEy+UEiFO T7TQfsE7qUMN91fkk2NzCdGyw6FZHU1asvRgt2u7O6uYm3bkosxHLvRlhfEkPc9yLUYQoyu0XbHn0g vdveRnaRysaLRv1WVSXqiY9dHXxKUsWVKpruC47WBom1868ealOPtS4KQotXOr3Pp4j1BDwAEQsoMN l2FqwIBy6rj28OY95LZT+WbnjQ2pou
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Use of FEAT_NMI requires that all the PEs in the system and the GIC have NMI
support. This patch implements the PE part of that detection.

In order to avoid problematic interactions between real and pseudo NMIs
we disable the architected feature if the user has enabled pseudo NMIs
on the command line. If this is done on a system where support for the
architected feature is detected then a warning is printed during boot in
order to help users spot what is likely to be a misconfiguration.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h |  6 ++++
 arch/arm64/kernel/cpufeature.c      | 55 ++++++++++++++++++++++++++++-
 arch/arm64/tools/cpucaps            |  1 +
 3 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index f73f11b55042..85eeb331a0ef 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -809,6 +809,12 @@ static __always_inline bool system_uses_irq_prio_masking(void)
 	       cpus_have_const_cap(ARM64_HAS_IRQ_PRIO_MASKING);
 }
 
+static __always_inline bool system_uses_nmi(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_NMI) &&
+		cpus_have_const_cap(ARM64_HAS_NMI);
+}
+
 static inline bool system_supports_mte(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_MTE) &&
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6062454a9067..18ab50b76f50 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -84,6 +84,7 @@
 #include <asm/kvm_host.h>
 #include <asm/mmu_context.h>
 #include <asm/mte.h>
+#include <asm/nmi.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/sysreg.h>
@@ -243,6 +244,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_NMI_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SME_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MPAM_frac_SHIFT, 4, 0),
@@ -2008,9 +2010,11 @@ static void cpu_enable_e0pd(struct arm64_cpu_capabilities const *cap)
 }
 #endif /* CONFIG_ARM64_E0PD */
 
-#ifdef CONFIG_ARM64_PSEUDO_NMI
+#if IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) || IS_ENABLED(CONFIG_ARM64_NMI)
 static bool enable_pseudo_nmi;
+#endif
 
+#ifdef CONFIG_ARM64_PSEUDO_NMI
 static int __init early_enable_pseudo_nmi(char *p)
 {
 	return strtobool(p, &enable_pseudo_nmi);
@@ -2024,6 +2028,41 @@ static bool can_use_gic_priorities(const struct arm64_cpu_capabilities *entry,
 }
 #endif
 
+#ifdef CONFIG_ARM64_NMI
+static bool has_nmi(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	if (!has_cpuid_feature(entry, scope))
+		return false;
+
+	/*
+	 * Having both real and pseudo NMIs enabled simultaneously is
+	 * likely to cause confusion.  Since pseudo NMIs must be
+	 * enabled with an explicit command line option, if the user
+	 * has set that option on a system with real NMIs for some
+	 * reason assume they know what they're doing.
+	 */
+	if (IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) && enable_pseudo_nmi) {
+		pr_info("Pseudo NMI enabled, not using architected NMI\n");
+		return false;
+	}
+
+	return true;
+}
+
+static void nmi_enable(const struct arm64_cpu_capabilities *__unused)
+{
+	/*
+	 * Enable use of NMIs controlled by ALLINT, SPINTMASK should
+	 * be clear by default but make it explicit that we are using
+	 * this mode.  Ensure that ALLINT is clear first in order to
+	 * avoid leaving things masked.
+	 */
+	_allint_clear();
+	sysreg_clear_set(sctlr_el1, SCTLR_EL1_SPINTMASK, SCTLR_EL1_NMI);
+	isb();
+}
+#endif
+
 #ifdef CONFIG_ARM64_BTI
 static void bti_enable(const struct arm64_cpu_capabilities *__unused)
 {
@@ -2640,6 +2679,20 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.cpu_enable = cpu_trap_el0_impdef,
 	},
+#ifdef CONFIG_ARM64_NMI
+	{
+		.desc = "Non-maskable Interrupts",
+		.capability = ARM64_HAS_NMI,
+		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
+		.sys_reg = SYS_ID_AA64PFR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64PFR1_EL1_NMI_SHIFT,
+		.field_width = 4,
+		.min_field_value = ID_AA64PFR1_EL1_NMI_IMP,
+		.matches = has_nmi,
+		.cpu_enable = nmi_enable,
+	},
+#endif
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index f1c0347ec31a..fff7517ea590 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -30,6 +30,7 @@ HAS_GENERIC_AUTH_IMP_DEF
 HAS_IRQ_PRIO_MASKING
 HAS_LDAPR
 HAS_LSE_ATOMICS
+HAS_NMI
 HAS_NO_FPSIMD
 HAS_NO_HW_PREFETCH
 HAS_PAN
-- 
2.30.2

