From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 23/45] KVM: arm/arm64: vgic-new: Add GICv3 MMIO handling framework
Date: Fri, 15 Apr 2016 18:11:34 +0100
Message-ID: <1460740316-8755-24-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Describe the GICv3 distributor and redistributor registers in our
structure. This adds a special macro to deal with the split of
SGI/PPI in the redistributor and SPIs in the distributor, which
allows us to reuse the existing GICv2 handlers for those registers
which are compatible.
Also we register the separate MMIO page for the redistributor
registers dealing with private interrupts.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Changelog RFC..v1:
- adapt to new MMIO registration approach:
  register one device for the distributor and two for each VCPU
- implement special handling for private interrupts
- remove empty stub functions
- make IGROUPR return RAO
---
 virt/kvm/arm/vgic/vgic.h      |  16 +++
 virt/kvm/arm/vgic/vgic_mmio.c | 269 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 285 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 59fddbf..ccae13e 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -40,6 +40,10 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+int vgic_v3_dist_access(struct kvm_vcpu *vcpu, bool is_write,
+			int offset, int len, void *val);
+int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
+			  int offset, int len, void *val);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -61,6 +65,18 @@ static inline void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
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
index daa2e00..4a31d60 100644
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
@@ -684,6 +686,20 @@ static int vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
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
@@ -715,6 +731,79 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16),
 };
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+struct vgic_register_region vgic_v3_dist_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
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
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 64),
+	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
+		vgic_mmio_read_nyi, vgic_mmio_write_wi, 48),
+};
+
+struct vgic_register_region vgic_v3_redist_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
+		vgic_mmio_read_nyi, vgic_mmio_write_wi, 4),
+	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
+		vgic_mmio_read_nyi, vgic_mmio_write_wi, 8),
+	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
+	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
+	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
+		vgic_mmio_read_nyi, vgic_mmio_write_wi, 48),
+};
+
+struct vgic_register_region vgic_v3_private_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, 4),
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
 /* Find the proper register handler entry given a certain address offset. */
 static struct vgic_register_region *
 vgic_find_mmio_region(struct vgic_register_region *region, int nr_regions,
@@ -823,6 +912,121 @@ struct kvm_io_device_ops kvm_io_v2dist_ops = {
 	.write = vgic_mmio_write_v2dist,
 };
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+int vgic_mmio_read_v3dist(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			  gpa_t addr, int len, void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	struct vgic_register_region *region;
+	int offset = addr - iodev->base_addr;
+
+	region = vgic_find_mmio_region(vgic_v3_dist_registers,
+				       ARRAY_SIZE(vgic_v3_dist_registers),
+				       offset);
+	if (!region)
+		return 1;
+
+	/* Private IRQs are RAZ on the GICv3 distributor. */
+	if (region->bits_per_irq) {
+		offset -= region->reg_offset;
+		if ((offset * 8 / region->bits_per_irq) < VGIC_NR_PRIVATE_IRQS)
+			return vgic_mmio_read_raz(vcpu, dev, addr, len, val);
+	}
+
+	return region->ops.read(vcpu, dev, addr, len, val);
+}
+
+int vgic_mmio_write_v3dist(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			   gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	struct vgic_register_region *region;
+	int offset = addr - iodev->base_addr;
+
+	region = vgic_find_mmio_region(vgic_v3_dist_registers,
+				       ARRAY_SIZE(vgic_v3_dist_registers),
+				       offset);
+	if (!region)
+		return 1;
+
+	/* Private IRQs are WI on the GICv3 distributor. */
+	if (region->bits_per_irq) {
+		offset -= region->reg_offset;
+		if ((offset * 8 / region->bits_per_irq) < VGIC_NR_PRIVATE_IRQS)
+			return vgic_mmio_write_wi(vcpu, dev, addr, len, val);
+	}
+
+	return region->ops.write(vcpu, dev, addr, len, val);
+}
+
+struct kvm_io_device_ops kvm_io_v3dist_ops = {
+	.read = vgic_mmio_read_v3dist,
+	.write = vgic_mmio_write_v3dist,
+};
+
+int vgic_mmio_read_v3redist(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			    gpa_t addr, int len, void *val)
+{
+	return dispatch_mmio_read(vcpu, vgic_v3_redist_registers,
+				  ARRAY_SIZE(vgic_v3_redist_registers), dev,
+				  addr, len, val);
+}
+
+int vgic_mmio_write_v3redist(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			     gpa_t addr, int len, const void *val)
+{
+	return dispatch_mmio_write(vcpu, vgic_v3_redist_registers,
+				   ARRAY_SIZE(vgic_v3_redist_registers), dev,
+				   addr, len, val);
+}
+
+struct kvm_io_device_ops kvm_io_v3redist_ops = {
+	.read = vgic_mmio_read_v3redist,
+	.write = vgic_mmio_write_v3redist,
+};
+
+int vgic_mmio_read_v3redist_private(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *dev,
+				    gpa_t addr, int len, void *val)
+{
+	return dispatch_mmio_read(vcpu, vgic_v3_private_registers,
+				  ARRAY_SIZE(vgic_v3_private_registers), dev,
+				  addr, len, val);
+}
+
+int vgic_mmio_write_v3redist_private(struct kvm_vcpu *vcpu,
+				     struct kvm_io_device *dev,
+				     gpa_t addr, int len, const void *val)
+{
+	return dispatch_mmio_write(vcpu, vgic_v3_private_registers,
+				   ARRAY_SIZE(vgic_v3_private_registers), dev,
+				   addr, len, val);
+}
+
+struct kvm_io_device_ops kvm_io_v3redist_private_ops = {
+	.read = vgic_mmio_read_v3redist_private,
+	.write = vgic_mmio_write_v3redist_private,
+};
+
+int vgic_v3_dist_access(struct kvm_vcpu *vcpu, bool is_write,
+			int offset, int len, void *val)
+{
+	return vgic_device_mmio_access(vcpu, vgic_v3_dist_registers,
+				       ARRAY_SIZE(vgic_v3_dist_registers),
+				       is_write, offset, len, val);
+}
+
+int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
+			  int offset, int len, void *val)
+{
+	return vgic_device_mmio_access(vcpu, vgic_v3_redist_registers,
+				       ARRAY_SIZE(vgic_v3_redist_registers),
+				       is_write, offset, len, val);
+}
+#endif
+
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type type)
 {
@@ -835,6 +1039,12 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 		kvm_iodevice_init(&io_device->dev, &kvm_io_v2dist_ops);
 		len = SZ_4K;
 		break;
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+	case VGIC_V3:
+		kvm_iodevice_init(&io_device->dev, &kvm_io_v3dist_ops);
+		len = SZ_64K;
+		break;
+#endif
 	default:
 		BUG_ON(1);
 	}
@@ -848,3 +1058,62 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 
 	return ret;
 }
+
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
+{
+	int nr_vcpus = atomic_read(&kvm->online_vcpus);
+	struct kvm_vcpu *vcpu;
+	struct vgic_io_device *regions, *region;
+	int c, ret = 0;
+
+	regions = kmalloc(sizeof(struct vgic_io_device) * nr_vcpus * 2,
+			  GFP_KERNEL);
+	if (!regions)
+		return -ENOMEM;
+
+	region = regions;
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		kvm_iodevice_init(&region->dev, &kvm_io_v3redist_ops);
+		region->base_addr = redist_base_address;
+
+		mutex_lock(&kvm->slots_lock);
+		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
+					      redist_base_address,
+					      SZ_64K, &region->dev);
+		mutex_unlock(&kvm->slots_lock);
+
+		if (ret)
+			break;
+
+		region++;
+		kvm_iodevice_init(&region->dev, &kvm_io_v3redist_private_ops);
+		region->base_addr = redist_base_address + SZ_64K;
+
+		mutex_lock(&kvm->slots_lock);
+		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS,
+					      redist_base_address + SZ_64K,
+					      SZ_64K, &region->dev);
+		mutex_unlock(&kvm->slots_lock);
+		if (ret) {
+			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
+						  &regions[c * 2].dev);
+			break;
+		}
+		redist_base_address += 2 * SZ_64K;
+	}
+
+	if (ret) {
+		for (c--; c >= 0; c--) {
+			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
+						  &regions[c * 2].dev);
+			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
+						  &regions[c * 2 + 1].dev);
+		}
+	} else {
+		kvm->arch.vgic.redist_iodevs = regions;
+	}
+
+	return ret;
+}
+#endif
-- 
2.7.3

