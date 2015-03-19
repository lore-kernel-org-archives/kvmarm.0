From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/5] arm64: Extract feature parsing code from cpu_errata.c
Date: Thu, 19 Mar 2015 13:59:34 +0000
Message-ID: <1426773576-14062-4-git-send-email-marc.zyngier@arm.com>
References: <1426773576-14062-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D598549278
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 09:53:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eIyH7oiCSUXu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2015 09:53:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF6484928A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2015 09:53:10 -0400 (EDT)
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

As we detect more architectural features at runtime, it makes
sense to reuse the existing framework whilst avoiding to call
a feature an erratum...

This patch extract the core capability parsing, moves it into
a new file (cpufeature.c), and let the CPU errata detection code
use it.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 15 ++++++++++++
 arch/arm64/kernel/Makefile          |  2 +-
 arch/arm64/kernel/cpu_errata.c      | 36 ++++------------------------
 arch/arm64/kernel/cpufeature.c      | 47 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c         |  1 +
 5 files changed, 68 insertions(+), 33 deletions(-)
 create mode 100644 arch/arm64/kernel/cpufeature.c

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index b6c16d5..6ae35d1 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -28,6 +28,18 @@
 
 #ifndef __ASSEMBLY__
 
+struct arm64_cpu_capabilities {
+	const char *desc;
+	u16 capability;
+	bool (*matches)(const struct arm64_cpu_capabilities *);
+	union {
+		struct {	/* To be used for erratum handling only */
+			u32 midr_model;
+			u32 midr_range_min, midr_range_max;
+		};
+	};
+};
+
 extern DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
 
 static inline bool cpu_have_feature(unsigned int num)
@@ -51,7 +63,10 @@ static inline void cpus_set_cap(unsigned int num)
 		__set_bit(num, cpu_hwcaps);
 }
 
+void check_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+			    const char *info);
 void check_local_cpu_errata(void);
+void check_local_cpu_features(void);
 bool cpu_supports_mixed_endian_el0(void);
 bool system_supports_mixed_endian_el0(void);
 
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index d5e7074..b12e15b 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -17,7 +17,7 @@ arm64-obj-y		:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   sys.o stacktrace.o time.o traps.o io.o vdso.o	\
 			   hyp-stub.o psci.o psci-call.o cpu_ops.o insn.o	\
 			   return_address.o cpuinfo.o cpu_errata.o		\
-			   alternative.o cacheinfo.o
+			   cpufeature.o alternative.o cacheinfo.o
 
 arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o entry32.o		\
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index fa62637..a66f4fa 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -16,8 +16,6 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#define pr_fmt(fmt) "alternatives: " fmt
-
 #include <linux/types.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
@@ -26,27 +24,11 @@
 #define MIDR_CORTEX_A53 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A53)
 #define MIDR_CORTEX_A57 MIDR_CPU_PART(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A57)
 
-/*
- * Add a struct or another datatype to the union below if you need
- * different means to detect an affected CPU.
- */
-struct arm64_cpu_capabilities {
-	const char *desc;
-	u16 capability;
-	bool (*is_affected)(struct arm64_cpu_capabilities *);
-	union {
-		struct {
-			u32 midr_model;
-			u32 midr_range_min, midr_range_max;
-		};
-	};
-};
-
 #define CPU_MODEL_MASK (MIDR_IMPLEMENTOR_MASK | MIDR_PARTNUM_MASK | \
 			MIDR_ARCHITECTURE_MASK)
 
 static bool __maybe_unused
-is_affected_midr_range(struct arm64_cpu_capabilities *entry)
+is_affected_midr_range(const struct arm64_cpu_capabilities *entry)
 {
 	u32 midr = read_cpuid_id();
 
@@ -59,12 +41,12 @@ is_affected_midr_range(struct arm64_cpu_capabilities *entry)
 }
 
 #define MIDR_RANGE(model, min, max) \
-	.is_affected = is_affected_midr_range, \
+	.matches = is_affected_midr_range, \
 	.midr_model = model, \
 	.midr_range_min = min, \
 	.midr_range_max = max
 
-struct arm64_cpu_capabilities arm64_errata[] = {
+const struct arm64_cpu_capabilities arm64_errata[] = {
 #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
 	defined(CONFIG_ARM64_ERRATUM_827319) || \
 	defined(CONFIG_ARM64_ERRATUM_824069)
@@ -97,15 +79,5 @@ struct arm64_cpu_capabilities arm64_errata[] = {
 
 void check_local_cpu_errata(void)
 {
-	struct arm64_cpu_capabilities *cpus = arm64_errata;
-	int i;
-
-	for (i = 0; cpus[i].desc; i++) {
-		if (!cpus[i].is_affected(&cpus[i]))
-			continue;
-
-		if (!cpus_have_cap(cpus[i].capability))
-			pr_info("enabling workaround for %s\n", cpus[i].desc);
-		cpus_set_cap(cpus[i].capability);
-	}
+	check_cpu_capabilities(arm64_errata, "enabling workaround for");
 }
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
new file mode 100644
index 0000000..3d9967e
--- /dev/null
+++ b/arch/arm64/kernel/cpufeature.c
@@ -0,0 +1,47 @@
+/*
+ * Contains CPU feature definitions
+ *
+ * Copyright (C) 2015 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) "alternatives: " fmt
+
+#include <linux/types.h>
+#include <asm/cpu.h>
+#include <asm/cpufeature.h>
+
+static const struct arm64_cpu_capabilities arm64_features[] = {
+	{},
+};
+
+void check_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
+			    const char *info)
+{
+	int i;
+
+	for (i = 0; caps[i].desc; i++) {
+		if (!caps[i].matches(&caps[i]))
+			continue;
+
+		if (!cpus_have_cap(caps[i].capability))
+			pr_info("%s %s\n", info, caps[i].desc);
+		cpus_set_cap(caps[i].capability);
+	}
+}
+
+void check_local_cpu_features(void)
+{
+	check_cpu_capabilities(arm64_features, "detected feature");
+}
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 9298556..75d5a86 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -236,6 +236,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	cpuinfo_detect_icache_policy(info);
 
 	check_local_cpu_errata();
+	check_local_cpu_features();
 	update_cpu_features(info);
 }
 
-- 
2.1.4
