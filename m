Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6397E1482FC
	for <kvmarm@lists.linux.dev>; Fri, 14 Jun 2024 03:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337154; cv=none; b=ErTzhI/EPtJ3fIiWUJUK6+BTHEy6ka4DwTNwAm+Ku/oN5bYCC23E88m8ywn/2wlBKaNnSqgrtsg1cP17jgi6VLjVTT9C9xkj6hkn2Jt6cXekGos9Maqp1f9QUKbz5okKpujLqPELDdBvGopMYLxo3aFyBSGY34V0Gs6LLxeYneM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337154; c=relaxed/simple;
	bh=KFKwgGk43N84VW8JJdJpFehGAuQ110plneYWm3zzzEQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PoqPmp8PahPG+dGk6mYp4uCsQBGPiZRp8AEIWWTHfBC1TIgdmudTE3CAVXgEA/9QHbIjqsODIpaOP69D0jk0Qbyxx+9XhuuqFzGtIVrFJY6OM5H4+5y+NyELgk99w2dwVg9NxmzOHaHh2sod/4Kj+SlK09YQrUyhc61jmdIexoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W0lcR4k4czxRVm;
	Fri, 14 Jun 2024 11:48:23 +0800 (CST)
Received: from kwepemd200013.china.huawei.com (unknown [7.221.188.133])
	by mail.maildlp.com (Postfix) with ESMTPS id EABD9180060;
	Fri, 14 Jun 2024 11:52:29 +0800 (CST)
Received: from huawei.com (10.67.174.28) by kwepemd200013.china.huawei.com
 (7.221.188.133) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 14 Jun
 2024 11:52:27 +0800
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
Subject: [PATCH v4 04/10] arm64: daifflags: Introduce logical interrupt masking
Date: Fri, 14 Jun 2024 03:44:27 +0000
Message-ID: <20240614034433.602622-5-liaochang1@huawei.com>
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

This patch introduces a series of functions for managing interrupt
masking on ARM64, adopting a "logical" approach. This approach builds
upon the suggestion made by Mark Rutland in th FEAT_NMI patchset [1] to
refactor DAIF management.

Implementation
--------------

- A new union data type is defined to represent the combined interrupt
  masking context, includes ICC_PMR, PSTATE.DAIF and PSTATE.ALLINT.

- New helper functions offer a similar interface (starting with
  "local_allint_") to their existing couterparts (starting with
  "local_daif_"), ensuing compatibility with existing code.

- For platform or kernel that does not support FEAT_NMI, this patch uses
  local_allint_save_flags() to determine NMI masking behavior instead of
  relying on the PSTATE.A field which is not a straightforward way to
  understand and maintain for kernel with PSEUDO_NMI enabled.

Benefits
--------

This patch introduces a robust approach for managing interrupt context,
it removes the need to explicitly check the PSTATE.A field to determine
NMIs masking status. Additionally, the new series of interrupt context
save/restore/mask/inherit functions uses names that reflect their
purpose directly, ensuring consistent behavior regardless of platform
support for FEAT_NMI or PSEUDO_NMI.

[1] https://lore.kernel.org/linux-arm-kernel/Y4sH5qX5bK9xfEBp@lpieralisi/

Signed-off-by: Liao Chang <liaochang1@huawei.com>
---
 arch/arm64/include/asm/daifflags.h   | 243 +++++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/ptrace.h |   1 +
 2 files changed, 244 insertions(+)

diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index 55f57dfa8e2f..5d502cc0dac2 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -141,4 +141,247 @@ static inline void local_daif_inherit(struct pt_regs *regs)
 	 */
 	write_sysreg(flags, daif);
 }
+
+/*
+ * For Arm64 processor support Armv8.8 or later, kernel supports three types
+ * of irqflags, they used for corresponding configuration depicted as below:
+ *
+ * 1. When CONFIG_ARM64_PSEUDO_NMI and CONFIG_ARM64_NMI are not 'y', kernel
+ *    does not support handling NMI.
+ *
+ * 2. When CONFIG_ARM64_PSEUDO_NMI=y and irqchip.gicv3_pseudo_nmi=1, kernel
+ *    makes use of the CPU Interface PMR and GIC priority feature to support
+ *    handling NMI.
+ *
+ * 3. When CONFIG_ARM64_NMI=y and irqchip.gicv3_pseudo_nmi is not enabled,
+ *    kernel makes use of the FEAT_NMI extension added since Armv8.8 to
+ *    support handling NMI.
+ *
+ * The table below depicts the relationship between fields in struct
+ * arch_irqflags and corresponding interrupt masking behavior reflected in
+ * hardware registers.
+ *
+ * Legend:
+ *  IRQ = IRQ and FIQ.
+ *  NMI = PSEUDO_NMI or IRQ with superpriority for ARMv8.8.
+ *    M = Interrupt is masked.
+ *    U = Interrupt is unmasked.
+ *    * = Non relevant.
+ *
+ * IRQ | NMI | SError | ICC_PMR_EL1                       | PSR.DAIF | PSR.ALLINT
+ * ------------------------------------------------------------------------------
+ *  U  |  U  |   *    | GIC_PRIO_IRQON                    | 0b **00  | 0b 0
+ * ------------------------------------------------------------------------------
+ *  M  |  U  |   *    | GIC_PRIO_IRQOFF                   | 0b **00  | 0b 0
+ * ------------------------------------------------------------------------------
+ *  M  |  M  |   *    | (GIC_PRIO_IRQON | GIC_PRIO_I_SET) | 0b **11  | 0b 1
+ * ------------------------------------------------------------------------------
+ *  M  |  M  |   M    | (GIC_PRIO_IRQON | GIC_PRIO_I_SET) | 0b *111  | 0b 1
+ */
+union arch_irqflags {
+	unsigned long flags;
+	struct {
+		unsigned long pmr : 8;     // SYS_ICC_PMR_EL1
+		unsigned long daif : 10;   // PSTATE.DAIF at bits[6-9]
+		unsigned long allint : 14; // PSTATE.ALLINT at bits[13]
+	} fields;
+};
+
+typedef union arch_irqflags arch_irqflags_t;
+
+static inline void __local_pmr_mask(void)
+{
+	WARN_ON(system_has_prio_mask_debugging() &&
+		(read_sysreg_s(SYS_ICC_PMR_EL1) ==
+		 (GIC_PRIO_IRQOFF | GIC_PRIO_PSR_I_SET)));
+	/*
+	 * Don't really care for a dsb here, we don't intend to enable
+	 * IRQs.
+	 */
+	gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
+}
+
+static inline void __local_nmi_mask(void)
+{
+	msr_pstate_allint(1);
+}
+
+static inline void local_allint_mask_notrace(void)
+{
+	asm volatile ("msr daifset, #0xf" : : : "memory");
+
+	if (system_uses_irq_prio_masking())
+		__local_pmr_mask();
+	else if (system_uses_nmi())
+		__local_nmi_mask();
+}
+
+static inline void local_allint_mask(void)
+{
+	local_allint_mask_notrace();
+	trace_hardirqs_off();
+}
+
+static inline arch_irqflags_t __local_save_pmr_daif_flags(void)
+{
+	arch_irqflags_t irqflags;
+
+	irqflags.fields.pmr = read_sysreg_s(SYS_ICC_PMR_EL1);
+	irqflags.fields.daif = read_sysreg(daif);
+
+	/*
+	 * If IRQs are masked with PMR, reflect it in the daif of irqflags.
+	 * If NMIs and IRQs are masked with PMR, reflect it in the allint
+	 * of irqflags, this avoid the need of checking PSTATE.A in
+	 * local_allint_restore() to determine if NMIs are masked.
+	 */
+	switch (irqflags.fields.pmr) {
+	case GIC_PRIO_IRQON:
+		irqflags.fields.allint = 0;
+		break;
+
+	case __GIC_PRIO_IRQOFF:
+	case __GIC_PRIO_IRQOFF_NS:
+		irqflags.fields.daif |= PSR_I_BIT | PSR_F_BIT;
+		irqflags.fields.allint = 0;
+		break;
+
+	case GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET:
+		irqflags.fields.daif |= PSR_I_BIT | PSR_F_BIT;
+		irqflags.fields.allint = PSR_ALLINT_BIT;
+		break;
+
+	default:
+		WARN_ON(1);
+	}
+
+	return irqflags;
+}
+
+static inline arch_irqflags_t __local_save_nmi_daif_flags(void)
+{
+	arch_irqflags_t irqflags;
+
+	irqflags.fields.daif = read_sysreg(daif);
+	irqflags.fields.allint = read_sysreg_s(SYS_ALLINT);
+
+	return irqflags;
+}
+
+static inline arch_irqflags_t local_allint_save_flags(void)
+{
+	arch_irqflags_t irqflags = { .flags = 0UL };
+
+	if (system_uses_irq_prio_masking())
+		return __local_save_pmr_daif_flags();
+
+	if (system_uses_nmi())
+		return __local_save_nmi_daif_flags();
+
+	irqflags.fields.daif = read_sysreg(daif);
+	return irqflags;
+}
+
+static inline arch_irqflags_t local_allint_save(void)
+{
+	arch_irqflags_t irqflags;
+
+	irqflags = local_allint_save_flags();
+
+	local_allint_mask();
+
+	return irqflags;
+}
+
+static inline void __local_pmr_restore(arch_irqflags_t irqflags)
+{
+	/*
+	 * There has been concern that the write to daif
+	 * might be reordered before this write to PMR.
+	 * From the ARM ARM DDI 0487D.a, section D1.7.1
+	 * "Accessing PSTATE fields":
+	 *   Writes to the PSTATE fields have side-effects on
+	 *   various aspects of the PE operation. All of these
+	 *   side-effects are guaranteed:
+	 *     - Not to be visible to earlier instructions in
+	 *       the execution stream.
+	 *     - To be visible to later instructions in the
+	 *       execution stream
+	 *
+	 * Also, writes to PMR are self-synchronizing, so no
+	 * interrupts with a lower priority than PMR is signaled
+	 * to the PE after the write.
+	 *
+	 * So we don't need additional synchronization here.
+	 */
+	gic_write_pmr(irqflags.fields.pmr);
+}
+
+static inline void __local_nmi_restore(arch_irqflags_t irqflags)
+{
+	msr_pstate_allint(!!irqflags.fields.allint ? 1 : 0);
+}
+
+static inline int local_hardirqs_disabled(arch_irqflags_t irqflags)
+{
+	return irqflags.fields.allint || (irqflags.fields.daif & PSR_I_BIT);
+}
+
+static inline void __local_allint_restore(arch_irqflags_t irqflags)
+{
+	if (system_uses_irq_prio_masking())
+		__local_pmr_restore(irqflags);
+	else if (system_uses_nmi())
+		__local_nmi_restore(irqflags);
+
+	write_sysreg(irqflags.fields.daif, daif);
+}
+
+static inline void local_allint_restore_notrace(arch_irqflags_t irqflags)
+{
+	/*
+	 * Use arch_allint.fields.allint to indicates we can take
+	 * NMIs, instead of the old hacking style that use PSTATE.A.
+	 */
+	if (system_uses_irq_prio_masking() && !irqflags.fields.allint)
+		irqflags.fields.daif &= ~(PSR_I_BIT | PSR_F_BIT);
+
+	__local_allint_restore(irqflags);
+}
+
+/*
+ * It has to conside the different kernel configure and parameters, that need
+ * to use corresponding operations to mask interrupts properly. For example,
+ * the kernel disable PSEUDO_NMI, the kernel uses prio masking to support
+ * PSEUDO_NMI, or the kernel uses FEAT_NMI extension to support ARM64_NMI.
+ */
+static inline void local_allint_restore(arch_irqflags_t irqflags)
+{
+	int irq_disabled = local_hardirqs_disabled(irqflags);
+
+	if (!irq_disabled)
+		trace_hardirqs_on();
+
+	local_allint_restore_notrace(irqflags);
+
+	if (irq_disabled)
+		trace_hardirqs_off();
+}
+
+/*
+ * Called by synchronous exception handlers to restore the DAIF bits that were
+ * modified by taking an exception.
+ */
+static inline void local_allint_inherit(struct pt_regs *regs)
+{
+	arch_irqflags_t irqflags;
+
+	if (interrupts_enabled(regs))
+		trace_hardirqs_on();
+
+	irqflags.fields.pmr = regs->pmr_save;
+	irqflags.fields.daif = regs->pstate & DAIF_MASK;
+	irqflags.fields.allint = regs->pstate & PSR_ALLINT_BIT;
+	__local_allint_restore(irqflags);
+}
 #endif
diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index 7fa2f7036aa7..8a125a1986be 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -48,6 +48,7 @@
 #define PSR_D_BIT	0x00000200
 #define PSR_BTYPE_MASK	0x00000c00
 #define PSR_SSBS_BIT	0x00001000
+#define PSR_ALLINT_BIT	0x00002000
 #define PSR_PAN_BIT	0x00400000
 #define PSR_UAO_BIT	0x00800000
 #define PSR_DIT_BIT	0x01000000
-- 
2.34.1

