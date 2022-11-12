Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBA6184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBFFC433D6;
	Sat, 12 Nov 2022 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266309;
	bh=mv4+zFUZCNEx7/Ymk22vpOPV8ZnwX7HiMj0PQ7QQ4QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF3noOYu7648H22CdCS7iTmswjymT3FP3go7buAqFmwvxoj2kbIGQDDKhS39MBrNA
	 uy8heytG0vu7c9V1LYSTUP6kQeaiepQ/uFMKkav8Q7a9WwtS5aufjk4C91Cir9zo1W
	 7RXz7ro7pdErg+bYv/3yCHVqKmDMNN3eFjWnr2XJYUhl4UcBpd3/GCwZZZ99Stnx81
	 ikiWEaHsyjpaLMKim+bcHWKgxtODoYWaKa0EUBaXpBm9O4MmsAMnOidI3kai3e0iM/
	 S6N+DbgGdufbvgE3XzZ+wCr5Xjgrxlj4hH9WIV/KPl3O6u2On1pTgeQoc0zCpxAzCo
	 kIuDh7wr+HIzA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sami Mujawar <Sami.Mujawar@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 14/14] irqchip/gic-v3: Implement FEAT_GICv3_NMI support
Date: Sat, 12 Nov 2022 15:17:08 +0000
Message-Id: <20221112151708.175147-15-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9704; i=broonie@kernel.org; h=from:subject; bh=mOo/Sb1eDrEuHkwJs8XKvy1E3moh4mSCudKUV2VjYyw=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7jztnqPD/LVQz3Zes0xAcsoM7EhiP4x5GNPJT+0 3Exe6y2JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+48wAKCRAk1otyXVSH0Ft/B/ 4uUUkHnuUs7v9OzX2fuL0giwLgg2gpXPVDed0JdVIASre/mj0X3sdK02vUqCmeR/d4n0sED8Qmmxv0 OETi6NUFLxOU5Nb+QjRfCc8NZ1WXeigmx6c+ciqfSITqljsPqe4c4wf5pqBgbQKr5+tKuvm6LkTdLA erVaxKUqo+HS/ExSeSkFoiNS258kM8FKvUVjO6OXUPgi921dpzK70LEr3iPB86YZBS2IAZ3BuV+JFn CpkErKYlzYhw6nERRnHenQBkNV28GTlBC0CdC776+/qVui3OYd+Nfv8ETUOWZK8bVQC+GILZWHCbYr /yMZ1cEi9Cmx4kAlJRoSDEnc9vvPkc
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

The FEAT_GICv3_NMI GIC feature coupled with the CPU FEAT_NMI enables
handling NMI interrupts in HW on aarch64, by adding a superpriority
interrupt to the existing GIC priority scheme.

Implement GIC driver support for the FEAT_GICv3_NMI feature.

Rename gic_supports_nmi() helper function to gic_supports_pseudo_nmis()
to make the pseudo NMIs code path clearer and more explicit.

Check, through the ARM64 capabilitity infrastructure, if support
for FEAT_NMI was detected on the core and the system has not overridden
the detection and forced pseudo-NMIs enablement.

If FEAT_NMI is detected, it was not overridden (check embedded in the
system_uses_nmi() call) and the GIC supports the FEAT_GICv3_NMI feature,
install an NMI handler and initialize NMIs related HW GIC registers.

Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c       | 143 ++++++++++++++++++++++++-----
 include/linux/irqchip/arm-gic-v3.h |   4 +
 2 files changed, 125 insertions(+), 22 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 34d58567b78d..dc45e1093e7b 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -54,6 +54,7 @@ struct gic_chip_data {
 	u32			nr_redist_regions;
 	u64			flags;
 	bool			has_rss;
+	bool			has_nmi;
 	unsigned int		ppi_nr;
 	struct partition_desc	**ppi_descs;
 };
@@ -145,6 +146,20 @@ enum gic_intid_range {
 	__INVALID_RANGE__
 };
 
+#ifdef CONFIG_ARM64
+#include <asm/cpufeature.h>
+
+static inline bool has_v3_3_nmi(void)
+{
+	return gic_data.has_nmi && system_uses_nmi();
+}
+#else
+static inline bool has_v3_3_nmi(void)
+{
+	return false;
+}
+#endif
+
 static enum gic_intid_range __get_intid_range(irq_hw_number_t hwirq)
 {
 	switch (hwirq) {
@@ -350,6 +365,42 @@ static int gic_peek_irq(struct irq_data *d, u32 offset)
 	return !!(readl_relaxed(base + offset + (index / 32) * 4) & mask);
 }
 
+static DEFINE_RAW_SPINLOCK(irq_controller_lock);
+
+static void gic_irq_configure_nmi(struct irq_data *d, bool enable)
+{
+	void __iomem *base, *addr;
+	u32 offset, index, mask, val;
+
+	offset = convert_offset_index(d, GICD_INMIR, &index);
+	mask = 1 << (index % 32);
+
+	if (gic_irq_in_rdist(d))
+		base = gic_data_rdist_sgi_base();
+	else
+		base = gic_data.dist_base;
+
+	addr = base + offset + (index / 32) * 4;
+
+	raw_spin_lock(&irq_controller_lock);
+
+	val = readl_relaxed(addr);
+	val = enable ? (val | mask) : (val & ~mask);
+	writel_relaxed(val, addr);
+
+	raw_spin_unlock(&irq_controller_lock);
+}
+
+static void gic_irq_enable_nmi(struct irq_data *d)
+{
+	gic_irq_configure_nmi(d, true);
+}
+
+static void gic_irq_disable_nmi(struct irq_data *d)
+{
+	gic_irq_configure_nmi(d, false);
+}
+
 static void gic_poke_irq(struct irq_data *d, u32 offset)
 {
 	void __iomem *base;
@@ -395,7 +446,7 @@ static void gic_unmask_irq(struct irq_data *d)
 	gic_poke_irq(d, GICD_ISENABLER);
 }
 
-static inline bool gic_supports_nmi(void)
+static inline bool gic_supports_pseudo_nmis(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) &&
 	       static_branch_likely(&supports_pseudo_nmis);
@@ -491,7 +542,7 @@ static int gic_irq_nmi_setup(struct irq_data *d)
 {
 	struct irq_desc *desc = irq_to_desc(d->irq);
 
-	if (!gic_supports_nmi())
+	if (!gic_supports_pseudo_nmis() && !has_v3_3_nmi())
 		return -EINVAL;
 
 	if (gic_peek_irq(d, GICD_ISENABLER)) {
@@ -519,7 +570,10 @@ static int gic_irq_nmi_setup(struct irq_data *d)
 		desc->handle_irq = handle_fasteoi_nmi;
 	}
 
-	gic_irq_set_prio(d, GICD_INT_NMI_PRI);
+	if (has_v3_3_nmi())
+		gic_irq_enable_nmi(d);
+	else
+		gic_irq_set_prio(d, GICD_INT_NMI_PRI);
 
 	return 0;
 }
@@ -528,7 +582,7 @@ static void gic_irq_nmi_teardown(struct irq_data *d)
 {
 	struct irq_desc *desc = irq_to_desc(d->irq);
 
-	if (WARN_ON(!gic_supports_nmi()))
+	if (WARN_ON(!gic_supports_pseudo_nmis() && !has_v3_3_nmi()))
 		return;
 
 	if (gic_peek_irq(d, GICD_ISENABLER)) {
@@ -554,7 +608,10 @@ static void gic_irq_nmi_teardown(struct irq_data *d)
 		desc->handle_irq = handle_fasteoi_irq;
 	}
 
-	gic_irq_set_prio(d, GICD_INT_DEF_PRI);
+	if (has_v3_3_nmi())
+		gic_irq_disable_nmi(d);
+	else
+		gic_irq_set_prio(d, GICD_INT_DEF_PRI);
 }
 
 static void gic_eoi_irq(struct irq_data *d)
@@ -674,7 +731,7 @@ static inline void gic_complete_ack(u32 irqnr)
 
 static bool gic_rpr_is_nmi_prio(void)
 {
-	if (!gic_supports_nmi())
+	if (!gic_supports_pseudo_nmis())
 		return false;
 
 	return unlikely(gic_read_rpr() == GICD_INT_RPR_PRI(GICD_INT_NMI_PRI));
@@ -706,7 +763,8 @@ static void __gic_handle_nmi(u32 irqnr, struct pt_regs *regs)
 	gic_complete_ack(irqnr);
 
 	if (generic_handle_domain_nmi(gic_data.domain, irqnr)) {
-		WARN_ONCE(true, "Unexpected pseudo-NMI (irqnr %u)\n", irqnr);
+		WARN_ONCE(true, "Unexpected %sNMI (irqnr %u)\n",
+			  gic_supports_pseudo_nmis() ? "pseudo-" : "", irqnr);
 		gic_deactivate_unhandled(irqnr);
 	}
 }
@@ -782,9 +840,37 @@ static void __gic_handle_irq_from_irqsoff(struct pt_regs *regs)
 	__gic_handle_nmi(irqnr, regs);
 }
 
+#ifdef CONFIG_ARM64
+static inline u64 gic_read_nmiar(void)
+{
+	u64 irqstat;
+
+	irqstat = read_sysreg_s(SYS_ICC_NMIAR1_EL1);
+
+	dsb(sy);
+
+	return irqstat;
+}
+
+static asmlinkage void __exception_irq_entry gic_handle_nmi_irq(struct pt_regs *regs)
+{
+	u32 irqnr = gic_read_nmiar();
+
+	__gic_handle_nmi(irqnr, regs);
+}
+
+static inline void gic_setup_nmi_handler(void)
+{
+	if (has_v3_3_nmi())
+		set_handle_nmi_irq(gic_handle_nmi_irq);
+}
+#else
+static inline void gic_setup_nmi_handler(void) { }
+#endif
+
 static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 {
-	if (unlikely(gic_supports_nmi() && !interrupts_enabled(regs)))
+	if (unlikely(gic_supports_pseudo_nmis() && !interrupts_enabled(regs)))
 		__gic_handle_irq_from_irqsoff(regs);
 	else
 		__gic_handle_irq_from_irqson(regs);
@@ -1072,7 +1158,7 @@ static void gic_cpu_sys_reg_init(void)
 	/* Set priority mask register */
 	if (!gic_prio_masking_enabled()) {
 		write_gicreg(DEFAULT_PMR_VALUE, ICC_PMR_EL1);
-	} else if (gic_supports_nmi()) {
+	} else if (gic_supports_pseudo_nmis()) {
 		/*
 		 * Mismatch configuration with boot CPU, the system is likely
 		 * to die as interrupt masking will not work properly on all
@@ -1753,20 +1839,8 @@ static const struct gic_quirk gic_quirks[] = {
 	}
 };
 
-static void gic_enable_nmi_support(void)
+static void gic_enable_pseudo_nmis(void)
 {
-	int i;
-
-	if (!gic_prio_masking_enabled())
-		return;
-
-	ppi_nmi_refs = kcalloc(gic_data.ppi_nr, sizeof(*ppi_nmi_refs), GFP_KERNEL);
-	if (!ppi_nmi_refs)
-		return;
-
-	for (i = 0; i < gic_data.ppi_nr; i++)
-		refcount_set(&ppi_nmi_refs[i], 0);
-
 	/*
 	 * Linux itself doesn't use 1:N distribution, so has no need to
 	 * set PMHE. The only reason to have it set is if EL3 requires it
@@ -1809,6 +1883,28 @@ static void gic_enable_nmi_support(void)
 		static_branch_enable(&gic_nonsecure_priorities);
 
 	static_branch_enable(&supports_pseudo_nmis);
+}
+
+static void gic_enable_nmi_support(void)
+{
+	int i;
+
+	if (!gic_prio_masking_enabled() && !has_v3_3_nmi())
+		return;
+
+	ppi_nmi_refs = kcalloc(gic_data.ppi_nr, sizeof(*ppi_nmi_refs), GFP_KERNEL);
+	if (!ppi_nmi_refs)
+		return;
+
+	for (i = 0; i < gic_data.ppi_nr; i++)
+		refcount_set(&ppi_nmi_refs[i], 0);
+
+	/*
+	 * Initialize pseudo-NMIs only if GIC driver cannot take advantage
+	 * of core (FEAT_NMI) and GIC (FEAT_GICv3_NMI) in HW
+	 */
+	if (!has_v3_3_nmi())
+		gic_enable_pseudo_nmis();
 
 	if (static_branch_likely(&supports_deactivate_key))
 		gic_eoimode1_chip.flags |= IRQCHIP_SUPPORTS_NMI;
@@ -1872,6 +1968,7 @@ static int __init gic_init_bases(void __iomem *dist_base,
 	irq_domain_update_bus_token(gic_data.domain, DOMAIN_BUS_WIRED);
 
 	gic_data.has_rss = !!(typer & GICD_TYPER_RSS);
+	gic_data.has_nmi = !!(typer & GICD_TYPER_NMI);
 
 	if (typer & GICD_TYPER_MBIS) {
 		err = mbi_init(handle, gic_data.domain);
@@ -1881,6 +1978,8 @@ static int __init gic_init_bases(void __iomem *dist_base,
 
 	set_handle_irq(gic_handle_irq);
 
+	gic_setup_nmi_handler();
+
 	gic_update_rdist_properties();
 
 	gic_dist_init();
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 728691365464..3306456c135f 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -30,6 +30,7 @@
 #define GICD_ICFGR			0x0C00
 #define GICD_IGRPMODR			0x0D00
 #define GICD_NSACR			0x0E00
+#define GICD_INMIR			0x0F80
 #define GICD_IGROUPRnE			0x1000
 #define GICD_ISENABLERnE		0x1200
 #define GICD_ICENABLERnE		0x1400
@@ -39,6 +40,7 @@
 #define GICD_ICACTIVERnE		0x1C00
 #define GICD_IPRIORITYRnE		0x2000
 #define GICD_ICFGRnE			0x3000
+#define GICD_INMIRnE			0x3B00
 #define GICD_IROUTER			0x6000
 #define GICD_IROUTERnE			0x8000
 #define GICD_IDREGS			0xFFD0
@@ -83,6 +85,7 @@
 #define GICD_TYPER_LPIS			(1U << 17)
 #define GICD_TYPER_MBIS			(1U << 16)
 #define GICD_TYPER_ESPI			(1U << 8)
+#define GICD_TYPER_NMI			(1U << 9)
 
 #define GICD_TYPER_ID_BITS(typer)	((((typer) >> 19) & 0x1f) + 1)
 #define GICD_TYPER_NUM_LPIS(typer)	((((typer) >> 11) & 0x1f) + 1)
@@ -238,6 +241,7 @@
 #define GICR_ICFGR0			GICD_ICFGR
 #define GICR_IGRPMODR0			GICD_IGRPMODR
 #define GICR_NSACR			GICD_NSACR
+#define GICR_INMIR0			GICD_INMIR
 
 #define GICR_TYPER_PLPIS		(1U << 0)
 #define GICR_TYPER_VLPIS		(1U << 1)
-- 
2.30.2

