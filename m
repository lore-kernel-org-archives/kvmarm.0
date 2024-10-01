Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835291B86C0
	for <kvmarm@lists.linux.dev>; Tue,  1 Oct 2024 04:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727757389; cv=none; b=cOcpfcKzple5VafEGQNlxIEhYeSx1RyW6t5gnUbDtYEhPZ/jXjnYYNmq+gCxVU8mBIMdQ366kvn2rc0gxkUt1mwacOvWYbTWDdnYnKm3EyatjUF+9iGS+mKPnp9hAAb7sWCAZGZrLMGBgnqi3ecrmoOZ68Y+FTWTkohROynbuBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727757389; c=relaxed/simple;
	bh=x6gTjGL7JLbHfqtzbUkvGjqU8hR8T4ozkisxpA1QjBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R16rgqFeD85H2/Tgg/vvoWXiO/HDYpADiwKhqrw9HsgP0pvPVwMXjXQSSghD6+RJKIPdvi9I7D+mR0vt24j76RtnsQjQ+k8BdZyVbvTYt5ry6NHPa6GJdfS4Yk0kg4gMGExpbjJHDyd6lYRZ8BP9NOHLzFTLnBlcg6z2NZCPNZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51A2A367;
	Mon, 30 Sep 2024 21:36:56 -0700 (PDT)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.16.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DB1B13F58B;
	Mon, 30 Sep 2024 21:36:22 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
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
Subject: [PATCH 3/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Date: Tue,  1 Oct 2024 10:06:02 +0530
Message-Id: <20241001043602.1116991-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241001043602.1116991-1-anshuman.khandual@arm.com>
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
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
 arch/arm64/include/asm/debug-monitors.h |  1 +
 arch/arm64/include/asm/hw_breakpoint.h  | 50 ++++++++++++++++++++-----
 arch/arm64/kernel/debug-monitors.c      | 16 ++++++--
 arch/arm64/kernel/hw_breakpoint.c       | 33 ++++++++++++++++
 4 files changed, 86 insertions(+), 14 deletions(-)

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
index bd81cf17744a..362c4d4a64ac 100644
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
@@ -94,13 +94,25 @@ static inline void decode_ctrl_reg(u32 reg,
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
+	if (is_debug_v8p9_enabled())	\
+		preempt_enable();	\
 } while (0)
 
 #define AARCH64_DBG_WRITE(N, REG, VAL) do {\
 	write_sysreg(VAL, dbg##REG##N##_el1);\
+	if (is_debug_v8p9_enabled())	\
+		preempt_enable();	\
 } while (0)
 
 struct task_struct;
@@ -138,19 +150,37 @@ static inline void ptrace_hw_copy_thread(struct task_struct *task)
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
index 024a7b245056..af643c935f2e 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -23,6 +23,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/system_misc.h>
 #include <asm/traps.h>
+#include <asm/hw_breakpoint.h>
 
 /* Determine debug architecture. */
 u8 debug_monitors_arch(void)
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
@@ -76,10 +77,11 @@ early_param("nodebugmon", early_debug_disable);
  */
 static DEFINE_PER_CPU(int, mde_ref_count);
 static DEFINE_PER_CPU(int, kde_ref_count);
+static DEFINE_PER_CPU(int, embwe_ref_count);
 
 void enable_debug_monitors(enum dbg_active_el el)
 {
-	u32 mdscr, enable = 0;
+	u64 mdscr, enable = 0;
 
 	WARN_ON(preemptible());
 
@@ -90,6 +92,9 @@ void enable_debug_monitors(enum dbg_active_el el)
 	    this_cpu_inc_return(kde_ref_count) == 1)
 		enable |= DBG_MDSCR_KDE;
 
+	if (is_debug_v8p9_enabled() && this_cpu_inc_return(embwe_ref_count) == 1)
+		enable |= DBG_MDSCR_EMBWE;
+
 	if (enable && debug_enabled) {
 		mdscr = mdscr_read();
 		mdscr |= enable;
@@ -100,7 +105,7 @@ NOKPROBE_SYMBOL(enable_debug_monitors);
 
 void disable_debug_monitors(enum dbg_active_el el)
 {
-	u32 mdscr, disable = 0;
+	u64 mdscr, disable = 0;
 
 	WARN_ON(preemptible());
 
@@ -111,6 +116,9 @@ void disable_debug_monitors(enum dbg_active_el el)
 	    this_cpu_dec_return(kde_ref_count) == 0)
 		disable &= ~DBG_MDSCR_KDE;
 
+	if (is_debug_v8p9_enabled() && this_cpu_dec_return(embwe_ref_count) == 0)
+		disable &= ~DBG_MDSCR_EMBWE;
+
 	if (disable) {
 		mdscr = mdscr_read();
 		mdscr &= disable;
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index 722ac45f9f7b..30156d732284 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -103,10 +103,40 @@ int hw_breakpoint_slots(int type)
 	WRITE_WB_REG_CASE(OFF, 14, REG, VAL);	\
 	WRITE_WB_REG_CASE(OFF, 15, REG, VAL)
 
+static int set_bank_index(int n)
+{
+	int mdsel_bank;
+	int bank = n / 16, index = n % 16;
+
+	switch (bank) {
+	case 0:
+		mdsel_bank = MDSELR_EL1_BANK_BANK_0;
+		break;
+	case 1:
+		mdsel_bank = MDSELR_EL1_BANK_BANK_1;
+		break;
+	case 2:
+		mdsel_bank = MDSELR_EL1_BANK_BANK_2;
+		break;
+	case 3:
+		mdsel_bank = MDSELR_EL1_BANK_BANK_3;
+		break;
+	default:
+		pr_warn("Unknown register bank %d\n", bank);
+	}
+	preempt_disable();
+	write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
+	isb();
+	return index;
+}
+
 static u64 read_wb_reg(int reg, int n)
 {
 	u64 val = 0;
 
+	if (is_debug_v8p9_enabled())
+		n = set_bank_index(n);
+
 	switch (reg + n) {
 	GEN_READ_WB_REG_CASES(AARCH64_DBG_REG_BVR, AARCH64_DBG_REG_NAME_BVR, val);
 	GEN_READ_WB_REG_CASES(AARCH64_DBG_REG_BCR, AARCH64_DBG_REG_NAME_BCR, val);
@@ -122,6 +152,9 @@ NOKPROBE_SYMBOL(read_wb_reg);
 
 static void write_wb_reg(int reg, int n, u64 val)
 {
+	if (is_debug_v8p9_enabled())
+		n = set_bank_index(n);
+
 	switch (reg + n) {
 	GEN_WRITE_WB_REG_CASES(AARCH64_DBG_REG_BVR, AARCH64_DBG_REG_NAME_BVR, val);
 	GEN_WRITE_WB_REG_CASES(AARCH64_DBG_REG_BCR, AARCH64_DBG_REG_NAME_BCR, val);
-- 
2.25.1

