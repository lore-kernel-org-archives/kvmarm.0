From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v8 20/20] KVM: ARM64: Add a new kvm ARM PMU device
Date: Tue, 22 Dec 2015 16:08:15 +0800
Message-ID: <1450771695-11948-21-git-send-email-zhaoshenglong@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F60E411BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 03:09:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qIVQHEL7y5L2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2015 03:09:34 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 862EF410B5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 03:09:31 -0500 (EST)
In-Reply-To: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Add a new kvm device type KVM_DEV_TYPE_ARM_PMU_V3 for ARM PMU. Implement
the kvm_device_ops for it.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-pmu.txt |  24 +++++
 arch/arm64/include/uapi/asm/kvm.h             |   4 +
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 virt/kvm/arm/pmu.c                            | 128 ++++++++++++++++++++++++++
 virt/kvm/kvm_main.c                           |   4 +
 6 files changed, 163 insertions(+)
 create mode 100644 Documentation/virtual/kvm/devices/arm-pmu.txt

diff --git a/Documentation/virtual/kvm/devices/arm-pmu.txt b/Documentation/virtual/kvm/devices/arm-pmu.txt
new file mode 100644
index 0000000..dda864e
--- /dev/null
+++ b/Documentation/virtual/kvm/devices/arm-pmu.txt
@@ -0,0 +1,24 @@
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
+    The attr field of kvm_device_attr encodes one value:
+    bits:     | 63 .... 32 | 31 ....  0 |
+    values:   |  reserved  | vcpu_index |
+    A value describing the PMU overflow interrupt number for the specified
+    vcpu_index vcpu. This interrupt could be a PPI or SPI, but for one VM the
+    interrupt type must be same for each vcpu. As a PPI, the interrupt number is
+    same for all vcpus, while as a SPI it must be different for each vcpu.
+
+  Errors:
+    -ENXIO: Unsupported attribute group
+    -EBUSY: The PMU overflow interrupt is already set
+    -ENODEV: Getting the PMU overflow interrupt number while it's not set
+    -EINVAL: Invalid vcpu_index or PMU overflow interrupt number supplied
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 2d4ca4b..cbb9022 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -204,6 +204,10 @@ struct kvm_arch_memory_slot {
 #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
 #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
 
+/* Device Control API: ARM PMU */
+#define KVM_DEV_ARM_PMU_GRP_IRQ		0
+#define   KVM_DEV_ARM_PMU_CPUID_MASK	0xffffffffULL
+
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
 #define KVM_ARM_IRQ_TYPE_MASK		0xff
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c923350..608dea6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1161,6 +1161,7 @@ extern struct kvm_device_ops kvm_mpic_ops;
 extern struct kvm_device_ops kvm_xics_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
+extern struct kvm_device_ops kvm_arm_pmu_ops;
 
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 03f3618..4ba6fdd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1032,6 +1032,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_FLIC		KVM_DEV_TYPE_FLIC
 	KVM_DEV_TYPE_ARM_VGIC_V3,
 #define KVM_DEV_TYPE_ARM_VGIC_V3	KVM_DEV_TYPE_ARM_VGIC_V3
+	KVM_DEV_TYPE_ARM_PMU_V3,
+#define	KVM_DEV_TYPE_ARM_PMU_V3		KVM_DEV_TYPE_ARM_PMU_V3
 	KVM_DEV_TYPE_MAX,
 };
 
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 3ec3cdd..5518308 100644
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
@@ -374,3 +375,130 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 
 	pmc->perf_event = event;
 }
+
+static inline bool kvm_arm_pmu_initialized(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.pmu.irq_num != -1;
+}
+
+static int kvm_arm_pmu_irq_access(struct kvm *kvm, struct kvm_device_attr *attr,
+				  int *irq, bool is_set)
+{
+	int cpuid;
+	struct kvm_vcpu *vcpu;
+	struct kvm_pmu *pmu;
+
+	cpuid = attr->attr & KVM_DEV_ARM_PMU_CPUID_MASK;
+	if (cpuid >= atomic_read(&kvm->online_vcpus))
+		return -EINVAL;
+
+	vcpu = kvm_get_vcpu(kvm, cpuid);
+	if (!vcpu)
+		return -EINVAL;
+
+	pmu = &vcpu->arch.pmu;
+	if (!is_set) {
+		if (!kvm_arm_pmu_initialized(vcpu))
+			return -ENODEV;
+
+		*irq = pmu->irq_num;
+	} else {
+		if (kvm_arm_pmu_initialized(vcpu))
+			return -EBUSY;
+
+		kvm_debug("Set kvm ARM PMU irq: %d\n", *irq);
+		pmu->irq_num = *irq;
+	}
+
+	return 0;
+}
+
+static int kvm_arm_pmu_create(struct kvm_device *dev, u32 type)
+{
+	int i;
+	struct kvm_vcpu *vcpu;
+	struct kvm *kvm = dev->kvm;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+		memset(pmu, 0, sizeof(*pmu));
+		kvm_pmu_vcpu_reset(vcpu);
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
+		/*
+		 * The PMU overflow interrupt could be a PPI or SPI, but for one
+		 * VM the interrupt type must be same for each vcpu. As a PPI,
+		 * the interrupt number is same for all vcpus, while as a SPI it
+		 * must be different for each vcpu.
+		 */
+		if (reg < VGIC_NR_SGIS || reg >= dev->kvm->arch.vgic.nr_irqs)
+			return -EINVAL;
+
+		return kvm_arm_pmu_irq_access(dev->kvm, attr, &reg, true);
+	}
+	}
+
+	return -ENXIO;
+}
+
+static int kvm_arm_pmu_get_attr(struct kvm_device *dev,
+				struct kvm_device_attr *attr)
+{
+	int ret;
+
+	switch (attr->group) {
+	case KVM_DEV_ARM_PMU_GRP_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int reg = -1;
+
+
+		ret = kvm_arm_pmu_irq_access(dev->kvm, attr, &reg, false);
+		if (ret)
+			return ret;
+		return put_user(reg, uaddr);
+	}
+	}
+
+	return -ENXIO;
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
index 484079e..81a42cc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2647,6 +2647,10 @@ static struct kvm_device_ops *kvm_device_ops_table[KVM_DEV_TYPE_MAX] = {
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
