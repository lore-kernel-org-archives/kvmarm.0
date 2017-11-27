From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 04/12] arm64/cpufeature: detect pointer authentication
Date: Mon, 27 Nov 2017 16:37:58 +0000
Message-ID: <20171127163806.31435-5-mark.rutland@arm.com>
References: <20171127163806.31435-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9D0549D19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 11:36:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MrtA3pjKFBI3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Nov 2017 11:36:08 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C0D40FB0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 11:36:08 -0500 (EST)
In-Reply-To: <20171127163806.31435-1-mark.rutland@arm.com>
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
Cc: linux-arch@vger.kernel.org, cdall@linaro.org, arnd@arndb.de, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

So that we can dynamically handle the presence of pointer authentication
functionality, wire up probing code in cpufeature.c.

It is assumed that if all CPUs support an IMP DEF algorithm, the same
algorithm is used across all CPUs.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  8 +++-
 arch/arm64/kernel/cpufeature.c   | 82 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 2ff7c5e8efab..d2830ce5c1c7 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -41,7 +41,13 @@
 #define ARM64_WORKAROUND_CAVIUM_30115		20
 #define ARM64_HAS_DCPOP				21
 #define ARM64_SVE				22
+#define ARM64_HAS_ADDRESS_AUTH_ARCH		23
+#define ARM64_HAS_ADDRESS_AUTH_IMP_DEF		24
+#define ARM64_HAS_ADDRESS_AUTH			25
+#define ARM64_HAS_GENERIC_AUTH_ARCH		26
+#define ARM64_HAS_GENERIC_AUTH_IMP_DEF		27
+#define ARM64_HAS_GENERIC_AUTH			28
 
-#define ARM64_NCAPS				23
+#define ARM64_NCAPS				29
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 1883cdffcdf7..babd4c173092 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -853,6 +853,36 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 					ID_AA64PFR0_FP_SHIFT) < 0;
 }
 
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
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
+#endif /* CONFIG_ARM64_POINTER_AUTHENTICATION */
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -970,6 +1000,58 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.enable = sve_kernel_enable,
 	},
 #endif /* CONFIG_ARM64_SVE */
+#ifdef CONFIG_ARM64_POINTER_AUTHENTICATION
+	{
+		.desc = "Address authentication (architected algorithm)",
+		.capability = ARM64_HAS_ADDRESS_AUTH_ARCH,
+		.def_scope = SCOPE_SYSTEM,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_APA_SHIFT,
+		.min_field_value = ID_AA64ISAR1_APA_ARCHITECTED,
+		.matches = has_cpuid_feature,
+	},
+	{
+		.desc = "Address authentication (IMP DEF algorithm)",
+		.capability = ARM64_HAS_ADDRESS_AUTH_IMP_DEF,
+		.def_scope = SCOPE_SYSTEM,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_API_SHIFT,
+		.min_field_value = ID_AA64ISAR1_API_IMP_DEF,
+		.matches = has_cpuid_feature,
+	},
+	{
+		.capability = ARM64_HAS_ADDRESS_AUTH,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_address_auth,
+	},
+	{
+		.desc = "Generic authentication (architected algorithm)",
+		.capability = ARM64_HAS_GENERIC_AUTH_ARCH,
+		.def_scope = SCOPE_SYSTEM,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_GPA_SHIFT,
+		.min_field_value = ID_AA64ISAR1_GPA_ARCHITECTED,
+		.matches = has_cpuid_feature
+	},
+	{
+		.desc = "Generic authentication (IMP DEF algorithm)",
+		.capability = ARM64_HAS_GENERIC_AUTH_IMP_DEF,
+		.def_scope = SCOPE_SYSTEM,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64ISAR1_GPI_SHIFT,
+		.min_field_value = ID_AA64ISAR1_GPI_IMP_DEF,
+		.matches = has_cpuid_feature
+	},
+	{
+		.capability = ARM64_HAS_GENERIC_AUTH,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_generic_auth,
+	},
+#endif /* CONFIG_ARM64_POINTER_AUTHENTICATION */
 	{},
 };
 
-- 
2.11.0
