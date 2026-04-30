Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338DD40758D;
	Thu, 30 Apr 2026 11:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777547745; cv=none; b=naFU9CTED8zfElruubvswRPbGCHzb6GSxoLrtyMXXYSc0y9y629G6e3HSEESSR1wOEN2Kcz5hftv8OjfFFTuphYTb05SWSAAkbw6qMxKWBzayRTPhgB5SHs8JFH7uAGWG65bc+iWdamZLbBIwPkLNGL3K5pRivO6TGuiSKWRWeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777547745; c=relaxed/simple;
	bh=RnNmUi25WQATOqzbYmUHJ+Iu1/LzjMsiRxtUGsjdP1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MPPVI9+EXXGFFNluwVScel0167aPDVSLqzpo012xscnxw4Ox7BYmNZcD0roS2wJtDYQkDfVjk1PpQ3SHW9pwjABxyL37LLWawmIEDcazgmWVbm1OhktIsz6AMlB7J/aNhNlDWKW9TiOGnBMBm9tvERLWC2t9fgdVjeWfZA4zOlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Q2fZJxgK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Q2fZJxgK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21BC63548;
	Thu, 30 Apr 2026 04:15:37 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2586A3F763;
	Thu, 30 Apr 2026 04:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777547742; bh=RnNmUi25WQATOqzbYmUHJ+Iu1/LzjMsiRxtUGsjdP1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2fZJxgKC25GnHizrIMLhZj3kwBhkBrD8tX9MUtFbGt/IWt6VDDhoK4ndFnTDnnr4
	 zl2ZLEnjJCPesxZXgJkfHsSutOVGwe+r5zfdHTJUvOyryLjhUM9zi3pAQeYvFUbkUp
	 ZpVe3mGYnnCVhr9y413ng7uqhrYXCsxTLlTUFxbs=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Thomas Huth <thuth@redhat.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v1 05/12] KVM: arm64: Detect (via ACPI) and initialize HACDBSIRQ
Date: Thu, 30 Apr 2026 12:14:09 +0100
Message-ID: <20260430111424.3479613-7-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430111424.3479613-2-leo.bras@arm.com>
References: <20260430111424.3479613-2-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
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
index 5c0b55e7b3e4..96b664dde9c2 100644
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
index 176cbe8baad3..aae230c33c41 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -34,20 +34,21 @@
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
 
@@ -2278,28 +2279,30 @@ int kvm_arch_enable_virtualization_cpu(void)
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
@@ -2450,20 +2453,22 @@ static int __init init_subsystems(void)
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
index 31ef35f3b72f..765ef609ff70 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -1,23 +1,120 @@
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
 
 inline u64 hdbss_get_ttwl(u64 chunk_size)
 {
 	u64 hw_lvl = ARM64_HW_PGTABLE_LEVELS(ilog2(chunk_size));
 
 	return HDBSS_ENTRY_TTWL(3 - hw_lvl);
 }
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

