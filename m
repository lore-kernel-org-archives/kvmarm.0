From: vijay.kilari@gmail.com
Subject: [RFC PATCH v2 2/4] arm/arm64: vgic-new: Add distributor and
 redistributor access
Date: Tue,  9 Aug 2016 16:28:44 +0530
Message-ID: <1470740326-27751-3-git-send-email-vijay.kilari@gmail.com>
References: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B2349B68
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 06:52:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mC1tR+--D90l for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2016 06:52:18 -0400 (EDT)
Received: from mail-pa0-f66.google.com (mail-pa0-f66.google.com
 [209.85.220.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D18A49B5C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2016 06:52:17 -0400 (EDT)
Received: by mail-pa0-f66.google.com with SMTP id vy10so784486pac.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Aug 2016 03:59:23 -0700 (PDT)
In-Reply-To: <1470740326-27751-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: Prasun.Kapoor@cavium.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>

VGICv3 Distributor and Redistributor registers are accessed using
KVM_DEV_ARM_VGIC_GRP_DIST_REGS and KVM_DEV_ARM_VGIC_GRP_DIST_REGS
with KVM_SET_DEVICE_ATTR and KVM_GET_DEVICE_ATTR ioctls.
These registers are accessed as 32-bit and cpu mpidr
value passed along with register offset is used to identify the
cpu for redistributor registers access.

The version of VGIC v3 specification is define here
http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
---
 arch/arm64/include/uapi/asm/kvm.h   |   3 +
 virt/kvm/arm/vgic/vgic-kvm-device.c |  81 ++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 113 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c       |   2 +-
 virt/kvm/arm/vgic/vgic.h            |   8 +++
 5 files changed, 200 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f209ea1..a6b996e 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -199,10 +199,13 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
 #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
 #define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
+#define   KVM_DEV_ARM_VGIC_V3_CPUID_MASK \
+				(0xffffffffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
+#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
 /* Device Control API on vcpu fd */
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 06de322..986f8e1 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -243,10 +243,19 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 	struct kvm_vcpu *vcpu, *tmp_vcpu;
 	int vcpu_lock_idx = -1;
 	u32 tmp32;
+	struct vgic_dist *vgic = &dev->kvm->arch.vgic;
 
-	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
-		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
-	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	if (vgic->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
+		cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
+			 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+		vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	}
+	else
+	{
+		cpuid = (attr->attr & KVM_DEV_ARM_VGIC_V3_CPUID_MASK) >>
+			 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+		vcpu = kvm_mpidr_to_vcpu(dev->kvm, cpuid);
+	}
 	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 
 	mutex_lock(&dev->kvm->lock);
@@ -283,10 +292,25 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 			*reg = tmp32;
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, &tmp32);
+		if (vgic->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+			ret = vgic_v2_dist_uaccess(vcpu, is_write, addr,
+						   &tmp32);
+		else
+			ret = vgic_v3_dist_uaccess(vcpu, is_write, addr,
+						   &tmp32);
 		if (!is_write)
 			*reg = tmp32;
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		if (vgic->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+			ret = vgic_v3_redist_uaccess(vcpu, is_write, addr,
+						     &tmp32);
+			if (!is_write)
+				*reg = tmp32;
+		} else {
+			ret = -EINVAL;
+		}
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -399,13 +423,55 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	return vgic_set_common_attr(dev, attr);
+	int ret;
+
+	ret = vgic_set_common_attr(dev, attr);
+	if (ret != -ENXIO)
+		return ret;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+		u32 tmp32;
+		u64 reg;
+
+		if (get_user(tmp32, uaddr))
+			return -EFAULT;
+
+		reg = tmp32;
+		return vgic_attr_regs_access(dev, attr, &reg, true);
+	}
+	}
+	return -ENXIO;
 }
 
 static int vgic_v3_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	return vgic_get_common_attr(dev, attr);
+	int ret;
+
+	ret = vgic_get_common_attr(dev, attr);
+	if (ret != -ENXIO)
+		return ret;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+		u64 reg;
+		u32 tmp32;
+
+		ret = vgic_attr_regs_access(dev, attr, &reg, false);
+		if (ret)
+			return ret;
+		tmp32 = reg;
+		ret = put_user(tmp32, uaddr);
+		return ret;
+	}
+	}
+
+	return -ENXIO;
 }
 
 static int vgic_v3_has_attr(struct kvm_device *dev,
@@ -419,6 +485,9 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		return vgic_v3_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index a0c515a..36b4882 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -18,6 +18,8 @@
 #include <kvm/arm_vgic.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
@@ -226,6 +228,9 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
 		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
@@ -348,6 +353,52 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
 	return ret;
 }
 
+int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	struct kvm_vcpu *vcpu;
+	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+	const struct vgic_register_region *regions;
+	gpa_t addr;
+	int nr_regions, i, len, cpuid;
+
+	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_V3_CPUID_MASK) >>
+		 KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+	vcpu = kvm_mpidr_to_vcpu(dev->kvm, cpuid);
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		regions = vgic_v3_dist_registers;
+		nr_regions = ARRAY_SIZE(vgic_v3_dist_registers);
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:{
+		struct vgic_io_device *devices;
+		struct vgic_io_device *rd_dev;
+
+		devices = dev->kvm->arch.vgic.redist_iodevs;
+		rd_dev = &devices[vcpu->vcpu_id * 2];
+
+		regions = rd_dev->regions;
+		nr_regions = rd_dev->nr_regions;
+		break;
+	}
+	default:
+		return -ENXIO;
+	}
+
+	for (i = 0; i < nr_regions; i++) {
+		if (regions[i].bits_per_irq)
+			len = (regions[i].bits_per_irq * nr_irqs) / 8;
+		else
+			len = regions[i].len;
+
+		if (regions[i].reg_offset <= addr &&
+		    regions[i].reg_offset + len > addr)
+			return 0;
+	}
+
+	return -ENXIO;
+}
 /*
  * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
  * generation register ICC_SGI1R_EL1) with a given VCPU.
@@ -453,3 +504,65 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 		vgic_queue_irq_unlock(vcpu->kvm, irq);
 	}
 }
+
+/*
+ * When userland tries to access the VGIC register handlers, we need to
+ * create a usable struct vgic_io_device to be passed to the handlers and we
+ * have to set up a buffer similar to what would have happened if a guest MMIO
+ * access occurred, including doing endian conversions on BE systems.
+ */
+static int vgic_v3_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
+			   bool is_write, int offset, u32 *val)
+{
+	unsigned int len = 4;
+	u8 buf[4];
+	int ret;
+
+	if (is_write) {
+		vgic_data_host_to_mmio_bus(buf, len, *val);
+		ret = kvm_io_gic_ops.write(vcpu, &dev->dev,
+					   dev->base_addr + offset, len, buf);
+	} else {
+		ret = kvm_io_gic_ops.read(vcpu, &dev->dev,
+					  dev->base_addr + offset, len, buf);
+		if (!ret)
+			*val = vgic_data_mmio_bus_to_host(buf, len);
+	}
+
+	return ret;
+}
+
+int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			 int offset, u32 *val)
+{
+	struct vgic_io_device dev = {
+		.regions = vgic_v3_dist_registers,
+		.nr_regions = ARRAY_SIZE(vgic_v3_dist_registers),
+	};
+
+	return vgic_v3_uaccess(vcpu, &dev, is_write, offset, val);
+}
+
+int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			   int offset, u32 *val)
+{
+	struct vgic_io_device *dev;
+	const struct vgic_register_region *region;
+
+	struct vgic_io_device rd_dev = {
+		.regions = vgic_v3_rdbase_registers,
+		.nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers),
+	};
+
+	struct vgic_io_device sgi_dev = {
+		.regions = vgic_v3_sgibase_registers,
+		.nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers),
+	};
+
+	dev = &sgi_dev;
+	region = vgic_find_mmio_region(dev->regions, dev->nr_regions, offset);
+	if (region == NULL)
+		dev = &rd_dev;
+
+	return vgic_v3_uaccess(vcpu, dev, is_write, offset, val);
+}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 9f6fab7..f583959 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -363,7 +363,7 @@ static int match_region(const void *key, const void *elt)
 }
 
 /* Find the proper register handler entry given a certain address offset. */
-static const struct vgic_register_region *
+const struct vgic_register_region *
 vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
 		      unsigned int offset)
 {
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 7b300ca..8637690 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -59,6 +59,9 @@ int vgic_v2_map_resources(struct kvm *kvm);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
 
+const struct vgic_register_region *
+	vgic_find_mmio_region(const struct vgic_register_region *region,
+			      int nr_regions, unsigned int offset);
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
@@ -71,6 +74,11 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
+int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
+int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			 int offset, u32 *val);
+int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			 int offset, u32 *val);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
-- 
1.9.1
