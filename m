Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 047301CD1FB
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734322154; cv=none; b=p+mVghzrgijmDqBRbfync0llMXu+9nR5gGdKFVllQ8igaRNgsqKwQi8dT2HZHdnmwjyqmNqkTvjTivL2VXdsMb8vuQaE5WE/siEXZU5Uekmy66M4GWAz2CVa2Shff986+j3JOs/o1fJZg1CTGrOhMcWSsXhuMxwgBIrUQNGDI7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734322154; c=relaxed/simple;
	bh=F0QiJpz/PImWox2G3/5YwFnika36cd6n2fQ4eGhw+Ks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PSwQACrl4nc/2MTbyonSXaqIbTVHpyT1xCfUZMap/7kS5f6juzPpbxk9GMc8ObfIU+hScY83WnyxFmH+1XBpnebUnltZwbNXoYvEpP0k/COGZcvMlzko7duBwgHDIZkbR2o+gehjAPYCEMNe816B2av018nKWFFZ41mNsLcJKhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE48B1AED;
	Sun, 15 Dec 2024 20:09:40 -0800 (PST)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C641A3F58B;
	Sun, 15 Dec 2024 20:09:08 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH V3 7/7] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Date: Mon, 16 Dec 2024 09:38:31 +0530
Message-Id: <20241216040831.2448257-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241216040831.2448257-1-anshuman.khandual@arm.com>
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently there can be maximum 16 breakpoints, and 16 watchpoints available
on a given platform - as detected from ID_AA64DFR0_EL1.[BRPs|WRPs] register
fields. But these breakpoint, and watchpoints can be extended further up to
64 via a new arch feature FEAT_Debugv8p9.

This first enables banked access for the breakpoint and watchpoint register
set via MDSELR_EL1, extended exceptions via MDSCR_EL1.EMBWE and determining
available breakpoints and watchpoints in the platform from ID_AA64DFR1_EL1,
when FEAT_Debugv8p9 is enabled.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V3:

- Used SYS_FIELD_PREP() in read_wb_reg() and write_wb_reg()
- Added MAX_PER_BANK based BUILD_BUG_ON() tests in arch_hw_breakpoint_init()
- Dropped local variables i.e mdsel_bank and index
- Derived bank and index from MAX_PER_BANK as required

 arch/arm64/include/asm/debug-monitors.h |  1 +
 arch/arm64/include/asm/hw_breakpoint.h  | 47 ++++++++++++++++++------
 arch/arm64/kernel/debug-monitors.c      | 15 +++++---
 arch/arm64/kernel/hw_breakpoint.c       | 48 +++++++++++++++++++++++--
 4 files changed, 95 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 8f6ba31b8658..56b89a582a0d 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -20,6 +20,7 @@
 #define DBG_MDSCR_KDE		(1 << 13)
 #define DBG_MDSCR_MDE		(1 << 15)
 #define DBG_MDSCR_MASK		~(DBG_MDSCR_KDE | DBG_MDSCR_MDE)
+#define DBG_MDSCR_EMBWE		(1UL << 32)
 
 #define	DBG_ESR_EVT(x)		(((x) >> 27) & 0x7)
 
diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
index bd81cf17744a..e48273b64109 100644
--- a/arch/arm64/include/asm/hw_breakpoint.h
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -79,8 +79,9 @@ static inline void decode_ctrl_reg(u32 reg,
  * Limits.
  * Changing these will require modifications to the register accessors.
  */
-#define ARM_MAX_BRP		16
-#define ARM_MAX_WRP		16
+#define ARM_MAX_BRP		64
+#define ARM_MAX_WRP		64
+#define MAX_PER_BANK		16
 
 /* Virtual debug register bases. */
 #define AARCH64_DBG_REG_BVR	0
@@ -94,6 +95,14 @@ static inline void decode_ctrl_reg(u32 reg,
 #define AARCH64_DBG_REG_NAME_WVR	wvr
 #define AARCH64_DBG_REG_NAME_WCR	wcr
 
+static inline bool is_debug_v8p9_enabled(void)
+{
+	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	int dver = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_DebugVer_SHIFT);
+
+	return dver == ID_AA64DFR0_EL1_DebugVer_V8P9;
+}
+
 /* Accessor macros for the debug registers. */
 #define AARCH64_DBG_READ(N, REG, VAL) do {\
 	VAL = read_sysreg(dbg##REG##N##_el1);\
@@ -138,19 +147,37 @@ static inline void ptrace_hw_copy_thread(struct task_struct *task)
 /* Determine number of BRP registers available. */
 static inline int get_num_brps(void)
 {
-	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-	return 1 +
-		cpuid_feature_extract_unsigned_field(dfr0,
-						ID_AA64DFR0_EL1_BRPs_SHIFT);
+	u64 dfr0, dfr1;
+	int dver, brps;
+
+	dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	dver = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_DebugVer_SHIFT);
+	if (dver == ID_AA64DFR0_EL1_DebugVer_V8P9) {
+		dfr1 = read_sanitised_ftr_reg(SYS_ID_AA64DFR1_EL1);
+		brps = cpuid_feature_extract_unsigned_field_width(dfr1,
+								  ID_AA64DFR1_EL1_BRPs_SHIFT, 8);
+	} else {
+		brps = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_BRPs_SHIFT);
+	}
+	return 1 + brps;
 }
 
 /* Determine number of WRP registers available. */
 static inline int get_num_wrps(void)
 {
-	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
-	return 1 +
-		cpuid_feature_extract_unsigned_field(dfr0,
-						ID_AA64DFR0_EL1_WRPs_SHIFT);
+	u64 dfr0, dfr1;
+	int dver, wrps;
+
+	dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	dver = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_DebugVer_SHIFT);
+	if (dver == ID_AA64DFR0_EL1_DebugVer_V8P9) {
+		dfr1 = read_sanitised_ftr_reg(SYS_ID_AA64DFR1_EL1);
+		wrps = cpuid_feature_extract_unsigned_field_width(dfr1,
+								  ID_AA64DFR1_EL1_WRPs_SHIFT, 8);
+	} else {
+		wrps = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_WRPs_SHIFT);
+	}
+	return 1 + wrps;
 }
 
 #ifdef CONFIG_CPU_PM
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 58f047de3e1c..50779c68f11e 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -21,6 +21,7 @@
 #include <asm/cputype.h>
 #include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
+#include <asm/hw_breakpoint.h>
 #include <asm/system_misc.h>
 #include <asm/traps.h>
 
@@ -34,7 +35,7 @@ u8 debug_monitors_arch(void)
 /*
  * MDSCR access routines.
  */
-static void mdscr_write(u32 mdscr)
+static void mdscr_write(u64 mdscr)
 {
 	unsigned long flags;
 	flags = local_daif_save();
@@ -43,7 +44,7 @@ static void mdscr_write(u32 mdscr)
 }
 NOKPROBE_SYMBOL(mdscr_write);
 
-static u32 mdscr_read(void)
+static u64 mdscr_read(void)
 {
 	return read_sysreg(mdscr_el1);
 }
@@ -79,7 +80,7 @@ static DEFINE_PER_CPU(int, kde_ref_count);
 
 void enable_debug_monitors(enum dbg_active_el el)
 {
-	u32 mdscr, enable = 0;
+	u64 mdscr, enable = 0;
 
 	WARN_ON(preemptible());
 
@@ -90,6 +91,9 @@ void enable_debug_monitors(enum dbg_active_el el)
 	    this_cpu_inc_return(kde_ref_count) == 1)
 		enable |= DBG_MDSCR_KDE;
 
+	if (is_debug_v8p9_enabled())
+		enable |= DBG_MDSCR_EMBWE;
+
 	if (enable && debug_enabled) {
 		mdscr = mdscr_read();
 		mdscr |= enable;
@@ -100,7 +104,7 @@ NOKPROBE_SYMBOL(enable_debug_monitors);
 
 void disable_debug_monitors(enum dbg_active_el el)
 {
-	u32 mdscr, disable = 0;
+	u64 mdscr, disable = 0;
 
 	WARN_ON(preemptible());
 
@@ -111,6 +115,9 @@ void disable_debug_monitors(enum dbg_active_el el)
 	    this_cpu_dec_return(kde_ref_count) == 0)
 		disable &= ~DBG_MDSCR_KDE;
 
+	if (is_debug_v8p9_enabled())
+		disable &= ~DBG_MDSCR_EMBWE;
+
 	if (disable) {
 		mdscr = mdscr_read();
 		mdscr &= disable;
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index 722ac45f9f7b..e9c87fb0e772 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -103,7 +103,7 @@ int hw_breakpoint_slots(int type)
 	WRITE_WB_REG_CASE(OFF, 14, REG, VAL);	\
 	WRITE_WB_REG_CASE(OFF, 15, REG, VAL)
 
-static u64 read_wb_reg(int reg, int n)
+static u64 __read_wb_reg(int reg, int n)
 {
 	u64 val = 0;
 
@@ -118,9 +118,31 @@ static u64 read_wb_reg(int reg, int n)
 
 	return val;
 }
+
+static u64 read_wb_reg(int reg, int n)
+{
+	unsigned long flags;
+	u64 val;
+
+	if (!is_debug_v8p9_enabled())
+		return __read_wb_reg(reg, n);
+
+	/*
+	 * Bank selection in MDSELR_EL1, followed by an indexed read from
+	 * breakpoint (or watchpoint) registers cannot be interrupted, as
+	 * that might cause misread from the wrong targets instead. Hence
+	 * this requires mutual exclusion.
+	 */
+	local_irq_save(flags);
+	write_sysreg_s(SYS_FIELD_PREP(MDSELR_EL1, BANK, n / MAX_PER_BANK), SYS_MDSELR_EL1);
+	isb();
+	val = __read_wb_reg(reg, n % MAX_PER_BANK);
+	local_irq_restore(flags);
+	return val;
+}
 NOKPROBE_SYMBOL(read_wb_reg);
 
-static void write_wb_reg(int reg, int n, u64 val)
+static void __write_wb_reg(int reg, int n, u64 val)
 {
 	switch (reg + n) {
 	GEN_WRITE_WB_REG_CASES(AARCH64_DBG_REG_BVR, AARCH64_DBG_REG_NAME_BVR, val);
@@ -132,6 +154,26 @@ static void write_wb_reg(int reg, int n, u64 val)
 	}
 	isb();
 }
+
+static void write_wb_reg(int reg, int n, u64 val)
+{
+	unsigned long flags;
+
+	if (!is_debug_v8p9_enabled())
+		return __write_wb_reg(reg, n, val);
+
+	/*
+	 * Bank selection in MDSELR_EL1, followed by an indexed read from
+	 * breakpoint (or watchpoint) registers cannot be interrupted, as
+	 * that might cause misread from the wrong targets instead. Hence
+	 * this requires mutual exclusion.
+	 */
+	local_irq_save(flags);
+	write_sysreg_s(SYS_FIELD_PREP(MDSELR_EL1, BANK, n / MAX_PER_BANK), SYS_MDSELR_EL1);
+	isb();
+	__write_wb_reg(reg, n % MAX_PER_BANK, val);
+	local_irq_restore(flags);
+}
 NOKPROBE_SYMBOL(write_wb_reg);
 
 /*
@@ -1005,6 +1047,8 @@ static int __init arch_hw_breakpoint_init(void)
 
 	/* Register cpu_suspend hw breakpoint restore hook */
 	cpu_suspend_set_dbg_restorer(hw_breakpoint_reset);
+	BUILD_BUG_ON((ARM_MAX_BRP % MAX_PER_BANK) != 0);
+	BUILD_BUG_ON((ARM_MAX_WRP % MAX_PER_BANK) != 0);
 
 	return ret;
 }
-- 
2.25.1

