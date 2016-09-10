From: vijay.kilari@gmail.com
Subject: [PATCH v4 2/5] arm/arm64: vgic-new: Add distributor and redistributor
 access
Date: Sat, 10 Sep 2016 17:52:15 +0530
Message-ID: <1473510138-4719-3-git-send-email-vijay.kilari@gmail.com>
References: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4201412D0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2016 08:14:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5kryEP1yRp+F for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Sep 2016 08:14:07 -0400 (EDT)
Received: from mail-pf0-f196.google.com (mail-pf0-f196.google.com
 [209.85.192.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25B14412A2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2016 08:14:07 -0400 (EDT)
Received: by mail-pf0-f196.google.com with SMTP id i75so456339pfa.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2016 05:22:42 -0700 (PDT)
In-Reply-To: <1473510138-4719-1-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
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
 arch/arm64/include/uapi/asm/kvm.h   |   4 ++
 virt/kvm/arm/vgic/vgic-kvm-device.c | 140 ++++++++++++++++++++++++++++++++++--
 virt/kvm/arm/vgic/vgic-mmio-v2.c    |  16 +----
 virt/kvm/arm/vgic/vgic-mmio-v3.c    |  72 +++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c       |  22 ++++++
 virt/kvm/arm/vgic/vgic-mmio.h       |   4 ++
 virt/kvm/arm/vgic/vgic.h            |   5 ++
 7 files changed, 245 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 3051f86..56dc08d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -201,10 +201,14 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
 #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
 #define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
+#define   KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT 32
+#define   KVM_DEV_ARM_VGIC_V3_MPIDR_MASK \
+			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
+#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
 /* Device Control API on vcpu fd */
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 163b057..3225388 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -320,9 +320,10 @@ static int vgic_attr_regs_access_v2(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	ret = vgic_init(dev->kvm);
-	if (ret)
+	if (unlikely(!vgic_initialized(dev->kvm))) {
+		ret = -EBUSY;
 		goto out;
+	}
 
 	if (!lock_all_vcpus(dev->kvm)) {
 		ret = -EBUSY;
@@ -433,16 +434,144 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 
+static int parse_vgic_v3_attr(struct kvm_device *dev,
+			      struct kvm_device_attr *attr,
+			      struct vgic_reg_attr *reg_attr)
+{
+	unsigned long mpidr;
+
+	mpidr = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
+		 KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
+
+	reg_attr->vcpu = kvm_mpidr_to_vcpu(dev->kvm, mpidr);
+	if (!reg_attr->vcpu)
+		return -EINVAL;
+
+	if (reg_attr->vcpu->vcpu_id >= atomic_read(&dev->kvm->online_vcpus))
+		return -EINVAL;
+
+	reg_attr->addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+
+	return 0;
+}
+
+/*
+ * vgic_attr_regs_access_v3 - allows user space to access VGIC v3 state
+ *
+ * @dev:      kvm device handle
+ * @attr:     kvm device attribute
+ * @reg:      address the value is read or written
+ * @is_write: true if userspace is writing a register
+ */
+static int vgic_attr_regs_access_v3(struct kvm_device *dev,
+				    struct kvm_device_attr *attr,
+				    u64 *reg, bool is_write)
+{
+	struct vgic_reg_attr reg_attr;
+	gpa_t addr;
+	struct kvm_vcpu *vcpu;
+	int ret;
+	u32 tmp32;
+
+	ret = parse_vgic_v3_attr(dev, attr, &reg_attr);
+	if (ret)
+		return ret;
+
+	vcpu = reg_attr.vcpu;
+	addr = reg_attr.addr;
+
+	mutex_lock(&dev->kvm->lock);
+
+	if (unlikely(!vgic_initialized(dev->kvm))) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (!lock_all_vcpus(dev->kvm)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		if (is_write)
+			tmp32 = *reg;
+
+		ret = vgic_v3_dist_uaccess(vcpu, is_write, addr, &tmp32);
+		if (!is_write)
+			*reg = tmp32;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		if (is_write)
+			tmp32 = *reg;
+
+		ret = vgic_v3_redist_uaccess(vcpu, is_write, addr, &tmp32);
+		if (!is_write)
+			*reg = tmp32;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	unlock_all_vcpus(dev->kvm);
+out:
+	mutex_unlock(&dev->kvm->lock);
+	return ret;
+}
+
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
+		return vgic_attr_regs_access_v3(dev, attr, &reg, true);
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
+		ret = vgic_attr_regs_access_v3(dev, attr, &reg, false);
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
@@ -456,6 +585,9 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 			return 0;
 		}
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		return vgic_v3_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 0b32f40..2cb04b7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -368,10 +368,9 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
 
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 {
-	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
 	const struct vgic_register_region *regions;
 	gpa_t addr;
-	int nr_regions, i, len;
+	int nr_regions;
 
 	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 
@@ -392,18 +391,7 @@ int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 	if (addr & 3)
 		return -ENXIO;
 
-	for (i = 0; i < nr_regions; i++) {
-		if (regions[i].bits_per_irq)
-			len = (regions[i].bits_per_irq * nr_irqs) / 8;
-		else
-			len = regions[i].len;
-
-		if (regions[i].reg_offset <= addr &&
-		    regions[i].reg_offset + len > addr)
-			return 0;
-	}
-
-	return -ENXIO;
+	return vgic_validate_mmio_region_addr(dev, regions, nr_regions, addr);
 }
 
 int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 3b4d507..ffbe1ae 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -18,6 +18,8 @@
 #include <kvm/arm_vgic.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
@@ -379,6 +381,9 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
 		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
 		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICD_STATUSR,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
 		vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
 		VGIC_ACCESS_32bit),
@@ -426,12 +431,18 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
 		vgic_mmio_read_v3r_ctlr, vgic_mmio_write_v3r_ctlr, 4,
 		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_STATUSR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
 		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
 		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_WAKER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
 		vgic_mmio_read_propbase, vgic_mmio_write_propbase, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
@@ -552,6 +563,34 @@ int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
 	return ret;
 }
 
+int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	const struct vgic_register_region *regions;
+	gpa_t addr;
+	int nr_regions;
+
+	addr = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		regions = vgic_v3_dist_registers;
+		nr_regions = ARRAY_SIZE(vgic_v3_dist_registers);
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:{
+		regions = vgic_v3_rdbase_registers;
+		nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
+		break;
+	}
+	default:
+		return -ENXIO;
+	}
+
+	/* We only support aligned 32-bit accesses. */
+	if (addr & 3)
+		return -ENXIO;
+
+	return vgic_validate_mmio_region_addr(dev, regions, nr_regions, addr);
+}
 /*
  * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
  * generation register ICC_SGI1R_EL1) with a given VCPU.
@@ -658,3 +697,36 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 }
+
+int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			 int offset, u32 *val)
+{
+	struct vgic_io_device dev = {
+		.regions = vgic_v3_dist_registers,
+		.nr_regions = ARRAY_SIZE(vgic_v3_dist_registers),
+	};
+
+	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
+}
+
+int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			   int offset, u32 *val)
+{
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
+	/* SGI_base is the next 64K frame after RD_base */
+	if (offset >= SZ_64K)
+		return vgic_uaccess(vcpu, &sgi_dev, is_write,
+				    offset - SZ_64K, val);
+	else
+		return vgic_uaccess(vcpu, &rd_dev, is_write,
+				    offset, val);
+}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 99d88a6..9294555 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -448,6 +448,28 @@ vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
 		       sizeof(region[0]), match_region);
 }
 
+/* Check if address falls within the region */
+int vgic_validate_mmio_region_addr(struct kvm_device *dev,
+				   const struct vgic_register_region *regions,
+				   int nr_regions, gpa_t addr)
+{
+	int i, len;
+	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
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
+
 /*
  * kvm_mmio_read_buf() returns a value in a format where it can be converted
  * to a byte array and be directly observed as the guest wanted it to appear
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 3435f28..9a0109b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -184,6 +184,10 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
 		 bool is_write, int offset, u32 *val);
 
+int vgic_validate_mmio_region_addr(struct kvm_device *dev,
+				   const struct vgic_register_region *regions,
+				   int nr_regions, gpa_t addr);
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 6c4625c..94b3479 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -89,6 +89,11 @@ bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
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
