From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 38/55] KVM: arm64: vgic-its: Read initial LPI pending table
Date: Fri, 22 Jul 2016 18:28:55 +0100
Message-ID: <1469208552-4155-39-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C3249B61
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vCFAncyPgO70 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:24:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BAA849BD5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:24:45 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

The LPI pending status for a GICv3 redistributor is held in a table
in (guest) memory. To achieve reasonable performance, we cache the
pending bit in our struct vgic_irq. The initial pending state must be
read from guest memory upon enabling LPIs for this redistributor.
As we can't access the guest memory while we hold the lpi_list spinlock,
we create a snapshot of the LPI list and iterate over that.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 95 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |  5 +++
 2 files changed, 100 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 14f91ff..2881b84 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -67,6 +67,94 @@ struct its_itte {
  * supports more. Let's be restrictive here.
  */
 #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
+#define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
+
+/*
+ * Create a snapshot of the current LPI list, so that we can enumerate all
+ * LPIs without holding any lock.
+ * Returns the array length and puts the kmalloc'ed array into intid_ptr.
+ */
+static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq;
+	u32 *intids;
+	int irq_count = dist->lpi_list_count, i = 0;
+
+	/*
+	 * We use the current value of the list length, which may change
+	 * after the kmalloc. We don't care, because the guest shouldn't
+	 * change anything while the command handling is still running,
+	 * and in the worst case we would miss a new IRQ, which one wouldn't
+	 * expect to be covered by this command anyway.
+	 */
+	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL);
+	if (!intids)
+		return -ENOMEM;
+
+	spin_lock(&dist->lpi_list_lock);
+	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+		/* We don't need to "get" the IRQ, as we hold the list lock. */
+		intids[i] = irq->intid;
+		if (++i == irq_count)
+			break;
+	}
+	spin_unlock(&dist->lpi_list_lock);
+
+	*intid_ptr = intids;
+	return irq_count;
+}
+
+/*
+ * Scan the whole LPI pending table and sync the pending bit in there
+ * with our own data structures. This relies on the LPI being
+ * mapped before.
+ */
+static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
+{
+	gpa_t pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
+	struct vgic_irq *irq;
+	int last_byte_offset = -1;
+	int ret = 0;
+	u32 *intids;
+	int nr_irqs, i;
+
+	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, &intids);
+	if (nr_irqs < 0)
+		return nr_irqs;
+
+	for (i = 0; i < nr_irqs; i++) {
+		int byte_offset, bit_nr;
+		u8 pendmask;
+
+		byte_offset = intids[i] / BITS_PER_BYTE;
+		bit_nr = intids[i] % BITS_PER_BYTE;
+
+		/*
+		 * For contiguously allocated LPIs chances are we just read
+		 * this very same byte in the last iteration. Reuse that.
+		 */
+		if (byte_offset != last_byte_offset) {
+			ret = kvm_read_guest(vcpu->kvm, pendbase + byte_offset,
+					     &pendmask, 1);
+			if (ret) {
+				kfree(intids);
+				return ret;
+			}
+			last_byte_offset = byte_offset;
+		}
+
+		irq = vgic_get_irq(vcpu->kvm, NULL, intids[i]);
+		spin_lock(&irq->irq_lock);
+		irq->pending = pendmask & (1U << bit_nr);
+		vgic_queue_irq_unlock(vcpu->kvm, irq);
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	kfree(intids);
+
+	return ret;
+}
 
 static unsigned long vgic_mmio_read_its_ctlr(struct kvm *vcpu,
 					     struct vgic_its *its,
@@ -403,6 +491,13 @@ static struct vgic_register_region its_registers[] = {
 		VGIC_ACCESS_32bit),
 };
 
+/* This is called on setting the LPI enable bit in the redistributor. */
+void vgic_enable_lpis(struct kvm_vcpu *vcpu)
+{
+	if (!(vcpu->arch.vgic_cpu.pendbaser & GICR_PENDBASER_PTZ))
+		its_sync_lpi_pending_table(vcpu);
+}
+
 static int vgic_its_init_its(struct kvm *kvm, struct vgic_its *its)
 {
 	struct vgic_io_device *iodev = &its->iodev;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 8192a29..ee348de 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -25,6 +25,7 @@
 #define IS_VGIC_ADDR_UNDEF(_x)  ((_x) == VGIC_ADDR_UNDEF)
 
 #define INTERRUPT_ID_BITS_SPIS	10
+#define INTERRUPT_ID_BITS_ITS	16
 #define VGIC_PRI_BITS		5
 
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
@@ -76,6 +77,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 bool vgic_has_its(struct kvm *kvm);
+void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -133,6 +135,9 @@ static inline bool vgic_has_its(struct kvm *kvm)
 	return false;
 }
 
+static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
+{
+}
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.8.1
