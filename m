From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH v2 2/3] arm64: kvm: reuse existing cache type/info related
 macros
Date: Mon, 30 Jan 2017 16:25:26 +0000
Message-ID: <1485793527-18028-2-git-send-email-sudeep.holla@arm.com>
References: <1485793527-18028-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3E440284
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 11:25:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zFfj+YnHO5mD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 11:25:20 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 967A040625
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 11:25:20 -0500 (EST)
In-Reply-To: <1485793527-18028-1-git-send-email-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We already have various macros related to cache type and bitfields in
CLIDR system register. We can replace some of the hardcoded values
here using those existing macros.

This patch reuses those existing cache type/info related macros and
replaces the hardcorded values. It also removes some of the comments
that become trivial with the macro names.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/cachetype.h |  7 +++++++
 arch/arm64/kernel/cacheinfo.c      |  7 -------
 arch/arm64/kvm/sys_regs.c          | 33 ++++++++++++++++-----------------
 3 files changed, 23 insertions(+), 24 deletions(-)

v1->v2:
	- Fixed issue pointed by Christoffer(left shift operator)
	- Replace couple of more hardcored values with macros

diff --git a/arch/arm64/include/asm/cachetype.h b/arch/arm64/include/asm/cachetype.h
index 180b3288aa3f..6cefbd39a40f 100644
--- a/arch/arm64/include/asm/cachetype.h
+++ b/arch/arm64/include/asm/cachetype.h
@@ -39,6 +39,13 @@

 extern unsigned long __icache_flags;

+#define MAX_CACHE_LEVEL			7	/* Max 7 level supported */
+/* Ctypen, bits[3(n - 1) + 2 : 3(n - 1)], for n = 1 to 7 */
+#define CLIDR_CTYPE_SHIFT(level)	(3 * (level - 1))
+#define CLIDR_CTYPE_MASK(level)		(7 << CLIDR_CTYPE_SHIFT(level))
+#define CLIDR_CTYPE(clidr, level)	\
+	(((clidr) & CLIDR_CTYPE_MASK(level)) >> CLIDR_CTYPE_SHIFT(level))
+
 /*
  * +---------------+---------+---------+------------------------------+
  * | Property      |   v1    |    v2   | Calculation                  |
diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
index 888b38f1709f..fdb384f18906 100644
--- a/arch/arm64/kernel/cacheinfo.c
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -26,13 +26,6 @@
 #include <asm/cachetype.h>
 #include <asm/processor.h>

-#define MAX_CACHE_LEVEL			7	/* Max 7 level supported */
-/* Ctypen, bits[3(n - 1) + 2 : 3(n - 1)], for n = 1 to 7 */
-#define CLIDR_CTYPE_SHIFT(level)	(3 * (level - 1))
-#define CLIDR_CTYPE_MASK(level)		(7 << CLIDR_CTYPE_SHIFT(level))
-#define CLIDR_CTYPE(clidr, level)	\
-	(((clidr) & CLIDR_CTYPE_MASK(level)) >> CLIDR_CTYPE_SHIFT(level))
-
 static inline enum cache_type get_cache_type(int level)
 {
 	u64 clidr;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 87e7e6608cd8..72656743b4cc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -21,11 +21,13 @@
  */

 #include <linux/bsearch.h>
+#include <linux/cacheinfo.h>
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>

 #include <asm/cacheflush.h>
+#include <asm/cachetype.h>
 #include <asm/cputype.h>
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
@@ -59,7 +61,7 @@
 static u32 cache_levels;

 /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
-#define CSSELR_MAX 12
+#define CSSELR_MAX 	((MAX_CACHE_LEVEL - 1) << 1)

 /* Which cache CCSIDR represents depends on CSSELR value. */
 static u32 get_ccsidr(u32 csselr)
@@ -68,9 +70,7 @@ static u32 get_ccsidr(u32 csselr)

 	/* Make sure noone else changes CSSELR during this! */
 	local_irq_disable();
-	write_sysreg(csselr, csselr_el1);
-	isb();
-	ccsidr = read_sysreg(ccsidr_el1);
+	ccsidr = cache_get_ccsidr(csselr);
 	local_irq_enable();

 	return ccsidr;
@@ -1960,19 +1960,18 @@ static bool is_valid_cache(u32 val)
 		return false;

 	/* Bottom bit is Instruction or Data bit.  Next 3 bits are level. */
-	level = (val >> 1);
-	ctype = (cache_levels >> (level * 3)) & 7;
+	level = (val >> 1) + 1;
+	ctype = CLIDR_CTYPE(cache_levels, level);

 	switch (ctype) {
-	case 0: /* No cache */
-		return false;
-	case 1: /* Instruction cache only */
-		return (val & 1);
-	case 2: /* Data cache only */
-	case 4: /* Unified cache */
-		return !(val & 1);
-	case 3: /* Separate instruction and data caches */
+	case CACHE_TYPE_INST:
+		return (val & CACHE_TYPE_INST);
+	case CACHE_TYPE_DATA:
+	case CACHE_TYPE_UNIFIED:
+		return !(val & CACHE_TYPE_INST);
+	case CACHE_TYPE_SEPARATE:
 		return true;
+	case CACHE_TYPE_NOCACHE:
 	default: /* Reserved: we can't know instruction or data. */
 		return false;
 	}
@@ -2239,11 +2238,11 @@ void kvm_sys_reg_table_init(void)
 	 */
 	get_clidr_el1(NULL, &clidr); /* Ugly... */
 	cache_levels = clidr.val;
-	for (i = 0; i < 7; i++)
-		if (((cache_levels >> (i*3)) & 7) == 0)
+	for (i = 1; i <= MAX_CACHE_LEVEL; i++)
+		if (CLIDR_CTYPE(cache_levels, i) == CACHE_TYPE_NOCACHE)
 			break;
 	/* Clear all higher bits. */
-	cache_levels &= (1 << (i*3))-1;
+	cache_levels &= (1 << CLIDR_CTYPE_SHIFT(i)) - 1;
 }

 /**
--
2.7.4
