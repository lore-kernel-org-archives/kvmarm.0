From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v6 06/13] arm64/cpufeature: detect pointer authentication
Date: Fri,  7 Dec 2018 18:39:24 +0000
Message-ID: <20181207183931.4285-7-kristina.martsenko@arm.com>
References: <20181207183931.4285-1-kristina.martsenko@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 057684A321
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Dec 2018 13:40:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ylPfke1XZZxr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Dec 2018 13:40:24 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DA364A2E9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Dec 2018 13:40:24 -0500 (EST)
In-Reply-To: <20181207183931.4285-1-kristina.martsenko@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jacob Bramley <jacob.bramley@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Adam Wallis <awallis@codeaurora.org>, Richard Henderson <richard.henderson@linaro.org>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Cyrill Gorcunov <gorcunov@gmail.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Kachhap <amit.kachhap@arm.com>, Dave P Martin <dave.martin@arm.com>, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

So that we can dynamically handle the presence of pointer authentication
functionality, wire up probing code in cpufeature.c.

>From ARMv8.3 onwards, ID_AA64ISAR1 is no longer entirely RES0, and now
has four fields describing the presence of pointer authentication
functionality:

* APA - address authentication present, using an architected algorithm
* API - address authentication present, using an IMP DEF algorithm
* GPA - generic authentication present, using an architected algorithm
* GPI - generic authentication present, using an IMP DEF algorithm

This patch checks for both address and generic authentication,
separately. It is assumed that if all CPUs support an IMP DEF algorithm,
the same algorithm is used across all CPUs.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/cpucaps.h    |  8 +++-
 arch/arm64/include/asm/cpufeature.h | 12 +++++
 arch/arm64/kernel/cpufeature.c      | 90 +++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 6e2d254c09eb..62fc48604263 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -54,7 +54,13 @@
 #define ARM64_HAS_CRC32				33
 #define ARM64_SSBS				34
 #define ARM64_WORKAROUND_1188873		35
+#define ARM64_HAS_ADDRESS_AUTH_ARCH		36
+#define ARM64_HAS_ADDRESS_AUTH_IMP_DEF		37
+#define ARM64_HAS_ADDRESS_AUTH			38
+#define ARM64_HAS_GENERIC_AUTH_ARCH		39
+#define ARM64_HAS_GENERIC_AUTH_IMP_DEF		40
+#define ARM64_HAS_GENERIC_AUTH			41
 
-#define ARM64_NCAPS				36
+#define ARM64_NCAPS				42
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 7e2ec64aa414..1c8393ffabff 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -514,6 +514,18 @@ static inline bool system_supports_cnp(void)
 		cpus_have_const_cap(ARM64_HAS_CNP);
 }
 
+static inline bool system_supports_address_auth(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_PTR_AUTH) &&
+		cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH);
+}
+
+static inline bool system_supports_generic_auth(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_PTR_AUTH) &&
+		cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH);
+}
+
 #define ARM64_SSBD_UNKNOWN		-1
 #define ARM64_SSBD_FORCE_DISABLE	0
 #define ARM64_SSBD_KERNEL		1
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index aec5ecb85737..f8e3c3568a79 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -141,9 +141,17 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
+		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_GPI_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
+		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_GPA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_LRCPC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_FCMA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_JSCVT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
+		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_API_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_PTR_AUTH),
+		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_APA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_DPB_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
@@ -1145,6 +1153,36 @@ static void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused)
 }
 #endif /* CONFIG_ARM64_RAS_EXTN */
 
+#ifdef CONFIG_ARM64_PTR_AUTH
+static bool has_address_auth(const struct arm64_cpu_capabilities *entry,
+			     int __unused)
+{
+	u64 isar1 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
+	bool api, apa;
+
+	apa = cpuid_feature_extract_unsigned_field(isar1,
+					ID_AA64ISAR1_APA_SHIFT) > 0;
+	api = cpuid_feature_extract_unsigned_field(isar1,
+					ID_AA64ISAR1_API_SHIFT) > 0;
+
+	return apa || api;
+}
+
+static bool has_generic_auth(const struct arm64_cpu_capabilities *entry,
+			     int __unused)
+{
+	u64 isar1 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
+	bool gpi, gpa;
+
+	gpa = cpuid_feature_extract_unsigned_field(isar1,
+					ID_AA64ISAR1_GPA_SHIFT) > 0;
+	gpi = cpuid_feature_extract_unsigned_field(isar1,
+					ID_AA64ISAR1_GPI_SHIFT) > 0;
+
+	return gpa || gpi;
+}
+#endif /* CONFIG_ARM64_PTR_AUTH */
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -1368,6 +1406,58 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_enable_cnp,
 	},
 #endif
+#ifdef CONFIG_ARM64_PTR_AUTH
+	{
+		.desc = "Address authentication (architected algorithm)",
+		.capability = ARM64_HAS_ADDRESS_AUTH_ARCH,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_APA_SHIFT,
+		.min_field_value = ID_AA64ISAR1_APA_ARCHITECTED,
+		.matches = has_cpuid_feature,
+	},
+	{
+		.desc = "Address authentication (IMP DEF algorithm)",
+		.capability = ARM64_HAS_ADDRESS_AUTH_IMP_DEF,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_API_SHIFT,
+		.min_field_value = ID_AA64ISAR1_API_IMP_DEF,
+		.matches = has_cpuid_feature,
+	},
+	{
+		.capability = ARM64_HAS_ADDRESS_AUTH,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_address_auth,
+	},
+	{
+		.desc = "Generic authentication (architected algorithm)",
+		.capability = ARM64_HAS_GENERIC_AUTH_ARCH,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_GPA_SHIFT,
+		.min_field_value = ID_AA64ISAR1_GPA_ARCHITECTED,
+		.matches = has_cpuid_feature,
+	},
+	{
+		.desc = "Generic authentication (IMP DEF algorithm)",
+		.capability = ARM64_HAS_GENERIC_AUTH_IMP_DEF,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_GPI_SHIFT,
+		.min_field_value = ID_AA64ISAR1_GPI_IMP_DEF,
+		.matches = has_cpuid_feature,
+	},
+	{
+		.capability = ARM64_HAS_GENERIC_AUTH,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_generic_auth,
+	},
+#endif /* CONFIG_ARM64_PTR_AUTH */
 	{},
 };
 
-- 
2.11.0
