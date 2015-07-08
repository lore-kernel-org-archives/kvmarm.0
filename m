From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 06/10] KVM: arm/arm64: vgic: Allow dynamic mapping of
 physical/virtual interrupts
Date: Wed,  8 Jul 2015 18:56:38 +0100
Message-ID: <1436378202-20224-7-git-send-email-marc.zyngier@arm.com>
References: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 998C4581E3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:45:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xat7fwkdMma9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 13:45:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B42581A4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 13:45:25 -0400 (EDT)
In-Reply-To: <1436378202-20224-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to be able to feed physical interrupts to a guest, we need
to be able to establish the virtual-physical mapping between the two
worlds.

The mappings are kept in a set of RCU lists, indexed by virtual interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c     |   2 +
 include/kvm/arm_vgic.h |  25 +++++++++
 virt/kvm/arm/vgic.c    | 144 ++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 170 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 1583a34..d5ce5cc 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -125,6 +125,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out_free_stage2_pgd;
 
+	kvm_vgic_init(kvm);
 	kvm_timer_init(kvm);
 
 	/* Mark the initial VMID generation invalid */
@@ -249,6 +250,7 @@ out:
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
+	kvm_vgic_vcpu_postcreate(vcpu);
 }
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4f9fa1d..32e57d2 100644
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
+void kvm_vgic_init(struct kvm *kvm);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
+void kvm_vgic_vcpu_postcreate(struct kvm_vcpu *vcpu);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu);
@@ -331,6 +353,9 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int irq_num,
 void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
+struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
+				       int virt_irq, int irq);
+int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 5bd1695..3424329 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/rculist.h>
 #include <linux/uaccess.h>
 
 #include <asm/kvm_emulate.h>
@@ -82,6 +83,8 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
 static void vgic_retire_lr(int lr_nr, int irq, struct kvm_vcpu *vcpu);
 static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
 static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
+static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
+						int virt_irq);
 
 static const struct vgic_ops *vgic_ops;
 static const struct vgic_params *vgic;
@@ -1583,6 +1586,131 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static struct list_head *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
+					       int virt_irq)
+{
+	if (virt_irq < VGIC_NR_PRIVATE_IRQS)
+		return &vcpu->arch.vgic_cpu.irq_phys_map_list;
+	else
+		return &vcpu->kvm->arch.vgic.irq_phys_map_list;
+}
+
+struct irq_phys_map *vgic_map_phys_irq(struct kvm_vcpu *vcpu,
+				       int virt_irq, int irq)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct list_head *root = vgic_get_irq_phys_map(vcpu, virt_irq);
+	struct irq_phys_map *map;
+	struct irq_phys_map_entry *entry;
+	struct irq_desc *desc;
+	struct irq_data *data;
+	int phys_irq;
+
+	desc = irq_to_desc(irq);
+	if (!desc) {
+		kvm_err("kvm_arch_timer: can't obtain interrupt descriptor\n");
+		return NULL;
+	}
+
+	data = irq_desc_get_irq_data(desc);
+	while (data->parent_data)
+		data = data->parent_data;
+
+	phys_irq = data->hwirq;
+
+	spin_lock(&dist->irq_phys_map_lock);
+
+	/* Try to match an existing mapping */
+	map = vgic_irq_map_search(vcpu, virt_irq);
+	if (map) {
+		/* Make sure this mapping matches */
+		if (map->phys_irq != phys_irq	||
+		    map->irq      != irq)
+			map = NULL;
+
+		goto out;
+	}
+
+	/* Create a new mapping */
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (!entry)
+		goto out;
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
+	return map;
+}
+
+static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
+						int virt_irq)
+{
+	struct list_head *root = vgic_get_irq_phys_map(vcpu, virt_irq);
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
+int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct irq_phys_map_entry *entry;
+
+	if (!map)
+		return -EINVAL;
+
+	entry = container_of(map, struct irq_phys_map_entry, map);
+
+	spin_lock(&dist->irq_phys_map_lock);
+	list_del_rcu(&entry->entry);
+	call_rcu(&entry->rcu, vgic_free_phys_irq_map_rcu);
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
@@ -1591,6 +1719,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kfree(vgic_cpu->active_shared);
 	kfree(vgic_cpu->pend_act_shared);
 	kfree(vgic_cpu->vgic_irq_lr_map);
+	vgic_destroy_irq_phys_map(vcpu->kvm, &vgic_cpu->irq_phys_map_list);
 	vgic_cpu->pending_shared = NULL;
 	vgic_cpu->active_shared = NULL;
 	vgic_cpu->pend_act_shared = NULL;
@@ -1627,6 +1756,12 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
 	return 0;
 }
 
+void kvm_vgic_vcpu_postcreate(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	INIT_LIST_HEAD(&vgic_cpu->irq_phys_map_list);
+}
+
 /**
  * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
  *
@@ -1664,6 +1799,7 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	kfree(dist->irq_spi_target);
 	kfree(dist->irq_pending_on_cpu);
 	kfree(dist->irq_active_on_cpu);
+	vgic_destroy_irq_phys_map(kvm, &dist->irq_phys_map_list);
 	dist->irq_sgi_sources = NULL;
 	dist->irq_spi_cpu = NULL;
 	dist->irq_spi_target = NULL;
@@ -1787,6 +1923,13 @@ static int init_vgic_model(struct kvm *kvm, int type)
 	return 0;
 }
 
+void kvm_vgic_init(struct kvm *kvm)
+{
+	spin_lock_init(&kvm->arch.vgic.lock);
+	spin_lock_init(&kvm->arch.vgic.irq_phys_map_lock);
+	INIT_LIST_HEAD(&kvm->arch.vgic.irq_phys_map_list);
+}
+
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	int i, vcpu_lock_idx = -1, ret;
@@ -1832,7 +1975,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	if (ret)
 		goto out_unlock;
 
-	spin_lock_init(&kvm->arch.vgic.lock);
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
 	kvm->arch.vgic.vctrl_base = vgic->vctrl_base;
-- 
2.1.4
