From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [KVMTOOL PATCH 15/15] kvm: add a vcpu feature for SPEv1 support
Date: Thu, 28 Feb 2019 16:07:37 +0000
Message-ID: <20190228160737.3323-16-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72D214A46D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FuDu8kFNhK83 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:26 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95CF84A48E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:25 -0500 (EST)
In-Reply-To: <20190228160737.3323-1-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This is a runtime configurable for KVM tool to enable Statistical
Profiling Extensions version 1 support in guest kernel. A command line
option --spe is required to use the same.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 Makefile                                  |  2 +-
 arm/aarch64/arm-cpu.c                     |  2 +
 arm/aarch64/include/asm/kvm.h             |  4 ++
 arm/aarch64/include/kvm/kvm-config-arch.h |  2 +
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |  3 +-
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/include/arm-common/spe.h              |  4 ++
 arm/spe.c                                 | 81 +++++++++++++++++++++++
 include/linux/kvm.h                       |  1 +
 9 files changed, 98 insertions(+), 2 deletions(-)
 create mode 100644 arm/include/arm-common/spe.h
 create mode 100644 arm/spe.c

diff --git a/Makefile b/Makefile
index a71efb664c87..828b14ec6e08 100644
--- a/Makefile
+++ b/Makefile
@@ -155,7 +155,7 @@ endif
 # ARM
 OBJS_ARM_COMMON		:= arm/fdt.o arm/gic.o arm/gicv2m.o arm/ioport.o \
 			   arm/kvm.o arm/kvm-cpu.o arm/pci.o arm/timer.o \
-			   arm/pmu.o
+			   arm/pmu.o arm/spe.o
 HDRS_ARM_COMMON		:= arm/include
 ifeq ($(ARCH), arm)
 	DEFINES		+= -DCONFIG_ARM
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index d7572b7790b1..6ccea033f361 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -6,6 +6,7 @@
 #include "arm-common/gic.h"
 #include "arm-common/timer.h"
 #include "arm-common/pmu.h"
+#include "arm-common/spe.h"
 
 #include <linux/byteorder.h>
 #include <linux/types.h>
@@ -17,6 +18,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 	pmu__generate_fdt_nodes(fdt, kvm);
+	spe__generate_fdt_nodes(fdt, kvm);
 }
 
 static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 97c3478ee6e7..152f8b9d8c1a 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -102,6 +102,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
+#define KVM_ARM_VCPU_SPE_V1		4 /* Support guest SPEv1 */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -263,6 +264,9 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define KVM_ARM_VCPU_SPE_V1_CTRL	2
+#define   KVM_ARM_VCPU_SPE_V1_IRQ	0
+#define   KVM_ARM_VCPU_SPE_V1_INIT	1
 
 /* KVM_IRQ_LINE irq field index values */
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43dfa9b2..9968e1666de5 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -6,6 +6,8 @@
 			"Run AArch32 guest"),				\
 	OPT_BOOLEAN('\0', "pmu", &(cfg)->has_pmuv3,			\
 			"Create PMUv3 device"),				\
+	OPT_BOOLEAN('\0', "spe", &(cfg)->has_spev1,			\
+			"Create SPEv1 device"),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
 			"Layout Randomization (KASLR)"),
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index a9d8563382c6..5abaf9505274 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -8,7 +8,8 @@
 #define ARM_VCPU_FEATURE_FLAGS(kvm, cpuid)	{				\
 	[0] = ((!!(cpuid) << KVM_ARM_VCPU_POWER_OFF) |				\
 	       (!!(kvm)->cfg.arch.aarch32_guest << KVM_ARM_VCPU_EL1_32BIT) |	\
-	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3))		\
+	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3) |		\
+	       (!!(kvm)->cfg.arch.has_spev1 << KVM_ARM_VCPU_SPE_V1))		\
 }
 
 #define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 6a196f1852de..2147fc4d04ee 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -9,6 +9,7 @@ struct kvm_config_arch {
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
 	bool		has_pmuv3;
+	bool		has_spev1;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 };
diff --git a/arm/include/arm-common/spe.h b/arm/include/arm-common/spe.h
new file mode 100644
index 000000000000..bcfa40877f6f
--- /dev/null
+++ b/arm/include/arm-common/spe.h
@@ -0,0 +1,4 @@
+
+#define KVM_ARM_SPEV1_PPI			21
+
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm);
diff --git a/arm/spe.c b/arm/spe.c
new file mode 100644
index 000000000000..ec03b01a3866
--- /dev/null
+++ b/arm/spe.c
@@ -0,0 +1,81 @@
+#include "kvm/fdt.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/util.h"
+
+#include "arm-common/gic.h"
+#include "arm-common/spe.h"
+
+#ifdef CONFIG_ARM64
+static int set_spe_attr(struct kvm *kvm, int vcpu_idx,
+			struct kvm_device_attr *attr)
+{
+	int ret, fd;
+
+	fd = kvm->cpus[vcpu_idx]->vcpu_fd;
+
+	ret = ioctl(fd, KVM_HAS_DEVICE_ATTR, attr);
+	if (!ret) {
+		ret = ioctl(fd, KVM_SET_DEVICE_ATTR, attr);
+		if (ret)
+			pr_err("SPE KVM_SET_DEVICE_ATTR failed (%d)\n", ret);
+	} else {
+		pr_err("Unsupported SPE on vcpu%d\n", vcpu_idx);
+	}
+
+	return ret;
+}
+
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm)
+{
+	const char compatible[] = "arm,statistical-profiling-extension-v1";
+	int irq = KVM_ARM_SPEV1_PPI;
+	int i, ret;
+
+	u32 cpu_mask = (((1 << kvm->nrcpus) - 1) << GIC_FDT_IRQ_PPI_CPU_SHIFT) \
+		       & GIC_FDT_IRQ_PPI_CPU_MASK;
+	u32 irq_prop[] = {
+		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
+		cpu_to_fdt32(irq - 16),
+		cpu_to_fdt32(cpu_mask | IRQ_TYPE_LEVEL_HIGH),
+	};
+
+	if (!kvm->cfg.arch.has_spev1)
+		return;
+
+	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_SPE_V1)) {
+		pr_info("SPE unsupported\n");
+		return;
+	}
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_device_attr spe_attr;
+
+		spe_attr = (struct kvm_device_attr){
+			.group	= KVM_ARM_VCPU_SPE_V1_CTRL,
+			.addr	= (u64)(unsigned long)&irq,
+			.attr	= KVM_ARM_VCPU_SPE_V1_IRQ,
+		};
+
+		ret = set_spe_attr(kvm, i, &spe_attr);
+		if (ret)
+			return;
+
+		spe_attr = (struct kvm_device_attr){
+			.group	= KVM_ARM_VCPU_SPE_V1_CTRL,
+			.attr	= KVM_ARM_VCPU_SPE_V1_INIT,
+		};
+
+		ret = set_spe_attr(kvm, i, &spe_attr);
+		if (ret)
+			return;
+	}
+
+	_FDT(fdt_begin_node(fdt, "spe"));
+	_FDT(fdt_property(fdt, "compatible", compatible, sizeof(compatible)));
+	_FDT(fdt_property(fdt, "interrupts", irq_prop, sizeof(irq_prop)));
+	_FDT(fdt_end_node(fdt));
+}
+#else
+void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm) { }
+#endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 6d4ea4b6c922..83e8a25cbb14 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -988,6 +988,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_VM_IPA_SIZE 165
 #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
 #define KVM_CAP_HYPERV_CPUID 167
+#define KVM_CAP_ARM_SPE_V1 168
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.17.1
