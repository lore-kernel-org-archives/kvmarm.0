From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 38/45] KVM: arm/arm64: vgic-new: vgic_init: implement
 kvm_vgic_hyp_init
Date: Fri, 25 Mar 2016 02:05:01 +0000
Message-ID: <1458871508-17279-39-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 547C049AFA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2UHmVbFqqHFp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 116B649B4C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:22 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

Implements kvm_vgic_hyp_init and vgic_probe function.

The vgic_global struct is enriched with new fields populated
by those functions.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h       |   1 +
 virt/kvm/arm/vgic/vgic-v2.c   |  90 +++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c   |  74 +++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h      |   6 +++
 virt/kvm/arm/vgic/vgic_init.c | 122 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 293 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic_init.c

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index c4102a0..1bc7b66 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -195,6 +195,7 @@ struct vgic_cpu {
 };
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
+int kvm_vgic_hyp_init(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level);
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index fe6da47..0cb5c4f 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -17,6 +17,11 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <kvm/vgic/vgic.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 
@@ -228,3 +233,88 @@ void vgic_v2_irq_change_affinity(struct kvm *kvm, u32 intid, u8 new_targets)
 	irq->target_vcpu = kvm_get_vcpu(kvm, target);
 	spin_unlock(&irq->irq_lock);
 }
+
+/**
+ * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
+ * @node:	pointer to the DT node
+ *
+ * Returns 0 if a GICv2 has been found, returns an error code otherwise
+ */
+int vgic_v2_probe(struct device_node *vgic_node)
+{
+	int ret;
+	struct resource vctrl_res;
+	struct resource vcpu_res;
+
+	kvm_vgic_global_state.maint_irq = irq_of_parse_and_map(vgic_node, 0);
+	if (!kvm_vgic_global_state.maint_irq) {
+		kvm_err("error getting vgic maintenance irq from DT\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	ret = of_address_to_resource(vgic_node, 2, &vctrl_res);
+	if (ret) {
+		kvm_err("Cannot obtain GICH resource\n");
+		goto out;
+	}
+
+	kvm_vgic_global_state.vctrl_base = of_iomap(vgic_node, 2);
+	if (!kvm_vgic_global_state.vctrl_base) {
+		kvm_err("Cannot ioremap GICH\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	kvm_vgic_global_state.nr_lr =
+		readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VTR);
+	kvm_vgic_global_state.nr_lr = (kvm_vgic_global_state.nr_lr & 0x3f) + 1;
+
+	ret = create_hyp_io_mappings(kvm_vgic_global_state.vctrl_base,
+				     kvm_vgic_global_state.vctrl_base +
+					 resource_size(&vctrl_res),
+				     vctrl_res.start);
+	if (ret) {
+		kvm_err("Cannot map VCTRL into hyp\n");
+		goto out_unmap;
+	}
+
+	if (of_address_to_resource(vgic_node, 3, &vcpu_res)) {
+		kvm_err("Cannot obtain GICV resource\n");
+		ret = -ENXIO;
+		goto out_unmap;
+	}
+
+	if (!PAGE_ALIGNED(vcpu_res.start)) {
+		kvm_err("GICV physical address 0x%llx not page aligned\n",
+			(unsigned long long)vcpu_res.start);
+		ret = -ENXIO;
+		goto out_unmap;
+	}
+
+	if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
+		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
+			(unsigned long long)resource_size(&vcpu_res),
+			PAGE_SIZE);
+		ret = -ENXIO;
+		goto out_unmap;
+	}
+
+	kvm_vgic_global_state.can_emulate_gicv2 = true;
+	kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+
+	kvm_vgic_global_state.vcpu_base = vcpu_res.start;
+
+	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
+		 vctrl_res.start, kvm_vgic_global_state.maint_irq);
+
+	kvm_vgic_global_state.type = VGIC_V2;
+	kvm_vgic_global_state.max_gic_vcpus = VGIC_V2_MAX_CPUS;
+	goto out;
+
+out_unmap:
+	iounmap(kvm_vgic_global_state.vctrl_base);
+out:
+	of_node_put(vgic_node);
+	return ret;
+}
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 04ef7f9..1a53141 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -16,9 +16,17 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/irqchip/arm-gic.h>
+#include <kvm/vgic/vgic.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_asm.h>
 
 #include "vgic.h"
 
+static u32 ich_vtr_el2;
+
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -211,3 +219,69 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
 	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
 }
+
+/**
+ * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
+ * @node:	pointer to the DT node
+ *
+ * Returns 0 if a GICv3 has been found, returns an error code otherwise
+ */
+int vgic_v3_probe(struct device_node *vgic_node)
+{
+	int ret = 0;
+	u32 gicv_idx;
+	struct resource vcpu_res;
+
+	kvm_vgic_global_state.maint_irq = irq_of_parse_and_map(vgic_node, 0);
+	if (!kvm_vgic_global_state.maint_irq) {
+		kvm_err("error getting vgic maintenance irq from DT\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
+
+	/*
+	 * The ListRegs field is 5 bits, but there is a architectural
+	 * maximum of 16 list registers. Just ignore bit 4...
+	 */
+	kvm_vgic_global_state.nr_lr = (ich_vtr_el2 & 0xf) + 1;
+	kvm_vgic_global_state.can_emulate_gicv2 = false;
+
+	if (of_property_read_u32(vgic_node, "#redistributor-regions",
+				 &gicv_idx))
+		gicv_idx = 1;
+
+	gicv_idx += 3; /* Also skip GICD, GICC, GICH */
+	if (of_address_to_resource(vgic_node, gicv_idx, &vcpu_res)) {
+		kvm_info("GICv3: no GICV resource entry\n");
+		kvm_vgic_global_state.vcpu_base = 0;
+	} else if (!PAGE_ALIGNED(vcpu_res.start)) {
+		pr_warn("GICV physical address 0x%llx not page aligned\n",
+			(unsigned long long)vcpu_res.start);
+		kvm_vgic_global_state.vcpu_base = 0;
+	} else if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
+		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
+			(unsigned long long)resource_size(&vcpu_res),
+			PAGE_SIZE);
+		kvm_vgic_global_state.vcpu_base = 0;
+	} else {
+		kvm_vgic_global_state.vcpu_base = vcpu_res.start;
+		kvm_vgic_global_state.can_emulate_gicv2 = true;
+		kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+	}
+	if (kvm_vgic_global_state.vcpu_base == 0)
+		kvm_info("disabling GICv2 emulation\n");
+	kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
+
+	kvm_vgic_global_state.vctrl_base = NULL;
+	kvm_vgic_global_state.type = VGIC_V3;
+	kvm_vgic_global_state.max_gic_vcpus = VGIC_V3_MAX_CPUS;
+
+	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
+		 vcpu_res.start, kvm_vgic_global_state.maint_irq);
+
+out:
+	of_node_put(vgic_node);
+	return ret;
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c6d3ff6..31c9299a 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -38,6 +38,7 @@ int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+int vgic_v2_probe(struct device_node *vgic_node);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid, u64 mpidr);
@@ -51,6 +52,7 @@ int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
 			  int offset, int len, void *val);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+int vgic_v3_probe(struct device_node *vgic_node);
 #else
 static inline void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid,
 					       u64 mpidr)
@@ -96,6 +98,10 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
 }
 
+static inline int vgic_v3_probe(struct device_node *vgic_node)
+{
+	return -ENODEV;
+}
 #endif
 
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
diff --git a/virt/kvm/arm/vgic/vgic_init.c b/virt/kvm/arm/vgic/vgic_init.c
new file mode 100644
index 0000000..d7c50bb
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic_init.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) 2015, 2016 ARM Ltd.
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
+#include <linux/uaccess.h>
+#include <linux/interrupt.h>
+#include <linux/cpu.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/kvm_host.h>
+#include <kvm/vgic/vgic.h>
+#include <asm/kvm_mmu.h>
+#include "vgic.h"
+
+/* GENERIC PROBE */
+
+static void vgic_init_maintenance_interrupt(void *info)
+{
+	enable_percpu_irq(kvm_vgic_global_state.maint_irq, 0);
+}
+
+static int vgic_cpu_notify(struct notifier_block *self,
+			   unsigned long action, void *cpu)
+{
+	switch (action) {
+	case CPU_STARTING:
+	case CPU_STARTING_FROZEN:
+		vgic_init_maintenance_interrupt(NULL);
+		break;
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		disable_percpu_irq(kvm_vgic_global_state.maint_irq);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block vgic_cpu_nb = {
+	.notifier_call = vgic_cpu_notify,
+};
+
+static irqreturn_t vgic_maintenance_handler(int irq, void *data)
+{
+	/*
+	 * We cannot rely on the vgic maintenance interrupt to be
+	 * delivered synchronously. This means we can only use it to
+	 * exit the VM, and we perform the handling of EOIed
+	 * interrupts on the exit path (see vgic_process_maintenance).
+	 */
+	return IRQ_HANDLED;
+}
+
+static const struct of_device_id vgic_ids[] = {
+	{ .compatible = "arm,cortex-a15-gic",	.data = vgic_v2_probe, },
+	{ .compatible = "arm,cortex-a7-gic",	.data = vgic_v2_probe, },
+	{ .compatible = "arm,gic-400",		.data = vgic_v2_probe, },
+	{ .compatible = "arm,gic-v3",		.data = vgic_v3_probe, },
+	{},
+};
+
+/**
+ * kvm_vgic_hyp_init: populates the kvm_vgic_global_state variable
+ * according to the host GIC model. Accordingly calls either
+ * vgic_v2/v3_probe which registers the KVM_DEVICE that can be
+ * instantiated by a guest later on .
+ */
+int kvm_vgic_hyp_init(void)
+{
+	const struct of_device_id *matched_id;
+	const int (*vgic_probe)(struct device_node *);
+	struct device_node *vgic_node;
+	int ret;
+
+	vgic_node = of_find_matching_node_and_match(NULL,
+						    vgic_ids, &matched_id);
+	if (!vgic_node) {
+		kvm_err("error: no compatible GIC node found\n");
+		return -ENODEV;
+	}
+
+	vgic_probe = matched_id->data;
+	ret = vgic_probe(vgic_node);
+	if (ret)
+		return ret;
+
+	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
+				 vgic_maintenance_handler,
+				 "vgic", kvm_get_running_vcpus());
+	if (ret) {
+		kvm_err("Cannot register interrupt %d\n",
+			kvm_vgic_global_state.maint_irq);
+		return ret;
+	}
+
+	ret = __register_cpu_notifier(&vgic_cpu_nb);
+	if (ret) {
+		kvm_err("Cannot register vgic CPU notifier\n");
+		goto out_free_irq;
+	}
+
+	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
+
+	return 0;
+
+out_free_irq:
+	free_percpu_irq(kvm_vgic_global_state.maint_irq,
+			kvm_get_running_vcpus());
+	return ret;
+}
-- 
2.7.3
