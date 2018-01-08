From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 08/16] arm64: Add vmap_stack header file
Date: Mon,  8 Jan 2018 15:38:10 +0000
Message-ID: <20180108153818.22743-9-james.morse@arm.com>
References: <20180108153818.22743-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25A5149DB2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 10:36:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TXlMQU8dka2x for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jan 2018 10:36:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1450E49DF4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jan 2018 10:36:27 -0500 (EST)
In-Reply-To: <20180108153818.22743-1-james.morse@arm.com>
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
Cc: devicetree@vger.kernel.org, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>, Loc Ho <lho@apm.com>, Heyi Guo <guoheyi@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Today the arm64 arch code allocates an extra IRQ stack per-cpu. If we
also have SDEI and VMAP stacks we need two extra per-cpu VMAP stacks.

Move the VMAP stack allocation out to a helper in a new header file.
This avoids missing THREADINFO_GFP, or getting the all-important alignment
wrong.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
---
Changes since v5:
 * Added two required header files

Changes since v4:
 * Added gfp.h include

Changes since v3:
 * Added BUILD_BUG() instead of a spooky link error

 arch/arm64/include/asm/vmap_stack.h | 28 ++++++++++++++++++++++++++++
 arch/arm64/kernel/irq.c             | 13 ++-----------
 2 files changed, 30 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm64/include/asm/vmap_stack.h

diff --git a/arch/arm64/include/asm/vmap_stack.h b/arch/arm64/include/asm/vmap_stack.h
new file mode 100644
index 000000000000..0b5ec6e08c10
--- /dev/null
+++ b/arch/arm64/include/asm/vmap_stack.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2017 Arm Ltd.
+#ifndef __ASM_VMAP_STACK_H
+#define __ASM_VMAP_STACK_H
+
+#include <linux/bug.h>
+#include <linux/gfp.h>
+#include <linux/kconfig.h>
+#include <linux/vmalloc.h>
+#include <asm/memory.h>
+#include <asm/pgtable.h>
+#include <asm/thread_info.h>
+
+/*
+ * To ensure that VMAP'd stack overflow detection works correctly, all VMAP'd
+ * stacks need to have the same alignment.
+ */
+static inline unsigned long *arch_alloc_vmap_stack(size_t stack_size, int node)
+{
+	BUILD_BUG_ON(!IS_ENABLED(CONFIG_VMAP_STACK));
+
+	return __vmalloc_node_range(stack_size, THREAD_ALIGN,
+				    VMALLOC_START, VMALLOC_END,
+				    THREADINFO_GFP, PAGE_KERNEL, 0, node,
+				    __builtin_return_address(0));
+}
+
+#endif /* __ASM_VMAP_STACK_H */
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 713561e5bcab..60e5fc661f74 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -29,6 +29,7 @@
 #include <linux/irqchip.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
+#include <asm/vmap_stack.h>
 
 unsigned long irq_err_count;
 
@@ -58,17 +59,7 @@ static void init_irq_stacks(void)
 	unsigned long *p;
 
 	for_each_possible_cpu(cpu) {
-		/*
-		* To ensure that VMAP'd stack overflow detection works
-		* correctly, the IRQ stacks need to have the same
-		* alignment as other stacks.
-		*/
-		p = __vmalloc_node_range(IRQ_STACK_SIZE, THREAD_ALIGN,
-					 VMALLOC_START, VMALLOC_END,
-					 THREADINFO_GFP, PAGE_KERNEL,
-					 0, cpu_to_node(cpu),
-					 __builtin_return_address(0));
-
+		p = arch_alloc_vmap_stack(IRQ_STACK_SIZE, cpu_to_node(cpu));
 		per_cpu(irq_stack_ptr, cpu) = p;
 	}
 }
-- 
2.15.0
