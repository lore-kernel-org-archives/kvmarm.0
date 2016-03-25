From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 23/45] KVM: arm/arm64: vgic-new: Add GICv3 emulation
 framework
Date: Fri, 25 Mar 2016 02:04:46 +0000
Message-ID: <1458871508-17279-24-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81A57411E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z1adMg4r5ALV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 862F8412A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:04:59 -0400 (EDT)
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

Describe the GICv3 distributor and redistributor registers in our
structure. This adds a special macro to deal with the split of
SGI/PPI in the redistributor and SPIs in the distributor, which
allows us to reuse the existing GICv2 handlers for those registers
which are compatible.
Also we register the separate MMIO page for the redistributor
registers dealing with private interrupts.
GICv3 specific registers are only implemented as stubs at this time.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic.h      |  16 +++
 virt/kvm/arm/vgic/vgic_mmio.c | 246 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 262 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 57aea8f..4b8952a 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -37,6 +37,10 @@ void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+int vgic_v3_dist_access(struct kvm_vcpu *vcpu, bool is_write,
+			int offset, int len, void *val);
+int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
+			  int offset, int len, void *val);
 #else
 static inline void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid,
 					       u64 mpidr)
@@ -59,6 +63,18 @@ static inline void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
 static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
 }
+
+static inline int vgic_v3_dist_access(struct kvm_vcpu *vcpu, bool is_write,
+				      int offset, int len, void *val)
+{
+	return -ENXIO;
+}
+
+static inline int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
+					int offset, int len, void *val)
+{
+	return -ENXIO;
+}
 #endif
 
 #endif
diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index 2ab8961..2d10c06 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -17,6 +17,8 @@
 #include <kvm/vgic/vgic.h>
 #include <linux/bitops.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/arm-gic-v3.h>
+#include <asm/kvm_emulate.h>
 
 #include "vgic.h"
 #include "vgic_mmio.h"
@@ -595,6 +597,105 @@ static int vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*****************************/
+/* GICv3 emulation functions */
+/*****************************/
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+
+static int vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
+				  struct kvm_io_device *this,
+				  gpa_t addr, int len, void *val)
+{
+	/* TODO: implement */
+	return 0;
+}
+
+static int vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
+				   struct kvm_io_device *this,
+				   gpa_t addr, int len, const void *val)
+{
+	/* TODO: implement */
+	return 0;
+}
+
+static int vgic_mmio_read_v3r_misc(struct kvm_vcpu *vcpu,
+				   struct kvm_io_device *this,
+				   gpa_t addr, int len, void *val)
+{
+	/* TODO: implement for ITS support */
+	return vgic_mmio_read_raz(vcpu, this, addr, len, val);
+}
+
+static int vgic_mmio_write_v3r_misc(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *this,
+				    gpa_t addr, int len, const void *val)
+{
+	/* TODO: implement for ITS support */
+	return vgic_mmio_write_wi(vcpu, this, addr, len, val);
+}
+
+static int vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
+				   struct kvm_io_device *this,
+				   gpa_t addr, int len, void *val)
+{
+	return 0;
+}
+
+static int vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *this,
+				    gpa_t addr, int len, void *val)
+{
+	/* TODO: implement */
+	return 0;
+}
+
+static int vgic_mmio_read_v3r_propbase(struct kvm_vcpu *vcpu,
+				       struct kvm_io_device *this,
+				       gpa_t addr, int len, void *val)
+{
+	/* TODO: implement */
+	return 0;
+}
+
+static int vgic_mmio_write_v3r_propbase(struct kvm_vcpu *vcpu,
+				        struct kvm_io_device *this,
+				        gpa_t addr, int len, const void *val)
+{
+	/* TODO: implement */
+	return 0;
+}
+
+static int vgic_mmio_read_v3r_pendbase(struct kvm_vcpu *vcpu,
+				       struct kvm_io_device *this,
+				       gpa_t addr, int len, void *val)
+{
+	/* TODO: implement */
+	return 0;
+}
+
+static int vgic_mmio_write_v3r_pendbase(struct kvm_vcpu *vcpu,
+				        struct kvm_io_device *this,
+				        gpa_t addr, int len, const void *val)
+{
+	/* TODO: implement */
+	return 0;
+}
+#endif
+
+/*
+ * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
+ * redistributors, while SPIs are covered by registers in the distributor
+ * block. Trying to set private IRQs in this block gets ignored.
+ * We take some special care here to fix the calculation of the register
+ * offset.
+ */
+#define REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(name, read_ops, write_ops, bpi) \
+	{.reg_offset = name, .bits_per_irq = 0, \
+	 .len = (bpi * VGIC_NR_PRIVATE_IRQS) / 8, \
+	 .ops.read = vgic_mmio_read_raz, .ops.write = vgic_mmio_write_wi, }, \
+	{.reg_offset = name, .bits_per_irq = bpi, .len = 0, \
+	 .ops.read = read_ops, .ops.write = write_ops, }
+
 struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
@@ -626,6 +727,73 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16),
 };
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+struct vgic_register_region vgic_v3_dist_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
+		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
+		vgic_mmio_read_enable, vgic_mmio_write_senable, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
+		vgic_mmio_read_pending, vgic_mmio_write_spending, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
+		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
+		vgic_mmio_read_active, vgic_mmio_write_sactive, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
+		vgic_mmio_read_active, vgic_mmio_write_cactive, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
+		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ITARGETSR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICFGR,
+		vgic_mmio_read_config, vgic_mmio_write_config, 2),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+};
+
+struct vgic_register_region vgic_v3_redist_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
+		vgic_mmio_read_v3r_misc, vgic_mmio_write_v3r_misc, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
+		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
+		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8),
+	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
+		vgic_mmio_read_v3r_propbase, vgic_mmio_write_v3r_propbase, 8),
+	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
+		vgic_mmio_read_v3r_pendbase, vgic_mmio_write_v3r_pendbase, 8),
+};
+
+struct vgic_register_region vgic_v3_private_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0,
+		vgic_mmio_read_enable, vgic_mmio_write_senable, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_ICENABLER0,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_ISPENDR0,
+		vgic_mmio_read_pending, vgic_mmio_write_spending, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_ICPENDR0,
+		vgic_mmio_read_pending, vgic_mmio_write_cpending, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_ISACTIVER0,
+		vgic_mmio_read_active, vgic_mmio_write_sactive, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_ICACTIVER0,
+		vgic_mmio_read_active, vgic_mmio_write_cactive, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_IPRIORITYR0,
+		vgic_mmio_read_priority, vgic_mmio_write_priority, 32),
+	REGISTER_DESC_WITH_LENGTH(GICR_ICFGR0,
+		vgic_mmio_read_config, vgic_mmio_write_config, 8),
+	REGISTER_DESC_WITH_LENGTH(GICR_IGRPMODR0,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_NSACR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
+};
+#endif
+
 /*
  * Using kvm_io_bus_* to access GIC registers directly from userspace does
  * not work, since we would need the absolute IPA address of the register
@@ -671,6 +839,24 @@ int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
 				is_write, offset, len, val);
 }
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+int vgic_v3_dist_access(struct kvm_vcpu *vcpu, bool is_write,
+			int offset, int len, void *val)
+{
+	return vgic_mmio_access(vcpu, vgic_v3_dist_registers,
+				ARRAY_SIZE(vgic_v3_dist_registers),
+				is_write, offset, len, val);
+}
+
+int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
+			  int offset, int len, void *val)
+{
+	return vgic_mmio_access(vcpu, vgic_v3_redist_registers,
+				ARRAY_SIZE(vgic_v3_redist_registers),
+				is_write, offset, len, val);
+}
+#endif
+
 int kvm_vgic_register_mmio_region(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				  struct vgic_register_region *reg_desc,
 				  struct vgic_io_device *region,
@@ -717,6 +903,12 @@ int vgic_register_dist_regions(struct kvm *kvm, gpa_t dist_base_address,
 		reg_desc = vgic_v2_dist_registers;
 		nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
 		break;
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+	case VGIC_V3:
+		reg_desc = vgic_v3_dist_registers;
+		nr_regions = ARRAY_SIZE(vgic_v3_dist_registers);
+		break;
+#endif
 	default:
 		BUG_ON(1);
 	}
@@ -750,3 +942,57 @@ int vgic_register_dist_regions(struct kvm *kvm, gpa_t dist_base_address,
 
 	return ret;
 }
+
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+int vgic_register_redist_regions(struct kvm *kvm, gpa_t redist_base_address)
+{
+	int nr_vcpus = atomic_read(&kvm->online_vcpus);
+	int nr_regions = ARRAY_SIZE(vgic_v3_redist_registers) +
+			 ARRAY_SIZE(vgic_v3_private_registers);
+	struct kvm_vcpu *vcpu;
+	struct vgic_io_device *regions, *region;
+	int c, i, ret = 0;
+
+	regions = kmalloc(sizeof(struct vgic_io_device) * nr_regions * nr_vcpus,
+			  GFP_KERNEL);
+	if (!regions)
+		return -ENOMEM;
+
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		region = &regions[c * nr_regions];
+		for (i = 0; i < ARRAY_SIZE(vgic_v3_redist_registers); i++) {
+			region->base_addr = redist_base_address;
+			region->base_addr += c * 2 * SZ_64K;
+
+			ret = kvm_vgic_register_mmio_region(kvm, vcpu,
+						vgic_v3_redist_registers + i,
+						region, VGIC_NR_PRIVATE_IRQS,
+						false);
+			if (ret)
+				break;
+			region++;
+		}
+		if (ret)
+			break;
+
+		for (i = 0; i < ARRAY_SIZE(vgic_v3_private_registers); i++) {
+			region->base_addr = redist_base_address;
+			region->base_addr += c * 2 * SZ_64K + SZ_64K;
+			ret = kvm_vgic_register_mmio_region(kvm, vcpu,
+						vgic_v3_private_registers + i,
+						region, VGIC_NR_PRIVATE_IRQS,
+						false);
+			if (ret)
+				break;
+			region++;
+		}
+		if (ret)
+			break;
+	}
+
+	if (!ret)
+		kvm->arch.vgic.redist_iodevs = regions;
+
+	return ret;
+}
+#endif
-- 
2.7.3
