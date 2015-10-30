From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 21/21] KVM: ARM64: Add a new kvm ARM PMU device
Date: Fri, 30 Oct 2015 14:22:03 +0800
Message-ID: <1446186123-11548-22-git-send-email-zhaoshenglong@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add a new kvm device type KVM_DEV_TYPE_ARM_PMU_V3 for ARM PMU. Implement
the kvm_device_ops for it.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-pmu.txt | 15 +++++
 arch/arm64/include/uapi/asm/kvm.h             |  3 +
 include/linux/kvm_host.h                      |  1 +
 include/uapi/linux/kvm.h                      |  2 +
 virt/kvm/arm/pmu.c                            | 92 +++++++++++++++++++++++++++
 virt/kvm/arm/vgic.c                           |  8 +++
 virt/kvm/arm/vgic.h                           |  1 +
 virt/kvm/kvm_main.c                           |  4 ++
 8 files changed, 126 insertions(+)
 create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt

diff --git a/Documentation/virtual/kvm/devices/arm-pmu.txt b/Documentation/virtual/kvm/devices/arm-pmu.txt
new file mode 100644
index 0000000..49481c4
--- /dev/null
+++ b/Documentation/virtual/kvm/devices/arm-pmu.txt
@@ -0,0 +1,15 @@
+ARM Virtual Performance Monitor Unit (vPMU)
+===========================================
+
+Device types supported:
+  KVM_DEV_TYPE_ARM_PMU_V3         ARM Performance Monitor Unit v3
+
+Instantiate one PMU instance for per VCPU through this API.
+
+Groups:
+  KVM_DEV_ARM_PMU_GRP_IRQ
+  Attributes:
+    A value describing the interrupt number of PMU overflow interrupt.
+
+  Errors:
+    -EINVAL: Value set is out of the expected range
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 0cd7b59..1309a93 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -204,6 +204,9 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
+/* Device Control API: ARM PMU */
+#define KVM_DEV_ARM_PMU_GRP_IRQ		0
+
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
 #define KVM_ARM_IRQ_TYPE_MASK		0xff
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1bef9e2..f6be696 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1122,6 +1122,7 @@ extern struct kvm_device_ops kvm_mpic_ops;
 extern struct kvm_device_ops kvm_xics_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
+extern struct kvm_device_ops kvm_arm_pmu_ops;
 
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a9256f0..f41e6b6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1025,6 +1025,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
 	KVM_DEV_TYPE_ARM_VGIC_V3,
 #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
+	KVM_DEV_TYPE_ARM_PMU_V3,
+#define	KVM_DEV_TYPE_ARM_PMU_V3		KVM_DEV_TYPE_ARM_PMU_V3
 	KVM_DEV_TYPE_MAX,
 };
 
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index d78ce7b..0a00d04 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -19,10 +19,13 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/uaccess.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
 
+#include "vgic.h"
+
 /**
  * kvm_pmu_get_counter_value - get PMU counter value
  * @vcpu: The vcpu pointer
@@ -416,3 +419,92 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 
 	pmc->perf_event = event;
 }
+
+static int kvm_arm_pmu_set_irq(struct kvm *kvm, int irq)
+{
+	int j;
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(j, vcpu, kvm) {
+		struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+		kvm_debug("Set kvm ARM PMU irq: %d\n", irq);
+		pmu->irq_num = irq;
+		vgic_dist_irq_set_cfg(vcpu, irq, true);
+	}
+
+	return 0;
+}
+
+static int kvm_arm_pmu_create(struct kvm_device *dev, u32 type)
+{
+	int i, j;
+	struct kvm_vcpu *vcpu;
+	struct kvm *kvm = dev->kvm;
+
+	kvm_for_each_vcpu(j, vcpu, kvm) {
+		struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+		memset(pmu, 0, sizeof(*pmu));
+		for (i = 0; i < ARMV8_MAX_COUNTERS; i++) {
+			pmu->pmc[i].idx = i;
+			pmu->pmc[i].vcpu = vcpu;
+			pmu->pmc[i].bitmask = 0xffffffffUL;
+		}
+		pmu->irq_num = -1;
+	}
+
+	return 0;
+}
+
+static void kvm_arm_pmu_destroy(struct kvm_device *dev)
+{
+	kfree(dev);
+}
+
+static int kvm_arm_pmu_set_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_PMU_GRP_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int reg;
+
+		if (get_user(reg, uaddr))
+			return -EFAULT;
+
+		if (reg < VGIC_NR_SGIS || reg > dev->kvm->arch.vgic.nr_irqs)
+			return -EINVAL;
+
+		return kvm_arm_pmu_set_irq(dev->kvm, reg);
+	}
+	}
+
+	return -ENXIO;
+}
+
+static int kvm_arm_pmu_get_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	return 0;
+}
+
+static int kvm_arm_pmu_has_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_PMU_GRP_IRQ:
+		return 0;
+	}
+
+	return -ENXIO;
+}
+
+struct kvm_device_ops kvm_arm_pmu_ops = {
+	.name = "kvm-arm-pmu",
+	.create = kvm_arm_pmu_create,
+	.destroy = kvm_arm_pmu_destroy,
+	.set_attr = kvm_arm_pmu_set_attr,
+	.get_attr = kvm_arm_pmu_get_attr,
+	.has_attr = kvm_arm_pmu_has_attr,
+};
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 66c6616..8e00987 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -380,6 +380,14 @@ void vgic_dist_irq_clear_pending(struct kvm_vcpu *vcpu, int irq)
 	vgic_bitmap_set_irq_val(&dist->irq_pending, vcpu->vcpu_id, irq, 0);
 }
 
+void vgic_dist_irq_set_cfg(struct kvm_vcpu *vcpu, int irq, bool level)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+
+	vgic_bitmap_set_irq_val(&dist->irq_cfg, vcpu->vcpu_id, irq,
+				level ? VGIC_CFG_LEVEL : VGIC_CFG_EDGE);
+}
+
 static void vgic_cpu_irq_set(struct kvm_vcpu *vcpu, int irq)
 {
 	if (irq < VGIC_NR_PRIVATE_IRQS)
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index 0df74cb..eb814f5 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -49,6 +49,7 @@ u32 *vgic_bytemap_get_reg(struct vgic_bytemap *x, int cpuid, u32 offset);
 
 void vgic_dist_irq_set_pending(struct kvm_vcpu *vcpu, int irq);
 void vgic_dist_irq_clear_pending(struct kvm_vcpu *vcpu, int irq);
+void vgic_dist_irq_set_cfg(struct kvm_vcpu *vcpu, int irq, bool level);
 void vgic_cpu_irq_clear(struct kvm_vcpu *vcpu, int irq);
 void vgic_bitmap_set_irq_val(struct vgic_bitmap *x, int cpuid,
 			     int irq, int val);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8db1d93..5decfb5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2641,6 +2641,10 @@ static struct kvm_device_ops *kvm_device_ops_table[KVM_DEV_TYPE_MAX] = {
 #ifdef CONFIG_KVM_XICS
 	[KVM_DEV_TYPE_XICS]		= &kvm_xics_ops,
 #endif
+
+#ifdef CONFIG_KVM_ARM_PMU
+	[KVM_DEV_TYPE_ARM_PMU_V3]	= &kvm_arm_pmu_ops,
+#endif
 };
 
 int kvm_register_device_ops(struct kvm_device_ops *ops, u32 type)
-- 
2.0.4


