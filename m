From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 09/12] KVM: arm64: sync LPI configuration and pending tables
Date: Sat, 26 Mar 2016 02:14:07 +0000
Message-ID: <1458958450-19662-10-git-send-email-andre.przywara@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The LPI configuration and pending tables of the GICv3 LPIs are held
in tables in (guest) memory. To achieve reasonable performance, we
cache this data in our own data structures, so we need to sync those
two views from time to time. This behaviour is well described in the
GICv3 spec and is also exercised by hardware, so the sync points are
well known.

Provide functions that read the guest memory and store the
information from the configuration and pending tables in the kernel.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h      |   2 +
 virt/kvm/arm/vgic/its-emul.c | 135 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |   1 +
 3 files changed, 138 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index ecf3260..ea98133 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -121,6 +121,8 @@ struct vgic_its {
 	int			cwriter;
 	struct list_head	device_list;
 	struct list_head	collection_list;
+	/* memory used for buffering guest's memory */
+	void			*buffer_page;
 };
 
 struct vgic_dist {
diff --git a/virt/kvm/arm/vgic/its-emul.c b/virt/kvm/arm/vgic/its-emul.c
index 1188e9a..d82ba9b 100644
--- a/virt/kvm/arm/vgic/its-emul.c
+++ b/virt/kvm/arm/vgic/its-emul.c
@@ -78,8 +78,130 @@ static struct its_itte *find_itte_by_lpi(struct kvm *kvm, int lpi)
 	return NULL;
 }
 
+#define LPI_PROP_ENABLE_BIT(p)	((p) & LPI_PROP_ENABLED)
+#define LPI_PROP_PRIORITY(p)	((p) & 0xfc)
+
+/* stores the priority and enable bit for a given LPI */
+static void update_lpi_config(struct kvm *kvm, struct its_itte *itte, u8 prop)
+{
+	spin_lock(&itte->irq.irq_lock);
+	itte->irq.priority = LPI_PROP_PRIORITY(prop);
+	itte->irq.enabled = LPI_PROP_ENABLE_BIT(prop);
+
+	vgic_queue_irq(kvm, &itte->irq);
+}
+
+#define GIC_LPI_OFFSET 8192
+
+/* We scan the table in chunks the size of the smallest page size */
+#define CHUNK_SIZE 4096U
+
 #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
 
+static int nr_idbits_propbase(u64 propbaser)
+{
+	int nr_idbits = (1U << (propbaser & 0x1f)) + 1;
+
+	return max(nr_idbits, INTERRUPT_ID_BITS_ITS);
+}
+
+/*
+ * Scan the whole LPI configuration table and put the LPI configuration
+ * data in our own data structures. This relies on the LPI being
+ * mapped before.
+ */
+static bool its_update_lpis_configuration(struct kvm *kvm, u64 prop_base_reg)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	u8 *prop = dist->its.buffer_page;
+	u32 tsize;
+	gpa_t propbase;
+	int lpi = GIC_LPI_OFFSET;
+	struct its_itte *itte;
+	struct its_device *device;
+	int ret;
+
+	propbase = BASER_BASE_ADDRESS(prop_base_reg);
+	tsize = nr_idbits_propbase(prop_base_reg);
+
+	while (tsize > 0) {
+		int chunksize = min(tsize, CHUNK_SIZE);
+
+		ret = kvm_read_guest(kvm, propbase, prop, chunksize);
+		if (ret)
+			return false;
+
+		spin_lock(&dist->its.lock);
+		/*
+		 * Updating the status for all allocated LPIs. We catch
+		 * those LPIs that get disabled. We really don't care
+		 * about unmapped LPIs, as they need to be updated
+		 * later manually anyway once they get mapped.
+		 */
+		for_each_lpi(device, itte, kvm) {
+			if (itte->lpi < lpi || itte->lpi >= lpi + chunksize)
+				continue;
+
+			update_lpi_config(kvm, itte, prop[itte->lpi - lpi]);
+		}
+		spin_unlock(&dist->its.lock);
+		tsize -= chunksize;
+		lpi += chunksize;
+		propbase += chunksize;
+	}
+
+	return true;
+}
+
+/*
+ * Scan the whole LPI pending table and sync the pending bit in there
+ * with our own data structures. This relies on the LPI being
+ * mapped before.
+ */
+static bool its_sync_lpi_pending_table(struct kvm_vcpu *vcpu, u64 base_addr_reg)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	unsigned long *pendmask = dist->its.buffer_page;
+	u32 nr_lpis = 1U << INTERRUPT_ID_BITS_ITS;
+	gpa_t pendbase;
+	int lpi = 0;
+	struct its_itte *itte;
+	struct its_device *device;
+	int ret;
+	int lpi_bit, nr_bits;
+
+	pendbase = BASER_BASE_ADDRESS(base_addr_reg);
+
+	while (nr_lpis > 0) {
+		nr_bits = min(nr_lpis, CHUNK_SIZE * 8);
+
+		ret = kvm_read_guest(vcpu->kvm, pendbase, pendmask,
+				     nr_bits / 8);
+		if (ret)
+			return false;
+
+		spin_lock(&dist->its.lock);
+		for_each_lpi(device, itte, vcpu->kvm) {
+			lpi_bit = itte->lpi - lpi;
+			if (lpi_bit < 0 || lpi_bit >= nr_bits)
+				continue;
+
+			if (!test_bit(lpi_bit, pendmask))
+				continue;
+
+			spin_lock(&itte->irq.irq_lock);
+			itte->irq.pending = true;
+			vgic_queue_irq(vcpu->kvm, &itte->irq);
+		}
+		spin_unlock(&dist->its.lock);
+		nr_lpis -= nr_bits;
+		lpi += nr_bits;
+		pendbase += nr_bits / 8;
+	}
+
+	return true;
+}
+
 static int vgic_mmio_read_its_ctlr(struct kvm_vcpu *vcpu,
 				   struct kvm_io_device *this,
 				   gpa_t addr, int len, void *val)
@@ -357,6 +479,14 @@ struct vgic_register_region its_registers[] = {
 /* This is called on setting the LPI enable bit in the redistributor. */
 void vgic_enable_lpis(struct kvm_vcpu *vcpu)
 {
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	u64 prop_base_reg, pend_base_reg;
+
+	pend_base_reg = dist->pendbaser[vcpu->vcpu_id];
+	prop_base_reg = dist->propbaser;
+
+	its_update_lpis_configuration(vcpu->kvm, prop_base_reg);
+	its_sync_lpi_pending_table(vcpu, pend_base_reg);
 }
 
 int vits_init(struct kvm *kvm)
@@ -371,6 +501,10 @@ int vits_init(struct kvm *kvm)
 	if (!dist->pendbaser)
 		return -ENOMEM;
 
+	its->buffer_page = kmalloc(CHUNK_SIZE, GFP_KERNEL);
+	if (!its->buffer_page)
+		return -ENOMEM;
+
 	spin_lock_init(&its->lock);
 
 	INIT_LIST_HEAD(&its->device_list);
@@ -430,6 +564,7 @@ void vits_destroy(struct kvm *kvm)
 		kfree(container_of(cur, struct its_collection, coll_list));
 	}
 
+	kfree(its->buffer_page);
 	kfree(dist->pendbaser);
 
 	its->enabled = false;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 160c511..a7218b0 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -23,6 +23,7 @@
 #define IS_VGIC_ADDR_UNDEF(_x)  ((_x) == VGIC_ADDR_UNDEF)
 
 #define INTERRUPT_ID_BITS_SPIS	10
+#define INTERRUPT_ID_BITS_ITS	16
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
-- 
2.7.3

