From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v6 3/7] KVM: arm/arm64: Refactor vGIC attributes handling code
Date: Tue, 24 Nov 2015 12:14:37 +0300
Message-ID: <d3425a27b416b347e4d709580ca9673439940be7.1448356282.git.p.fedin@samsung.com>
References: <cover.1448356282.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 763F048531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 04:13:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WURbWPMZt-Bn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 04:13:51 -0500 (EST)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8630495BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 04:13:51 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYB00CUNB0O1950@mailout2.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 24 Nov 2015 09:14:48 +0000 (GMT)
In-reply-to: <cover.1448356282.git.p.fedin@samsung.com>
In-reply-to: <cover.1448356282.git.p.fedin@samsung.com>
References: <cover.1448356282.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Separate all implementation-independent code in vgic_attr_regs_access()
and move it to vgic.c. This will allow to reuse this code for vGICv3
implementation.

vcpu lookup is left where it originally was, because vGICv3 API will
expect affinity ID instead of vCPU index, therefore it will be done
differently. Also, vcpu pointer has backpointer to kvm, so 'dev' was
replaced with  'vcpu'.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/arm/vgic-v2-emul.c | 120 +++++++++++---------------------------------
 virt/kvm/arm/vgic.c         |  57 +++++++++++++++++++++
 virt/kvm/arm/vgic.h         |   3 ++
 3 files changed, 88 insertions(+), 92 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 959b9c6..8e769c6 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -661,38 +661,24 @@ static const struct vgic_io_range vgic_cpu_ranges[] = {
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
+	struct kvm_vcpu *vcpu;
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
+	if (cpuid >= atomic_read(&dev->kvm->online_vcpus))
+		return -EINVAL;
 
-	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
-	vgic = &dev->kvm->arch.vgic;
-
-	mmio.len = 4;
-	mmio.is_write = is_write;
-	mmio.data = data;
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 		mmio.phys_addr = vgic->vgic_dist_base + offset;
@@ -703,49 +689,16 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
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
+	vcpu = kvm_get_vcpu(dev->kvm, cpuid);
 
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
+	return vgic_attr_regs_access(vcpu, ranges, &mmio, offset);
 }
 
 static int vgic_v2_create(struct kvm_device *dev, u32 type)
@@ -761,55 +714,38 @@ static void vgic_v2_destroy(struct kvm_device *dev)
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
index 5335383..5e09629 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2365,6 +2365,63 @@ int vgic_has_attr_regs(const struct vgic_io_range *ranges, phys_addr_t offset)
 		return -ENXIO;
 }
 
+int vgic_attr_regs_access(struct kvm_vcpu *vcpu,
+			  const struct vgic_io_range *ranges,
+			  struct kvm_exit_mmio *mmio, phys_addr_t offset)
+{
+	const struct vgic_io_range *r;
+	int ret, c;
+	struct kvm_vcpu *tmp_vcpu;
+	struct vgic_dist *vgic;
+
+	r = vgic_find_range(ranges, 4, offset);
+
+	if (unlikely(!r || !r->handle_mmio))
+		return -ENXIO;
+
+	mutex_lock(&vcpu->kvm->lock);
+
+	ret = vgic_init(vcpu->kvm);
+	if (ret)
+		goto out;
+
+	vgic = &vcpu->kvm->arch.vgic;
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
+	kvm_for_each_vcpu(c, tmp_vcpu, vcpu->kvm) {
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
+	kvm_for_each_vcpu(c, tmp_vcpu, vcpu->kvm)
+		vgic_unqueue_irqs(tmp_vcpu);
+
+	offset -= r->base;
+	r->handle_mmio(vcpu, mmio, offset);
+
+	ret = 0;
+out_vgic_unlock:
+	spin_unlock(&vgic->lock);
+out:
+	mutex_unlock(&vcpu->kvm->lock);
+	return ret;
+}
+
 static void vgic_init_maintenance_interrupt(void *info)
 {
 	enable_percpu_irq(vgic->maint_irq, 0);
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index 0df74cb..fca89b7 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -132,6 +132,9 @@ void vgic_kick_vcpus(struct kvm *kvm);
 int vgic_has_attr_regs(const struct vgic_io_range *ranges, phys_addr_t offset);
 int vgic_set_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_get_common_attr(struct kvm_device *dev, struct kvm_device_attr *attr);
+int vgic_attr_regs_access(struct kvm_vcpu *vcpu,
+			  const struct vgic_io_range *ranges,
+			  struct kvm_exit_mmio *mmio, phys_addr_t offset);
 
 int vgic_init(struct kvm *kvm);
 void vgic_v2_init_emulation(struct kvm *kvm);
-- 
2.4.4
