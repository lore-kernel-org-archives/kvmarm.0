From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 02/16] arm64: introduce an order for exceptions
Date: Fri, 28 Jul 2017 15:10:05 +0100
Message-ID: <20170728141019.9084-3-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED42240D25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id olArQU045-IK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:10:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BB9349C24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:34 -0400 (EDT)
In-Reply-To: <20170728141019.9084-1-james.morse@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Lets define an order for masking and unmasking exceptions. To support
v8.2's RAS extentions, which are notified by SError, 'A' needs to be
the highest priority, (so we can leave PSTATE.A unmasked over an eret).
Debug should come next so our order is 'ADI'.

Masking debug exceptions should cause interrupts to be masked, but not
SError. Masking SError should mask all exceptions. Masking Interrupts has
no side effects for other flags. Keeping to this order makes it easier for
entry.S to know which exceptions should be unmasked.

FIQ is never expected, but we mask it when we mask SError exceptions, and
unmask it at all other times.

Change our local_dbg_{save,restore}() helpers to mask Interrupts too.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/irqflags.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index 578d14f376ce..6904f2247394 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -21,6 +21,20 @@
 #include <asm/ptrace.h>
 
 /*
+ * AArch64 has flags for masking: Debug, Asynchronous (serror), Interrupts and
+ * FIQ exceptions, in the 'daif' register. We mask and unmask them in 'adi'
+ * order:
+ * Masking Asynchronous (serror) exceptions should causes all other exceptions
+ * to be masked too. Masking Debug should mask Interrupts, but not Asynchronous
+ * (serror) exceptions. Masking Interrupts has no side effects for other flags.
+ * Keeping to this order makes it easier for entry.S to know which exceptions
+ * should be unmasked.
+ *
+ * FIQ is never expected, but we mask it when we mask Asynchronous (serror)
+ * exceptions, and unmask it at all other times.
+ */
+
+/*
  * CPU interrupt mask handling.
  */
 static inline unsigned long arch_local_irq_save(void)
@@ -91,14 +105,14 @@ static inline int arch_irqs_disabled_flags(unsigned long flags)
 }
 
 /*
- * save and restore debug state
+ * save and restore debug and interrupt flags
  */
 #define local_dbg_save(flags)						\
 	do {								\
 		typecheck(unsigned long, flags);			\
 		asm volatile(						\
 		"mrs    %0, daif		// local_dbg_save\n"	\
-		"msr    daifset, #8"					\
+		"msr    daifset, #(8+2)"				\
 		: "=r" (flags) : : "memory");				\
 	} while (0)
 
-- 
2.13.2
