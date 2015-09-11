From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 02/22] KVM: ARM64: Define PMU data structure for each vcpu
Date: Fri, 11 Sep 2015 16:54:55 +0800
Message-ID: <1441961715-11688-3-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 959BD410EB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JiZbbMgv+Lzm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:35 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03A17412FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:31 -0400 (EDT)
In-Reply-To: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

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
 arch/arm64/include/asm/pmu.h      |  2 ++
 arch/arm64/kvm/Kconfig            |  8 ++++++++
 include/kvm/arm_pmu.h             | 39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 51 insertions(+)
 create mode 100644 include/kvm/arm_pmu.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2709db2..3c88873 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -42,6 +42,7 @@
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
+#include <kvm/arm_pmu.h>
 
 #define KVM_VCPU_MAX_FEATURES 3
 
@@ -116,6 +117,7 @@ struct kvm_vcpu_arch {
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
+	struct kvm_pmu pmu;
 
 	/*
 	 * Anything that is not used directly from assembly code goes
diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
index b9f394a..95681e6 100644
--- a/arch/arm64/include/asm/pmu.h
+++ b/arch/arm64/include/asm/pmu.h
@@ -19,6 +19,8 @@
 #ifndef __ASM_PMU_H
 #define __ASM_PMU_H
 
+#include <linux/perf_event.h>
+
 #define ARMV8_MAX_COUNTERS      32
 #define ARMV8_COUNTER_MASK      (ARMV8_MAX_COUNTERS - 1)
 
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
index 0000000..64af88a
--- /dev/null
+++ b/include/kvm/arm_pmu.h
@@ -0,0 +1,39 @@
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
2.0.4
