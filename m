From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 19/59] KVM: arm/arm64: vgic-new: Add IRQ sorting
Date: Tue, 24 May 2016 11:09:13 +0200
Message-ID: <1464080993-10884-20-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B09F349BCB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j7JZPeCgtWg2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:44 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED93D49BBB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:41 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id a136so62249777wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:15 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

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
index ada1d02..bce17de 100644
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
+	spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
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
2.1.2.330.g565301e.dirty
