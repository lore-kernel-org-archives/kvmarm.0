From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 06/11] KVM: arm/arm64: vgic: Allow dynamic mapping of physical/virtual interrupts
Date: Fri,  7 Aug 2015 16:45:42 +0100
Message-ID: <1438962347-17541-7-git-send-email-marc.zyngier@arm.com>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to be able to feed physical interrupts to a guest, we need
to be able to establish the virtual-physical mapping between the two
worlds.

The mappings are kept in a set of RCU lists, indexed by virtual interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c     |   2 +
 include/kvm/arm_vgic.h |  25 ++++++
 virt/kvm/arm/vgic.c    | 209 ++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 235 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index f1bf418..ce404a5 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -125,6 +125,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_free_stage2_pgd;
 
+	kvm_vgic_early_init(kvm);
 	kvm_timer_init(kvm);
 
 	/* Mark the initial VMID generation invalid */
@@ -249,6 +250,7 @@ out:
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
+	kvm_vgic_vcpu_early_init(vcpu);
 }
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a881e39..c0e6354 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -159,6 +159,19 @@ struct vgic_io_device {
 	struct kvm_io_device dev;
 };
 
+struct irq_phys_map {
+	u32			virt_irq;
+	u32			phys_irq;
+	u32			irq;
+	bool			active;
+};
+
+struct irq_phys_map_entry {
+	struct list_head	entry;
+	struct rcu_head		rcu;
+	struct irq_phys_map	map;
+};
+
 struct vgic_dist {
 	spinlock_t		lock;
 	bool			in_kernel;
@@ -256,6 +269,10 @@ struct vgic_dist {
 	struct vgic_vm_ops	vm_ops;
 	struct vgic_io_device	dist_iodev;
 	struct vgic_io_device	*redist_iodevs;
+
+	/* Virtual irq to hwirq mapping */
+	spinlock_t		irq_phys_map_lock;
+	struct list_head	irq_phys_map_list;
 };
 
 struct vgic_v2_cpu_if {
@@ -307,6 +324,9 @@ struct vgic_cpu {
 		struct vgic_v2_cpu_if	vgic_v2;
 		struct vgic_v3_cpu_if	vgic_v3;
 	};
+
+	/* Protected by the distributor's irq_phys_map_lock */
+	struct list_head	irq_phys_map_list;
 };
 
 #define LR_EMPTY	0xff
@@ -321,8 +341,10 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
 int kvm_vgic_hyp_init(void);
 int kvm_vgic_map_resources(struct kvm *kvm);
 int kvm_vgic_get_max_vcpus(void);
+void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
+void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
@@ -331,6 +353,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
+struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
+					   int virt_irq, int irq);
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 5bd1695..51c9900 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/rculist.h>
 #include <linux/uaccess.h>
 
 #include <asm/kvm_emulate.h>
@@ -74,6 +75,28 @@
  *   cause the interrupt to become inactive in such a situation.
  *   Conversely, writes to GICD_ICPENDRn do not cause the interrupt to become
  *   inactive as long as the external input line is held high.
+ *
+ *
+ * Initialization rules: there are multiple stages to the vgic
+ * initialization, both for the distributor and the CPU interfaces.
+ *
+ * Distributor:
+ *
+ * - kvm_vgic_early_init(): initialization of static data that doesn't
+ *   depend on any sizing information or emulation type. No allocation
+ *   is allowed there.
+ *
+ * - vgic_init(): allocation and initialization of the generic data
+ *   structures that depend on sizing information (number of CPUs,
+ *   number of interrupts). Also initializes the vcpu specific data
+ *   structures. Can be executed lazily for GICv2.
+ *   [to be renamed to kvm_vgic_init??]
+ *
+ * CPU Interface:
+ *
+ * - kvm_vgic_cpu_early_init(): initialization of static data that
+ *   doesn't depend on any sizing information or emulation type. No
+ *   allocation is allowed there.
  */
 
 #include "vgic.h"
@@ -82,6 +105,8 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
 static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
 static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
 static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
+static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
+						int virt_irq);
 
 static const struct vgic_ops *vgic_ops;
 static const struct vgic_params *vgic;
@@ -1583,6 +1608,164 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static struct list_head *vgic_get_irq_phys_map_list(struct kvm_vcpu *vcpu,
+						    int virt_irq)
+{
+	if (virt_irq < VGIC_NR_PRIVATE_IRQS)
+		return &vcpu->arch.vgic_cpu.irq_phys_map_list;
+	else
+		return &vcpu->kvm->arch.vgic.irq_phys_map_list;
+}
+
+/**
+ * kvm_vgic_map_phys_irq - map a virtual IRQ to a physical IRQ
+ * @vcpu: The VCPU pointer
+ * @virt_irq: The virtual irq number
+ * @irq: The Linux IRQ number
+ *
+ * Establish a mapping between a guest visible irq (@virt_irq) and a
+ * Linux irq (@irq). On injection, @virt_irq will be associated with
+ * the physical interrupt represented by @irq. This mapping can be
+ * established multiple times as long as the parameters are the same.
+ *
+ * Returns a valid pointer on success, and an error pointer otherwise
+ */
+struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
+					   int virt_irq, int irq)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
+	struct irq_phys_map *map;
+	struct irq_phys_map_entry *entry;
+	struct irq_desc *desc;
+	struct irq_data *data;
+	int phys_irq;
+
+	desc = irq_to_desc(irq);
+	if (!desc) {
+		kvm_err("%s: no interrupt descriptor\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
+	data = irq_desc_get_irq_data(desc);
+	while (data->parent_data)
+		data = data->parent_data;
+
+	phys_irq = data->hwirq;
+
+	/* Create a new mapping */
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock(&dist->irq_phys_map_lock);
+
+	/* Try to match an existing mapping */
+	map = vgic_irq_map_search(vcpu, virt_irq);
+	if (map) {
+		/* Make sure this mapping matches */
+		if (map->phys_irq != phys_irq	||
+		    map->irq      != irq)
+			map = ERR_PTR(-EINVAL);
+
+		/* Found an existing, valid mapping */
+		goto out;
+	}
+
+	map           = &entry->map;
+	map->virt_irq = virt_irq;
+	map->phys_irq = phys_irq;
+	map->irq      = irq;
+
+	list_add_tail_rcu(&entry->entry, root);
+
+out:
+	spin_unlock(&dist->irq_phys_map_lock);
+	/* If we've found a hit in the existing list, free the useless
+	 * entry */
+	if (IS_ERR(map) || map != &entry->map)
+		kfree(entry);
+	return map;
+}
+
+static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
+						int virt_irq)
+{
+	struct list_head *root = vgic_get_irq_phys_map_list(vcpu, virt_irq);
+	struct irq_phys_map_entry *entry;
+	struct irq_phys_map *map;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(entry, root, entry) {
+		map = &entry->map;
+		if (map->virt_irq == virt_irq) {
+			rcu_read_unlock();
+			return map;
+		}
+	}
+
+	rcu_read_unlock();
+
+	return NULL;
+}
+
+static void vgic_free_phys_irq_map_rcu(struct rcu_head *rcu)
+{
+	struct irq_phys_map_entry *entry;
+
+	entry = container_of(rcu, struct irq_phys_map_entry, rcu);
+	kfree(entry);
+}
+
+/**
+ * kvm_vgic_unmap_phys_irq - Remove a virtual to physical IRQ mapping
+ * @vcpu: The VCPU pointer
+ * @map: The pointer to a mapping obtained through kvm_vgic_map_phys_irq
+ *
+ * Remove an existing mapping between virtual and physical interrupts.
+ */
+int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct irq_phys_map_entry *entry;
+	struct list_head *root;
+
+	if (!map)
+		return -EINVAL;
+
+	root = vgic_get_irq_phys_map_list(vcpu, map->virt_irq);
+
+	spin_lock(&dist->irq_phys_map_lock);
+
+	list_for_each_entry(entry, root, entry) {
+		if (&entry->map == map) {
+			list_del_rcu(&entry->entry);
+			call_rcu(&entry->rcu, vgic_free_phys_irq_map_rcu);
+			break;
+		}
+	}
+
+	spin_unlock(&dist->irq_phys_map_lock);
+
+	return 0;
+}
+
+static void vgic_destroy_irq_phys_map(struct kvm *kvm, struct list_head *root)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct irq_phys_map_entry *entry;
+
+	spin_lock(&dist->irq_phys_map_lock);
+
+	list_for_each_entry(entry, root, entry) {
+		list_del_rcu(&entry->entry);
+		call_rcu(&entry->rcu, vgic_free_phys_irq_map_rcu);
+	}
+
+	spin_unlock(&dist->irq_phys_map_lock);
+}
+
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
@@ -1591,6 +1774,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kfree(vgic_cpu->active_shared);
 	kfree(vgic_cpu->pend_act_shared);
 	kfree(vgic_cpu->vgic_irq_lr_map);
+	vgic_destroy_irq_phys_map(vcpu->kvm, &vgic_cpu->irq_phys_map_list);
 	vgic_cpu->pending_shared = NULL;
 	vgic_cpu->active_shared = NULL;
 	vgic_cpu->pend_act_shared = NULL;
@@ -1628,6 +1812,17 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
 }
 
 /**
+ * kvm_vgic_vcpu_early_init - Earliest possible per-vcpu vgic init stage
+ *
+ * No memory allocation should be performed here, only static init.
+ */
+void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	INIT_LIST_HEAD(&vgic_cpu->irq_phys_map_list);
+}
+
+/**
  * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
  *
  * The host's GIC naturally limits the maximum amount of VCPUs a guest
@@ -1664,6 +1859,7 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	kfree(dist->irq_spi_target);
 	kfree(dist->irq_pending_on_cpu);
 	kfree(dist->irq_active_on_cpu);
+	vgic_destroy_irq_phys_map(kvm, &dist->irq_phys_map_list);
 	dist->irq_sgi_sources = NULL;
 	dist->irq_spi_cpu = NULL;
 	dist->irq_spi_target = NULL;
@@ -1787,6 +1983,18 @@ static int init_vgic_model(struct kvm *kvm, int type)
 	return 0;
 }
 
+/**
+ * kvm_vgic_early_init - Earliest possible vgic initialization stage
+ *
+ * No memory allocation should be performed here, only static init.
+ */
+void kvm_vgic_early_init(struct kvm *kvm)
+{
+	spin_lock_init(&kvm->arch.vgic.lock);
+	spin_lock_init(&kvm->arch.vgic.irq_phys_map_lock);
+	INIT_LIST_HEAD(&kvm->arch.vgic.irq_phys_map_list);
+}
+
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	int i, vcpu_lock_idx = -1, ret;
@@ -1832,7 +2040,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	if (ret)
 		goto out_unlock;
 
-	spin_lock_init(&kvm->arch.vgic.lock);
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
 	kvm->arch.vgic.vctrl_base = vgic->vctrl_base;
-- 
2.1.4

