From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 07/14] arm64/sve: Move read_zcr_features() out of
 cpufeature.h
Date: Fri,  4 May 2018 17:05:28 +0100
Message-ID: <1525449935-31424-8-git-send-email-Dave.Martin@arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C600D49FD3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 11:56:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5x1KJ3g5srkR for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 May 2018 11:56:16 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1127649FD8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 11:56:03 -0400 (EDT)
In-Reply-To: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Having read_zcr_features() inline in cpufeature.h results in that
header requiring #includes which make it hard to include
<asm/fpsimd.h> elsewhere without triggering header inclusion
cycles.

This is not a hot-path function and arguably should not be in
cpufeature.h in the first place, so this patch moves it to
fpsimd.c, compiled conditionally if CONFIG_ARM64_SVE=y.

This allows some SVE-related #includes to be dropped from
cpufeature.h, which will ease future maintenance.

A couple of missing #includes of <asm/fpsimd.h> are exposed by this
change under arch/arm64/.  This patch adds the missing #includes as
necessary.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 29 -----------------------------
 arch/arm64/include/asm/fpsimd.h     |  2 ++
 arch/arm64/include/asm/processor.h  |  1 +
 arch/arm64/kernel/fpsimd.c          | 28 ++++++++++++++++++++++++++++
 arch/arm64/kernel/ptrace.c          |  1 +
 5 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 09b0f2a..0a6b713 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -11,9 +11,7 @@
 
 #include <asm/cpucaps.h>
 #include <asm/cputype.h>
-#include <asm/fpsimd.h>
 #include <asm/hwcap.h>
-#include <asm/sigcontext.h>
 #include <asm/sysreg.h>
 
 /*
@@ -510,33 +508,6 @@ static inline bool system_supports_sve(void)
 		cpus_have_const_cap(ARM64_SVE);
 }
 
-/*
- * Read the pseudo-ZCR used by cpufeatures to identify the supported SVE
- * vector length.
- *
- * Use only if SVE is present.
- * This function clobbers the SVE vector length.
- */
-static inline u64 read_zcr_features(void)
-{
-	u64 zcr;
-	unsigned int vq_max;
-
-	/*
-	 * Set the maximum possible VL, and write zeroes to all other
-	 * bits to see if they stick.
-	 */
-	sve_kernel_enable(NULL);
-	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL1);
-
-	zcr = read_sysreg_s(SYS_ZCR_EL1);
-	zcr &= ~(u64)ZCR_ELx_LEN_MASK; /* find sticky 1s outside LEN field */
-	vq_max = sve_vq_from_vl(sve_get_vl());
-	zcr |= vq_max - 1; /* set LEN field to maximum effective value */
-
-	return zcr;
-}
-
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index aa60895..f4d80ae 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -68,6 +68,8 @@ extern unsigned int sve_get_vl(void);
 struct arm64_cpu_capabilities;
 extern void sve_kernel_enable(const struct arm64_cpu_capabilities *__unused);
 
+extern u64 read_zcr_features(void);
+
 extern int __ro_after_init sve_max_vl;
 
 #ifdef CONFIG_ARM64_SVE
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 7675989..f902b6d 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -40,6 +40,7 @@
 
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
+#include <asm/fpsimd.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/lse.h>
 #include <asm/pgtable-hwdef.h>
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index e7349b5..e7f99f2 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -37,6 +37,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
+#include <linux/stddef.h>
 #include <linux/sysctl.h>
 
 #include <asm/esr.h>
@@ -764,6 +765,33 @@ void sve_kernel_enable(const struct arm64_cpu_capabilities *__always_unused p)
 	isb();
 }
 
+/*
+ * Read the pseudo-ZCR used by cpufeatures to identify the supported SVE
+ * vector length.
+ *
+ * Use only if SVE is present.
+ * This function clobbers the SVE vector length.
+ */
+u64 read_zcr_features(void)
+{
+	u64 zcr;
+	unsigned int vq_max;
+
+	/*
+	 * Set the maximum possible VL, and write zeroes to all other
+	 * bits to see if they stick.
+	 */
+	sve_kernel_enable(NULL);
+	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL1);
+
+	zcr = read_sysreg_s(SYS_ZCR_EL1);
+	zcr &= ~(u64)ZCR_ELx_LEN_MASK; /* find sticky 1s outside LEN field */
+	vq_max = sve_vq_from_vl(sve_get_vl());
+	zcr |= vq_max - 1; /* set LEN field to maximum effective value */
+
+	return zcr;
+}
+
 void __init sve_setup(void)
 {
 	u64 zcr;
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 7ff81fe..78889c4 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -44,6 +44,7 @@
 #include <asm/compat.h>
 #include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
+#include <asm/fpsimd.h>
 #include <asm/pgtable.h>
 #include <asm/stacktrace.h>
 #include <asm/syscall.h>
-- 
2.1.4
