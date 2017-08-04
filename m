From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH][RESEND] arm64: kvm: reuse existing cache type/info related
 macros
Date: Fri,  4 Aug 2017 13:53:57 +0100
Message-ID: <1501851237-13017-1-git-send-email-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E16A849C3D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Aug 2017 08:52:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WIa2NqFz1J2U for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Aug 2017 08:52:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F91E49C2B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Aug 2017 08:52:38 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
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
 arch/arm64/include/asm/cache.h |  7 +++++++
 arch/arm64/kernel/cacheinfo.c  |  7 -------
 arch/arm64/kvm/sys_regs.c      | 29 +++++++++++++++--------------
 3 files changed, 22 insertions(+), 21 deletions(-)

Hi,

I dropped the support for 64bit format CCSIDR after Will's commit a8d4636f96ad
("arm64: cacheinfo: Remove CCSIDR-based cache information probing"). However
I forgot to follow up on this patch which can be still applied. So just
reposting again rebasing on v4.13-rc3 as mentioned by Will as it was too
late for last cycle. Christoffer was fine with the changes but has not
given an official ACK.

Regards,
Sudeep

diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index ea9bb4e0e9bb..70fd4357ed38 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -49,6 +49,13 @@
 #define ICACHEF_VPIPT		1
 extern unsigned long __icache_flags;

+#define MAX_CACHE_LEVEL			7	/* Max 7 level supported */
+/* Ctypen, bits[3(n - 1) + 2 : 3(n - 1)], for n = 1 to 7 */
+#define CLIDR_CTYPE_SHIFT(level)	(3 * (level - 1))
+#define CLIDR_CTYPE_MASK(level)		(7 << CLIDR_CTYPE_SHIFT(level))
+#define CLIDR_CTYPE(clidr, level)	\
+	(((clidr) & CLIDR_CTYPE_MASK(level)) >> CLIDR_CTYPE_SHIFT(level))
+
 /*
  * Whilst the D-side always behaves as PIPT on AArch64, aliasing is
  * permitted in the I-cache.
diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
index 380f2e2fbed5..4798aa4bc17b 100644
--- a/arch/arm64/kernel/cacheinfo.c
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -20,13 +20,6 @@
 #include <linux/cacheinfo.h>
 #include <linux/of.h>

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
index 77862881ae86..5601f77d1e1e 100644
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
+#include <asm/cache.h>
 #include <asm/cputype.h>
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
@@ -79,7 +81,7 @@ static bool write_to_read_only(struct kvm_vcpu *vcpu,
 static u32 cache_levels;

 /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
-#define CSSELR_MAX 12
+#define CSSELR_MAX	((MAX_CACHE_LEVEL - 1) << 1)

 /* Which cache CCSIDR represents depends on CSSELR value. */
 static u32 get_ccsidr(u32 csselr)
@@ -1913,19 +1915,18 @@ static bool is_valid_cache(u32 val)
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
@@ -2192,11 +2193,11 @@ void kvm_sys_reg_table_init(void)
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
