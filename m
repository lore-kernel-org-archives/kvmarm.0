Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D57D148840
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 03:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337162; cv=none; b=bVmf4Q6Q1hqlV4nILrqdOJjZLSgz0wb4ES8gCIFfKtiOU3GWNq6EA+EDkiZ5GTLER/ul/2g1KSuUUr5HNM5mrYaRL5mN3F1oUqDL4sXpQsBOh8BK7zdbypBmD/+fbiLXZAVR6qPDj8+VnqSRnXUoj6L51aHULAEZvzRsXbXsqOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337162; c=relaxed/simple;
	bh=P0EOX+fXR4WZ887u3x1oTmoSxgMrsQhE0Ve3wQs9eZk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xeyv1bDlKfyf+gnPvrVG0Bg5PGOPTNYezpDw6FBW/SX+yi2gb/VuKBXTyzTcAi+CtLYUJ1XveaKQiwlTXjAJVxra64cuDLuzb8/w64Zsube5fZgI9BqGIUe4urBDpKmtXfzJ1rzpWpZG63wt+9RwlyiBuNH/OOB0ZSyDHpiD1Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4W0lcR6mZPz1SBXB;
	Fri, 14 Jun 2024 11:48:23 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id CC09818007E;
	Fri, 14 Jun 2024 11:52:31 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 14 Jun
 2024 11:52:29 +0800
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
Subject: [PATCH v4 05/10] arm64: Sipmlify exception masking during exception entry and exit
Date: Fri, 14 Jun 2024 03:44:28 +0000
Message-ID: <20240614034433.602622-6-liaochang1@huawei.com>
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

The current approach to interrupt masking during exception handling
involves an intermediate step, The kernel writes GIC_PRIO_IRQON |
GIC_PRIO_PSR_I_SET into ICC_PMR unconditionally, followed by a specific
value based on different exception cause. Due to this intermediate step
is unnecessary for platform support FEAT_NMI, this patch propose a
simpler interrupt masking for exception entry.

Implementation
--------------

This patch introduces a series of new helper functions to unify
exception masking at entry and exit points.

- local_nmi_disable(): Masks IRQ, FIQ and NMI interrupts (used at
  IRQ/FIQ entry).

- local_irq_serror_enable(): Unmasks IRQ, FIQ, NMI, Serror and Debug
  exceptions, which restore exception masks to the point exception
  ocurrs (used at regular synchronous exception entyr, e.g., SVC etc).

- local_nmi_serror_disable(): Masks IRQ, FIQ, NMI, Serror and Debug
  exceptions (used at Serror entry for safest requirement).

- local_irq_mark_enabled(): Masks IRQ, FIQ and NMI as enabled, but does
  not directly enable them, PSTATE.I still needs to be cleared for the
  kernel supports PSEUDO_NMI.

Benefits
--------

These functions use descriptive names that convey their purpose (e.g.,
local_nmi_disable()), instead of depicting the details about low-level
hardware operations which can vary depending on kernel NMI configure.
Additionally, removing the unnecessary intermediate step during
exception entry may reduce interrupt handling latency slightly.

Signed-off-by: Liao Chang <liaochang1@huawei.com>
---
 arch/arm64/include/asm/daifflags.h | 80 +++++++++++++++++++--------
 arch/arm64/kernel/entry-common.c   | 88 ++++++++++++++----------------
 arch/arm64/kernel/entry.S          |  2 -
 3 files changed, 98 insertions(+), 72 deletions(-)

diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index 5d502cc0dac2..90bf0bdde3c9 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -120,28 +120,6 @@ static inline void local_daif_restore(unsigned long flags)
 		trace_hardirqs_off();
 }
 
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
-		gic_write_pmr(regs->pmr_save);
-
-	/*
-	 * We can't use local_daif_restore(regs->pstate) here as
-	 * system_has_prio_mask_debugging() won't restore the I bit if it can
-	 * use the pmr instead.
-	 */
-	write_sysreg(flags, daif);
-}
-
 /*
  * For Arm64 processor support Armv8.8 or later, kernel supports three types
  * of irqflags, they used for corresponding configuration depicted as below:
@@ -384,4 +362,62 @@ static inline void local_allint_inherit(struct pt_regs *regs)
 	irqflags.fields.allint = regs->pstate & PSR_ALLINT_BIT;
 	__local_allint_restore(irqflags);
 }
+
+/*
+ * local_nmi_disable - Disable IRQ, FIQ and NMI, with or without superpriority.
+ */
+static inline void local_nmi_disable(void)
+{
+	arch_irqflags_t irqflags;
+
+	irqflags.fields.daif = DAIF_PROCCTX_NOIRQ;
+	irqflags.fields.pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
+	irqflags.fields.allint = PSR_ALLINT_BIT;
+	__local_allint_restore(irqflags);
+}
+
+/*
+ * local_irq_mark_enabled - When the kernel enables priority masking,
+ * interrupts cannot be handled util ICC_PMR_EL1 is set to GIC_PRIO_IRQON
+ * and PSTATE.IF is cleared. This helper function indicates that interrupts
+ * remains in a semi-masked state, requring further clearing of PSTATE.IF.
+ *
+ * Kernel will give a warning, if some function try to enable semi-masked
+ * interrupt via the arch_local_irq_enable() defined in <asm/irqflags.h>.
+ *
+ * This function is typically used before handling the Debug exception.
+ */
+static inline void local_irq_mark_enabled(void)
+{
+	if (system_uses_irq_prio_masking())
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
+}
+
+/*
+ * local_nmi_serror_disable - Disable all types of interrupt including IRQ,
+ * FIQ, Serror and NMI, with or without superpriority.
+ */
+static inline void local_nmi_serror_disable(void)
+{
+	arch_irqflags_t irqflags;
+
+	irqflags.fields.daif = DAIF_ERRCTX;
+	irqflags.fields.pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
+	irqflags.fields.allint = PSR_ALLINT_BIT;
+	__local_allint_restore(irqflags);
+}
+
+/*
+ * local_irq_serror_enable - Enable all types of interrupt including IRQ, FIQ,
+ * Serror and NMI, with or without superpriority.
+ */
+static inline void local_irq_serror_enable(void)
+{
+	arch_irqflags_t irqflags;
+
+	irqflags.fields.daif = DAIF_PROCCTX;
+	irqflags.fields.pmr = GIC_PRIO_IRQON;
+	irqflags.fields.allint = 0;
+	__local_allint_restore(irqflags);
+}
 #endif
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 72c2c9d033a8..eabfc80df6fb 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -168,7 +168,7 @@ static __always_inline void exit_to_user_mode_prepare(struct pt_regs *regs)
 	if (unlikely(flags & _TIF_WORK_MASK))
 		do_notify_resume(regs, flags);
 
-	local_daif_mask();
+	local_allint_mask();
 
 	lockdep_sys_exit();
 }
@@ -428,9 +428,9 @@ static void noinstr el1_abort(struct pt_regs *regs, unsigned long esr)
 	unsigned long far = read_sysreg(far_el1);
 
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	local_allint_inherit(regs);
 	do_mem_abort(far, esr, regs);
-	local_daif_mask();
+	local_allint_mask();
 	exit_to_kernel_mode(regs);
 }
 
@@ -439,27 +439,27 @@ static void noinstr el1_pc(struct pt_regs *regs, unsigned long esr)
 	unsigned long far = read_sysreg(far_el1);
 
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	local_allint_inherit(regs);
 	do_sp_pc_abort(far, esr, regs);
-	local_daif_mask();
+	local_allint_mask();
 	exit_to_kernel_mode(regs);
 }
 
 static void noinstr el1_undef(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	local_allint_inherit(regs);
 	do_el1_undef(regs, esr);
-	local_daif_mask();
+	local_allint_mask();
 	exit_to_kernel_mode(regs);
 }
 
 static void noinstr el1_bti(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	local_allint_inherit(regs);
 	do_el1_bti(regs, esr);
-	local_daif_mask();
+	local_allint_mask();
 	exit_to_kernel_mode(regs);
 }
 
@@ -467,6 +467,7 @@ static void noinstr el1_dbg(struct pt_regs *regs, unsigned long esr)
 {
 	unsigned long far = read_sysreg(far_el1);
 
+	local_irq_mark_enabled();
 	arm64_enter_el1_dbg(regs);
 	if (!cortex_a76_erratum_1463225_debug_handler(regs))
 		do_debug_exception(far, esr, regs);
@@ -476,9 +477,9 @@ static void noinstr el1_dbg(struct pt_regs *regs, unsigned long esr)
 static void noinstr el1_fpac(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_kernel_mode(regs);
-	local_daif_inherit(regs);
+	local_allint_inherit(regs);
 	do_el1_fpac(regs, esr);
-	local_daif_mask();
+	local_allint_mask();
 	exit_to_kernel_mode(regs);
 }
 
@@ -543,7 +544,7 @@ static __always_inline void __el1_irq(struct pt_regs *regs,
 static void noinstr el1_interrupt(struct pt_regs *regs,
 				  void (*handler)(struct pt_regs *))
 {
-	write_sysreg(DAIF_PROCCTX_NOIRQ, daif);
+	local_nmi_disable();
 
 	if (IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) && !interrupts_enabled(regs))
 		__el1_pnmi(regs, handler);
@@ -565,7 +566,7 @@ asmlinkage void noinstr el1h_64_error_handler(struct pt_regs *regs)
 {
 	unsigned long esr = read_sysreg(esr_el1);
 
-	local_daif_restore(DAIF_ERRCTX);
+	local_nmi_serror_disable();
 	arm64_enter_nmi(regs);
 	do_serror(regs, esr);
 	arm64_exit_nmi(regs);
@@ -576,7 +577,7 @@ static void noinstr el0_da(struct pt_regs *regs, unsigned long esr)
 	unsigned long far = read_sysreg(far_el1);
 
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_mem_abort(far, esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -594,7 +595,7 @@ static void noinstr el0_ia(struct pt_regs *regs, unsigned long esr)
 		arm64_apply_bp_hardening();
 
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_mem_abort(far, esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -602,7 +603,7 @@ static void noinstr el0_ia(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_fpsimd_acc(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_fpsimd_acc(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -610,7 +611,7 @@ static void noinstr el0_fpsimd_acc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_sve_acc(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_sve_acc(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -618,7 +619,7 @@ static void noinstr el0_sve_acc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_sme_acc(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_sme_acc(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -626,7 +627,7 @@ static void noinstr el0_sme_acc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_fpsimd_exc(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_fpsimd_exc(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -634,7 +635,7 @@ static void noinstr el0_fpsimd_exc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_sys(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_el0_sys(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -647,7 +648,7 @@ static void noinstr el0_pc(struct pt_regs *regs, unsigned long esr)
 		arm64_apply_bp_hardening();
 
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_sp_pc_abort(far, esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -655,7 +656,7 @@ static void noinstr el0_pc(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_sp(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_sp_pc_abort(regs->sp, esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -663,7 +664,7 @@ static void noinstr el0_sp(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_undef(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_el0_undef(regs, esr);
 	exit_to_user_mode(regs);
 }
@@ -671,7 +672,7 @@ static void noinstr el0_undef(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_bti(struct pt_regs *regs)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_el0_bti(regs);
 	exit_to_user_mode(regs);
 }
@@ -679,7 +680,7 @@ static void noinstr el0_bti(struct pt_regs *regs)
 static void noinstr el0_mops(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_el0_mops(regs, esr);
 	exit_to_user_mode(regs);
 }
@@ -687,7 +688,7 @@ static void noinstr el0_mops(struct pt_regs *regs, unsigned long esr)
 static void noinstr el0_inv(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	bad_el0_sync(regs, 0, esr);
 	exit_to_user_mode(regs);
 }
@@ -697,9 +698,10 @@ static void noinstr el0_dbg(struct pt_regs *regs, unsigned long esr)
 	/* Only watchpoints write FAR_EL1, otherwise its UNKNOWN */
 	unsigned long far = read_sysreg(far_el1);
 
+	local_irq_mark_enabled();
 	enter_from_user_mode(regs);
 	do_debug_exception(far, esr, regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	exit_to_user_mode(regs);
 }
 
@@ -708,7 +710,7 @@ static void noinstr el0_svc(struct pt_regs *regs)
 	enter_from_user_mode(regs);
 	cortex_a76_erratum_1463225_svc_handler();
 	fp_user_discard();
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_el0_svc(regs);
 	exit_to_user_mode(regs);
 }
@@ -716,7 +718,7 @@ static void noinstr el0_svc(struct pt_regs *regs)
 static void noinstr el0_fpac(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_el0_fpac(regs, esr);
 	exit_to_user_mode(regs);
 }
@@ -785,7 +787,7 @@ static void noinstr el0_interrupt(struct pt_regs *regs,
 {
 	enter_from_user_mode(regs);
 
-	write_sysreg(DAIF_PROCCTX_NOIRQ, daif);
+	local_nmi_disable();
 
 	if (regs->pc & BIT(55))
 		arm64_apply_bp_hardening();
@@ -797,24 +799,14 @@ static void noinstr el0_interrupt(struct pt_regs *regs,
 	exit_to_user_mode(regs);
 }
 
-static void noinstr __el0_irq_handler_common(struct pt_regs *regs)
-{
-	el0_interrupt(regs, handle_arch_irq);
-}
-
 asmlinkage void noinstr el0t_64_irq_handler(struct pt_regs *regs)
 {
-	__el0_irq_handler_common(regs);
-}
-
-static void noinstr __el0_fiq_handler_common(struct pt_regs *regs)
-{
-	el0_interrupt(regs, handle_arch_fiq);
+	el0_interrupt(regs, handle_arch_irq);
 }
 
 asmlinkage void noinstr el0t_64_fiq_handler(struct pt_regs *regs)
 {
-	__el0_fiq_handler_common(regs);
+	el0_interrupt(regs, handle_arch_fiq);
 }
 
 static void noinstr __el0_error_handler_common(struct pt_regs *regs)
@@ -822,11 +814,11 @@ static void noinstr __el0_error_handler_common(struct pt_regs *regs)
 	unsigned long esr = read_sysreg(esr_el1);
 
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_ERRCTX);
+	local_nmi_serror_disable();
 	arm64_enter_nmi(regs);
 	do_serror(regs, esr);
 	arm64_exit_nmi(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	exit_to_user_mode(regs);
 }
 
@@ -839,7 +831,7 @@ asmlinkage void noinstr el0t_64_error_handler(struct pt_regs *regs)
 static void noinstr el0_cp15(struct pt_regs *regs, unsigned long esr)
 {
 	enter_from_user_mode(regs);
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_el0_cp15(esr, regs);
 	exit_to_user_mode(regs);
 }
@@ -848,7 +840,7 @@ static void noinstr el0_svc_compat(struct pt_regs *regs)
 {
 	enter_from_user_mode(regs);
 	cortex_a76_erratum_1463225_svc_handler();
-	local_daif_restore(DAIF_PROCCTX);
+	local_irq_serror_enable();
 	do_el0_svc_compat(regs);
 	exit_to_user_mode(regs);
 }
@@ -899,12 +891,12 @@ asmlinkage void noinstr el0t_32_sync_handler(struct pt_regs *regs)
 
 asmlinkage void noinstr el0t_32_irq_handler(struct pt_regs *regs)
 {
-	__el0_irq_handler_common(regs);
+	el0_interrupt(regs, handle_arch_irq);
 }
 
 asmlinkage void noinstr el0t_32_fiq_handler(struct pt_regs *regs)
 {
-	__el0_fiq_handler_common(regs);
+	el0_interrupt(regs, handle_arch_fiq);
 }
 
 asmlinkage void noinstr el0t_32_error_handler(struct pt_regs *regs)
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c568b4ff9e62..e61ecb597905 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -316,8 +316,6 @@ alternative_else_nop_endif
 
 	mrs_s	x20, SYS_ICC_PMR_EL1
 	str	x20, [sp, #S_PMR_SAVE]
-	mov	x20, #GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET
-	msr_s	SYS_ICC_PMR_EL1, x20
 
 .Lskip_pmr_save\@:
 #endif
-- 
2.34.1

