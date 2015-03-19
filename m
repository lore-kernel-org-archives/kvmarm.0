From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/5] arm64: alternative: Introduce feature for GICv3 CPU
 interface
Date: Thu, 19 Mar 2015 13:59:35 +0000
Message-ID: <1426773576-14062-5-git-send-email-marc.zyngier@arm.com>
References: <1426773576-14062-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 220F749297
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 09:53:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EFmMBZ4dRk6H for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 09:53:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A7E49292
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 09:53:12 -0400 (EDT)
In-Reply-To: <1426773576-14062-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Dave Martin <dave.martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add a new item to the feature set (ARM64_HAS_SYSREG_GIC_CPUIF)
to indicate that we have a system register GIC CPU interface

This will help KVM switching to alternative instruction patching.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  8 +++++++-
 arch/arm64/kernel/cpufeature.c      | 16 ++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 6ae35d1..d9e57b5 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -23,8 +23,9 @@
 
 #define ARM64_WORKAROUND_CLEAN_CACHE		0
 #define ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE	1
+#define ARM64_HAS_SYSREG_GIC_CPUIF		2
 
-#define ARM64_NCAPS				2
+#define ARM64_NCAPS				3
 
 #ifndef __ASSEMBLY__
 
@@ -37,6 +38,11 @@ struct arm64_cpu_capabilities {
 			u32 midr_model;
 			u32 midr_range_min, midr_range_max;
 		};
+
+		struct {	/* Feature register checking */
+			u64 register_mask;
+			u64 register_value;
+		};
 	};
 };
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 3d9967e..b0bea2b3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -22,7 +22,23 @@
 #include <asm/cpu.h>
 #include <asm/cpufeature.h>
 
+static bool
+has_id_aa64pfr0_feature(const struct arm64_cpu_capabilities *entry)
+{
+	u64 val;
+
+	val = read_cpuid(id_aa64pfr0_el1);
+	return (val & entry->register_mask) == entry->register_value;
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
+	{
+		.desc = "system register GIC CPU interface",
+		.capability = ARM64_HAS_SYSREG_GIC_CPUIF,
+		.matches = has_id_aa64pfr0_feature,
+		.register_mask = (0xf << 24),
+		.register_value = (1 << 24),
+	},
 	{},
 };
 
-- 
2.1.4
