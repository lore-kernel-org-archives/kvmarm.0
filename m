From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 29/52] irqchip/gic-v4: Add per-VM VPE domain creation
Date: Wed, 28 Jun 2017 16:03:48 +0100
Message-ID: <20170628150411.15846-30-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EEE749BFF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gs3h38ULZweV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2910640FA5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:18 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

When creating a VM, it is very convenient to have an irq domain
containing all the doorbell interrupts associated with that VM
(each interrupt representing a VPE).

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v4.c       | 58 ++++++++++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v4.h |  3 ++
 2 files changed, 61 insertions(+)
 create mode 100644 drivers/irqchip/irq-gic-v4.c

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
new file mode 100644
index 000000000000..2ea12baf2e53
--- /dev/null
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -0,0 +1,58 @@
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
+static struct irq_domain *gic_domain;
+static const struct irq_domain_ops *vpe_domain_ops;
+
+int its_alloc_vcpu_irqs(struct its_vm *vm)
+{
+	int vpe_base_irq, i;
+
+	vm->domain = irq_domain_create_hierarchy(gic_domain, 0, vm->nr_vpes,
+						 NULL, vpe_domain_ops, vm);
+	if (!vm->domain)
+		return -ENOMEM;
+
+	for (i = 0; i < vm->nr_vpes; i++) {
+		vm->vpes[i]->its_vm = vm;
+		vm->vpes[i]->idai = true;
+	}
+
+	vpe_base_irq = __irq_domain_alloc_irqs(vm->domain, -1, vm->nr_vpes,
+					       NUMA_NO_NODE, vm,
+					       false, NULL);
+	if (vpe_base_irq <= 0)
+		return -ENOMEM;
+
+	for (i = 0; i < vm->nr_vpes; i++)
+		vm->vpes[i]->irq = vpe_base_irq + i;
+
+	return 0;
+}
+
+void its_free_vcpu_irqs(struct its_vm *vm)
+{
+	irq_domain_free_irqs(vm->vpes[0]->irq, vm->nr_vpes);
+	irq_domain_remove(vm->domain);
+}
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 4cac48e220da..7474a981ed6d 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -88,4 +88,7 @@ struct its_cmd_info {
 	};
 };
 
+int its_alloc_vcpu_irqs(struct its_vm *vm);
+void its_free_vcpu_irqs(struct its_vm *vm);
+
 #endif
-- 
2.11.0
