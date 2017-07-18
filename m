From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 01/38] arm64: Add ARM64_HAS_NESTED_VIRT feature
Date: Tue, 18 Jul 2017 11:58:27 -0500
Message-ID: <1500397144-16232-2-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: corbet@lwn.net, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, akpm@linux-foundation.org, mchehab@kernel.org, cov@codeaurora.org, daniel.lezcano@linaro.org, david.daney@cavium.com, mark.rutland@arm.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, andy.gross@linaro.org, wcohen@redhat.com, ard.biesheuvel@linaro.org, shankerd@codeaurora.org, vladimir.murzin@arm.com, james.morse@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Jintack Lim <jintack.lim@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Add a new ARM64_HAS_NESTED_VIRT feature to indicate that the
CPU has the ARMv8.3 nested virtualization capability.

This will be used to support nested virtualization in KVM.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/include/asm/sysreg.h  |  1 +
 arch/arm64/kernel/cpufeature.c   | 11 +++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8d2272c..64df263 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -39,7 +39,8 @@
 #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	18
 #define ARM64_WORKAROUND_858921			19
 #define ARM64_WORKAROUND_CAVIUM_30115		20
+#define ARM64_HAS_NESTED_VIRT			21
 
-#define ARM64_NCAPS				21
+#define ARM64_NCAPS				22
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 16e44fa..737ca30 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -376,6 +376,7 @@
 #define ID_AA64MMFR1_VMIDBITS_16	2
 
 /* id_aa64mmfr2 */
+#define ID_AA64MMFR2_NV_SHIFT		24
 #define ID_AA64MMFR2_LVA_SHIFT		16
 #define ID_AA64MMFR2_IESB_SHIFT		12
 #define ID_AA64MMFR2_LSM_SHIFT		8
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 94b8f7f..523f998 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -144,6 +144,7 @@
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64MMFR2_NV_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64MMFR2_LVA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64MMFR2_IESB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64MMFR2_LSM_SHIFT, 4, 0),
@@ -867,6 +868,16 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 		.min_field_value = 0,
 		.matches = has_no_fpsimd,
 	},
+	{
+		.desc = "Nested Virtualization Support",
+		.capability = ARM64_HAS_NESTED_VIRT,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_NV_SHIFT,
+		.min_field_value = 1,
+	},
 	{},
 };
 
-- 
1.9.1
