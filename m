From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 5/8] arm64: cpufeature: Track 32bit EL0 support
Date: Thu, 25 Feb 2016 09:52:45 +0000
Message-ID: <1456393968-17386-6-git-send-email-suzuki.poulose@arm.com>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 918664970D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tcfqOLK9LllT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Feb 2016 04:46:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFEC748529
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:21 -0500 (EST)
In-Reply-To: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, ynorov@caviumnetworks.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Keep track of the support for 32bit EL0.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |    8 +++++++-
 arch/arm64/kernel/cpufeature.c      |    9 +++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 98f83d7..46c6f4c 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -30,8 +30,9 @@
 #define ARM64_HAS_LSE_ATOMICS			5
 #define ARM64_WORKAROUND_CAVIUM_23154		6
 #define ARM64_WORKAROUND_834220			7
+#define ARM64_HAS_32BIT_EL0			8
 
-#define ARM64_NCAPS				8
+#define ARM64_NCAPS				9
 
 #ifndef __ASSEMBLY__
 
@@ -187,6 +188,11 @@ static inline bool cpu_supports_mixed_endian_el0(void)
 	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
 }
 
+static inline bool system_supports_32bit_el0(void)
+{
+	return cpus_have_cap(ARM64_HAS_32BIT_EL0);
+}
+
 static inline bool system_supports_mixed_endian_el0(void)
 {
 	return id_aa64mmfr0_mixed_endian_el0(read_system_reg(SYS_ID_AA64MMFR0_EL1));
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 853e575..8f6b674 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -675,6 +675,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 2,
 	},
 #endif /* CONFIG_AS_LSE && CONFIG_ARM64_LSE_ATOMICS */
+	{
+		.desc = "32 bit EL0",
+		.capability = ARM64_HAS_32BIT_EL0,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64PFR0_EL1,
+		.field_pos = ID_AA64PFR0_EL0_SHIFT,
+		.sign = FTR_UNSIGNED,
+		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
+	},
 	{},
 };
 
-- 
1.7.9.5
