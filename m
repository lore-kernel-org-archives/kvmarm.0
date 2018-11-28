From: Steven Price <steven.price@arm.com>
Subject: [PATCH 10/12] arm64: Retrieve stolen time as paravirtualized guest
Date: Wed, 28 Nov 2018 14:45:25 +0000
Message-ID: <20181128144527.44710-11-steven.price@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BB6B4A371
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JGKG8Lbx+8iq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Nov 2018 09:46:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2238B4A3A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:46 -0500 (EST)
In-Reply-To: <20181128144527.44710-1-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Enable paravirtualization features when running under a hypervisor
supporting the PV_TIME_ST hypercall.

For each (v)CPU, we ask the hypervisor for the location of a shared
page which the hypervisor will use to report stolen time to us. We set
pv_time_ops to the stolen time function which simply reads the stolen
value from the shared page for a VCPU. We guarantee single-copy
atomicity using READ_ONCE which means we can also read the stolen
time for another VCPU than the currently running one while it is
potentially being updated by the hypervisor.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kernel/Makefile |   1 +
 arch/arm64/kernel/kvm.c    | 156 +++++++++++++++++++++++++++++++++++++
 include/linux/cpuhotplug.h |   1 +
 3 files changed, 158 insertions(+)
 create mode 100644 arch/arm64/kernel/kvm.c

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 4c8b13bede80..daaed14ed7a4 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -57,6 +57,7 @@ arm64-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
 arm64-obj-$(CONFIG_CRASH_CORE)		+= crash_core.o
 arm64-obj-$(CONFIG_ARM_SDE_INTERFACE)	+= sdei.o
 arm64-obj-$(CONFIG_ARM64_SSBD)		+= ssbd.o
+arm64-obj-$(CONFIG_PARAVIRT)		+= kvm.o
 
 obj-y					+= $(arm64-obj-y) vdso/ probes/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/kvm.c b/arch/arm64/kernel/kvm.c
new file mode 100644
index 000000000000..72c9554648fc
--- /dev/null
+++ b/arch/arm64/kernel/kvm.c
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Arm Ltd.
+
+#define pr_fmt(fmt) "kvmarm-pv: " fmt
+
+#include <linux/arm-smccc.h>
+#include <linux/cpuhotplug.h>
+#include <linux/io.h>
+#include <linux/printk.h>
+#include <linux/psci.h>
+#include <linux/reboot.h>
+#include <linux/slab.h>
+
+#include <kvm/arm_pv.h>
+
+#include <asm/paravirt.h>
+#include <asm/smp_plat.h>
+
+struct kvmarm_stolen_time_region {
+	struct pvclock_vcpu_stolen_time_info *kaddr;
+};
+
+static DEFINE_PER_CPU(struct kvmarm_stolen_time_region, stolen_time_region);
+
+static bool steal_acc = true;
+static int __init parse_no_stealacc(char *arg)
+{
+	steal_acc = false;
+	return 0;
+}
+early_param("no-steal-acc", parse_no_stealacc);
+
+/* return stolen time in ns by asking the hypervisor */
+static u64 kvm_steal_clock(int cpu)
+{
+	struct kvmarm_stolen_time_region *reg;
+
+	reg = per_cpu_ptr(&stolen_time_region, cpu);
+	if (!reg->kaddr) {
+		pr_warn_once("stolen time enabled but not configued for cpu %d\n",
+			     cpu);
+		return 0;
+	}
+
+	return le64_to_cpu(READ_ONCE(reg->kaddr->stolen_time));
+}
+
+static int disable_stolen_time_current_cpu(void)
+{
+	struct kvmarm_stolen_time_region *reg;
+
+	reg = this_cpu_ptr(&stolen_time_region);
+	if (!reg->kaddr)
+		return 0;
+
+	memunmap(reg->kaddr);
+	memset(reg, 0, sizeof(*reg));
+
+	return 0;
+}
+
+static int stolen_time_dying_cpu(unsigned int cpu)
+{
+	return disable_stolen_time_current_cpu();
+}
+
+static int init_stolen_time_cpu(unsigned int cpu)
+{
+	struct kvmarm_stolen_time_region *reg;
+	int ret;
+	struct arm_smccc_res res;
+
+	reg = this_cpu_ptr(&stolen_time_region);
+
+	if (reg->kaddr)
+		return 0;
+
+	ret = arm_smccc_1_1(ARM_SMCCC_HV_PV_TIME_ST, &res);
+
+	if ((long)res.a0 < 0)
+		return -EINVAL;
+
+	reg->kaddr = memremap(res.a0,
+			sizeof(struct pvclock_vcpu_stolen_time_info),
+			MEMREMAP_WB);
+
+	if (reg->kaddr == NULL) {
+		pr_warn("Failed to map stolen time data structure\n");
+		return -EINVAL;
+	}
+
+	if (le32_to_cpu(reg->kaddr->revision) != 0 ||
+			le32_to_cpu(reg->kaddr->attributes) != 0) {
+		pr_warn("Unexpected revision or attributes in stolen time data\n");
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int kvm_arm_init_stolen_time(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state(CPUHP_AP_ARM_KVMPV_STARTING,
+				"hypervisor/kvmarm/pv:starting",
+				init_stolen_time_cpu, stolen_time_dying_cpu);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+static bool has_kvm_steal_clock(void)
+{
+	struct arm_smccc_res res;
+
+	/* To detect the presence of PV time support we require SMCCC 1.1+ */
+	if (psci_ops.smccc_version < SMCCC_VERSION_1_1)
+		return false;
+
+	arm_smccc_1_1(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+		      ARM_SMCCC_HV_PV_FEATURES, &res);
+
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return false;
+
+	arm_smccc_1_1(ARM_SMCCC_HV_PV_FEATURES, ARM_SMCCC_HV_PV_TIME_ST, &res);
+
+	if (res.a0 != SMCCC_RET_SUCCESS)
+		return false;
+
+	return true;
+}
+
+static int __init kvm_guest_init(void)
+{
+	int ret = 0;
+
+	if (!has_kvm_steal_clock())
+		return 0;
+
+	ret = kvm_arm_init_stolen_time();
+	if (ret)
+		return ret;
+
+	pv_ops.time.steal_clock = kvm_steal_clock;
+
+	static_key_slow_inc(&paravirt_steal_enabled);
+	if (steal_acc)
+		static_key_slow_inc(&paravirt_steal_rq_enabled);
+
+	pr_info("using stolen time PV\n");
+
+	return 0;
+}
+early_initcall(kvm_guest_init);
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index e0cd2baa8380..5c176a31deb8 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -134,6 +134,7 @@ enum cpuhp_state {
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
+	CPUHP_AP_ARM_KVMPV_STARTING,
 	CPUHP_AP_ARM_CORESIGHT_STARTING,
 	CPUHP_AP_ARM64_ISNDEP_STARTING,
 	CPUHP_AP_SMPCFD_DYING,
-- 
2.19.2
