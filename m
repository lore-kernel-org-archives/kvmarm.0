From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 4/7] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Mon, 28 Sep 2015 18:27:31 +0300
Message-ID: <9d42bb0fd6abf17bae0179c4233c45d267c25162.1443451687.git.p.fedin@samsung.com>
References: <cover.1443451687.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <cover.1443451687.git.p.fedin@samsung.com>
In-reply-to: <cover.1443451687.git.p.fedin@samsung.com>
References: <cover.1443451687.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The access is done similar to vGICv2, using KVM_DEV_ARM_VGIC_GRP_DIST_REGS
and KVM_DEV_ARM_VGIC_GRP_REDIST_REGS with KVM_SET_DEVICE_ATTR and
KVM_GET_DEVICE_ATTR ioctls. Since GICv3 can handle large number of CPUs,
KVM_DEV_ARM_VGIC_CPUID_MASK has been extended to 20 bits. This is enough
for 1048576 CPUs.

Some registers are 64-bit wide according to the specification.
KVM_DEV_ARM_VGIC_64BIT flag is introduced, allowing to perform full 64-bit
accesses. vgic_attr_regs_access() has also been fixed up in order to be
able to perform 64-bit accesses correctly.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 Documentation/virtual/kvm/devices/arm-vgic.txt | 36 ++++++++--
 arch/arm64/include/uapi/asm/kvm.h              |  4 +-
 virt/kvm/arm/vgic-v3-emul.c                    | 94 ++++++++++++++++++++++----
 virt/kvm/arm/vgic.c                            |  5 +-
 4 files changed, 118 insertions(+), 21 deletions(-)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 4727829..1c570e4 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -43,10 +43,13 @@ Groups:
   KVM_DEV_ARM_VGIC_GRP_DIST_REGS
   Attributes:
     The attr field of kvm_device_attr encodes two values:
-    bits:     | 63   ....  40 | 39 ..  32  |  31   ....    0 |
-    values:   |    reserved   |  cpu idx   |      offset     |
+    bits:     |  63  | 62 .. 52 | 51 ..  32  |  31   ....    0 |
+    values:   | size | reserved |  cpu idx   |      offset     |
 
-    All distributor regs are (rw, 32-bit)
+    All distributor regs can be accessed as (rw, 32-bit)
+    For GICv3 some regsisters are actually (rw, 64-bit) according to the
+    specification. In order to perform full 64-bit access 'size' bit should be
+    set to 1. KVM_DEV_ARM_VGIC_64BIT flag value is provided for this purpose.
 
     The offset is relative to the "Distributor base address" as defined in the
     GICv2 specs.  Getting or setting such a register has the same effect as
@@ -54,9 +57,34 @@ Groups:
     index is specified with cpu idx field.  Note that most distributor fields
     are not banked, but return the same value regardless of the cpu idx used to
     access the register.
+
+  Limitations:
+    - Priorities are not implemented, and registers are RAZ/WI
+  Errors:
+    -ENXIO: Getting or setting this register is not yet supported
+    -EBUSY: One or more VCPUs are running
+    -EINVAL: Invalid CPU index supplied
+
+  KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
+  Attributes:
+    The attr field of kvm_device_attr encodes two values:
+    bits:     |  63  | 62 .. 52 | 51 ..  32  |  31   ....    0 |
+    values:   | size | reserved |  cpu idx   |      offset     |
+
+    All redistributor regs can be accessed as (rw, 32-bit)
+    For GICv3 some registerss are actually (rw, 64-bit) according to the
+    specification. In order to perform full 64-bit access 'size' bit should be
+    set to 1. KVM_DEV_ARM_VGIC_64BIT flag value is provided for this purpose.
+
+    The offset is relative to the "Redistributor base address" as defined in
+    the GICv3 specs.  Getting or setting such a register has the same effect as
+    reading or writing the register on the actual hardware from the cpu whose
+    index is specified with cpu idx field. Note that most distributor fields
+    are not banked, but return the same value regardless of the cpu idx used to
+    access the register.
+
   Limitations:
     - Priorities are not implemented, and registers are RAZ/WI
-    - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
   Errors:
     -ENXIO: Getting or setting this register is not yet supported
     -EBUSY: One or more VCPUs are running
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 0cd7b59..249954f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -196,13 +196,15 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
 #define KVM_DEV_ARM_VGIC_GRP_CPU_REGS	2
+#define   KVM_DEV_ARM_VGIC_64BIT	(1ULL << 63)
 #define   KVM_DEV_ARM_VGIC_CPUID_SHIFT	32
-#define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
+#define   KVM_DEV_ARM_VGIC_CPUID_MASK	(0xfffffULL << KVM_DEV_ARM_VGIC_CPUID_SHIFT)
 #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
 #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
 #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
+#define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index e661e7f..ce797bd 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -39,6 +39,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 #include <kvm/arm_vgic.h>
@@ -990,6 +991,76 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg)
 		vgic_kick_vcpus(vcpu->kvm);
 }
 
+static int vgic_v3_attr_regs_access(struct kvm_device *dev,
+				    struct kvm_device_attr *attr,
+				    bool is_write)
+{
+	const struct vgic_io_range *ranges;
+	phys_addr_t offset;
+	int cpuid, ret;
+	struct vgic_dist *vgic = &dev->kvm->arch.vgic;
+	struct kvm_exit_mmio mmio;
+
+	offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+	cpuid = (attr->attr & KVM_DEV_ARM_VGIC_CPUID_MASK) >>
+		KVM_DEV_ARM_VGIC_CPUID_SHIFT;
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
+	mmio.is_write = is_write;
+
+	if (attr->attr & KVM_DEV_ARM_VGIC_64BIT) {
+		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+		__le64 data;
+
+		if (is_write) {
+			u64 reg;
+
+			if (get_user(reg, uaddr))
+				return -EFAULT;
+			data = cpu_to_le64(reg);
+		}
+
+		mmio.len = sizeof(data);
+		mmio.data = &data;
+		ret = vgic_attr_regs_access(dev, ranges, &mmio, offset, cpuid);
+
+		if (!ret && !is_write)
+			ret = put_user(le64_to_cpu(data), uaddr);
+	} else {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+		__le32 data;
+
+		if (is_write) {
+			u32 reg;
+
+			if (get_user(reg, uaddr))
+				return -EFAULT;
+			data = cpu_to_le32(reg);
+		}
+
+		mmio.len = sizeof(data);
+		mmio.data = &data;
+		ret = vgic_attr_regs_access(dev, ranges, &mmio, offset, cpuid);
+
+		if (!ret && !is_write)
+			ret = put_user(le32_to_cpu(data), uaddr);
+	}
+
+	return ret;
+}
+
 static int vgic_v3_create(struct kvm_device *dev, u32 type)
 {
 	return kvm_vgic_create(dev->kvm, type);
@@ -1009,13 +1080,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 	if (ret != -ENXIO)
 		return ret;
 
-	switch (attr->group) {
-	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;
-	}
-
-	return -ENXIO;
+	return vgic_v3_attr_regs_access(dev, attr, true);
 }
 
 static int vgic_v3_get_attr(struct kvm_device *dev,
@@ -1027,18 +1092,14 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 	if (ret != -ENXIO)
 		return ret;
 
-	switch (attr->group) {
-	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
-	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;
-	}
-
-	return -ENXIO;
+	return vgic_v3_attr_regs_access(dev, attr, false);
 }
 
 static int vgic_v3_has_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
+	phys_addr_t offset;
+
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_ADDR:
 		switch (attr->attr) {
@@ -1051,6 +1112,11 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 		}
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
+		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+		return vgic_has_attr_regs(vgic_v3_dist_ranges, offset);
+	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
+		offset = attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK;
+		return vgic_has_attr_regs(vgic_redist_ranges, offset);
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
 		return -ENXIO;
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 91e0f15..653fef2 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2430,7 +2430,7 @@ int vgic_attr_regs_access(struct kvm_device *dev,
 	struct kvm_vcpu *vcpu, *tmp_vcpu;
 	struct vgic_dist *vgic;
 
-	r = vgic_find_range(ranges, 4, offset);
+	r = vgic_find_range(ranges, mmio->len, offset);
 
 	if (unlikely(!r || !r->handle_mmio))
 		return -ENXIO;
@@ -2473,8 +2473,9 @@ int vgic_attr_regs_access(struct kvm_device *dev,
 	kvm_for_each_vcpu(c, tmp_vcpu, dev->kvm)
 		vgic_unqueue_irqs(tmp_vcpu);
 
+	mmio->private = vcpu; /* Small hack for redistributor handlers */
 	offset -= r->base;
-	r->handle_mmio(vcpu, mmio, offset);
+	call_range_handler(vcpu, mmio, offset, r);
 
 	ret = 0;
 out_vgic_unlock:
-- 
2.4.4

