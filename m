From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v3 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Thu, 24 Sep 2015 15:31:25 -0700
Message-ID: <1443133885-3366-21-git-send-email-shannon.zhao@linaro.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a new kvm device type KVM_DEV_TYPE_ARM_PMU_V3 for ARM PMU. Implement
the kvm_device_ops for it.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-pmu.txt | 15 +++++
 arch/arm64/include/uapi/asm/kvm.h             |  3 +
 include/linux/kvm_host.h                      |  1 +
 include/uapi/linux/kvm.h                      |  2 +
 virt/kvm/arm/pmu.c                            | 88 +++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                           |  4 ++
 6 files changed, 113 insertions(+)
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
index 00ef0b4..0aa4bc1 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -19,6 +19,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/uaccess.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_vgic.h>
@@ -324,3 +325,90 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 	}
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a25a731..028bd54 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2639,6 +2639,10 @@ static struct kvm_device_ops *kvm_device_ops_table[KVM_DEV_TYPE_MAX] = {
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
2.1.4

