From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 10/13] KVM: arm64: sync LPI configuration and pending tables
Date: Fri,  3 Jun 2016 15:02:49 +0100
Message-ID: <1464962572-3925-11-git-send-email-andre.przywara@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
 virt/kvm/arm/vgic/vgic-its.c | 145 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h     |   6 ++
 3 files changed, 153 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 77f4503..dec63f0 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -131,6 +131,8 @@ struct vgic_its {
 	u32			cwriter;
 	struct list_head	device_list;
 	struct list_head	collection_list;
+	/* memory used for buffering guest's memory */
+	void			*buffer_page;
 };
 
 struct vgic_dist {
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 4f248ef..84e6f3b 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -93,6 +93,128 @@ static struct its_itte *find_itte_by_lpi(struct vgic_its *its, int lpi)
 
 #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
 
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
+	vgic_queue_irq_unlock(kvm, &itte->irq);
+}
+
+#define GIC_LPI_OFFSET 8192
+
+/* We scan the table in chunks the size of the smallest page size */
+#define CHUNK_SIZE 4096U
+
+static u32 max_lpis_propbaser(u64 propbaser)
+{
+	int nr_idbits = (propbaser & 0x1f) + 1;
+
+	return 1U << min(nr_idbits, INTERRUPT_ID_BITS_ITS);
+}
+
+/*
+ * Scan the whole LPI configuration table and put the LPI configuration
+ * data in our own data structures. This relies on the LPI being
+ * mapped before.
+ */
+static bool its_update_lpis_configuration(struct kvm *kvm, struct vgic_its *its,
+					  u64 prop_base_reg)
+{
+	u8 *prop = its->buffer_page;
+	u32 tsize;
+	gpa_t propbase;
+	int lpi = GIC_LPI_OFFSET;
+	struct its_itte *itte;
+	struct its_device *device;
+	int ret;
+
+	propbase = BASER_BASE_ADDRESS(prop_base_reg);
+	tsize = max_lpis_propbaser(prop_base_reg);
+
+	while (tsize > 0) {
+		int chunksize = min(tsize, CHUNK_SIZE);
+
+		ret = kvm_read_guest(kvm, propbase, prop, chunksize);
+		if (ret)
+			return false;
+
+		spin_lock(&its->lock);
+		/*
+		 * Updating the status for all allocated LPIs. We catch
+		 * those LPIs that get disabled. We really don't care
+		 * about unmapped LPIs, as they need to be updated
+		 * later manually anyway once they get mapped.
+		 */
+		for_each_lpi(device, itte, its) {
+			if (itte->lpi < lpi || itte->lpi >= lpi + chunksize)
+				continue;
+
+			update_lpi_config(kvm, itte, prop[itte->lpi - lpi]);
+		}
+		spin_unlock(&its->lock);
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
+static bool its_sync_lpi_pending_table(struct kvm_vcpu *vcpu,
+				       struct vgic_its *its, u64 base_addr_reg)
+{
+	unsigned long *pendmask = its->buffer_page;
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
+		nr_bits = min(nr_lpis, CHUNK_SIZE * BITS_PER_BYTE);
+
+		ret = kvm_read_guest(vcpu->kvm, pendbase, pendmask,
+				     nr_bits / BITS_PER_BYTE);
+		if (ret)
+			return false;
+
+		spin_lock(&its->lock);
+		for_each_lpi(device, itte, its) {
+			lpi_bit = itte->lpi - lpi;
+			if (lpi_bit < 0 || lpi_bit >= nr_bits)
+				continue;
+
+			if (!test_bit(lpi_bit, pendmask))
+				continue;
+
+			spin_lock(&itte->irq.irq_lock);
+			itte->irq.pending = true;
+			vgic_queue_irq_unlock(vcpu->kvm, &itte->irq);
+		}
+		spin_unlock(&its->lock);
+		nr_lpis -= nr_bits;
+		lpi += nr_bits;
+		pendbase += nr_bits / BITS_PER_BYTE;
+	}
+
+	return true;
+}
+
 #define ITS_FRAME(addr) ((addr) & ~(SZ_64K - 1))
 
 static unsigned long vgic_mmio_read_its_ctlr(struct kvm_vcpu *vcpu,
@@ -355,6 +477,21 @@ struct vgic_register_region its_registers[] = {
 		VGIC_ACCESS_32bit),
 };
 
+/* This is called on setting the LPI enable bit in the redistributor. */
+void vgic_enable_lpis(struct kvm_vcpu *vcpu)
+{
+	u64 prop_base_reg, pend_base_reg;
+	struct vgic_its *its;
+
+	pend_base_reg = vcpu->arch.vgic_cpu.pendbaser;
+	prop_base_reg = vcpu->kvm->arch.vgic.propbaser;
+
+	list_for_each_entry(its, &vcpu->kvm->arch.vits_list, its_list) {
+		its_update_lpis_configuration(vcpu->kvm, its, prop_base_reg);
+		its_sync_lpi_pending_table(vcpu, its, pend_base_reg);
+	}
+}
+
 int vits_init(struct kvm *kvm, struct vgic_its *its)
 {
 	struct vgic_io_device *iodev = &its->iodev;
@@ -381,6 +518,8 @@ void vits_destroy(struct kvm *kvm, struct vgic_its *its)
 	struct list_head *dev_cur, *dev_temp;
 	struct list_head *cur, *temp;
 
+	kfree(its->buffer_page);
+
 	/*
 	 * We may end up here without the lists ever having been initialized.
 	 * Check this and bail out early to avoid dereferencing a NULL pointer.
@@ -419,6 +558,12 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	if (!its)
 		return -ENOMEM;
 
+	its->buffer_page = kmalloc(CHUNK_SIZE, GFP_KERNEL);
+	if (!its->buffer_page) {
+		kfree(its);
+		return -ENOMEM;
+	}
+
 	spin_lock_init(&its->lock);
 
 	its->vgic_its_base = VGIC_ADDR_UNDEF;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 6fecd70..46c239f 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -25,6 +25,7 @@
 #define IS_VGIC_ADDR_UNDEF(_x)  ((_x) == VGIC_ADDR_UNDEF)
 
 #define INTERRUPT_ID_BITS_SPIS	10
+#define INTERRUPT_ID_BITS_ITS	16
 #define VGIC_PRI_BITS		5
 
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
@@ -79,6 +80,7 @@ int vits_init(struct kvm *kvm, struct vgic_its *its);
 void vits_destroy(struct kvm *kvm, struct vgic_its *its);
 int kvm_vgic_register_its_device(void);
 struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid);
+void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -154,6 +156,10 @@ static inline struct vgic_irq *vgic_its_get_lpi(struct kvm *kvm, u32 intid)
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

