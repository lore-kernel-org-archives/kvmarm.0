From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 29/33] irqchip/gic-v4: Add per-VM VPE domain creation
Date: Tue, 17 Jan 2017 10:20:50 +0000
Message-ID: <1484648454-21216-30-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 603274095A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:20:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5YQemB2oPDKq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:20:04 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0801D4097B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:20:04 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

When creating a VM, it is very convenient to have an irq domain
containing all the doorbell interrupts associated with that VM
(each interrupt representing a VPE).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v4.c       | 111 +++++++++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v4.h |   3 +
 2 files changed, 114 insertions(+)
 create mode 100644 drivers/irqchip/irq-gic-v4.c

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
new file mode 100644
index 0000000..b9a0b34
--- /dev/null
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -0,0 +1,111 @@
+/*
+ * Copyright (C) 2016 ARM Limited, All Rights Reserved.
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
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
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/msi.h>
+
+#include <linux/irqchip/arm-gic-v4.h>
+
+static struct irq_domain *its_vpe_domain;
+
+static struct irq_chip its_vcpu_irq_chip = {
+	.name			= "GICv4-vcpu",
+	.irq_mask		= irq_chip_mask_parent,
+	.irq_unmask		= irq_chip_unmask_parent,
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_set_affinity	= irq_chip_set_affinity_parent,
+	.irq_set_vcpu_affinity	= irq_chip_set_vcpu_affinity_parent,
+};
+
+static int its_vcpu_irq_domain_alloc(struct irq_domain *domain,
+				     unsigned int virq,
+				     unsigned int nr_irqs, void *args)
+{
+	msi_alloc_info_t info;
+	struct its_vpe **vpes = args;
+	int err, i;
+
+	info.desc = NULL;
+	info.scratchpad[0].ptr = vpes;
+
+	/* Allocate LPIs at the redistributor level */
+	err = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, &info);
+	if (err)
+		return err;
+
+	for (i = 0; i < nr_irqs; i++) {
+		irq_domain_set_hwirq_and_chip(domain, virq + i, i,
+					      &its_vcpu_irq_chip, vpes[i]);
+	}
+
+	return 0;
+}
+
+static void its_vcpu_irq_domain_free(struct irq_domain *domain,
+				     unsigned int virq,
+				     unsigned int nr_irqs)
+{
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_data *data = irq_domain_get_irq_data(domain,
+								virq + i);
+
+		irq_domain_reset_irq_data(data);
+	}
+
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
+static const struct irq_domain_ops vcpu_domain_ops = {
+	.alloc	= its_vcpu_irq_domain_alloc,
+	.free	= its_vcpu_irq_domain_free,
+};
+
+int its_alloc_vcpu_irqs(struct its_vm *vm, struct its_vpe **vpes, int nr_vpes)
+{
+	int vpe_base_irq, i;
+
+	vm->domain = irq_domain_create_hierarchy(its_vpe_domain, 0, nr_vpes,
+						 NULL, &vcpu_domain_ops,
+						 vpes);
+	if (!vm->domain)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_vpes; i++) {
+		vpes[i]->its_vm = vm;
+		vpes[i]->idai = true;
+	}
+
+	vpe_base_irq = __irq_domain_alloc_irqs(vm->domain, -1, nr_vpes,
+					       NUMA_NO_NODE, vpes,
+					       false, NULL);
+	return vpe_base_irq;
+}
+
+void its_free_vcpu_irqs(struct its_vm *vm, int nr_vpes)
+{
+	unsigned int irq;
+
+	irq = irq_find_mapping(vm->domain, 0);
+	if (!irq)
+		return;
+
+	irq_domain_free_irqs(irq, nr_vpes);
+}
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 6e9c2b3..2463d70 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -89,4 +89,7 @@ struct its_cmd_info {
 	};
 };
 
+int its_alloc_vcpu_irqs(struct its_vm *vm, struct its_vpe **vpes, int nr_vpes);
+void its_free_vcpu_irqs(struct its_vm *vm, int nr_vpes);
+
 #endif
-- 
2.1.4
