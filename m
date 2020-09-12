Return-Path: <SRS0=P1KX=CV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D1C9C43461
	for <kvmarm@archiver.kernel.org>; Sat, 12 Sep 2020 15:36:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7D9AD207C3
	for <kvmarm@archiver.kernel.org>; Sat, 12 Sep 2020 15:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D9AD207C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 184F34B6B7;
	Sat, 12 Sep 2020 11:36:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dgF77gKgAwqY; Sat, 12 Sep 2020 11:36:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E890E4B62B;
	Sat, 12 Sep 2020 11:36:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F38D4B5BB
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Sep 2020 11:36:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rHnYIoccPF6w for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Sep 2020 11:36:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7DEA4B62B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Sep 2020 11:36:12 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 802C51396;
 Sat, 12 Sep 2020 08:36:12 -0700 (PDT)
Received: from monolith.localdoman (unknown [10.37.8.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 208663F68F;
 Sat, 12 Sep 2020 08:36:10 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 2/2] irqchip/gic-v3: Support pseudo-NMIs when SCR_EL3.FIQ
 == 0
Date: Sat, 12 Sep 2020 16:37:07 +0100
Message-Id: <20200912153707.667731-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200912153707.667731-1-alexandru.elisei@arm.com>
References: <20200912153707.667731-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, tglx@linutronix.de, will@kernel.org, jason@lakedaemon.net,
 catalin.marinas@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The GIC's internal view of the priority mask register and the assigned
interrupt priorities are based on whether GIC security is enabled and
whether firmware routes Group 0 interrupts to EL3. At the moment, we
support priority masking when ICC_PMR_EL1 and interrupt priorities are
either both modified by the GIC, or both left unchanged.

Trusted Firmware-A's default interrupt routing model allows Group 0
interrupts to be delivered to the non-secure world (SCR_EL3.FIQ == 0).
Unfortunately, this is precisely the case that the GIC driver doesn't
support: ICC_PMR_EL1 remains unchanged, but the GIC's view of interrupt
priorities is different from the software programmed values.

Support pseudo-NMIs when SCR_EL3.FIQ == 0 by using a different value to
mask regular interrupts. All the other values remain the same.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/arch_gicv3.h |  8 ++++-
 arch/arm64/include/asm/ptrace.h     | 14 +++++++-
 arch/arm64/kernel/image-vars.h      |  2 ++
 drivers/irqchip/irq-gic-v3.c        | 56 ++++++++++++++++++++++-------
 4 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 6647ae4f0231..880b9054d75c 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -153,7 +153,7 @@ static inline bool gic_prio_masking_enabled(void)
 
 static inline void gic_pmr_mask_irqs(void)
 {
-	BUILD_BUG_ON(GICD_INT_DEF_PRI < (GIC_PRIO_IRQOFF |
+	BUILD_BUG_ON(GICD_INT_DEF_PRI < (__GIC_PRIO_IRQOFF |
 					 GIC_PRIO_PSR_I_SET));
 	BUILD_BUG_ON(GICD_INT_DEF_PRI >= GIC_PRIO_IRQON);
 	/*
@@ -162,6 +162,12 @@ static inline void gic_pmr_mask_irqs(void)
 	 * are applied to IRQ priorities
 	 */
 	BUILD_BUG_ON((0x80 | (GICD_INT_DEF_PRI >> 1)) >= GIC_PRIO_IRQON);
+	/*
+	 * Same situation as above, but now we make sure that we can mask
+	 * regular interrupts.
+	 */
+	BUILD_BUG_ON((0x80 | (GICD_INT_DEF_PRI >> 1)) < (__GIC_PRIO_IRQOFF_NS |
+							 GIC_PRIO_PSR_I_SET));
 	gic_write_pmr(GIC_PRIO_IRQOFF);
 }
 
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 966ed30ed5f7..997cf8c8cd52 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -31,9 +31,21 @@
  * interrupt disabling temporarily does not rely on IRQ priorities.
  */
 #define GIC_PRIO_IRQON			0xe0
-#define GIC_PRIO_IRQOFF			(GIC_PRIO_IRQON & ~0x80)
+#define __GIC_PRIO_IRQOFF		(GIC_PRIO_IRQON & ~0x80)
+#define __GIC_PRIO_IRQOFF_NS		0xa0
 #define GIC_PRIO_PSR_I_SET		(1 << 4)
 
+#define GIC_PRIO_IRQOFF							\
+	({								\
+		extern struct static_key_false gic_nonsecure_priorities;\
+		u8 __prio = __GIC_PRIO_IRQOFF;				\
+									\
+		if (static_branch_unlikely(&gic_nonsecure_priorities))	\
+			__prio = __GIC_PRIO_IRQOFF_NS;			\
+									\
+		__prio;							\
+	})
+
 /* Additional SPSR bits not exposed in the UABI */
 #define PSR_MODE_THREAD_BIT	(1 << 0)
 #define PSR_IL_BIT		(1 << 20)
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8982b68289b7..98a5215c1598 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -101,6 +101,8 @@ KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
 /* Static key checked in pmr_sync(). */
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 KVM_NVHE_ALIAS(gic_pmr_sync);
+/* Static key checked in GIC_PRIO_IRQOFF. */
+KVM_NVHE_ALIAS(gic_nonsecure_priorities);
 #endif
 
 /* EL2 exception handling */
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index aa9b43d412b2..bb55d89d7d49 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -75,16 +75,14 @@ static DEFINE_STATIC_KEY_TRUE(supports_deactivate_key);
  *
  * If SCR_EL3.FIQ == 1, the values writen to/read from PMR and RPR at non-secure
  * EL1 are subject to a similar operation thus matching the priorities presented
- * from the (re)distributor when security is enabled.
+ * from the (re)distributor when security is enabled. When SCR_EL3.FIQ == 0,
+ * these values are unchanched by the GIC.
  *
  * see GICv3/GICv4 Architecture Specification (IHI0069D):
  * - section 4.8.1 Non-secure accesses to register fields for Secure interrupt
  *   priorities.
  * - Figure 4-7 Secure read of the priority field for a Non-secure Group 1
  *   interrupt.
- *
- * For now, we only support pseudo-NMIs if we have non-secure view of
- * priorities.
  */
 static DEFINE_STATIC_KEY_FALSE(supports_pseudo_nmis);
 
@@ -97,6 +95,9 @@ static DEFINE_STATIC_KEY_FALSE(supports_pseudo_nmis);
 DEFINE_STATIC_KEY_FALSE(gic_pmr_sync);
 EXPORT_SYMBOL(gic_pmr_sync);
 
+DEFINE_STATIC_KEY_FALSE(gic_nonsecure_priorities);
+EXPORT_SYMBOL(gic_nonsecure_priorities);
+
 /* ppi_nmi_refs[n] == number of cpus having ppi[n + 16] set as NMI */
 static refcount_t *ppi_nmi_refs;
 
@@ -932,14 +933,20 @@ static void gic_cpu_sys_reg_init(void)
 	/* Set priority mask register */
 	if (!gic_prio_masking_enabled()) {
 		write_gicreg(DEFAULT_PMR_VALUE, ICC_PMR_EL1);
-	} else {
+	} else if (gic_supports_nmi()) {
 		/*
 		 * Mismatch configuration with boot CPU, the system is likely
 		 * to die as interrupt masking will not work properly on all
 		 * CPUs
+		 *
+		 * The boot CPU calls this function before enabling NMI support,
+		 * and as a result we'll never see this warning in the boot path
+		 * for that CPU.
 		 */
-		WARN_ON(gic_supports_nmi() && group0 &&
-			!gic_dist_security_disabled());
+		if (static_branch_unlikely(&gic_nonsecure_priorities))
+			WARN_ON(!group0 || gic_dist_security_disabled());
+		else
+			WARN_ON(group0 && !gic_dist_security_disabled());
 	}
 
 	/*
@@ -1544,11 +1551,6 @@ static void gic_enable_nmi_support(void)
 	if (!gic_prio_masking_enabled())
 		return;
 
-	if (gic_has_group0() && !gic_dist_security_disabled()) {
-		pr_warn("SCR_EL3.FIQ is cleared, cannot enable use of pseudo-NMIs\n");
-		return;
-	}
-
 	ppi_nmi_refs = kcalloc(gic_data.ppi_nr, sizeof(*ppi_nmi_refs), GFP_KERNEL);
 	if (!ppi_nmi_refs)
 		return;
@@ -1567,6 +1569,36 @@ static void gic_enable_nmi_support(void)
 	pr_info("Pseudo-NMIs enabled using %s ICC_PMR_EL1 synchronisation\n",
 		static_branch_unlikely(&gic_pmr_sync) ? "forced" : "relaxed");
 
+	/*
+	 * How priority values are used by the GIC depends on two things:
+	 * the security state of the GIC (controlled by the GICD_CTRL.DS bit)
+	 * and if Group 0 interrupts can be delivered to Linux in the non-secure
+	 * world as FIQs (controlled by the SCR_EL3.FIQ bit). These affect the
+	 * the ICC_PMR_EL1 register and the priority that software assigns to
+	 * interrupts:
+	 *
+	 * GICD_CTRL.DS | SCR_EL3.FIQ | ICC_PMR_EL1 | Group 1 priority
+	 * -----------------------------------------------------------
+	 *      1       |      -      |  unchanged  |    unchanged
+	 * -----------------------------------------------------------
+	 *      0       |      1      |  non-secure |    non-secure
+	 * -----------------------------------------------------------
+	 *      0       |      0      |  unchanged  |    non-secure
+	 *
+	 * where non-secure means that the value is right-shifted by one and the
+	 * MSB bit set, to make it fit in the non-secure priority range.
+	 *
+	 * In the first two cases, where ICC_PMR_EL1 and the interrupt priority
+	 * are both either modified or unchanged, we can use the same set of
+	 * priorities.
+	 *
+	 * In the last case, where only the interrupt priorities are modified to
+	 * be in the non-secure range, we use a different PMR value to mask IRQs
+	 * and the rest of the values that we use remain unchanged.
+	 */
+	if (gic_has_group0() && !gic_dist_security_disabled())
+		static_branch_enable(&gic_nonsecure_priorities);
+
 	static_branch_enable(&supports_pseudo_nmis);
 
 	if (static_branch_likely(&supports_deactivate_key))
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
