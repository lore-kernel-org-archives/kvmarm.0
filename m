From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 04/13] arm64: KVM: define SPE data structure for each vcpu
Date: Thu, 28 Feb 2019 16:07:26 +0000
Message-ID: <20190228160737.3323-5-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 941AA4A3B0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qlK7YM78S1vj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:08 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDBDB4A46E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:07 -0500 (EST)
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

In order to support virtual SPE for guest, so define some basic structs.
This features depends on host having hardware with SPE support.

Since we can support this only on ARM64, add a separate config symbol
for the same.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/Kconfig            |  7 +++++++
 include/kvm/arm_spe.h             | 18 ++++++++++++++++++
 3 files changed, 27 insertions(+)
 create mode 100644 include/kvm/arm_spe.h

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index da3fc7324d68..6714d6a0ef1e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -40,6 +40,7 @@
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
 #include <kvm/arm_pmu.h>
+#include <kvm/arm_spe.h>
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
@@ -266,6 +267,7 @@ struct kvm_vcpu_arch {
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
 	struct kvm_pmu pmu;
+	struct kvm_spe spe;
 
 	/*
 	 * Anything that is not used directly from assembly code goes
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index a3f85624313e..c51b125ed63f 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -34,6 +34,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_PMU if HW_PERF_EVENTS
+	select KVM_ARM_SPE if (HW_PERF_EVENTS && ARM_SPE_PMU)
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
@@ -58,6 +59,12 @@ config KVM_ARM_PMU
 	  Adds support for a virtual Performance Monitoring Unit (PMU) in
 	  virtual machines.
 
+config KVM_ARM_SPE
+	bool
+	---help---
+	  Adds support for a virtual Statistical Profiling Extension(SPE) in
+	  virtual machines.
+
 config KVM_INDIRECT_VECTORS
        def_bool KVM && (HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS)
 
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
new file mode 100644
index 000000000000..8c96bdfad6ac
--- /dev/null
+++ b/include/kvm/arm_spe.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018 ARM Ltd.
+ */
+
+#ifndef __ASM_ARM_KVM_SPE_H
+#define __ASM_ARM_KVM_SPE_H
+
+#include <uapi/linux/kvm.h>
+#include <linux/kvm_host.h>
+
+struct kvm_spe {
+	int irq;
+	bool ready; /* indicates that SPE KVM instance is ready for use */
+	bool created; /* SPE KVM instance is created, may not be ready yet */
+};
+
+#endif /* __ASM_ARM_KVM_SPE_H */
-- 
2.17.1
