Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC68518FC84
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 05:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093709; cv=none; b=Ye3CA0LRHCi0vof3SvEkA78aYO0uiqULiypTOsMGhjYmK16+vB42T8sF4Ljll4QXtrqUsaC+z0narfbivrcO6gxa3sB/qzE9waX6t6L+evqgudZJQtFWglC2BUGk/l4FXKFb4AZg0tqtsfvK/e5XHSgu5G8emZq2MRhS3y/Ytso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093709; c=relaxed/simple;
	bh=kk/qbJ8/usR0E4r18v0HxXu7/7YOt1ZcRKZLd1mHLJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=stY3pM9xD5DL/yDYyJfILajclU7xJojqpIg/SMGCxL01yteazqOjWTDIQ2PNDStE1YUVrayb8MNHVbJJXrpTkqqcidslEMRWmS8dfnouLN1VhT0pnBVG7GKFyJU9XmicyFjO4AWHEmnWiDcHolpisiuTBnWCt9TcfYqXrMDx5RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C626497;
	Sun, 27 Oct 2024 22:35:36 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1AC1E3F66E;
	Sun, 27 Oct 2024 22:35:02 -0700 (PDT)
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
Subject: [PATCH V2 7/7] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Date: Mon, 28 Oct 2024 11:04:26 +0530
Message-Id: <20241028053426.2486633-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241028053426.2486633-1-anshuman.khandual@arm.com>
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
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
Changes in V2:

- Alphabetically order header files in debug-monitors.c
- Dropped embwe_ref_count mechanism
- Dropped preempt_enable() from AARCH64_DBG_READ
- Dropped preempt_disable() from AARCH64_DBG_WRITE
- Dropped set_bank_index()
- Renamed read/write_wb_reg() as __read/__write_wb_reg()
- Modified read/write_wb_reg() to have MDSELR_E1 based banked read/write

 arch/arm64/include/asm/debug-monitors.h |  1 +
 arch/arm64/include/asm/hw_breakpoint.h  | 46 +++++++++++++++++++------
 arch/arm64/kernel/debug-monitors.c      | 15 +++++---
 arch/arm64/kernel/hw_breakpoint.c       | 38 ++++++++++++++++++--
 4 files changed, 84 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 13d437bcbf58..a14097673ae0 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -20,6 +20,7 @@
 #define DBG_MDSCR_KDE		(1 << 13)
 #define DBG_MDSCR_MDE		(1 << 15)
 #define DBG_MDSCR_MASK		~(DBG_MDSCR_KDE | DBG_MDSCR_MDE)
+#define DBG_MDSCR_EMBWE		(1UL << 32)
 
 #define	DBG_ESR_EVT(x)		(((x) >> 27) & 0x7)
 
diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
index bd81cf17744a..ec7c7901c61a 100644
--- a/arch/arm64/include/asm/hw_breakpoint.h
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -79,8 +79,8 @@ static inline void decode_ctrl_reg(u32 reg,
  * Limits.
  * Changing these will require modifications to the register accessors.
  */
-#define ARM_MAX_BRP		16
-#define ARM_MAX_WRP		16
+#define ARM_MAX_BRP		64
+#define ARM_MAX_WRP		64
 
 /* Virtual debug register bases. */
 #define AARCH64_DBG_REG_BVR	0
@@ -94,6 +94,14 @@ static inline void decode_ctrl_reg(u32 reg,
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
@@ -138,19 +146,37 @@ static inline void ptrace_hw_copy_thread(struct task_struct *task)
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
index 024a7b245056..b56716c654d8 100644
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
index 722ac45f9f7b..630db607ca2b 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -103,7 +103,7 @@ int hw_breakpoint_slots(int type)
 	WRITE_WB_REG_CASE(OFF, 14, REG, VAL);	\
 	WRITE_WB_REG_CASE(OFF, 15, REG, VAL)
 
-static u64 read_wb_reg(int reg, int n)
+static u64 __read_wb_reg(int reg, int n)
 {
 	u64 val = 0;
 
@@ -118,9 +118,27 @@ static u64 read_wb_reg(int reg, int n)
 
 	return val;
 }
+
+static u64 read_wb_reg(int reg, int n)
+{
+	int mdsel_bank, index;
+	u64 val;
+
+	if (!is_debug_v8p9_enabled())
+		return __read_wb_reg(reg, n);
+
+	mdsel_bank = n / 16;
+	index = n % 16;
+	preempt_disable();
+	write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
+	isb();
+	val = __read_wb_reg(reg, index);
+	preempt_enable();
+	return val;
+}
 NOKPROBE_SYMBOL(read_wb_reg);
 
-static void write_wb_reg(int reg, int n, u64 val)
+static void __write_wb_reg(int reg, int n, u64 val)
 {
 	switch (reg + n) {
 	GEN_WRITE_WB_REG_CASES(AARCH64_DBG_REG_BVR, AARCH64_DBG_REG_NAME_BVR, val);
@@ -132,6 +150,22 @@ static void write_wb_reg(int reg, int n, u64 val)
 	}
 	isb();
 }
+
+static void write_wb_reg(int reg, int n, u64 val)
+{
+	int mdsel_bank, index;
+
+	if (!is_debug_v8p9_enabled())
+		return __write_wb_reg(reg, n, val);
+
+	mdsel_bank = n / 16;
+	index = n % 16;
+	preempt_disable();
+	write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
+	isb();
+	__write_wb_reg(reg, index, val);
+	preempt_enable();
+}
 NOKPROBE_SYMBOL(write_wb_reg);
 
 /*
-- 
2.25.1

