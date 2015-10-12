From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v5 3/7] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Mon, 12 Oct 2015 11:29:35 +0300
Message-ID: <4d0ae7dbfa93ba31c79785c3cb3141c905d29004.1444638023.git.p.fedin@samsung.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1444638023.git.p.fedin@samsung.com>
In-reply-to: <cover.1444638023.git.p.fedin@samsung.com>
References: <cover.1444638023.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The access is done similar to vGICv2, using KVM_DEV_ARM_VGIC_GRP_DIST_REGS
and KVM_DEV_ARM_VGIC_GRP_REDIST_REGS with KVM_SET_DEVICE_ATTR and
KVM_GET_DEVICE_ATTR ioctls. Since GICv3 can handle large number of CPUs,
KVM_DEV_ARM_VGIC_CPUID_MASK has been extended to 32 bits.

Access size for vGICv3 is 64 bits, vgic_attr_regs_access() fixed to
support this. The trick with vgic_v3_get_reg_size() is necessary because
the major part of GICv3 registers is actually 32-bit, and their accessors
do not distinguish between lower and upper words (offset & 3). Accessing
these registers with len == 8 would cause rollover. For write operations
this would overwrite lower word with the upper one (which would normally
be 0), for read operations this would cause duplication of the same word
in both halves.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm64/include/uapi/asm/kvm.h  |   3 +-
 include/linux/irqchip/arm-gic-v3.h |   1 +
 virt/kvm/arm/vgic-v3-emul.c        | 113 ++++++++++++++++++++++++++++++++-----
 virt/kvm/arm/vgic.c                |   4 +-
 4 files changed, 104 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 0cd7b59..2db09d8 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -197,12 +197,13 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
 #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
 #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
-#define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
+#define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
+#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c0c8a2e..add60bb 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -45,6 +45,7 @@
 #define GICD_IGRPMODR			0x0D00
 #define GICD_NSACR			0x0E00
 #define GICD_IROUTER			0x6000
+#define GICD_IROUTER1019		0x7FD8
 #define GICD_IDREGS			0xFFD0
 #define GICD_PIDR2			0xFFE8
 
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index e661e7f..ca1d553 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -39,6 +39,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 #include <kvm/arm_vgic.h>
@@ -990,6 +991,78 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 		vgic_kick_vcpus(vcpu->kvm);
 }
 
+static u32 vgic_v3_get_reg_size(u32 group, u32 offset)
+{
+	switch (group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		if (offset >= GICD_IROUTER && offset <= GICD_IROUTER1019)
+			return 8;
+		else
+			return 4;
+		break;
+
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		if ((offset == GICR_TYPER) ||
+		    (offset >= GICR_SETLPIR && offset <= GICR_INVALLR))
+			return 8;
+		else
+			return 4;
+		break;
+
+	default:
+		BUG();
+	}
+}
+
+static int vgic_v3_attr_regs_access(struct kvm_device *dev,
+				    struct kvm_device_attr *attr,
+				    u64 *reg, bool is_write)
+{
+	const struct vgic_io_range *ranges;
+	phys_addr_t offset;
+	struct kvm_vcpu *vcpu;
+	u64 cpuid;
+	struct vgic_dist *vgic = &dev->kvm->arch.vgic;
+	struct kvm_exit_mmio mmio;
+	__le64 data;
+	int ret;
+
+	offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
+		KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+
+	/* Convert affinity ID from our packed to normal form */
+	cpuid = (cpuid & 0x00ffffff) | ((cpuid & 0xff000000) << 8);
+	vcpu = kvm_mpidr_to_vcpu(dev->kvm, cpuid);
+	if (!vcpu)
+		return -EINVAL;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		mmio.phys_addr = vgic->vgic_dist_base + offset;
+		ranges = vgic_v3_dist_ranges;
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		mmio.phys_addr = vgic->vgic_redist_base + offset;
+		ranges = vgic_redist_ranges;
+		break;
+	default:
+		return -ENXIO;
+	}
+
+	data = cpu_to_le64(*reg);
+
+	mmio.len = vgic_v3_get_reg_size(attr->group, offset);
+	mmio.is_write = is_write;
+	mmio.data = &data;
+	mmio.private = vcpu; /* Redistributor handlers expect this */
+
+	ret = vgic_attr_regs_access(vcpu, ranges, &mmio, offset);
+
+	*reg = le64_to_cpu(data);
+	return ret;
+}
+
 static int vgic_v3_create(struct kvm_device *dev, u32 type)
 {
 	return kvm_vgic_create(dev->kvm, type);
@@ -1003,42 +1076,45 @@ static void vgic_v3_destroy(struct kvm_device *dev)
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	u64 reg;
 	int ret;
 
 	ret = vgic_set_common_attr(dev, attr);
 	if (ret != -ENXIO)
 		return ret;
 
-	switch (attr->group) {
-	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;
-	}
+	if (get_user(reg, uaddr))
+		return -EFAULT;
 
-	return -ENXIO;
+	return vgic_v3_attr_regs_access(dev, attr, &reg, true);
 }
 
 static int vgic_v3_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	u64 reg = 0;
 	int ret;
 
 	ret = vgic_get_common_attr(dev, attr);
 	if (ret != -ENXIO)
 		return ret;
 
-	switch (attr->group) {
-	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;
-	}
+	ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
+	if (ret)
+		return ret;
 
-	return -ENXIO;
+	return put_user(reg, uaddr);
 }
 
 static int vgic_v3_has_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
+	phys_addr_t offset;
+	struct sys_reg_params params;
+	u64 regid;
+
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		switch (attr->attr) {
@@ -1051,8 +1127,17 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 		}
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;
+		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+		return vgic_has_attr_regs(vgic_v3_dist_ranges, offset);
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+		return vgic_has_attr_regs(vgic_redist_ranges, offset);
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+		regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_MASK) |
+			KVM_REG_SIZE_U64;
+		return find_reg_by_id(regid, &params, gic_v3_icc_reg_descs,
+				      ARRAY_SIZE(gic_v3_icc_reg_descs)) ?
+			0 : -ENXIO;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 45176df..f7acf50 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2429,7 +2429,7 @@ int vgic_attr_regs_access(struct kvm_vcpu *vcpu,
 	struct kvm_vcpu *tmp_vcpu;
 	struct vgic_dist *vgic;
 
-	r = vgic_find_range(ranges, 4, offset);
+	r = vgic_find_range(ranges, mmio->len, offset);
 
 	if (unlikely(!r || !r->handle_mmio))
 		return -ENXIO;
@@ -2467,7 +2467,7 @@ int vgic_attr_regs_access(struct kvm_vcpu *vcpu,
 		vgic_unqueue_irqs(tmp_vcpu);
 
 	offset -= r->base;
-	r->handle_mmio(vcpu, mmio, offset);
+	call_range_handler(vcpu, mmio, offset, r);
 
 	ret = 0;
 out_vgic_unlock:
-- 
2.4.4

