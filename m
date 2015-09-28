From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 2/7] KVM: arm/arm64: Refactor vGIC attributes handling code
Date: Mon, 28 Sep 2015 18:27:29 +0300
Message-ID: <b45cd9b29413271cc583f9ee9b222f4c1e54190c.1443451687.git.p.fedin@samsung.com>
References: <cover.1443451687.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1443451687.git.p.fedin@samsung.com>
In-reply-to: <cover.1443451687.git.p.fedin@samsung.com>
References: <cover.1443451687.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Separate all implementation-independent code in vgic_attr_regs_access()
and move it to vgic.c. This will allow to reuse this code for vGICv3
implementation.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/arm/vgic-v2-emul.c | 118 +++++++++-----------------------------------
 virt/kvm/arm/vgic.c         |  64 ++++++++++++++++++++++++
 virt/kvm/arm/vgic.h         |   4 ++
 3 files changed, 92 insertions(+), 94 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 959b9c6..b4699c1 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -661,38 +661,20 @@ static const struct vgic_io_range vgic_cpu_ranges[] = {
 	},
 };
 
-static int vgic_attr_regs_access(struct kvm_device *dev,
-				 struct kvm_device_attr *attr,
-				 __le32 *data, bool is_write)
+static int vgic_v2_attr_regs_access(struct kvm_device *dev,
+				    struct kvm_device_attr *attr,
+				    __le32 *data, bool is_write)
 {
-	const struct vgic_io_range *r = NULL, *ranges;
+	const struct vgic_io_range *ranges;
 	phys_addr_t offset;
-	int ret, cpuid, c;
-	struct kvm_vcpu *vcpu, *tmp_vcpu;
-	struct vgic_dist *vgic;
+	int cpuid;
+	struct vgic_dist *vgic = &dev->kvm->arch.vgic;
 	struct kvm_exit_mmio mmio;
 
 	offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
 		KVM_DEV_ARM_VGIC_CPUID_SHIFT;
 
-	mutex_lock(&dev->kvm->lock);
-
-	ret = vgic_init(dev->kvm);
-	if (ret)
-		goto out;
-
-	if (cpuid >= atomic_read(&dev->kvm->online_vcpus)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
-	vgic = &dev->kvm->arch.vgic;
-
-	mmio.len = 4;
-	mmio.is_write = is_write;
-	mmio.data = data;
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 		mmio.phys_addr = vgic->vgic_dist_base + offset;
@@ -703,49 +685,14 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 		ranges = vgic_cpu_ranges;
 		break;
 	default:
-		BUG();
+		return -ENXIO;
 	}
-	r = vgic_find_range(ranges, 4, offset);
-
-	if (unlikely(!r || !r->handle_mmio)) {
-		ret = -ENXIO;
-		goto out;
-	}
-
-
-	spin_lock(&vgic->lock);
-
-	/*
-	 * Ensure that no other VCPU is running by checking the vcpu->cpu
-	 * field.  If no other VPCUs are running we can safely access the VGIC
-	 * state, because even if another VPU is run after this point, that
-	 * VCPU will not touch the vgic state, because it will block on
-	 * getting the vgic->lock in kvm_vgic_sync_hwstate().
-	 */
-	kvm_for_each_vcpu(c, tmp_vcpu, dev->kvm) {
-		if (unlikely(tmp_vcpu->cpu != -1)) {
-			ret = -EBUSY;
-			goto out_vgic_unlock;
-		}
-	}
-
-	/*
-	 * Move all pending IRQs from the LRs on all VCPUs so the pending
-	 * state can be properly represented in the register state accessible
-	 * through this API.
-	 */
-	kvm_for_each_vcpu(c, tmp_vcpu, dev->kvm)
-		vgic_unqueue_irqs(tmp_vcpu);
 
-	offset -= r->base;
-	r->handle_mmio(vcpu, &mmio, offset);
+	mmio.len = 4;
+	mmio.is_write = is_write;
+	mmio.data = data;
 
-	ret = 0;
-out_vgic_unlock:
-	spin_unlock(&vgic->lock);
-out:
-	mutex_unlock(&dev->kvm->lock);
-	return ret;
+	return vgic_attr_regs_access(dev, ranges, &mmio, offset, cpuid);
 }
 
 static int vgic_v2_create(struct kvm_device *dev, u32 type)
@@ -761,55 +708,38 @@ static void vgic_v2_destroy(struct kvm_device *dev)
 static int vgic_v2_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
+	u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+	u32 reg;
+	__le32 data;
 	int ret;
 
 	ret = vgic_set_common_attr(dev, attr);
 	if (ret != -ENXIO)
 		return ret;
 
-	switch (attr->group) {
-	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg;
-		__le32 data;
-
-		if (get_user(reg, uaddr))
-			return -EFAULT;
-
-		data = cpu_to_le32(reg);
-		return vgic_attr_regs_access(dev, attr, &data, true);
-	}
-
-	}
+	if (get_user(reg, uaddr))
+		return -EFAULT;
 
-	return -ENXIO;
+	data = cpu_to_le32(reg);
+	return vgic_v2_attr_regs_access(dev, attr, &data, true);
 }
 
 static int vgic_v2_get_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
+	u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+	__le32 data = 0;
 	int ret;
 
 	ret = vgic_get_common_attr(dev, attr);
 	if (ret != -ENXIO)
 		return ret;
 
-	switch (attr->group) {
-	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		__le32 data = 0;
-
-		ret = vgic_attr_regs_access(dev, attr, &data, false);
-		if (ret)
-			return ret;
-		return put_user(le32_to_cpu(data), uaddr);
-	}
-
-	}
+	ret = vgic_v2_attr_regs_access(dev, attr, &data, false);
+	if (ret)
+		return ret;
 
-	return -ENXIO;
+	return put_user(le32_to_cpu(data), uaddr);
 }
 
 static int vgic_v2_has_attr(struct kvm_device *dev,
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 6bd1c9b..91e0f15 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2420,6 +2420,70 @@ int vgic_has_attr_regs(const struct vgic_io_range *ranges, phys_addr_t offset)
 		return -ENXIO;
 }
 
+int vgic_attr_regs_access(struct kvm_device *dev,
+			  const struct vgic_io_range *ranges,
+			  struct kvm_exit_mmio *mmio, phys_addr_t offset,
+			  int cpuid)
+{
+	const struct vgic_io_range *r;
+	int ret, c;
+	struct kvm_vcpu *vcpu, *tmp_vcpu;
+	struct vgic_dist *vgic;
+
+	r = vgic_find_range(ranges, 4, offset);
+
+	if (unlikely(!r || !r->handle_mmio))
+		return -ENXIO;
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
+	r->handle_mmio(vcpu, mmio, offset);
+
+	ret = 0;
+out_vgic_unlock:
+	spin_unlock(&vgic->lock);
+out:
+	mutex_unlock(&dev->kvm->lock);
+	return ret;
+}
+
 static void vgic_init_maintenance_interrupt(void *info)
 {
 	enable_percpu_irq(vgic->maint_irq, 0);
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index 0df74cb..75c253b 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -132,6 +132,10 @@ void vgic_kick_vcpus(struct kvm *kvm);
 int vgic_has_attr_regs(const struct vgic_io_range *ranges, phys_addr_t offset);
 int vgic_set_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_get_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr);
+int vgic_attr_regs_access(struct kvm_device *dev,
+			  const struct vgic_io_range *ranges,
+			  struct kvm_exit_mmio *mmio, phys_addr_t offset,
+			  int cpuid);
 
 int vgic_init(struct kvm *kvm);
 void vgic_v2_init_emulation(struct kvm *kvm);
-- 
2.4.4

