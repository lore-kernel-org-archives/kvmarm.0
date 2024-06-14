Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A0F1487EC
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 03:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337159; cv=none; b=bJyRFyJmfLl0y3gh/N5hRh0eKb95db0kghoYdALYhTFDAr22X0+qjYEAK1lNZ3NxOB0OV2+mc3Rp5pU8X6QG77aqyQv4YiXSM/w7b7c8FSnDRRd4p/lk056S+yOX+/uXj2Q3GGnDgMIR9EZJvLbseN4W1Ia8Kp+Vm9q2ZGdkBDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337159; c=relaxed/simple;
	bh=yJcvzm3hKOzbliDl6IA3AUoJ7agDnatRyA0680JNZz4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KYAXS5Lq4lMLVj377tm7DKzfjkUalv4lBQ6anHybb8YYaPXI4UAlzn94mOJNYR7Y+NjxxB2BuZSQ/Vwkpaff71f/Pag7QQkIecSkOQPGdeCEYaqEORqCD8l1+h5KmM0f+7L/jvyjzi5SAATHR316SA60MogypeXPxet4Hdt3TfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W0lbl1rx7zmYpT;
	Fri, 14 Jun 2024 11:47:47 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id A130114059F;
	Fri, 14 Jun 2024 11:52:33 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 14 Jun
 2024 11:52:31 +0800
From: Liao Chang <liaochang1@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <ryabinin.a.a@gmail.com>,
	<glider@google.com>, <andreyknvl@gmail.com>, <dvyukov@google.com>,
	<vincenzo.frascino@arm.com>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<mark.rutland@arm.com>, <lpieralisi@kernel.org>, <tglx@linutronix.de>,
	<ardb@kernel.org>, <broonie@kernel.org>, <liaochang1@huawei.com>,
	<steven.price@arm.com>, <ryan.roberts@arm.com>, <pcc@google.com>,
	<anshuman.khandual@arm.com>, <eric.auger@redhat.com>,
	<miguel.luis@oracle.com>, <shiqiliu@hust.edu.cn>, <quic_jiles@quicinc.com>,
	<rafael@kernel.org>, <sudeep.holla@arm.com>, <dwmw@amazon.co.uk>,
	<joey.gouly@arm.com>, <jeremy.linton@arm.com>, <robh@kernel.org>,
	<scott@os.amperecomputing.com>, <songshuaishuai@tinylab.org>,
	<swboyd@chromium.org>, <dianders@chromium.org>,
	<shijie@os.amperecomputing.com>, <bhe@redhat.com>,
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <mhiramat@kernel.org>,
	<mcgrof@kernel.org>, <rmk+kernel@armlinux.org.uk>,
	<Jonathan.Cameron@huawei.com>, <takakura@valinux.co.jp>,
	<sumit.garg@linaro.org>, <frederic@kernel.org>, <tabba@google.com>,
	<kristina.martsenko@arm.com>, <ruanjinjie@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<kasan-dev@googlegroups.com>, <kvmarm@lists.linux.dev>
Subject: [PATCH v4 06/10] arm64: Deprecate old local_daif_{mask,save,restore} helper functions
Date: Fri, 14 Jun 2024 03:44:29 +0000
Message-ID: <20240614034433.602622-7-liaochang1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240614034433.602622-1-liaochang1@huawei.com>
References: <20240614034433.602622-1-liaochang1@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200013.china.huawei.com (7.221.188.133)

Motivation
----------

With upcoming FEAT_NMI extension in Arm64 v8.8, the kernel needs to
support two separate interrupt masking implementation. This increase
complexity in the exception masks management, furthermore, the FEAT_NMI
feature introduces the ALLINT feild in PSTATE, rendering the current
helper functions inadequate to reflect the actual behavior.

This patch deprecates the old interrupt masking helper functions
starting with local_daif_. Developers are encouraged to migrate to the
new series of logical interrupt masking function starting with
local_allint_.

Implementation
--------------

This patch replaces the instance of the old functions with their
corresponding new couterparts:

- local_daif_mask() -> local_allint_mask()

- local_daif_save_flags() -> local_allint_save_flags()

- local_daif_restore(flags) -> local_allint_restore(flags), except for
  specific cases. It always used with local_allint_save_flags() in pair.

- local_daif_restore(DAIF_PROCCTX_NOIRQ) -> local_nmi_serror_enable()

- local_daif_restore(DAIF_ERRCTX) -> local_nmi_serror_disable()

- local_daif_restore(DAIF_PROCCTX) -> local_irq_serror_enable()

Benefits
--------

The new API functions offer clear naming that reflect their purpose,
regardless of the kernel NMI configuration. This provides developers
with a consistent and comprehensive set of function to use, even when
the FEAT_NMI feature is enabled in the future.

Signed-off-by: Liao Chang <liaochang1@huawei.com>
---
 arch/arm64/include/asm/daifflags.h | 118 ++++-------------------------
 arch/arm64/kernel/acpi.c           |  10 +--
 arch/arm64/kernel/debug-monitors.c |   6 +-
 arch/arm64/kernel/hibernate.c      |   6 +-
 arch/arm64/kernel/irq.c            |   2 +-
 arch/arm64/kernel/machine_kexec.c  |   2 +-
 arch/arm64/kernel/setup.c          |   2 +-
 arch/arm64/kernel/smp.c            |   6 +-
 arch/arm64/kernel/suspend.c        |   6 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c    |   6 +-
 arch/arm64/kvm/hyp/vhe/switch.c    |   4 +-
 arch/arm64/mm/mmu.c                |   6 +-
 12 files changed, 43 insertions(+), 131 deletions(-)

diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index 90bf0bdde3c9..b19dfd948704 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -17,109 +17,6 @@
 #define DAIF_ERRCTX		(PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
 #define DAIF_MASK		(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
 
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
 /*
  * For Arm64 processor support Armv8.8 or later, kernel supports three types
  * of irqflags, they used for corresponding configuration depicted as below:
@@ -164,6 +61,7 @@ union arch_irqflags {
 		unsigned long allint : 14; // PSTATE.ALLINT at bits[13]
 	} fields;
 };
+#define ARCH_IRQFLAGS_INITIALIZER	{ .flags = 0UL }
 
 typedef union arch_irqflags arch_irqflags_t;
 
@@ -194,6 +92,7 @@ static inline void local_allint_mask_notrace(void)
 		__local_nmi_mask();
 }
 
+/* mask/save/unmask/restore all exceptions, including interrupts. */
 static inline void local_allint_mask(void)
 {
 	local_allint_mask_notrace();
@@ -420,4 +319,17 @@ static inline void local_irq_serror_enable(void)
 	irqflags.fields.allint = 0;
 	__local_allint_restore(irqflags);
 }
+
+/*
+ * local_nmi_serror_enable - Enable Serror and NMI with or without superpriority.
+ */
+static inline void local_nmi_serror_enable(void)
+{
+	arch_irqflags_t irqflags;
+
+	irqflags.fields.daif = DAIF_PROCCTX_NOIRQ;
+	irqflags.fields.pmr = GIC_PRIO_IRQOFF;
+	irqflags.fields.allint = 0;
+	local_allint_restore_notrace(irqflags);
+}
 #endif
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index e0e7b93c16cc..be7925a39d3b 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -375,12 +375,12 @@ int apei_claim_sea(struct pt_regs *regs)
 {
 	int err = -ENOENT;
 	bool return_to_irqs_enabled;
-	unsigned long current_flags;
+	arch_irqflags_t current_flags;
 
 	if (!IS_ENABLED(CONFIG_ACPI_APEI_GHES))
 		return err;
 
-	current_flags = local_daif_save_flags();
+	current_flags = local_allint_save_flags();
 
 	/* current_flags isn't useful here as daif doesn't tell us about pNMI */
 	return_to_irqs_enabled = !irqs_disabled_flags(arch_local_save_flags());
@@ -392,7 +392,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	 * SEA can interrupt SError, mask it and describe this as an NMI so
 	 * that APEI defers the handling.
 	 */
-	local_daif_restore(DAIF_ERRCTX);
+	local_nmi_serror_disable();
 	nmi_enter();
 	err = ghes_notify_sea();
 	nmi_exit();
@@ -403,7 +403,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	 */
 	if (!err) {
 		if (return_to_irqs_enabled) {
-			local_daif_restore(DAIF_PROCCTX_NOIRQ);
+			local_nmi_serror_enable();
 			__irq_enter();
 			irq_work_run();
 			__irq_exit();
@@ -413,7 +413,7 @@ int apei_claim_sea(struct pt_regs *regs)
 		}
 	}
 
-	local_daif_restore(current_flags);
+	local_allint_restore(current_flags);
 
 	return err;
 }
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 64f2ecbdfe5c..fd656746df2d 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -36,10 +36,10 @@ u8 debug_monitors_arch(void)
  */
 static void mdscr_write(u32 mdscr)
 {
-	unsigned long flags;
-	flags = local_daif_save();
+	arch_irqflags_t flags;
+	flags = local_allint_save();
 	write_sysreg(mdscr, mdscr_el1);
-	local_daif_restore(flags);
+	local_allint_restore(flags);
 }
 NOKPROBE_SYMBOL(mdscr_write);
 
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 02870beb271e..3f0d276121d3 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -327,7 +327,7 @@ static void swsusp_mte_restore_tags(void)
 int swsusp_arch_suspend(void)
 {
 	int ret = 0;
-	unsigned long flags;
+	arch_irqflags_t flags;
 	struct sleep_stack_data state;
 
 	if (cpus_are_stuck_in_kernel()) {
@@ -335,7 +335,7 @@ int swsusp_arch_suspend(void)
 		return -EBUSY;
 	}
 
-	flags = local_daif_save();
+	flags = local_allint_save();
 
 	if (__cpu_suspend_enter(&state)) {
 		/* make the crash dump kernel image visible/saveable */
@@ -385,7 +385,7 @@ int swsusp_arch_suspend(void)
 		spectre_v4_enable_mitigation(NULL);
 	}
 
-	local_daif_restore(flags);
+	local_allint_restore(flags);
 
 	return ret;
 }
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 85087e2df564..ad4872fcee6c 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -132,6 +132,6 @@ void __init init_IRQ(void)
 		 * the PMR/PSR pair to a consistent state.
 		 */
 		WARN_ON(read_sysreg(daif) & PSR_A_BIT);
-		local_daif_restore(DAIF_PROCCTX_NOIRQ);
+		local_nmi_serror_enable();
 	}
 }
diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 82e2203d86a3..412f90c188dc 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -176,7 +176,7 @@ void machine_kexec(struct kimage *kimage)
 
 	pr_info("Bye!\n");
 
-	local_daif_mask();
+	local_allint_mask();
 
 	/*
 	 * Both restart and kernel_reloc will shutdown the MMU, disable data
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index a096e2451044..1fba96a43370 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -308,7 +308,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	 * IRQ and FIQ will be unmasked after the root irqchip has been
 	 * detected and initialized.
 	 */
-	local_daif_restore(DAIF_PROCCTX_NOIRQ);
+	local_nmi_serror_enable();
 
 	/*
 	 * TTBR0 is only used for the identity mapping at this stage. Make it
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 31c8b3094dd7..11da5681a3fb 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -271,7 +271,7 @@ asmlinkage notrace void secondary_start_kernel(void)
 	 * as the root irqchip has already been detected and initialized we can
 	 * unmask IRQ and FIQ at the same time.
 	 */
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 
 	/*
 	 * OK, it's off to the idle thread for us
@@ -378,7 +378,7 @@ void __noreturn cpu_die(void)
 
 	idle_task_exit();
 
-	local_daif_mask();
+	local_allint_mask();
 
 	/* Tell cpuhp_bp_sync_dead() that this CPU is now safe to dispose of */
 	cpuhp_ap_report_dead();
@@ -817,7 +817,7 @@ static void __noreturn local_cpu_stop(void)
 {
 	set_cpu_online(smp_processor_id(), false);
 
-	local_daif_mask();
+	local_allint_mask();
 	sdei_mask_local_cpu();
 	cpu_park_loop();
 }
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 0e79af827540..559f1eb1ae2e 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -97,7 +97,7 @@ void notrace __cpu_suspend_exit(void)
 int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 {
 	int ret = 0;
-	unsigned long flags;
+	arch_irqflags_t flags;
 	struct sleep_stack_data state;
 	struct arm_cpuidle_irq_context context;
 
@@ -122,7 +122,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * hardirqs should be firmly off by now. This really ought to use
 	 * something like raw_local_daif_save().
 	 */
-	flags = local_daif_save();
+	flags = local_allint_save();
 
 	/*
 	 * Function graph tracer state gets inconsistent when the kernel
@@ -168,7 +168,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
 	 * restored, so from this point onwards, debugging is fully
 	 * reenabled if it was enabled when core started shutdown.
 	 */
-	local_daif_restore(flags);
+	local_allint_restore(flags);
 
 	return ret;
 }
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 7b397fad26f2..7f2b05654135 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -414,7 +414,7 @@ void __vgic_v3_init_lrs(void)
 u64 __vgic_v3_get_gic_config(void)
 {
 	u64 val, sre = read_gicreg(ICC_SRE_EL1);
-	unsigned long flags = 0;
+	arch_irqflags_t flags = ARCH_IRQFLAGS_INITIALIZER;
 
 	/*
 	 * To check whether we have a MMIO-based (GICv2 compatible)
@@ -427,7 +427,7 @@ u64 __vgic_v3_get_gic_config(void)
 	 * EL2.
 	 */
 	if (has_vhe())
-		flags = local_daif_save();
+		flags = local_allint_save();
 
 	/*
 	 * Table 11-2 "Permitted ICC_SRE_ELx.SRE settings" indicates
@@ -447,7 +447,7 @@ u64 __vgic_v3_get_gic_config(void)
 	isb();
 
 	if (has_vhe())
-		local_daif_restore(flags);
+		local_allint_restore(flags);
 
 	val  = (val & ICC_SRE_EL1_SRE) ? 0 : (1ULL << 63);
 	val |= read_gicreg(ICH_VTR_EL2);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d7af5f46f22a..81a271218014 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -354,7 +354,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	local_daif_mask();
+	local_allint_mask();
 
 	/*
 	 * Having IRQs masked via PMR when entering the guest means the GIC
@@ -373,7 +373,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * local_daif_restore() takes care to properly restore PSTATE.DAIF
 	 * and the GIC PMR if the host is using IRQ priorities.
 	 */
-	local_daif_restore(DAIF_PROCCTX_NOIRQ);
+	local_nmi_serror_enable();
 
 	/*
 	 * When we exit from the guest we change a number of CPU configuration
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index c927e9312f10..9f99118b3ee4 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1526,7 +1526,7 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 	typedef void (ttbr_replace_func)(phys_addr_t);
 	extern ttbr_replace_func idmap_cpu_replace_ttbr1;
 	ttbr_replace_func *replace_phys;
-	unsigned long daif;
+	arch_irqflags_t flags;
 
 	/* phys_to_ttbr() zeros lower 2 bits of ttbr with 52-bit PA */
 	phys_addr_t ttbr1 = phys_to_ttbr(virt_to_phys(pgdp));
@@ -1542,9 +1542,9 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 	 * We really don't want to take *any* exceptions while TTBR1 is
 	 * in the process of being replaced so mask everything.
 	 */
-	daif = local_daif_save();
+	flags = local_allint_save();
 	replace_phys(ttbr1);
-	local_daif_restore(daif);
+	local_allint_restore(flags);
 
 	cpu_uninstall_idmap();
 }
-- 
2.34.1

