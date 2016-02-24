From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v13 02/20] KVM: ARM64: Define PMU data structure for each vcpu
Date: Wed, 24 Feb 2016 13:08:22 +0800
Message-ID: <1456290520-10012-3-git-send-email-zhaoshenglong@huawei.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF449412DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QxGKTQpv9osS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 00:03:32 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 62A7B412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:31 -0500 (EST)
In-Reply-To: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
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

Here we plan to support virtual PMU for guest by full software
emulation, so define some basic structs and functions preparing for
futher steps. Define struct kvm_pmc for performance monitor counter and
struct kvm_pmu for performance monitor unit for each vcpu. According to
ARMv8 spec, the PMU contains at most 32(ARMV8_PMU_MAX_COUNTERS)
counters.

Since this only supports ARM64 (or PMUv3), add a separate config symbol
for it.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/Kconfig            |  7 +++++++
 include/kvm/arm_pmu.h             | 42 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)
 create mode 100644 include/kvm/arm_pmu.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 689d4c9..6f0241f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -36,6 +36,7 @@
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
+#include <kvm/arm_pmu.h>
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
@@ -211,6 +212,7 @@ struct kvm_vcpu_arch {
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
+	struct kvm_pmu pmu;
 
 	/*
 	 * Anything that is not used directly from assembly code goes
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a5272c0..de7450d 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -36,6 +36,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_VGIC_V3
+	select KVM_ARM_PMU if HW_PERF_EVENTS
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
@@ -48,6 +49,12 @@ config KVM_ARM_HOST
 	---help---
 	  Provides host support for ARM processors.
 
+config KVM_ARM_PMU
+	bool
+	---help---
+	  Adds support for a virtual Performance Monitoring Unit (PMU) in
+	  virtual machines.
+
 source drivers/vhost/Kconfig
 
 endif # VIRTUALIZATION
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
new file mode 100644
index 0000000..3c2fd56
--- /dev/null
+++ b/include/kvm/arm_pmu.h
@@ -0,0 +1,42 @@
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
+#ifdef CONFIG_KVM_ARM_PMU
+
+#include <linux/perf_event.h>
+#include <asm/perf_event.h>
+
+struct kvm_pmc {
+	u8 idx;	/* index into the pmu->pmc array */
+	struct perf_event *perf_event;
+	u64 bitmask;
+};
+
+struct kvm_pmu {
+	int irq_num;
+	struct kvm_pmc pmc[ARMV8_PMU_MAX_COUNTERS];
+	bool ready;
+};
+#else
+struct kvm_pmu {
+};
+#endif
+
+#endif
-- 
2.0.4
