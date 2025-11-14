Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B23A26290
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136469; cv=none; b=riwNHq0CghV09JFszAIaUbhl91p3N9ekFf1z7PW7Sj16ceIKPi+Y6mkVN76iSkqHrGhryofGDbtc6dt78dlhGyF1VHH1BKq+gv7FiYcEQV6VqpvnT/QtXjsqTn32MHFkLf0WQIwFMjHhO3WcmXD2oTYnPJhhCAjq0DU8/XyKJUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136469; c=relaxed/simple;
	bh=6ifjlGMuga3I97bLj+hRL4GQLhm1xh5nNqPSu1dlhjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/SeTNyKDXqU8YG3tM21rVaOYXOmp8RrMhENqkL7wM/1PuDVj4xtgRqaJxTU2EG4+GCT1/VY9TT5eST6x7KrxCqenquJvBTZs9Eoc9jhRlz9VFJyQo7jSyzBeZ9uvZ5FNSYp+VbXu58T0R71KR3lVh/KgzPbmSAOUvIxDVOzFTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3868819F6;
	Fri, 14 Nov 2025 08:07:39 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0A9D3F5A1;
	Fri, 14 Nov 2025 08:07:44 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 05/35] KVM: arm64: Add KVM_CAP_ARM_SPE capability
Date: Fri, 14 Nov 2025 16:06:46 +0000
Message-ID: <20251114160717.163230-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the SPE capability that will be used by userspace to test if KVM
supports SPE virtualization.

The SPE driver supports heterogenous systems. Keep track of all the
available Statistical Profiling Units (SPUs) in the system, because KVM
will require the user to associate a VM with exactly one SPU.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/api.rst   | 10 +++++++++
 arch/arm64/include/asm/kvm_spe.h | 20 +++++++++++++++++
 arch/arm64/kvm/Makefile          |  1 +
 arch/arm64/kvm/arm.c             |  5 ++++-
 arch/arm64/kvm/spe.c             | 38 ++++++++++++++++++++++++++++++++
 drivers/perf/arm_spe_pmu.c       |  2 ++
 include/linux/perf/arm_spe_pmu.h |  8 +++++++
 include/uapi/linux/kvm.h         |  1 +
 8 files changed, 84 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/kvm_spe.h
 create mode 100644 arch/arm64/kvm/spe.c

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 57061fa29e6a..10e0733297ac 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9229,6 +9229,16 @@ KVM exits with the register state of either the L1 or L2 guest
 depending on which executed at the time of an exit. Userspace must
 take care to differentiate between these cases.
 
+8.46 KVM_CAP_ARM_SPE
+--------------------
+
+:Capability: KVM_CAP_ARM_SPE
+:Architectures: arm64
+:Type: vm
+
+This capability indicates that Statistical Profiling Extension (SPE)
+virtualization is available in KVM.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
new file mode 100644
index 000000000000..6572384531e2
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_spe.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ */
+
+#ifndef __ARM64_KVM_SPE_H__
+#define __ARM64_KVM_SPE_H__
+
+#ifdef CONFIG_KVM_ARM_SPE
+DECLARE_STATIC_KEY_FALSE(kvm_spe_available);
+
+static __always_inline bool kvm_supports_spe(void)
+{
+	return static_branch_likely(&kvm_spe_available);
+}
+#else
+#define kvm_supports_spe()	false
+#endif /* CONFIG_KVM_ARM_SPE */
+
+#endif /* __ARM64_KVM_SPE_H__ */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3ebc0570345c..6ea071653c5e 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -29,6 +29,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
+kvm-$(CONFIG_KVM_ARM_SPE)     += spe.o
 
 always-y := hyp_constants.h hyp-constants.s
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 052bf0d4d0b0..ee230cb34215 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -39,6 +39,7 @@
 #include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_ptrauth.h>
+#include <asm/kvm_spe.h>
 #include <asm/sections.h>
 
 #include <kvm/arm_hypercalls.h>
@@ -419,7 +420,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		else
 			r = kvm_supports_cacheable_pfnmap();
 		break;
-
+	case KVM_CAP_ARM_SPE:
+		r = kvm_supports_spe();
+		break;
 	default:
 		r = 0;
 	}
diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
new file mode 100644
index 000000000000..cf902853750f
--- /dev/null
+++ b/arch/arm64/kvm/spe.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2021 - ARM Ltd
+ */
+
+#include <linux/cpumask.h>
+#include <linux/kvm_host.h>
+#include <linux/perf/arm_spe_pmu.h>
+
+#include <asm/kvm_spe.h>
+#include <asm/sysreg.h>
+
+DEFINE_STATIC_KEY_FALSE(kvm_spe_available);
+
+static LIST_HEAD(arm_spus);
+static DEFINE_MUTEX(arm_spus_lock);
+
+struct arm_spu_entry {
+	struct list_head link;
+	struct arm_spe_pmu *arm_spu;
+};
+
+void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
+{
+	struct arm_spu_entry *entry;
+
+	guard(mutex)(&arm_spus_lock);
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return;
+
+	entry->arm_spu = arm_spu;
+	list_add_tail(&entry->link, &arm_spus);
+
+	if (list_is_singular(&arm_spus))
+		static_branch_enable(&kvm_spe_available);
+}
diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 188ea783a569..66ae36d4d32e 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1326,6 +1326,8 @@ static int arm_spe_pmu_device_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_teardown_dev;
 
+	kvm_host_spe_init(spe_pmu);
+
 	return 0;
 
 out_teardown_dev:
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
index 86085a7559d9..8a2db0e03e45 100644
--- a/include/linux/perf/arm_spe_pmu.h
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -46,4 +46,12 @@ struct arm_spe_pmu {
 
 #define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
 
+#ifdef CONFIG_KVM_ARM_SPE
+void kvm_host_spe_init(struct arm_spe_pmu *spe_pmu);
+#else
+static inline void kvm_host_spe_init(struct arm_spe_pmu *spe_pmu)
+{
+}
+#endif /* CONFIG_KVM_ARM_SPE */
+
 #endif /* __PERF_ARM_SPE_PMU_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..11e5dbde331b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -963,6 +963,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_ARM_SPE 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.51.2

