From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 1/7] KVM: arm/arm64: Move endianness conversion out of
 vgic_attr_regs_access()
Date: Mon, 28 Sep 2015 18:27:28 +0300
Message-ID: <05e209cb818d981c2b7e52d156410a2199555ac9.1443451687.git.p.fedin@samsung.com>
References: <cover.1443451687.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1443451687.git.p.fedin@samsung.com>
In-reply-to: <cover.1443451687.git.p.fedin@samsung.com>
References: <cover.1443451687.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

mmio_data_read() and mmio_data_write(), originally used in this function,
are limited only to 32 bits. We are going to refactor this code and
eventually let it do 64-bit I/O for vGICv3. Therefore, our first step is
to get rid of this limitation.

We open up these inlines, which consist of endianness conversion and
masking. Masking is not used here (the mask is set to ~0), so we just move
out the remaining endianness conversion.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/arm/vgic-v2-emul.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 1390797..959b9c6 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -663,7 +663,7 @@ static const struct vgic_io_range vgic_cpu_ranges[] = {
 
 static int vgic_attr_regs_access(struct kvm_device *dev,
 				 struct kvm_device_attr *attr,
-				 u32 *reg, bool is_write)
+				 __le32 *data, bool is_write)
 {
 	const struct vgic_io_range *r = NULL, *ranges;
 	phys_addr_t offset;
@@ -671,7 +671,6 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 	struct kvm_vcpu *vcpu, *tmp_vcpu;
 	struct vgic_dist *vgic;
 	struct kvm_exit_mmio mmio;
-	u32 data;
 
 	offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
 	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
@@ -693,9 +692,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 
 	mmio.len = 4;
 	mmio.is_write = is_write;
-	mmio.data = &data;
-	if (is_write)
-		mmio_data_write(&mmio, ~0, *reg);
+	mmio.data = data;
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 		mmio.phys_addr = vgic->vgic_dist_base + offset;
@@ -743,9 +740,6 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 	offset -= r->base;
 	r->handle_mmio(vcpu, &mmio, offset);
 
-	if (!is_write)
-		*reg = mmio_data_read(&mmio, ~0);
-
 	ret = 0;
 out_vgic_unlock:
 	spin_unlock(&vgic->lock);
@@ -778,11 +772,13 @@ static int vgic_v2_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
 		u32 reg;
+		__le32 data;
 
 		if (get_user(reg, uaddr))
 			return -EFAULT;
 
-		return vgic_attr_regs_access(dev, attr, &reg, true);
+		data = cpu_to_le32(reg);
+		return vgic_attr_regs_access(dev, attr, &data, true);
 	}
 
 	}
@@ -803,12 +799,12 @@ static int vgic_v2_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS: {
 		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-		u32 reg = 0;
+		__le32 data = 0;
 
-		ret = vgic_attr_regs_access(dev, attr, &reg, false);
+		ret = vgic_attr_regs_access(dev, attr, &data, false);
 		if (ret)
 			return ret;
-		return put_user(reg, uaddr);
+		return put_user(le32_to_cpu(data), uaddr);
 	}
 
 	}
-- 
2.4.4

