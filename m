From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 17/56] KVM: arm/arm64: vgic-new: Add IRQ sorting
Date: Mon, 16 May 2016 10:53:05 +0100
Message-ID: <1463392481-26583-18-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Adds the sorting function to cover the case where you have more IRQs
to consider than you have LRs. We now consider priorities.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 62fede6..1bc8f92 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -16,6 +16,7 @@
 
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/list_sort.h>
 
 #include "vgic.h"
 
@@ -103,6 +104,62 @@ static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
 }
 
 /*
+ * The order of items in the ap_lists defines how we'll pack things in LRs as
+ * well, the first items in the list being the first things populated in the
+ * LRs.
+ *
+ * A hard rule is that active interrupts can never be pushed out of the LRs
+ * (and therefore take priority) since we cannot reliably trap on deactivation
+ * of IRQs and therefore they have to be present in the LRs.
+ *
+ * Otherwise things should be sorted by the priority field and the GIC
+ * hardware support will take care of preemption of priority groups etc.
+ *
+ * Return negative if "a" sorts before "b", 0 to preserve order, and positive
+ * to sort "b" before "a".
+ */
+static int vgic_irq_cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct vgic_irq *irqa = container_of(a, struct vgic_irq, ap_list);
+	struct vgic_irq *irqb = container_of(b, struct vgic_irq, ap_list);
+	bool penda, pendb;
+	int ret;
+
+	spin_lock(&irqa->irq_lock);
+	spin_lock(&irqb->irq_lock);
+
+	if (irqa->active || irqb->active) {
+		ret = (int)irqb->active - (int)irqa->active;
+		goto out;
+	}
+
+	penda = irqa->enabled && irqa->pending;
+	pendb = irqb->enabled && irqb->pending;
+
+	if (!penda || !pendb) {
+		ret = (int)pendb - (int)penda;
+		goto out;
+	}
+
+	/* Both pending and enabled, sort by priority */
+	ret = irqa->priority - irqb->priority;
+out:
+	spin_unlock(&irqb->irq_lock);
+	spin_unlock(&irqa->irq_lock);
+	return ret;
+}
+
+/* Must be called with the ap_list_lock held */
+static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
+
+	list_sort(NULL, &vgic_cpu->ap_list_head, vgic_irq_cmp);
+}
+
+/*
  * Only valid injection if changing level for level-triggered IRQs or for a
  * rising edge.
  */
-- 
2.8.2

