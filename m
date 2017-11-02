From: James Morse <james.morse@arm.com>
Subject: [RESEND PATCH v4 2/9] arm64: introduce an order for exceptions
Date: Thu,  2 Nov 2017 12:12:35 +0000
Message-ID: <20171102121242.8925-3-james.morse@arm.com>
References: <20171102121242.8925-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01AA949D4B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:13:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jH7Y+5g3kp1D for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Nov 2017 08:12:58 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C351849D56
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:12:58 -0400 (EDT)
In-Reply-To: <20171102121242.8925-1-james.morse@arm.com>
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
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Currently SError is always masked in the kernel. To support RAS exceptions
using SError on hardware with the v8.2 RAS Extensions we need to unmask
SError as much as possible.

Let's define an order for masking and unmasking exceptions. 'dai' is
memorable and effectively what we have today.

Disabling debug exceptions should cause all other exceptions to be masked.
Masking SError should mask irq, but not disable debug exceptions.
Masking irqs has no side effects for other flags. Keeping to this order
makes it easier for entry.S to know which exceptions should be unmasked.

FIQ is never expected, but we mask it when we mask debug exceptions, and
unmask it at all other times.

Given masking debug exceptions masks everything, we don't need macros
to save/restore that bit independently. Remove them and switch the last
caller over to use the daif calls.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

==
Changes since v3:
 * Use save_daif version, swapped verb/daif word-order.
 * tweak last sentence of commit message.
---
 arch/arm64/include/asm/irqflags.h  | 34 +++++++++++++---------------------
 arch/arm64/kernel/debug-monitors.c |  5 +++--
 2 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index 8c581281fa12..9ecdca7011f0 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -20,6 +20,19 @@
 
 #include <asm/ptrace.h>
 
+/*
+ * Aarch64 has flags for masking: Debug, Asynchronous (serror), Interrupts and
+ * FIQ exceptions, in the 'daif' register. We mask and unmask them in 'dai'
+ * order:
+ * Masking debug exceptions causes all other exceptions to be masked too/
+ * Masking SError masks irq, but not debug exceptions. Masking irqs has no
+ * side effects for other flags. Keeping to this order makes it easier for
+ * entry.S to know which exceptions should be unmasked.
+ *
+ * FIQ is never expected, but we mask it when we disable debug exceptions, and
+ * unmask it at all other times.
+ */
+
 /*
  * CPU interrupt mask handling.
  */
@@ -89,26 +102,5 @@ static inline int arch_irqs_disabled_flags(unsigned long flags)
 {
 	return flags & PSR_I_BIT;
 }
-
-/*
- * save and restore debug state
- */
-#define local_dbg_save(flags)						\
-	do {								\
-		typecheck(unsigned long, flags);			\
-		asm volatile(						\
-		"mrs    %0, daif		// local_dbg_save\n"	\
-		"msr    daifset, #8"					\
-		: "=r" (flags) : : "memory");				\
-	} while (0)
-
-#define local_dbg_restore(flags)					\
-	do {								\
-		typecheck(unsigned long, flags);			\
-		asm volatile(						\
-		"msr    daif, %0		// local_dbg_restore\n"	\
-		: : "r" (flags) : "memory");				\
-	} while (0)
-
 #endif
 #endif
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index c7ef99904934..a88b6ccebbb4 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -30,6 +30,7 @@
 
 #include <asm/cpufeature.h>
 #include <asm/cputype.h>
+#include <asm/daifflags.h>
 #include <asm/debug-monitors.h>
 #include <asm/system_misc.h>
 
@@ -46,9 +47,9 @@ u8 debug_monitors_arch(void)
 static void mdscr_write(u32 mdscr)
 {
 	unsigned long flags;
-	local_dbg_save(flags);
+	flags = local_daif_save();
 	write_sysreg(mdscr, mdscr_el1);
-	local_dbg_restore(flags);
+	local_daif_restore(flags);
 }
 NOKPROBE_SYMBOL(mdscr_write);
 
-- 
2.15.0.rc2
