From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v6 11/15] KVM: arm64: read initial LPI pending table
Date: Fri, 17 Jun 2016 13:08:43 +0100
Message-ID: <1466165327-32060-12-git-send-email-andre.przywara@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71F0149B97
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2016 08:04:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c0HGXyr4YfbM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2016 08:04:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DEF049BBE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2016 08:04:16 -0400 (EDT)
In-Reply-To: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The LPI pending status for a GICv3 redistributor is held in a table
in (guest) memory. To achieve reasonable performance, we cache this
data in our struct vgic_irq. The initial pending state must be read
from guest memory upon enabling LPIs for this redistributor.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |  6 ++++++
 2 files changed, 49 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 9ef951f7..ba2af85 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -149,6 +149,43 @@ struct its_itte {
 
 #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
 #define BASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
+#define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
+
+/*
+ * Scan the whole LPI pending table and sync the pending bit in there
+ * with our own data structures. This relies on the LPI being
+ * mapped before.
+ */
+static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
+{
+	gpa_t pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct vgic_irq *irq;
+	u8 pendmask;
+	int ret = 0;
+
+	mutex_lock(&dist->lpi_list_lock);
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_entry) {
+		int byte_offset, bit_nr;
+
+		byte_offset = irq->intid / BITS_PER_BYTE;
+		bit_nr = irq->intid % BITS_PER_BYTE;
+
+		ret = kvm_read_guest(vcpu->kvm, pendbase + byte_offset,
+				     &pendmask, 1);
+		if (ret)
+			goto out_unlock;
+
+		spin_lock(&irq->irq_lock);
+		irq->pending = pendmask & (1U << bit_nr);
+		vgic_queue_irq_put(vcpu->kvm, irq);
+	}
+
+out_unlock:
+	mutex_unlock(&dist->lpi_list_lock);
+
+	return ret;
+}
 
 #define ITS_FRAME(addr) ((addr) & ~(SZ_64K - 1))
 
@@ -454,6 +491,12 @@ struct vgic_register_region its_registers[] = {
 		VGIC_ACCESS_32bit),
 };
 
+/* This is called on setting the LPI enable bit in the redistributor. */
+void vgic_enable_lpis(struct kvm_vcpu *vcpu)
+{
+	its_sync_lpi_pending_table(vcpu);
+}
+
 static int vits_register(struct kvm *kvm, struct vgic_its *its)
 {
 	struct vgic_io_device *iodev = &its->iodev;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 558252d..8c2105a 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -25,6 +25,7 @@
 #define IS_VGIC_ADDR_UNDEF(_x)  ((_x) == VGIC_ADDR_UNDEF)
 
 #define INTERRUPT_ID_BITS_SPIS	10
+#define INTERRUPT_ID_BITS_ITS	16
 #define VGIC_PRI_BITS		5
 
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
@@ -82,6 +83,7 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
+void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -148,6 +150,10 @@ static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
 {
 	return NULL;
 }
+
+static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
+{
+}
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.8.2
