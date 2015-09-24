From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v3 02/20] KVM: ARM64: Define PMU data structure for each vcpu
Date: Thu, 24 Sep 2015 15:31:07 -0700
Message-ID: <1443133885-3366-3-git-send-email-shannon.zhao@linaro.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Here we plan to support virtual PMU for guest by full software
emulation, so define some basic structs and functions preparing for
futher steps. Define struct kvm_pmc for performance monitor counter and
struct kvm_pmu for performance monitor unit for each vcpu. According to
ARMv8 spec, the PMU contains at most 32(ARMV8_MAX_COUNTERS) counters.

Since this only supports ARM64 (or PMUv3), add a separate config symbol
for it.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/Kconfig            |  8 ++++++++
 include/kvm/arm_pmu.h             | 40 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+)
 create mode 100644 include/kvm/arm_pmu.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 415938d..6a246a3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -42,6 +42,7 @@
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
+#include <kvm/arm_pmu.h>
 
 #define KVM_VCPU_MAX_FEATURES 3
 
@@ -135,6 +136,7 @@ struct kvm_vcpu_arch {
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
+	struct kvm_pmu pmu;
 
 	/*
 	 * Anything that is not used directly from assembly code goes
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index bfffe8f..3c7c58d 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -31,6 +31,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select KVM_ARM_PMU
 	---help---
 	  Support hosting virtualized guest machines.
 
@@ -52,4 +53,11 @@ config KVM_ARM_MAX_VCPUS
 	  large, so only choose a reasonable number that you expect to
 	  actually use.
 
+config KVM_ARM_PMU
+	bool
+	depends on KVM_ARM_HOST
+	---help---
+	  Adds support for a virtual Performance Monitoring Unit (PMU) in
+	  virtual machines.
+
 endif # VIRTUALIZATION
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
new file mode 100644
index 0000000..bb0cd21
--- /dev/null
+++ b/include/kvm/arm_pmu.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2015 Linaro Ltd.
+ * Author: Shannon Zhao <shannon.zhao@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __ASM_ARM_KVM_PMU_H
+#define __ASM_ARM_KVM_PMU_H
+
+#include <linux/perf_event.h>
+#include <asm/pmu.h>
+
+struct kvm_pmc {
+	u8 idx;/* index into the pmu->pmc array */
+	struct perf_event *perf_event;
+	struct kvm_vcpu *vcpu;
+};
+
+struct kvm_pmu {
+#ifdef CONFIG_KVM_ARM_PMU
+	/* PMU IRQ Number per VCPU */
+	int irq_num;
+	/* IRQ pending flag */
+	bool irq_pending;
+	struct kvm_pmc pmc[ARMV8_MAX_COUNTERS];
+#endif
+};
+
+#endif
-- 
2.1.4

