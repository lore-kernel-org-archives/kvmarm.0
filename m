Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297B22874F5
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 11:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747912333; cv=none; b=mIrZoSbKY1KRy+qTdt5qxIZ5NQ2slhRnkT6Byxwcb58xDTA8wSAHADG9sSLtFDRJbudktfJWslwiq2glUL4Gw7Ln6KyPSIy9AVHeUYMZCRKvl8TSx4mvQtiTjW11UUH+rTHvUSA4Mcw4DDCVKhoaZLLF6de74jM2r608KqJz2GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747912333; c=relaxed/simple;
	bh=bMyrO6ghyIVUzYr6t3QbyNrn/jRVVxAFLVIrJYJ9NvU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pgifr9U4KtwrudUPB+RsHm9wU8diqLxSBNRrcxHyjn4eBJZY0t9MFN+KOuo4+93344GTg8SWcRuWZNuk+SUlrh2ReXkyGqKm3Te8eH+uDK15Yyv4GxhmSOJZFKXttT1PsbokMGCdlHWP2eNikPiJ8ApRTcQPgkw0hc612P4X8aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4b35FQ4cT3z1f0cg;
	Thu, 22 May 2025 19:11:06 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 09EC11A016C;
	Thu, 22 May 2025 19:12:01 +0800 (CST)
Received: from kwepemq200011.china.huawei.com (7.202.195.155) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 22 May 2025 19:12:00 +0800
Received: from huawei.com (10.67.174.28) by kwepemq200011.china.huawei.com
 (7.202.195.155) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 May
 2025 19:11:58 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<oliver.upton@linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <mark.rutland@arm.com>, <broonie@kernel.org>,
	<liaochang1@huawei.com>, <puranjay@kernel.org>, <sgsu.park@samsung.com>,
	<frederic@kernel.org>, <gshan@redhat.com>, <sudeep.holla@arm.com>,
	<guohanjun@huawei.com>, <ryan.roberts@arm.com>,
	<Jonathan.Cameron@huawei.com>, <liuwei09@cestc.cn>,
	<shameerali.kolothum.thodi@huawei.com>, <james.morse@arm.com>,
	<hardevsinh.palaniya@siliconsignals.io>, <ptosi@google.com>,
	<kristina.martsenko@arm.com>, <vschneid@redhat.com>,
	<thiago.bauermann@linaro.org>, <yang@os.amperecomputing.com>,
	<david@redhat.com>, <minhuadotchen@gmail.com>, <tglx@linutronix.de>,
	<farbere@amazon.com>, <arnd@arndb.de>, <rppt@kernel.org>,
	<mcgrof@kernel.org>, <guoweikang.kernel@gmail.com>, <robh@kernel.org>,
	<andreyknvl@gmail.com>, <usamaarif642@gmail.com>,
	<samuel.holland@sifive.com>, <kevin.brodsky@arm.com>, <Dave.Martin@arm.com>,
	<rmk+kernel@armlinux.org.uk>, <jean-philippe@linaro.org>,
	<ruanjinjie@huawei.com>, <dianders@chromium.org>, <pcc@google.com>,
	<bigeasy@linutronix.de>, <jintack@cs.columbia.edu>,
	<christoffer.dall@arm.com>, <tabba@google.com>, <robin.murphy@arm.com>,
	<ziy@nvidia.com>, <wangkefeng.wang@huawei.com>, <quic_zhenhuah@quicinc.com>,
	<anshuman.khandual@arm.com>, <yangyicong@hisilicon.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v5 1/2] arm64: New exception mask helpers to manage DAIF, PMR and ALLINT
Date: Thu, 22 May 2025 10:56:57 +0000
Message-ID: <20250522105658.1338331-2-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250522105658.1338331-1-liaochang1@huawei.com>
References: <20250522105658.1338331-1-liaochang1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200011.china.huawei.com (7.202.195.155)

This patch refactors the arm64 exception masking helpers to reduce
complexity without any function changes, especially with the upcoming
FEAT_NMI support [1]. Currently, managing differnt hardware contexts
(DAIF, PMR, ALLINT) within a single set of exception
mask/save/unmask/restore helpers is becoming error-prone and adds more
conditional branching overhead.

To adderss this problem, this patch introduces:

  1. Using a single 64bit integer to manage all hardware contexts
     involved in masking exceptions, maskable and non-maskable
     interrupts. Field 'pmr' stores a software generated value that will
     be written to the SYS_ICC_PMR_EL1 register when kernel uses
     PSEUDO_NMI. Field 'daif' stores the value of PSTATE.DAIF. It
     indicates any exception or interrupt is masked. Field 'allint'
     stores PSTATE.A when kernel uses PSEUDO_NMI, Alternatively, it
     stores PSTATE.ALLINT when kernel uses FEAT_NMI to indicate that
     arm64 superpriority interrupt(NMI) is masked.

  2. Instead of one complicated function trying to handle every
     situation, it now has two distinct series of specialized logical
     exception mask helpers. Each set is designed for a specific
     scenario based on how the kernel is configured.

For examples:

  - When NMI is not supported (CONFIG_ARM64_PSEUDO_NMI and
    CONFIG_ARM64_NMI [1] are not 'y'), the kernel uses the default
    daif_handler to manipulate DAIF only.

  - With PSEUDO_NMI enabled (CONFIG_ARM64_PSEUDO_NMI=y and
    irqchip.gicv3_pseudo_nmi=1), the kernel uses the pmr_handler to
    manage both PMR and DAIF for interrupt masking. The most trick part
    is masking NMI mentioned above.

  - For hardware NMI support (CONFIG_ARM64_NMI=y and pseudo_nmi
    disabled), a new cpu_exception_mask_handler could be added to manage
    DAIF and ALLINT for interrupt masking.

This changes make exception mask helpers more obvious what's happening
in each situation. And it's easier to add support for new CPU feature in
the future without adding code complexity.

With these refactor, this patch also replace the local_daif_xxx helpers
used at exception entry and exit with a series abstract exception masks
helpers.

[1] https://lore.kernel.org/linux-arm-kernel/Y4sH5qX5bK9xfEBp@lpieralisi/

Signed-off-by: Liao Chang <liaochang1@huawei.com>
CC: Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Marc Zyngier <maz@kernel.org>
CC: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/exception_mask.h | 137 ++++++++++++++++++
 arch/arm64/kernel/Makefile              |   2 +-
 arch/arm64/kernel/cpufeature.c          |   3 +
 arch/arm64/kernel/entry-common.c        |  79 +++++------
 arch/arm64/kernel/exception_mask.c      | 177 ++++++++++++++++++++++++
 5 files changed, 358 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm64/include/asm/exception_mask.h
 create mode 100644 arch/arm64/kernel/exception_mask.c

diff --git a/arch/arm64/include/asm/exception_mask.h b/arch/arm64/include/asm/exception_mask.h
new file mode 100644
index 000000000000..46e85e4ac70d
--- /dev/null
+++ b/arch/arm64/include/asm/exception_mask.h
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2025 Huawei Ltd.
+ */
+#ifndef __ASM_EXCEPTION_MASK_H
+#define __ASM_EXCEPTION_MASK_H
+
+#include <asm/ptrace.h>
+#include <asm/sysreg.h>
+
+#define DAIF_PROCCTX		0
+#define DAIF_PROCCTX_NOIRQ	(PSR_I_BIT | PSR_F_BIT)
+#define DAIF_ERRCTX		(PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+#define DAIF_MASK		(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+
+union cpu_exception_mask {
+	unsigned long flags;
+	struct {
+		unsigned long pmr : 8;		// SYS_ICC_PMR_EL1
+		unsigned long daif : 10;	// PSTATE.DAIF at bits[6-9]
+		unsigned long allint : 14;	// PSTATE.ALLINT at bits[13]
+	} fields;
+};
+
+struct cpu_exception_mask_handler {
+	void (*mask)(void);             // mask all exception and interrupt
+	unsigned long (*save)(void);    // save exception and interrupt masks
+	void (*restore)(unsigned long flags); // restore exception from given masks
+};
+
+extern const union cpu_exception_mask procctx;
+extern const union cpu_exception_mask procctx_noirq;
+extern const union cpu_exception_mask errctx;
+extern struct cpu_exception_mask_handler *cpu_exception;
+int set_exception_mask_handler(int type);
+
+/*
+ * The exception masking steps for exception entry and exit:
+ *
+ * [EL0 Sync]
+ *	el0_sync_entry_exception_mask()
+ *	...
+ *	do_resume_notify()
+ *	el0_common_exit_exception_mask()
+ *
+ * [EL0 IRQ & FIQ]
+ *	irq_common_entry_exception_mask()
+ *	...
+ *	do_resume_notify()
+ *	el0_common_exit_exception_mask()
+ *
+ * [EL0 serror]
+ *	serror_entry_exception_mask()
+ *	...
+ *	el0_serror_exit_exception_mask()
+ *	do_resume_notify()
+ *	el0_exit_common_exception_mask()
+ *
+ * [EL1 Sync]
+ *	el1_sync_entry_exception_mask()
+ *	...
+ *	el1_sync_exit_exception_mask()
+ *
+ * [EL1 IRQ & FIQ]
+ *	irq_common_entry_exception_mask()
+ *
+ * [EL1 Serror]
+ *	serror_entry_exception_mask()
+ */
+static inline void el0_sync_entry_exception_mask(void)
+{
+	cpu_exception->restore(procctx.flags);
+}
+
+static inline void irq_common_entry_exception_mask(void)
+{
+	/* only mask normal interrupts and NMIs*/
+	asm volatile ("msr daifclr, #0xc" : : : "memory");
+}
+
+static inline void serror_entry_exception_mask(void)
+{
+	cpu_exception->restore(errctx.flags);
+}
+
+static inline void el0_serror_exit_exception_mask(void)
+{
+	cpu_exception->restore(procctx.flags);
+}
+
+static inline void el0_common_exit_exception_mask(void)
+{
+	cpu_exception->mask();
+}
+
+static inline void el1_sync_entry_exception_mask(struct pt_regs *regs)
+{
+	union cpu_exception_mask mask;
+
+	mask.fields.pmr = regs->pmr;
+	mask.fields.daif = regs->pstate & DAIF_MASK;
+
+	cpu_exception->restore(mask.flags);
+}
+
+static inline void el1_sync_exit_exception_mask(void)
+{
+	cpu_exception->mask();
+}
+
+static inline unsigned long local_exception_save(void)
+{
+	unsigned long flags;
+
+	flags = cpu_exception->save();
+	cpu_exception->mask();
+
+	return flags;
+}
+
+static inline unsigned long local_exception_save_flags(void)
+{
+	return cpu_exception->save();
+}
+
+/* mask/save/unmask/restore all exceptions, including interrupts. */
+static inline void local_exception_mask(void)
+{
+	cpu_exception->mask();
+}
+
+static inline void local_exception_restore(unsigned long flags)
+{
+	cpu_exception->restore(flags);
+}
+
+#endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 71c29a2a2f19..b88c0f2af796 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -34,7 +34,7 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
 			   smp.o smp_spin_table.o topology.o smccc-call.o	\
 			   syscall.o proton-pack.o idle.o patching.o pi/	\
-			   rsi.o
+			   rsi.o exception_mask.o
 
 obj-$(CONFIG_COMPAT)			+= sys32.o signal32.o			\
 					   sys_compat.o
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9c4d6d552b25..792f599f5c4d 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -93,6 +93,7 @@
 #include <asm/traps.h>
 #include <asm/vectors.h>
 #include <asm/virt.h>
+#include <asm/exception_mask.h>
 
 /* Kernel representation of AT_HWCAP and AT_HWCAP2 */
 static DECLARE_BITMAP(elf_hwcap, MAX_CPU_FEATURES) __read_mostly;
@@ -2290,6 +2291,8 @@ static bool can_use_gic_priorities(const struct arm64_cpu_capabilities *entry,
 	if (!cpus_have_cap(ARM64_HAS_GIC_CPUIF_SYSREGS))
 		return false;
 
+	set_exception_mask_handler(enable_pseudo_nmi ? 1 : 0);
+
 	return enable_pseudo_nmi;
 }
 
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index b260ddc4d3e9..528d1bfbb5ed 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -27,6 +27,7 @@
 #include <asm/stacktrace.h>
 #include <asm/sysreg.h>
 #include <asm/system_misc.h>
+#include <asm/exception_mask.h>
 
 /*
  * Handle IRQ/context state management when entering from kernel mode.
@@ -168,7 +169,7 @@ static __always_inline void exit_to_user_mode_prepare(struct pt_regs *regs)
 	if (unlikely(flags & _TIF_WORK_MASK))
 		do_notify_resume(regs, flags);
 
-	local_daif_mask();
+	el0_common_exit_exception_mask();
 
 	lockdep_sys_exit();
 }
@@ -428,9 +429,9 @@ static void noinstr el1_abort(struct pt_regs *regs, unsigned long esr)
 	unsigned long far = read_sysreg(far_el1);
 
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	el1_sync_entry_exception_mask(regs);
 	do_mem_abort(far, esr, regs);
-	local_daif_mask();
+	el1_sync_exit_exception_mask();
 	exit_to_kernel_mode(regs);
 }
 
@@ -439,45 +440,45 @@ static void noinstr el1_pc(struct pt_regs *regs, unsigned long esr)
 	unsigned long far = read_sysreg(far_el1);
 
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	el1_sync_entry_exception_mask(regs);
 	do_sp_pc_abort(far, esr, regs);
-	local_daif_mask();
+	el1_sync_exit_exception_mask();
 	exit_to_kernel_mode(regs);
 }
 
 static void noinstr el1_undef(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	el1_sync_entry_exception_mask(regs);
 	do_el1_undef(regs, esr);
-	local_daif_mask();
+	el1_sync_exit_exception_mask();
 	exit_to_kernel_mode(regs);
 }
 
 static void noinstr el1_bti(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	el1_sync_entry_exception_mask(regs);
 	do_el1_bti(regs, esr);
-	local_daif_mask();
+	el1_sync_exit_exception_mask();
 	exit_to_kernel_mode(regs);
 }
 
 static void noinstr el1_gcs(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	el1_sync_entry_exception_mask(regs);
 	do_el1_gcs(regs, esr);
-	local_daif_mask();
+	el1_sync_exit_exception_mask();
 	exit_to_kernel_mode(regs);
 }
 
 static void noinstr el1_mops(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	el1_sync_entry_exception_mask(regs);
 	do_el1_mops(regs, esr);
-	local_daif_mask();
+	el1_sync_exit_exception_mask();
 	exit_to_kernel_mode(regs);
 }
 
@@ -494,9 +495,9 @@ static void noinstr el1_dbg(struct pt_regs *regs, unsigned long esr)
 static void noinstr el1_fpac(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	el1_sync_entry_exception_mask(regs);
 	do_el1_fpac(regs, esr);
-	local_daif_mask();
+	el1_sync_exit_exception_mask();
 	exit_to_kernel_mode(regs);
 }
 
@@ -567,7 +568,7 @@ static __always_inline void __el1_irq(struct pt_regs *regs,
 static void noinstr el1_interrupt(struct pt_regs *regs,
 				  void (*handler)(struct pt_regs *))
 {
-	write_sysreg(DAIF_PROCCTX_NOIRQ, daif);
+	irq_common_entry_exception_mask();
 
 	if (IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) && !interrupts_enabled(regs))
 		__el1_pnmi(regs, handler);
@@ -589,7 +590,7 @@ asmlinkage void noinstr el1h_64_error_handler(struct pt_regs *regs)
 {
 	unsigned long esr = read_sysreg(esr_el1);
 
-	local_daif_restore(DAIF_ERRCTX);
+	serror_entry_exception_mask();
 	arm64_enter_nmi(regs);
 	do_serror(regs, esr);
 	arm64_exit_nmi(regs);
@@ -600,7 +601,7 @@ static void noinstr el0_da(struct pt_regs *regs, unsigned long esr)
 	unsigned long far = read_sysreg(far_el1);
 
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_mem_abort(far, esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -618,7 +619,7 @@ static void noinstr el0_ia(struct pt_regs *regs, unsigned long esr)
 		arm64_apply_bp_hardening();
 
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_mem_abort(far, esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -626,7 +627,7 @@ static void noinstr el0_ia(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_fpsimd_acc(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_fpsimd_acc(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -634,7 +635,7 @@ static void noinstr el0_fpsimd_acc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_sve_acc(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_sve_acc(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -642,7 +643,7 @@ static void noinstr el0_sve_acc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_sme_acc(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_sme_acc(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -650,7 +651,7 @@ static void noinstr el0_sme_acc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_fpsimd_exc(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_fpsimd_exc(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -658,7 +659,7 @@ static void noinstr el0_fpsimd_exc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_sys(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_el0_sys(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -671,7 +672,7 @@ static void noinstr el0_pc(struct pt_regs *regs, unsigned long esr)
 		arm64_apply_bp_hardening();
 
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_sp_pc_abort(far, esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -679,7 +680,7 @@ static void noinstr el0_pc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_sp(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_sp_pc_abort(regs->sp, esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -687,7 +688,7 @@ static void noinstr el0_sp(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_undef(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_el0_undef(regs, esr);
 	exit_to_user_mode(regs);
 }
@@ -695,7 +696,7 @@ static void noinstr el0_undef(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_bti(struct pt_regs *regs)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_el0_bti(regs);
 	exit_to_user_mode(regs);
 }
@@ -703,7 +704,7 @@ static void noinstr el0_bti(struct pt_regs *regs)
 static void noinstr el0_mops(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_el0_mops(regs, esr);
 	exit_to_user_mode(regs);
 }
@@ -711,7 +712,7 @@ static void noinstr el0_mops(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_gcs(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_el0_gcs(regs, esr);
 	exit_to_user_mode(regs);
 }
@@ -719,7 +720,7 @@ static void noinstr el0_gcs(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_inv(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	bad_el0_sync(regs, 0, esr);
 	exit_to_user_mode(regs);
 }
@@ -731,7 +732,7 @@ static void noinstr el0_dbg(struct pt_regs *regs, unsigned long esr)
 
 	enter_from_user_mode(regs);
 	do_debug_exception(far, esr, regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	exit_to_user_mode(regs);
 }
 
@@ -740,7 +741,7 @@ static void noinstr el0_svc(struct pt_regs *regs)
 	enter_from_user_mode(regs);
 	cortex_a76_erratum_1463225_svc_handler();
 	fp_user_discard();
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_el0_svc(regs);
 	exit_to_user_mode(regs);
 }
@@ -748,7 +749,7 @@ static void noinstr el0_svc(struct pt_regs *regs)
 static void noinstr el0_fpac(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_el0_fpac(regs, esr);
 	exit_to_user_mode(regs);
 }
@@ -820,7 +821,7 @@ static void noinstr el0_interrupt(struct pt_regs *regs,
 {
 	enter_from_user_mode(regs);
 
-	write_sysreg(DAIF_PROCCTX_NOIRQ, daif);
+	irq_common_entry_exception_mask();
 
 	if (regs->pc & BIT(55))
 		arm64_apply_bp_hardening();
@@ -857,11 +858,11 @@ static void noinstr __el0_error_handler_common(struct pt_regs *regs)
 	unsigned long esr = read_sysreg(esr_el1);
 
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_ERRCTX);
+	serror_entry_exception_mask();
 	arm64_enter_nmi(regs);
 	do_serror(regs, esr);
 	arm64_exit_nmi(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_serror_exit_exception_mask();
 	exit_to_user_mode(regs);
 }
 
@@ -874,7 +875,7 @@ asmlinkage void noinstr el0t_64_error_handler(struct pt_regs *regs)
 static void noinstr el0_cp15(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_el0_cp15(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -883,7 +884,7 @@ static void noinstr el0_svc_compat(struct pt_regs *regs)
 {
 	enter_from_user_mode(regs);
 	cortex_a76_erratum_1463225_svc_handler();
-	local_daif_restore(DAIF_PROCCTX);
+	el0_sync_entry_exception_mask();
 	do_el0_svc_compat(regs);
 	exit_to_user_mode(regs);
 }
diff --git a/arch/arm64/kernel/exception_mask.c b/arch/arm64/kernel/exception_mask.c
new file mode 100644
index 000000000000..b0f1ec71ba0e
--- /dev/null
+++ b/arch/arm64/kernel/exception_mask.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Exception masking code for DAIF, PMR and ALLINT.
+ *
+ * Copyright (C) 2025 Huawei Ltd.
+ */
+#include <linux/irqflags.h>
+
+#include <asm/arch_gicv3.h>
+#include <asm/barrier.h>
+#include <asm/cpufeature.h>
+#include <asm/ptrace.h>
+#include <asm/exception_mask.h>
+
+/* unmask all interrupts including interrupts */
+const union cpu_exception_mask procctx = {
+	.fields.daif = 0,
+	.fields.pmr = GIC_PRIO_IRQON,
+	.fields.allint = 0,
+};
+
+/* only mask normal interrupts */
+const union cpu_exception_mask procctx_noirq = {
+	.fields.daif = DAIF_PROCCTX_NOIRQ,
+	.fields.pmr = GIC_PRIO_IRQOFF,
+	.fields.allint = 0,
+};
+
+/* mask all interrupts including NMI and Serror */
+const union cpu_exception_mask errctx = {
+	.fields.daif = DAIF_ERRCTX,
+	.fields.pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET,
+	.fields.allint = 1,
+};
+
+static void daif_exception_mask(void)
+{
+	asm volatile(
+		"msr	daifset, #0xf\n"
+		:
+		:
+		: "memory");
+
+	trace_hardirqs_off();
+}
+
+static unsigned long daif_exception_save(void)
+{
+	return read_sysreg(daif);
+}
+
+static void daif_exception_restore(unsigned long flags)
+{
+	union cpu_exception_mask mask = { .flags = flags };
+	bool irq_disabled = mask.fields.daif & PSR_I_BIT;
+
+	if (!irq_disabled)
+		trace_hardirqs_on();
+
+	write_sysreg(mask.fields.daif, daif);
+
+	if (irq_disabled)
+		trace_hardirqs_off();
+}
+
+static struct cpu_exception_mask_handler daif_handler = {
+	.mask		= daif_exception_mask,
+	.save		= daif_exception_save,
+	.restore	= daif_exception_restore,
+};
+
+static void pmr_exception_mask(void)
+{
+	WARN_ON(system_has_prio_mask_debugging() &&
+		(read_sysreg_s(SYS_ICC_PMR_EL1) == (GIC_PRIO_IRQOFF |
+						    GIC_PRIO_PSR_I_SET)));
+
+	asm volatile(
+		"msr	daifset, #0xf\n"
+		:
+		:
+		: "memory");
+
+	gic_write_pmr(errctx.fields.pmr);
+
+	trace_hardirqs_off();
+}
+
+static unsigned long pmr_exception_save(void)
+{
+	union cpu_exception_mask mask = { .flags = 0UL };
+
+	mask.fields.daif = read_sysreg(daif);
+	mask.fields.allint = mask.fields.daif & PSR_A_BIT;
+
+	/* If IRQs are masked with PMR, reflect it in the daif */
+	if (read_sysreg_s(SYS_ICC_PMR_EL1) != procctx.fields.pmr) {
+		mask.fields.daif |= DAIF_PROCCTX_NOIRQ;
+		mask.fields.pmr = mask.fields.allint ?
+				errctx.fields.pmr : procctx_noirq.fields.pmr;
+	} else {
+		mask.fields.pmr = procctx.fields.pmr;
+	}
+
+	return mask.flags;
+}
+
+static void pmr_exception_restore(unsigned long flags)
+{
+	union cpu_exception_mask mask = { .flags = flags };
+	bool irq_disabled = (mask.fields.daif & PSR_I_BIT);
+
+	WARN_ON(system_has_prio_mask_debugging() &&
+		(read_sysreg(daif) & (DAIF_PROCCTX_NOIRQ)) != (DAIF_PROCCTX_NOIRQ));
+
+	if (!irq_disabled) {
+		trace_hardirqs_on();
+		gic_write_pmr(mask.fields.pmr);
+		pmr_sync();
+	} else {
+		if (!mask.fields.allint)
+			mask.fields.daif &= ~DAIF_PROCCTX_NOIRQ;
+		/*
+		 * There has been concern that the write to daif
+		 * might be reordered before this write to PMR.
+		 * From the ARM ARM DDI 0487D.a, section D1.7.1
+		 * "Accessing PSTATE fields":
+		 *   Writes to the PSTATE fields have side-effects on
+		 *   various aspects of the PE operation. All of these
+		 *   side-effects are guaranteed:
+		 *     - Not to be visible to earlier instructions in
+		 *       the execution stream.
+		 *     - To be visible to later instructions in the
+		 *       execution stream
+		 *
+		 * Also, writes to PMR are self-synchronizing, so no
+		 * interrupts with a lower priority than PMR is signaled
+		 * to the PE after the write.
+		 *
+		 * So we don't need additional synchronization here.
+		 */
+		gic_write_pmr(mask.fields.pmr);
+	}
+
+	write_sysreg(mask.fields.daif, daif);
+
+	if (irq_disabled)
+		trace_hardirqs_off();
+}
+
+static struct cpu_exception_mask_handler pmr_handler = {
+	.mask		= pmr_exception_mask,
+	.save		= pmr_exception_save,
+	.restore	= pmr_exception_restore,
+};
+
+struct cpu_exception_mask_handler *cpu_exception = &daif_handler;
+
+int set_exception_mask_handler(int type)
+{
+	switch (type) {
+	case 0:
+		cpu_exception = &daif_handler;
+		break;
+	case 1:
+		cpu_exception = &pmr_handler;
+		break;
+	/* case 2: reserved for FEAT_NMI */
+	default:
+		return -EINVAL;
+	}
+	pr_info("Exception mask handlers: %ps %ps %ps\n",
+					cpu_exception->mask,
+					cpu_exception->save,
+					cpu_exception->restore);
+	return 0;
+}
-- 
2.34.1

