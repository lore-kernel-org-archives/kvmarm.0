From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 14/17] KVM: arm64: allow updates of LPI configuration table
Date: Tue,  5 Jul 2016 12:23:06 +0100
Message-ID: <20160705112309.28877-15-andre.przywara@arm.com>
References: <20160705112309.28877-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A0A49B5B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2016 07:17:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sOYffHP+adRW for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jul 2016 07:17:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95C6649B65
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2016 07:17:17 -0400 (EDT)
In-Reply-To: <20160705112309.28877-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The (system-wide) LPI configuration table is held in a table in
(guest) memory. To achieve reasonable performance, we cache this data
in our struct vgic_irq. If the guest updates the configuration data
(which consists of the enable bit and the priority value), it issues
an INV or INVALL command to allow us to update our information.
Provide functions that update that information for one LPI or all LPIs
mapped to a specific collection.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 45 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 29bb4fe..5de71bd 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -94,6 +94,51 @@ struct its_itte {
 
 #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
 #define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
+#define PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
+
+#define GIC_LPI_OFFSET 8192
+
+#define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
+#define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
+
+/*
+ * Reads the configuration data for a given LPI from guest memory and
+ * updates the fields in struct vgic_irq.
+ * If filter_vcpu is not NULL, applies only if the IRQ is targeting this
+ * VCPU. Unconditionally applies if filter_vcpu is NULL.
+ */
+static int update_lpi_config_filtered(struct kvm *kvm, struct vgic_irq *irq,
+				      struct kvm_vcpu *filter_vcpu)
+{
+	u64 propbase = PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
+	u8 prop;
+	int ret;
+
+	ret = kvm_read_guest(kvm, propbase + irq->intid - GIC_LPI_OFFSET,
+			     &prop, 1);
+
+	if (ret)
+		return ret;
+
+	spin_lock(&irq->irq_lock);
+
+	if (!filter_vcpu || filter_vcpu == irq->target_vcpu) {
+		irq->priority = LPI_PROP_PRIORITY(prop);
+		irq->enabled = LPI_PROP_ENABLE_BIT(prop);
+
+		vgic_queue_irq_unlock(kvm, irq);
+	} else {
+		spin_unlock(&irq->irq_lock);
+	}
+
+	return 0;
+}
+
+/* Updates the priority and enable bit for a given LPI. */
+int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq)
+{
+	return update_lpi_config_filtered(kvm, irq, NULL);
+}
 
 static int vgic_its_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
 {
-- 
2.9.0
