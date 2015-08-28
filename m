From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 1/3] KVM: arm64: Implement vGICv3 distributor and redistributor
 access from userspace
Date: Fri, 28 Aug 2015 15:56:10 +0300
Message-ID: <cb311e13e56311c535362f32177313850c51af66.1440766141.git.p.fedin@samsung.com>
References: <cover.1440766141.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1440766141.git.p.fedin@samsung.com>
In-reply-to: <cover.1440766141.git.p.fedin@samsung.com>
References: <cover.1440766141.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The access is done similar to GICv2, using KVM_DEV_ARM_VGIC_GRP_DIST_REGS
and KVM_DEV_ARM_VGIC_GRP_REDIST_REGS with KVM_SET_DEVICE_ATTR and
KVM_GET_DEVICE_ATTR ioctls.

Registers are always assumed to be of their native size, 4 or 8 bytes.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm64/include/uapi/asm/kvm.h |   1 +
 virt/kvm/arm/vgic-v3-emul.c       | 186 +++++++++++++++++++++++++++++++++++---
 2 files changed, 172 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 0cd7b59..2936651 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -203,6 +203,7 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
+#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index e661e7f..b3847e1 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -39,6 +39,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 #include <kvm/arm_vgic.h>
@@ -990,6 +991,107 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 		vgic_kick_vcpus(vcpu->kvm);
 }
 
+static int vgic_v3_attr_regs_access(struct kvm_device *dev,
+				 struct kvm_device_attr *attr,
+				 void *reg, u32 len, bool is_write)
+{
+	const struct vgic_io_range *r = NULL, *ranges;
+	phys_addr_t offset;
+	int ret, cpuid, c;
+	struct kvm_vcpu *vcpu, *tmp_vcpu;
+	struct vgic_dist *vgic;
+	struct kvm_exit_mmio mmio;
+	u64 data;
+
+	offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
+		KVM_DEV_ARM_VGIC_CPUID_SHIFT;
+
+	mutex_lock(&dev->kvm->lock);
+
+	ret = vgic_init(dev->kvm);
+	if (ret)
+		goto out;
+
+	if (cpuid >= atomic_read(&dev->kvm->online_vcpus)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
+	vgic = &dev->kvm->arch.vgic;
+
+	mmio.len = len;
+	mmio.is_write = is_write;
+	mmio.data = &data;
+	if (is_write) {
+		if (len == 8)
+			data = cpu_to_le64(*((u64 *)reg));
+		else
+			mmio_data_write(&mmio, ~0, *((u32 *)reg));
+	}
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
+		BUG();
+	}
+	r = vgic_find_range(ranges, 4, offset);
+
+	if (unlikely(!r || !r->handle_mmio)) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+
+	spin_lock(&vgic->lock);
+
+	/*
+	 * Ensure that no other VCPU is running by checking the vcpu->cpu
+	 * field.  If no other VPCUs are running we can safely access the VGIC
+	 * state, because even if another VPU is run after this point, that
+	 * VCPU will not touch the vgic state, because it will block on
+	 * getting the vgic->lock in kvm_vgic_sync_hwstate().
+	 */
+	kvm_for_each_vcpu(c, tmp_vcpu, dev->kvm) {
+		if (unlikely(tmp_vcpu->cpu != -1)) {
+			ret = -EBUSY;
+			goto out_vgic_unlock;
+		}
+	}
+
+	/*
+	 * Move all pending IRQs from the LRs on all VCPUs so the pending
+	 * state can be properly represented in the register state accessible
+	 * through this API.
+	 */
+	kvm_for_each_vcpu(c, tmp_vcpu, dev->kvm)
+		vgic_unqueue_irqs(tmp_vcpu);
+
+	offset -= r->base;
+	r->handle_mmio(vcpu, &mmio, offset);
+
+	if (!is_write) {
+		if (len == 8)
+			*(u64 *)reg = le64_to_cpu(data);
+		else
+			*(u32 *)reg = mmio_data_read(&mmio, ~0);
+	}
+
+	ret = 0;
+out_vgic_unlock:
+	spin_unlock(&vgic->lock);
+out:
+	mutex_unlock(&dev->kvm->lock);
+	return ret;
+}
+
 static int vgic_v3_create(struct kvm_device *dev, u32 type)
 {
 	return kvm_vgic_create(dev->kvm, type);
@@ -1000,40 +1102,95 @@ static void vgic_v3_destroy(struct kvm_device *dev)
 	kfree(dev);
 }
 
+static u32 vgic_v3_get_reg_size(struct kvm_device_attr *attr)
+{
+	u32 offset;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+		if (offset >= GICD_IROUTER && offset <= 0x7FD8)
+			return 8;
+		else
+			return 4;
+		break;
+
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+		if ((offset == GICR_TYPER) ||
+		    (offset >= GICR_SETLPIR && offset <= GICR_INVALLR))
+			return 8;
+		else
+			return 4;
+		break;
+
+	default:
+		return -ENXIO;
+	}
+}
+
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
+	int ret, len;
+	u64 reg64;
+	u32 reg;
+	void *data;
 
 	ret = vgic_set_common_attr(dev, attr);
 	if (ret != -ENXIO)
 		return ret;
 
-	switch (attr->group) {
-	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;
+	len = vgic_v3_get_reg_size(attr);
+	if (len < 0)
+		return len;
+
+	if (len == 8) {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+
+		ret = get_user(reg64, uaddr);
+		data = &reg64;
+	} else {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+
+		ret = get_user(reg, uaddr);
+		data = &reg;
 	}
+	if (ret)
+		return -EFAULT;
 
-	return -ENXIO;
+	return vgic_v3_attr_regs_access(dev, attr, data, len, true);
 }
 
 static int vgic_v3_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
-	int ret;
+	int ret, len;
+	u64 reg64;
+	u32 reg;
 
 	ret = vgic_get_common_attr(dev, attr);
 	if (ret != -ENXIO)
 		return ret;
 
-	switch (attr->group) {
-	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;
-	}
+	len = vgic_v3_get_reg_size(attr);
+	if (len < 0)
+		return len;
 
-	return -ENXIO;
+	ret = vgic_v3_attr_regs_access(dev, attr, (len == 8) ? (void *)&reg64 :
+					(void *)&reg, len, false);
+	if (ret)
+		return ret;
+
+	if (len == 8) {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+
+		return put_user(reg64, uaddr);
+	} else {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+
+		return put_user(reg, uaddr);
+	}
 }
 
 static int vgic_v3_has_attr(struct kvm_device *dev,
@@ -1051,8 +1208,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 		}
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
-- 
2.4.4

