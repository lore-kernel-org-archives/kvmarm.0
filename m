From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: [PATCH v3 6/8] arm64: RAS: add ras extension runtime detection
Date: Thu, 30 Mar 2017 18:31:06 +0800
Message-ID: <1490869877-118713-7-git-send-email-xiexiuqi@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DAA540C1D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w5HIW9cxpbuL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Mar 2017 06:32:46 -0400 (EDT)
Received: from dggrg01-dlp.huawei.com (unknown [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5113040AE8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:44 -0400 (EDT)
In-Reply-To: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: wuquanming@huawei.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com, wangxiongfeng2@huawei.com, linux-acpi@vger.kernel.org, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

According to <<RAS Extension PRD03>> document, we add RAS extension
feature runtime detection, which would be used for error recovery
in the future.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/include/asm/sysreg.h  |  2 ++
 arch/arm64/kernel/cpufeature.c   | 11 +++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index fb78a5d..3847cf8 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -37,7 +37,8 @@
 #define ARM64_HAS_NO_FPSIMD			16
 #define ARM64_WORKAROUND_REPEAT_TLBI		17
 #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	18
+#define ARM64_HAS_RAS_EXTN			19
 
-#define ARM64_NCAPS				19
+#define ARM64_NCAPS				20
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ac24b6e..32964c7 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -157,6 +157,7 @@
 #define ID_AA64ISAR0_AES_SHIFT		4
 
 /* id_aa64pfr0 */
+#define ID_AA64PFR0_RAS_SHIFT		28
 #define ID_AA64PFR0_GIC_SHIFT		24
 #define ID_AA64PFR0_ASIMD_SHIFT		20
 #define ID_AA64PFR0_FP_SHIFT		16
@@ -165,6 +166,7 @@
 #define ID_AA64PFR0_EL1_SHIFT		4
 #define ID_AA64PFR0_EL0_SHIFT		0
 
+#define ID_AA64PFR0_RAS_V1		0x1
 #define ID_AA64PFR0_FP_NI		0xf
 #define ID_AA64PFR0_FP_SUPPORTED	0x0
 #define ID_AA64PFR0_ASIMD_NI		0xf
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index abda8e8..b0fb81e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -98,6 +98,7 @@
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_RAS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
@@ -860,6 +861,16 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 		.min_field_value = 0,
 		.matches = has_no_fpsimd,
 	},
+	{
+		.desc = "ARM64 RAS Extension Support",
+		.capability = ARM64_HAS_RAS_EXTN,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64PFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64PFR0_RAS_SHIFT,
+		.min_field_value = ID_AA64PFR0_RAS_V1,
+	},
 	{},
 };
 
-- 
1.8.3.1
