From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 3/8] arm64: Add helpers for detecting AArch32 support at EL0
Date: Thu, 25 Feb 2016 09:52:43 +0000
Message-ID: <1456393968-17386-4-git-send-email-suzuki.poulose@arm.com>
References: <1456393968-17386-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 488464965E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fLaZFJhY3Ep6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Feb 2016 04:46:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D09DE49695
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 04:46:17 -0500 (EST)
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

Adds a helper to extract the support for AArch32 at EL0

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |    7 +++++++
 arch/arm64/include/asm/sysreg.h     |    1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 5444a77..98f83d7 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -165,6 +165,13 @@ static inline bool id_aa64mmfr0_mixed_endian_el0(u64 mmfr0)
 		cpuid_feature_extract_unsigned_field(mmfr0, ID_AA64MMFR0_BIGENDEL0_SHIFT) == 0x1;
 }
 
+static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
+{
+	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL0_SHIFT);
+
+	return val == ID_AA64PFR0_EL0_32BIT_64BIT;
+}
+
 void __init setup_cpu_features(void);
 
 void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 4aeebec..76d2f3e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -111,6 +111,7 @@
 #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
 #define ID_AA64PFR0_EL1_64BIT_ONLY	0x1
 #define ID_AA64PFR0_EL0_64BIT_ONLY	0x1
+#define ID_AA64PFR0_EL0_32BIT_64BIT	0x2
 
 /* id_aa64mmfr0 */
 #define ID_AA64MMFR0_TGRAN4_SHIFT	28
-- 
1.7.9.5
