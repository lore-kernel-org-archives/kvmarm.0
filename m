From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v5 05/17] arm64/cpufeature: detect pointer authentication
Date: Fri,  5 Oct 2018 09:47:42 +0100
Message-ID: <20181005084754.20950-6-kristina.martsenko@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
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

For the moment we only care about address authentication, so we only
need to check APA and API. It is assumed that if all CPUs support an IMP
DEF algorithm, the same algorithm is used across all CPUs.

Note that when we implement KVM support, we will also need to ensure
that CPUs have uniform support for GPA and GPI.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
[kristina: update cpucap numbers]
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  5 ++++-
 arch/arm64/kernel/cpufeature.c   | 47 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index ae1f70450fb2..276d4c95aa3c 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -51,7 +51,10 @@
 #define ARM64_SSBD				30
 #define ARM64_MISMATCHED_CACHE_TYPE		31
 #define ARM64_HAS_STAGE2_FWB			32
+#define ARM64_HAS_ADDRESS_AUTH_ARCH		33
+#define ARM64_HAS_ADDRESS_AUTH_IMP_DEF		34
+#define ARM64_HAS_ADDRESS_AUTH			35
 
-#define ARM64_NCAPS				33
+#define ARM64_NCAPS				36
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e238b7932096..0dd171c7d71e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -142,6 +142,10 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
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
@@ -1035,6 +1039,22 @@ static void cpu_has_fwb(const struct arm64_cpu_capabilities *__unused)
 	WARN_ON(val & (7 << 27 | 7 << 21));
 }
 
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
+#endif /* CONFIG_ARM64_PTR_AUTH */
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -1222,6 +1242,33 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_enable_hw_dbm,
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
+#endif /* CONFIG_ARM64_PTR_AUTH */
 	{},
 };
 
-- 
2.11.0
