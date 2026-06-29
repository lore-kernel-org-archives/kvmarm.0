Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CEDA3BBA0D;
	Mon, 29 Jun 2026 11:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782731935; cv=none; b=dZH6z89TTrUKEXE1q4uGOyKmzmOOs1uSq9eJcce7ve75VVxFH0b+FjLp6BIthUfJQmQPiiJFsSoEpurmOemh27Kg5x6jgtz/wAYGOvre9NfilMOPlhRcqlC/ke3kUSNZ72glbrXWowj1xsle9brcN2NxsBQopZtW54C5IyMOSXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782731935; c=relaxed/simple;
	bh=hZhhpdSNOFRJJHeeJGDabDdoMt2xow3SK8tiRv/XWDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ezLEmKdWNNtM7pcxeNTUmsbNkHaThUr0vIhslFkI2GvAcdm8okC7VmXruOoeDiX+6yVhXFaJAolfqo1GhgLNFVhl3XaZ/pl6+7pCQwInAgC9MnNBWWMzO2PQ3+othFAoE6hCQm/ugcCdGuGZi26ZRWZHf6A7kMbNiCQ9kHze8jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ii6C/GP7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ii6C/GP7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 561942A31;
	Mon, 29 Jun 2026 04:18:49 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94CD13F905;
	Mon, 29 Jun 2026 04:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782731933; bh=hZhhpdSNOFRJJHeeJGDabDdoMt2xow3SK8tiRv/XWDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ii6C/GP7lLEYsb+IVxIwzWkyOTUyWojcy6Fu7g5AAkCVThFiBV6FrrpZaXmFVHQ75
	 meYCV8SB2X73ywXKYbDLRUxDD25ceGptDbUWxzQ/R1n5Aoh/2WkqeTUczcjF7LUagi
	 Mn82uJxP3cl3QU/Kf8fxRJhHO04f1zynRcMRGU9M=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	James Morse <james.morse@arm.com>,
	Zeng Heng <zengheng4@huawei.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v2 05/13] KVM: arm64: Detect (via ACPI) and initialize HACDBSIRQ
Date: Mon, 29 Jun 2026 12:17:53 +0100
Message-ID: <20260629111820.1873540-6-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629111820.1873540-1-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8768; i=leo.bras@arm.com; h=from:subject; bh=hZhhpdSNOFRJJHeeJGDabDdoMt2xow3SK8tiRv/XWDs=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLKcQhJsGA7cyfVYcDDzTMs9n8Jfv59x9N/b/eDuKxkut z3ak3XFO0pZGMS4GGTFFFlkH81fxfN9SsaRKz8WwMxhZQIZwsDFKQATEcxkZNjodWTuPLbMM1e+ W8qUXdfeY6DR9GBS2yWxXZ89l/wV1uNgZJh/8P3uS9WslzWyJizPF/25yNjVND/kZeonbQeRM79 tpDgB
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Find via ACPI [1] the Id for HACDBSIRQ, initialize it as a per-cpu IRQ
and make sure any cpu able to run virtualization has it active.

Introduce a per-cpu structure used by the HACDBSIRQ handler to keep track
of entries size and the status of HACDBS. Size is used to detect end of
processing in case the number of entries being processed is different of
the supported entries size.

Status may look easily replaceable by checking HACDBS registers now, but
will make the OFF/IDLE detection easier in next patches.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>

[1] https://github.com/tianocore/edk2/issues/12409
---
 arch/arm64/include/asm/acpi.h          |  3 +
 arch/arm64/include/asm/kvm_dirty_bit.h | 18 +++++
 include/acpi/actbl2.h                  |  1 +
 arch/arm64/kvm/arm.c                   |  5 ++
 arch/arm64/kvm/dirty_bit.c             | 97 ++++++++++++++++++++++++++
 5 files changed, 124 insertions(+)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 8a54ca6ba602..883315e9d79d 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -38,20 +38,23 @@
 
 #define BAD_MADT_GICC_ENTRY(entry, end)					\
 	(!(entry) || (entry)->header.length < ACPI_MADT_GICC_MIN_LENGTH || \
 	(unsigned long)(entry) + (entry)->header.length > (end))
 
 #define ACPI_MADT_GICC_SPE  (offsetof(struct acpi_madt_generic_interrupt, \
 	spe_interrupt) + sizeof(u16))
 
 #define ACPI_MADT_GICC_TRBE  (offsetof(struct acpi_madt_generic_interrupt, \
 	trbe_interrupt) + sizeof(u16))
+
+#define ACPI_MADT_GICC_HACDBSIRQ  (offsetof(struct acpi_madt_generic_interrupt, \
+	hacdbsirq_gsi) + sizeof(u32))
 /*
  * Arm® Functional Fixed Hardware Specification Version 1.2.
  * Table 2: Arm Architecture context loss flags
  */
 #define CPUIDLE_CORE_CTXT		BIT(0) /* Core context Lost */
 
 static inline unsigned int arch_get_idle_state_flags(u32 arch_flags)
 {
 	if (arch_flags & CPUIDLE_CORE_CTXT)
 		return CPUIDLE_FLAG_TIMER_STOP;
diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
index dd16438f0651..904e59f95b7e 100644
--- a/arch/arm64/include/asm/kvm_dirty_bit.h
+++ b/arch/arm64/include/asm/kvm_dirty_bit.h
@@ -2,11 +2,29 @@
 /*
  * Copyright (C) 2026 ARM Ltd.
  * Author: Leonardo Bras <leo.bras@arm.com>
  */
 
 #ifndef __ARM64_KVM_DIRTY_BIT_H__
 #define __ARM64_KVM_DIRTY_BIT_H__
 
 #include <asm/kvm_pgtable.h>
 
+enum hacdbs_status {
+	HACDBS_OFF,
+	HACDBS_IDLE,
+	HACDBS_RUNNING,
+	HACDBS_ERROR
+};
+
+struct hacdbs {
+	enum hacdbs_status status;
+	int size;
+};
+
+DECLARE_PER_CPU(struct hacdbs, hacdbs_pcp);
+
+void __init kvm_hacdbs_init(void);
+void kvm_hacdbs_cpu_up(void);
+void kvm_hacdbs_cpu_down(void);
+
 #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index baef525367b5..eaefb494ef59 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -1442,20 +1442,21 @@ struct acpi_madt_generic_interrupt {
 	u64 gich_base_address;
 	u32 vgic_interrupt;
 	u64 gicr_base_address;
 	u64 arm_mpidr;
 	u8 efficiency_class;
 	u8 reserved2[1];
 	u16 spe_interrupt;	/* ACPI 6.3 */
 	u16 trbe_interrupt;	/* ACPI 6.5 */
 	u16 iaffid;		/* ACPI 6.7 */
 	u32 irs_id;
+	u32 hacdbsirq_gsi;	/* ACPI 6.X */
 };
 
 /* Masks for Flags field above */
 
 /* ACPI_MADT_ENABLED                    (1)      Processor is usable if set */
 #define ACPI_MADT_PERFORMANCE_IRQ_MODE  (1<<1)	/* 01: Performance Interrupt Mode */
 #define ACPI_MADT_VGIC_IRQ_MODE         (1<<2)	/* 02: VGIC Maintenance Interrupt mode */
 #define ACPI_MADT_GICC_ONLINE_CAPABLE   (1<<3)	/* 03: Processor is online capable  */
 #define ACPI_MADT_GICC_NON_COHERENT     (1<<4)	/* 04: GIC redistributor is not coherent */
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..dc1a4629aaeb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -35,20 +35,21 @@
 #include <asm/cpufeature.h>
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_ptrauth.h>
+#include <asm/kvm_dirty_bit.h>
 #include <asm/sections.h>
 #include <asm/stacktrace/nvhe.h>
 
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
 #include <kvm/arm_vgic.h>
 
 #include <linux/irqchip/arm-gic-v5.h>
 
@@ -2300,28 +2301,30 @@ int kvm_arch_enable_virtualization_cpu(void)
 	 * disabled, but not with preemption disabled. The former is
 	 * enough to ensure correctness, but most of the helpers
 	 * expect the later and will throw a tantrum otherwise.
 	 */
 	preempt_disable();
 
 	cpu_hyp_init(NULL);
 
 	kvm_vgic_cpu_up();
 	kvm_timer_cpu_up();
+	kvm_hacdbs_cpu_up();
 
 	preempt_enable();
 
 	return 0;
 }
 
 void kvm_arch_disable_virtualization_cpu(void)
 {
+	kvm_hacdbs_cpu_down();
 	kvm_timer_cpu_down();
 	kvm_vgic_cpu_down();
 
 	if (!is_protected_kvm_enabled())
 		cpu_hyp_uninit(NULL);
 }
 
 #ifdef CONFIG_CPU_PM
 static int hyp_init_cpu_pm_notifier(struct notifier_block *self,
 				    unsigned long cmd,
@@ -2474,20 +2477,22 @@ static int __init init_subsystems(void)
 		goto out;
 	}
 
 	/*
 	 * Init HYP architected timer support
 	 */
 	err = kvm_timer_hyp_init(vgic_present);
 	if (err)
 		goto out;
 
+	kvm_hacdbs_init();
+
 	kvm_register_perf_callbacks();
 
 	err = kvm_hyp_trace_init();
 	if (err)
 		kvm_err("Failed to initialize Hyp tracing\n");
 
 out:
 	if (err)
 		hyp_cpu_pm_exit();
 
diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
index 32fe938d6bf7..789da8712b1b 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -1,16 +1,113 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2026 ARM Ltd.
  * Author: Leonardo Bras <leo.bras@arm.com>
  */
 
 #include <asm/kvm_dirty_bit.h>
+#include <linux/kconfig.h>
+#include <linux/acpi.h>
+
+DEFINE_PER_CPU(struct hacdbs, hacdbs_pcp) = {
+	.status = HACDBS_OFF,
+	.size = 0,
+};
 
 /* HDBSS entry field definitions */
 #define HDBSS_ENTRY_VALID BIT(0)
 #define HDBSS_ENTRY_TTWL_SHIFT (1)
 #define HDBSS_ENTRY_TTWL_MASK (GENMASK(3, 1))
 #define HDBSS_ENTRY_TTWL(x) \
 	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
 #define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
 #define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
+
+static __ro_after_init int hacdbsirq = -1;
+
+static irqreturn_t hacdbsirq_handler(int irq, void *pcpu)
+{
+	u64 cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
+	unsigned long err = FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons);
+
+	switch (err) {
+	case HACDBSCONS_EL2_ERR_REASON_NOF:
+		this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
+		break;
+	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
+		/* When size not a power of two >= 4k, exit with reserved TTLW */
+		int index = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
+
+		if (index >= this_cpu_read(hacdbs_pcp.size)) {
+			this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
+			break;
+		}
+		fallthrough;
+	case HACDBSCONS_EL2_ERR_REASON_STRUCTF:
+	case HACDBSCONS_EL2_ERR_REASON_IPAF:
+		this_cpu_write(hacdbs_pcp.status, HACDBS_ERROR);
+		break;
+	}
+
+	return IRQ_HANDLED;
+}
+
+void kvm_hacdbs_cpu_up(void)
+{
+	if (hacdbsirq < 0)
+		return;
+
+	enable_percpu_irq(hacdbsirq, IRQ_TYPE_LEVEL_HIGH);
+	this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
+}
+
+void kvm_hacdbs_cpu_down(void)
+{
+	if (hacdbsirq < 0)
+		return;
+
+	disable_percpu_irq(hacdbsirq);
+	this_cpu_write(hacdbs_pcp.status, HACDBS_OFF);
+}
+
+#ifdef CONFIG_ACPI
+static int __init hacdbs_acpi_get_irq(void)
+{
+	struct acpi_madt_generic_interrupt *gicc;
+	u32 gsi;
+	int irq;
+
+	gicc = acpi_cpu_get_madt_gicc(smp_processor_id());
+	if (gicc->header.length < ACPI_MADT_GICC_HACDBSIRQ)
+		return -ENXIO;
+
+	gsi =  gicc->hacdbsirq_gsi;
+
+	irq = acpi_register_gsi(NULL, gsi, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_HIGH);
+	if (irq < 0) {
+		pr_warn("ACPI: Unable to register HACDBS interrupt: %d\n", gsi);
+		return -ENXIO;
+	}
+
+	return irq;
+}
+#else
+#define hacdbs_acpi_get_irq() (-ENXIO)
+#endif
+
+void __init kvm_hacdbs_init(void)
+{
+	int irq;
+
+	/* FEAT_HACDBS is only supported if Linux runs in EL2 (VHE) */
+	if (!system_supports_hacdbs() || !is_kernel_in_hyp_mode())
+		return;
+
+	irq = hacdbs_acpi_get_irq();
+	if (irq < 0)
+		return;
+
+	if (request_percpu_irq(irq, hacdbsirq_handler, "HACDBSIRQ", &hacdbs_pcp) < 0)
+		return;
+
+	hacdbsirq = irq;
+}
-- 
2.54.0

