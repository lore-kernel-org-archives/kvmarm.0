Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18000221DBC
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 11:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747912335; cv=none; b=uzIRmioKudsbayhelucpXg8AXsV045UTUDBNt/iwArZT25EzZqZrrjf/6eA7P22vXiLxb2mfkhQyeBa3bXJfNbI7kCqx57UPTmoxkeZjT+oNGsV8ED6CdOuqlrRCIpu0FMlmNqY+/QHmhHKVYohyQt6L9uaIoETbXfZHpc+TwcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747912335; c=relaxed/simple;
	bh=0jbWSeWR8R8oDbMMJ4+irFq8XnQcrQQeU8RP/GzlMro=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=geIhWccMxRsnXjGOD4gWq+RWH2E9x6hLgepO8jb6CzSrRFgZfulHmDGNAlNbt82YIQQFpA6e6ChtrPYzTZ9hRW8p4RyRXq6eODDgaty3Ok9PnoyOzizrhOvTtXDXVOzOwfq96FSedJG1l92p5rMdDKvAR1HN3nm7z00tqeZwJ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4b35Cy24XPz1R7k2;
	Thu, 22 May 2025 19:09:50 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id EC8DD1A0188;
	Thu, 22 May 2025 19:12:02 +0800 (CST)
Received: from kwepemq200011.china.huawei.com (7.202.195.155) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 22 May 2025 19:12:02 +0800
Received: from huawei.com (10.67.174.28) by kwepemq200011.china.huawei.com
 (7.202.195.155) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 May
 2025 19:12:00 +0800
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
Subject: [PATCH v5 2/2] arm64: Deprecate the old daifflags helpers
Date: Thu, 22 May 2025 10:56:58 +0000
Message-ID: <20250522105658.1338331-3-liaochang1@huawei.com>
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

Replacing all of the daifflags helpers used in the arm64 architecture
code with the counterparts defined in exception_mask.h

Signed-off-by: Liao Chang <liaochang1@huawei.com>
CC: Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Marc Zyngier <maz@kernel.org>
CC: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/daifflags.h   | 144 ---------------------------
 arch/arm64/include/asm/kvm_host.h    |   2 +-
 arch/arm64/include/asm/mmu_context.h |   2 +-
 arch/arm64/kernel/acpi.c             |  10 +-
 arch/arm64/kernel/debug-monitors.c   |   6 +-
 arch/arm64/kernel/entry-common.c     |   2 +-
 arch/arm64/kernel/hibernate.c        |   6 +-
 arch/arm64/kernel/irq.c              |   4 +-
 arch/arm64/kernel/machine_kexec.c    |   4 +-
 arch/arm64/kernel/probes/kprobes.c   |   2 +-
 arch/arm64/kernel/setup.c            |   4 +-
 arch/arm64/kernel/signal.c           |   2 +-
 arch/arm64/kernel/smp.c              |  10 +-
 arch/arm64/kernel/suspend.c          |   6 +-
 arch/arm64/kernel/traps.c            |   2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c      |   4 +-
 arch/arm64/mm/fault.c                |   2 +-
 arch/arm64/mm/mmu.c                  |   6 +-
 19 files changed, 39 insertions(+), 183 deletions(-)
 delete mode 100644 arch/arm64/include/asm/daifflags.h

diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
deleted file mode 100644
index fbb5c99eb2f9..000000000000
--- a/arch/arm64/include/asm/daifflags.h
+++ /dev/null
@@ -1,144 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2017 ARM Ltd.
- */
-#ifndef __ASM_DAIFFLAGS_H
-#define __ASM_DAIFFLAGS_H
-
-#include <linux/irqflags.h>
-
-#include <asm/arch_gicv3.h>
-#include <asm/barrier.h>
-#include <asm/cpufeature.h>
-#include <asm/ptrace.h>
-
-#define DAIF_PROCCTX		0
-#define DAIF_PROCCTX_NOIRQ	(PSR_I_BIT | PSR_F_BIT)
-#define DAIF_ERRCTX		(PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
-#define DAIF_MASK		(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
-
-
-/* mask/save/unmask/restore all exceptions, including interrupts. */
-static inline void local_daif_mask(void)
-{
-	WARN_ON(system_has_prio_mask_debugging() &&
-		(read_sysreg_s(SYS_ICC_PMR_EL1) == (GIC_PRIO_IRQOFF |
-						    GIC_PRIO_PSR_I_SET)));
-
-	asm volatile(
-		"msr	daifset, #0xf		// local_daif_mask\n"
-		:
-		:
-		: "memory");
-
-	/* Don't really care for a dsb here, we don't intend to enable IRQs */
-	if (system_uses_irq_prio_masking())
-		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
-
-	trace_hardirqs_off();
-}
-
-static inline unsigned long local_daif_save_flags(void)
-{
-	unsigned long flags;
-
-	flags = read_sysreg(daif);
-
-	if (system_uses_irq_prio_masking()) {
-		/* If IRQs are masked with PMR, reflect it in the flags */
-		if (read_sysreg_s(SYS_ICC_PMR_EL1) != GIC_PRIO_IRQON)
-			flags |= PSR_I_BIT | PSR_F_BIT;
-	}
-
-	return flags;
-}
-
-static inline unsigned long local_daif_save(void)
-{
-	unsigned long flags;
-
-	flags = local_daif_save_flags();
-
-	local_daif_mask();
-
-	return flags;
-}
-
-static inline void local_daif_restore(unsigned long flags)
-{
-	bool irq_disabled = flags & PSR_I_BIT;
-
-	WARN_ON(system_has_prio_mask_debugging() &&
-		(read_sysreg(daif) & (PSR_I_BIT | PSR_F_BIT)) != (PSR_I_BIT | PSR_F_BIT));
-
-	if (!irq_disabled) {
-		trace_hardirqs_on();
-
-		if (system_uses_irq_prio_masking()) {
-			gic_write_pmr(GIC_PRIO_IRQON);
-			pmr_sync();
-		}
-	} else if (system_uses_irq_prio_masking()) {
-		u64 pmr;
-
-		if (!(flags & PSR_A_BIT)) {
-			/*
-			 * If interrupts are disabled but we can take
-			 * asynchronous errors, we can take NMIs
-			 */
-			flags &= ~(PSR_I_BIT | PSR_F_BIT);
-			pmr = GIC_PRIO_IRQOFF;
-		} else {
-			pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
-		}
-
-		/*
-		 * There has been concern that the write to daif
-		 * might be reordered before this write to PMR.
-		 * From the ARM ARM DDI 0487D.a, section D1.7.1
-		 * "Accessing PSTATE fields":
-		 *   Writes to the PSTATE fields have side-effects on
-		 *   various aspects of the PE operation. All of these
-		 *   side-effects are guaranteed:
-		 *     - Not to be visible to earlier instructions in
-		 *       the execution stream.
-		 *     - To be visible to later instructions in the
-		 *       execution stream
-		 *
-		 * Also, writes to PMR are self-synchronizing, so no
-		 * interrupts with a lower priority than PMR is signaled
-		 * to the PE after the write.
-		 *
-		 * So we don't need additional synchronization here.
-		 */
-		gic_write_pmr(pmr);
-	}
-
-	write_sysreg(flags, daif);
-
-	if (irq_disabled)
-		trace_hardirqs_off();
-}
-
-/*
- * Called by synchronous exception handlers to restore the DAIF bits that were
- * modified by taking an exception.
- */
-static inline void local_daif_inherit(struct pt_regs *regs)
-{
-	unsigned long flags = regs->pstate & DAIF_MASK;
-
-	if (interrupts_enabled(regs))
-		trace_hardirqs_on();
-
-	if (system_uses_irq_prio_masking())
-		gic_write_pmr(regs->pmr);
-
-	/*
-	 * We can't use local_daif_restore(regs->pstate) here as
-	 * system_has_prio_mask_debugging() won't restore the I bit if it can
-	 * use the pmr instead.
-	 */
-	write_sysreg(flags, daif);
-}
-#endif
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 08ba91e6fb03..0af825f11efc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -23,7 +23,7 @@
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/cputype.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 0dbe3b29049b..6284ce3fd3b4 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -19,7 +19,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/gcs.h>
 #include <asm/proc-fns.h>
 #include <asm/cputype.h>
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index b9a66fc146c9..3f3a4ff95d5d 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -33,7 +33,7 @@
 #include <acpi/processor.h>
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/smp_plat.h>
 
 int acpi_noirq = 1;		/* skip ACPI IRQ initialization */
@@ -397,7 +397,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	if (!IS_ENABLED(CONFIG_ACPI_APEI_GHES))
 		return err;
 
-	current_flags = local_daif_save_flags();
+	current_flags = local_exception_save_flags();
 
 	/* current_flags isn't useful here as daif doesn't tell us about pNMI */
 	return_to_irqs_enabled = !irqs_disabled_flags(arch_local_save_flags());
@@ -409,7 +409,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	 * SEA can interrupt SError, mask it and describe this as an NMI so
 	 * that APEI defers the handling.
 	 */
-	local_daif_restore(DAIF_ERRCTX);
+	serror_entry_exception_mask();
 	nmi_enter();
 	err = ghes_notify_sea();
 	nmi_exit();
@@ -420,7 +420,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	 */
 	if (!err) {
 		if (return_to_irqs_enabled) {
-			local_daif_restore(DAIF_PROCCTX_NOIRQ);
+			local_exception_restore(procctx_noirq.flags);
 			__irq_enter();
 			irq_work_run();
 			__irq_exit();
@@ -430,7 +430,7 @@ int apei_claim_sea(struct pt_regs *regs)
 		}
 	}
 
-	local_daif_restore(current_flags);
+	local_exception_restore(current_flags);
 
 	return err;
 }
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 58f047de3e1c..97dc7cafccd6 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -19,7 +19,7 @@
 
 #include <asm/cpufeature.h>
 #include <asm/cputype.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/debug-monitors.h>
 #include <asm/system_misc.h>
 #include <asm/traps.h>
@@ -37,9 +37,9 @@ u8 debug_monitors_arch(void)
 static void mdscr_write(u32 mdscr)
 {
 	unsigned long flags;
-	flags = local_daif_save();
+	flags = local_exception_save();
 	write_sysreg(mdscr, mdscr_el1);
-	local_daif_restore(flags);
+	local_exception_restore(flags);
 }
 NOKPROBE_SYMBOL(mdscr_write);
 
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 528d1bfbb5ed..221df3937da6 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -16,7 +16,7 @@
 #include <linux/thread_info.h>
 
 #include <asm/cpufeature.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/esr.h>
 #include <asm/exception.h>
 #include <asm/irq_regs.h>
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 18749e9a6c2d..cb1c9d00d840 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -20,7 +20,7 @@
 #include <asm/barrier.h>
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/irqflags.h>
 #include <asm/kexec.h>
 #include <asm/memory.h>
@@ -341,7 +341,7 @@ int swsusp_arch_suspend(void)
 		return -EBUSY;
 	}
 
-	flags = local_daif_save();
+	flags = local_exception_save();
 
 	if (__cpu_suspend_enter(&state)) {
 		/* make the crash dump kernel image visible/saveable */
@@ -391,7 +391,7 @@ int swsusp_arch_suspend(void)
 		spectre_v4_enable_mitigation(NULL);
 	}
 
-	local_daif_restore(flags);
+	local_exception_restore(flags);
 
 	return ret;
 }
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 85087e2df564..f92497e9849d 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -20,7 +20,7 @@
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/exception.h>
 #include <asm/numa.h>
 #include <asm/softirq_stack.h>
@@ -132,6 +132,6 @@ void __init init_IRQ(void)
 		 * the PMR/PSR pair to a consistent state.
 		 */
 		WARN_ON(read_sysreg(daif) & PSR_A_BIT);
-		local_daif_restore(DAIF_PROCCTX_NOIRQ);
+		local_exception_restore(procctx_noirq.flags);
 	}
 }
diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 6f121a0164a4..e415d7a74269 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -17,7 +17,7 @@
 
 #include <asm/cacheflush.h>
 #include <asm/cpu_ops.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/memory.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
@@ -176,7 +176,7 @@ void machine_kexec(struct kimage *kimage)
 
 	pr_info("Bye!\n");
 
-	local_daif_mask();
+	local_exception_mask();
 
 	/*
 	 * Both restart and kernel_reloc will shutdown the MMU, disable data
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index d9e462eafb95..9405d8110525 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -23,7 +23,7 @@
 #include <linux/vmalloc.h>
 
 #include <asm/cacheflush.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
 #include <asm/irq.h>
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 85104587f849..9e52c4649a43 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -37,7 +37,7 @@
 #include <asm/fixmap.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/elf.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
@@ -311,7 +311,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	 * IRQ and FIQ will be unmasked after the root irqchip has been
 	 * detected and initialized.
 	 */
-	local_daif_restore(DAIF_PROCCTX_NOIRQ);
+	local_exception_restore(procctx_noirq.flags);
 
 	/*
 	 * TTBR0 is only used for the identity mapping at this stage. Make it
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index a7c37afb4ebe..07c2950c3298 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -21,7 +21,7 @@
 #include <linux/syscalls.h>
 #include <linux/pkeys.h>
 
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/debug-monitors.h>
 #include <asm/elf.h>
 #include <asm/exception.h>
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 3b3f6b56e733..86594601fe37 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -42,7 +42,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/kvm_mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/numa.h>
@@ -271,7 +271,7 @@ asmlinkage notrace void secondary_start_kernel(void)
 	 * as the root irqchip has already been detected and initialized we can
 	 * unmask IRQ and FIQ at the same time.
 	 */
-	local_daif_restore(DAIF_PROCCTX);
+	local_exception_restore(procctx.flags);
 
 	/*
 	 * OK, it's off to the idle thread for us
@@ -378,7 +378,7 @@ void __noreturn cpu_die(void)
 
 	idle_task_exit();
 
-	local_daif_mask();
+	local_exception_mask();
 
 	/* Tell cpuhp_bp_sync_dead() that this CPU is now safe to dispose of */
 	cpuhp_ap_report_dead();
@@ -873,7 +873,7 @@ static void __noreturn local_cpu_stop(unsigned int cpu)
 {
 	set_cpu_online(cpu, false);
 
-	local_daif_mask();
+	local_exception_mask();
 	sdei_mask_local_cpu();
 	cpu_park_loop();
 }
@@ -899,7 +899,7 @@ static void __noreturn ipi_cpu_crash_stop(unsigned int cpu, struct pt_regs *regs
 	 * interrupt us. It's better to prevent the NMI and let the IRQ
 	 * finish since the pt_regs will be better.
 	 */
-	local_daif_mask();
+	local_exception_mask();
 
 	crash_save_cpu(regs, cpu);
 
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index eaaff94329cd..754a56f08e66 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -9,7 +9,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/cpuidle.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/debug-monitors.h>
 #include <asm/exec.h>
 #include <asm/fpsimd.h>
@@ -122,7 +122,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * hardirqs should be firmly off by now. This really ought to use
 	 * something like raw_local_daif_save().
 	 */
-	flags = local_daif_save();
+	flags = local_exception_save();
 
 	/*
 	 * Function graph tracer state gets inconsistent when the kernel
@@ -168,7 +168,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * restored, so from this point onwards, debugging is fully
 	 * reenabled if it was enabled when core started shutdown.
 	 */
-	local_daif_restore(flags);
+	local_exception_restore(flags);
 
 	return ret;
 }
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 529cff825531..62562e9fb4ba 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -33,7 +33,7 @@
 #include <asm/atomic.h>
 #include <asm/bug.h>
 #include <asm/cpufeature.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/debug-monitors.h>
 #include <asm/efi.h>
 #include <asm/esr.h>
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index ed363aa3027e..2e60f61a094c 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -437,7 +437,7 @@ u64 __vgic_v3_get_gic_config(void)
 	 * EL2.
 	 */
 	if (has_vhe())
-		flags = local_daif_save();
+		flags = local_exception_save();
 
 	/*
 	 * Table 11-2 "Permitted ICC_SRE_ELx.SRE settings" indicates
@@ -457,7 +457,7 @@ u64 __vgic_v3_get_gic_config(void)
 	isb();
 
 	if (has_vhe())
-		local_daif_restore(flags);
+		local_exception_restore(flags);
 
 	val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
 	val |= read_gicreg(ICH_VTR_EL2);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 731a0378ed13..ea938b0d6920 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -644,7 +644,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	local_daif_mask();
+	local_exception_mask();
 
 	/*
 	 * Having IRQs masked via PMR when entering the guest means the GIC
@@ -663,7 +663,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * local_daif_restore() takes care to properly restore PSTATE.DAIF
 	 * and the GIC PMR if the host is using IRQ priorities.
 	 */
-	local_daif_restore(DAIF_PROCCTX_NOIRQ);
+	local_exception_restore(procctx_noirq.flags);
 
 	/*
 	 * When we exit from the guest we change a number of CPU configuration
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index ec0a337891dd..34441e023b58 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -33,7 +33,7 @@
 #include <asm/cpufeature.h>
 #include <asm/efi.h>
 #include <asm/exception.h>
-#include <asm/daifflags.h>
+#include <asm/exception_mask.h>
 #include <asm/debug-monitors.h>
 #include <asm/esr.h>
 #include <asm/kprobes.h>
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index ea6695d53fb9..a712f9b02d58 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1533,7 +1533,7 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 	typedef void (ttbr_replace_func)(phys_addr_t);
 	extern ttbr_replace_func idmap_cpu_replace_ttbr1;
 	ttbr_replace_func *replace_phys;
-	unsigned long daif;
+	unsigned long flags;
 
 	/* phys_to_ttbr() zeros lower 2 bits of ttbr with 52-bit PA */
 	phys_addr_t ttbr1 = phys_to_ttbr(virt_to_phys(pgdp));
@@ -1549,9 +1549,9 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 	 * We really don't want to take *any* exceptions while TTBR1 is
 	 * in the process of being replaced so mask everything.
 	 */
-	daif = local_daif_save();
+	flags = local_exception_save();
 	replace_phys(ttbr1);
-	local_daif_restore(daif);
+	local_exception_restore(flags);
 
 	cpu_uninstall_idmap();
 }
-- 
2.34.1

