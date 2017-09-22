From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v3 08/13] arm64: Add vmap_stack header file
Date: Fri, 22 Sep 2017 19:26:09 +0100
Message-ID: <20170922182614.27885-9-james.morse@arm.com>
References: <20170922182614.27885-1-james.morse@arm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170922182614.27885-1-james.morse-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

Today the arm64 arch code allocates an extra IRQ stack per-cpu. If we
also have SDEI and VMAP stacks we need two extra per-cpu VMAP stacks.

Move the VMAP stack allocation out to a helper in a new header file.
This avoids missing THREADINFO_GFP, or getting the all-important alignment
wrong.

Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>

---
This patch is new for v3. Having a bare prototype if VMAP stacks aren't
enabled allows us to avoid ifdeffery but still forbid building code using
the symbol.

 arch/arm64/include/asm/vmap_stack.h | 41 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/irq.c             | 13 ++----------
 2 files changed, 43 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm64/include/asm/vmap_stack.h

diff --git a/arch/arm64/include/asm/vmap_stack.h b/arch/arm64/include/asm/vmap_stack.h
new file mode 100644
index 000000000000..f41d043cac31
--- /dev/null
+++ b/arch/arm64/include/asm/vmap_stack.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2017 ARM Ltd.
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
+#ifndef __ASM_VMAP_STACK_H
+#define __ASM_VMAP_STACK_H
+
+#include <linux/vmalloc.h>
+#include <asm/memory.h>
+#include <asm/pgtable.h>
+#include <asm/thread_info.h>
+
+#ifdef CONFIG_VMAP_STACK
+/*
+ * To ensure that VMAP'd stack overflow detection works correctly, all VMAP'd
+ * stacks need to have the same alignment.
+ */
+static inline unsigned long *arch_alloc_vmap_stack(size_t stack_size, int node)
+{
+	return __vmalloc_node_range(stack_size, THREAD_ALIGN,
+				    VMALLOC_START, VMALLOC_END,
+				    THREADINFO_GFP, PAGE_KERNEL, 0, node,
+				    __builtin_return_address(0));
+}
+
+#else
+unsigned long *arch_alloc_vmap_stack(size_t stack_size, int node); // link error
+
+#endif /* CONFIG_VMAP_STACK */
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
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
