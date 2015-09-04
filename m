From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v3 1/5] KVM: arm/arm64: Refactor vGIC attributes handling code
Date: Fri, 04 Sep 2015 15:40:15 +0300
Message-ID: <bbc73425b0fdf9f6e39115e842678302c69e2097.1441370053.git.p.fedin@samsung.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1441370053.git.p.fedin@samsung.com>
In-reply-to: <cover.1441370053.git.p.fedin@samsung.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Separate all implementation-independent code in vgic_attr_regs_access()
and move it to vgic.c. This will allow to reuse this code for vGICv3
implementation.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/arm/vgic-v2-emul.c | 126 +++++++++-----------------------------------
 virt/kvm/arm/vgic.c         |  77 +++++++++++++++++++++++++++
 virt/kvm/arm/vgic.h         |   4 ++
 3 files changed, 107 insertions(+), 100 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 1390797..557c5a6 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -661,97 +661,38 @@ static const struct vgic_io_range vgic_cpu_ranges[] = {
 	},
 };
 
-static int vgic_attr_regs_access(struct kvm_device *dev,
-				 struct kvm_device_attr *attr,
-				 u32 *reg, bool is_write)
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
-	u32 data;
 
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
-	mmio.data = &data;
-	if (is_write)
-		mmio_data_write(&mmio, ~0, *reg);
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-		mmio.phys_addr = vgic->vgic_dist_base + offset;
+		mmio.phys_addr = vgic->vgic_dist_base;
 		ranges = vgic_dist_ranges;
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		mmio.phys_addr = vgic->vgic_cpu_base + offset;
+		mmio.phys_addr = vgic->vgic_cpu_base;
 		ranges = vgic_cpu_ranges;
 		break;
 	default:
-		BUG();
+		return -ENXIO;
 	}
-	r = vgic_find_range(ranges, 4, offset);
 
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
-
-	offset -= r->base;
-	r->handle_mmio(vcpu, &mmio, offset);
-
-	if (!is_write)
-		*reg = mmio_data_read(&mmio, ~0);
+	mmio.is_write = is_write;
+	mmio.data = data;
 
-	ret = 0;
-out_vgic_unlock:
-	spin_unlock(&vgic->lock);
-out:
-	mutex_unlock(&dev->kvm->lock);
-	return ret;
+	return vgic_attr_regs_access(dev, ranges, &mmio, offset, sizeof(data),
+				     cpuid);
 }
 
 static int vgic_v2_create(struct kvm_device *dev, u32 type)
@@ -767,53 +708,38 @@ static void vgic_v2_destroy(struct kvm_device *dev)
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
-
-		if (get_user(reg, uaddr))
-			return -EFAULT;
-
-		return vgic_attr_regs_access(dev, attr, &reg, true);
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
-		u32 reg = 0;
-
-		ret = vgic_attr_regs_access(dev, attr, &reg, false);
-		if (ret)
-			return ret;
-		return put_user(reg, uaddr);
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
index 9eb489a..33b00e5 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2410,6 +2410,83 @@ int vgic_has_attr_regs(const struct vgic_io_range *ranges, phys_addr_t offset)
 		return -ENXIO;
 }
 
+int vgic_attr_regs_access(struct kvm_device *dev,
+			  const struct vgic_io_range *ranges,
+			  struct kvm_exit_mmio *mmio, phys_addr_t offset,
+			  int len, int cpuid)
+{
+	const struct vgic_io_range *r;
+	int ret, c;
+	struct kvm_vcpu *vcpu, *tmp_vcpu;
+	struct vgic_dist *vgic;
+
+	r = vgic_find_range(ranges, len, offset);
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
+	/*
+	 * Unfortunately our MMIO handlers can process only up to 32 bits per
+	 * access. For 64-bit registers we have to split up the operation.
+	 */
+	mmio->len = sizeof(u32);
+	mmio->phys_addr += offset;
+	offset -= r->base;
+	r->handle_mmio(vcpu, mmio, offset);
+
+	if (len == sizeof(u64)) {
+		mmio->data += sizeof(u32);
+		mmio->phys_addr += sizeof(u32);
+		offset += sizeof(u32);
+		r->handle_mmio(vcpu, mmio, offset);
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
 static void vgic_init_maintenance_interrupt(void *info)
 {
 	enable_percpu_irq(vgic->maint_irq, 0);
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index 0df74cb..a08348d 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -132,6 +132,10 @@ void vgic_kick_vcpus(struct kvm *kvm);
 int vgic_has_attr_regs(const struct vgic_io_range *ranges, phys_addr_t offset);
 int vgic_set_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_get_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr);
+int vgic_attr_regs_access(struct kvm_device *dev,
+			  const struct vgic_io_range *ranges,
+			  struct kvm_exit_mmio *mmio, phys_addr_t offset,
+			  int len, int cpuid);
 
 int vgic_init(struct kvm *kvm);
 void vgic_v2_init_emulation(struct kvm *kvm);
-- 
2.4.4

