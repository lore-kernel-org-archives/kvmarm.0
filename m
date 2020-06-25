Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FEEC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 15:00:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E101820781
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 15:00:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E101820781
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 756794B503;
	Thu, 25 Jun 2020 11:00:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dWiOoJ3oq-Nx; Thu, 25 Jun 2020 11:00:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2ABD4B50F;
	Thu, 25 Jun 2020 10:59:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B89494B50F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 10:59:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pZbsiMwpqSIe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 10:59:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D94CD4B4EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 10:59:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C65F1045;
 Thu, 25 Jun 2020 07:59:56 -0700 (PDT)
Received: from monolith.arm.com (unknown [10.37.8.55])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87E603F6CF;
 Thu, 25 Jun 2020 07:59:54 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/2] irqchip/gic-v3: Support pseudo-NMIs when SCR_EL3.FIQ == 0
Date: Thu, 25 Jun 2020 16:00:26 +0100
Message-Id: <20200625150026.867727-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625150026.867727-1-alexandru.elisei@arm.com>
References: <20200625150026.867727-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: jason@lakedaemon.net, maz@kernel.org, catalin.marinas@arm.com,
 tglx@linutronix.de, will@kernel.org
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
 arch/arm64/include/asm/daifflags.h  |  4 +--
 arch/arm64/include/asm/irqflags.h   | 14 +++++---
 arch/arm64/include/asm/ptrace.h     | 12 +++++++
 arch/arm64/kernel/entry.S           |  2 +-
 arch/arm64/kvm/hyp/switch.c         |  2 +-
 drivers/irqchip/irq-gic-v3.c        | 52 ++++++++++++++++++++++-------
 7 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index a358e97572c1..c2a67a81e39d 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -162,7 +162,13 @@ static inline void gic_pmr_mask_irqs(void)
 	 * are applied to IRQ priorities
 	 */
 	BUILD_BUG_ON((0x80 | (GICD_INT_DEF_PRI >> 1)) >= GIC_PRIO_IRQON);
-	gic_write_pmr(GIC_PRIO_IRQOFF);
+	/*
+	 * Same situation as above, but now we make sure that we can mask
+	 * regular interrupts.
+	 */
+	BUILD_BUG_ON((0x80 | (GICD_INT_DEF_PRI >> 1)) < (GIC_PRIO_IRQOFF_NS |
+							 GIC_PRIO_PSR_I_SET));
+	gic_write_pmr(gic_prio_irqoff());
 }
 
 static inline void gic_arch_enable_irqs(void)
diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index ec213b4a1650..3efa240a6c48 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -22,7 +22,7 @@
 static inline void local_daif_mask(void)
 {
 	WARN_ON(system_has_prio_mask_debugging() &&
-		(read_sysreg_s(SYS_ICC_PMR_EL1) == (GIC_PRIO_IRQOFF |
+		(read_sysreg_s(SYS_ICC_PMR_EL1) == (gic_prio_irqoff() |
 						    GIC_PRIO_PSR_I_SET)));
 
 	asm volatile(
@@ -87,7 +87,7 @@ static inline void local_daif_restore(unsigned long flags)
 			 * asynchronous errors, we can take NMIs
 			 */
 			flags &= ~PSR_I_BIT;
-			pmr = GIC_PRIO_IRQOFF;
+			pmr = gic_prio_irqoff();
 		} else {
 			pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
 		}
diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index aa4b6521ef14..dc68e11c63a1 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -28,10 +28,13 @@
  */
 static inline void arch_local_irq_enable(void)
 {
+	u32 pmr_irqon = GIC_PRIO_IRQON;
+
 	if (system_has_prio_mask_debugging()) {
 		u32 pmr = read_sysreg_s(SYS_ICC_PMR_EL1);
+		u32 pmr_irqoff = gic_prio_irqoff();
 
-		WARN_ON_ONCE(pmr != GIC_PRIO_IRQON && pmr != GIC_PRIO_IRQOFF);
+		WARN_ON_ONCE(pmr != pmr_irqon && pmr != pmr_irqoff);
 	}
 
 	asm volatile(ALTERNATIVE(
@@ -39,7 +42,7 @@ static inline void arch_local_irq_enable(void)
 		__msr_s(SYS_ICC_PMR_EL1, "%0"),
 		ARM64_HAS_IRQ_PRIO_MASKING)
 		:
-		: "r" ((unsigned long) GIC_PRIO_IRQON)
+		: "r" (pmr_irqon)
 		: "memory");
 
 	pmr_sync();
@@ -47,10 +50,13 @@ static inline void arch_local_irq_enable(void)
 
 static inline void arch_local_irq_disable(void)
 {
+	u32 pmr_irqoff = gic_prio_irqoff();
+
 	if (system_has_prio_mask_debugging()) {
 		u32 pmr = read_sysreg_s(SYS_ICC_PMR_EL1);
+		u32 pmr_irqon = GIC_PRIO_IRQON;
 
-		WARN_ON_ONCE(pmr != GIC_PRIO_IRQON && pmr != GIC_PRIO_IRQOFF);
+		WARN_ON_ONCE(pmr != pmr_irqon && pmr != pmr_irqoff);
 	}
 
 	asm volatile(ALTERNATIVE(
@@ -58,7 +64,7 @@ static inline void arch_local_irq_disable(void)
 		__msr_s(SYS_ICC_PMR_EL1, "%0"),
 		ARM64_HAS_IRQ_PRIO_MASKING)
 		:
-		: "r" ((unsigned long) GIC_PRIO_IRQOFF)
+		: "r" (pmr_irqoff)
 		: "memory");
 }
 
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 953b6a1ce549..ad58f05544a1 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -32,6 +32,7 @@
  */
 #define GIC_PRIO_IRQON			0xe0
 #define GIC_PRIO_IRQOFF			(GIC_PRIO_IRQON & ~0x80)
+#define GIC_PRIO_IRQOFF_NS		0xa0
 #define GIC_PRIO_PSR_I_SET		(1 << 4)
 
 /* Additional SPSR bits not exposed in the UABI */
@@ -129,6 +130,17 @@
 #define compat_sp_fiq	regs[29]
 #define compat_lr_fiq	regs[30]
 
+#define gic_prio_irqoff()						\
+	({								\
+		extern struct static_key_false gic_nonsecure_priorities;\
+		u8 __prio = GIC_PRIO_IRQOFF;				\
+									\
+		if (static_branch_unlikely(&gic_nonsecure_priorities))	\
+			__prio = GIC_PRIO_IRQOFF_NS;			\
+									\
+		__prio;							\
+	})
+
 static inline unsigned long compat_psr_to_pstate(const unsigned long psr)
 {
 	unsigned long pstate;
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 5304d193c79d..73654234f454 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -643,7 +643,7 @@ alternative_else_nop_endif
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 	/*
 	 * When using IRQ priority masking, we can get spurious interrupts while
-	 * PMR is set to GIC_PRIO_IRQOFF. An NMI might also have occurred in a
+	 * PMR is set to mask interrupts. An NMI might also have occurred in a
 	 * section with interrupts disabled. Skip tracing in those cases.
 	 */
 	test_irqs_unmasked	res=x0, pmr=x20
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index db1c4487d95d..40d1041ab46d 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -870,7 +870,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	/* Returning to host will clear PSR.I, remask PMR if needed */
 	if (system_uses_irq_prio_masking())
-		gic_write_pmr(GIC_PRIO_IRQOFF);
+		gic_write_pmr(gic_prio_irqoff());
 
 	return exit_code;
 }
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 83103277d2a9..012ff8819313 100644
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
 
@@ -932,14 +933,16 @@ static void gic_cpu_sys_reg_init(void)
 	/* Set priority mask register */
 	if (!gic_prio_masking_enabled()) {
 		write_gicreg(DEFAULT_PMR_VALUE, ICC_PMR_EL1);
-	} else {
+	} else if (gic_supports_nmi()) {
 		/*
 		 * Mismatch configuration with boot CPU, the system is likely
 		 * to die as interrupt masking will not work properly on all
 		 * CPUs
 		 */
-		WARN_ON(gic_supports_nmi() && group0 &&
-			!gic_dist_security_disabled());
+		if (static_branch_unlikely(&gic_nonsecure_priorities))
+			WARN_ON(!group0 || gic_dist_security_disabled());
+		else
+			WARN_ON(group0 && !gic_dist_security_disabled());
 	}
 
 	/*
@@ -1544,11 +1547,6 @@ static void gic_enable_nmi_support(void)
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
@@ -1567,6 +1565,36 @@ static void gic_enable_nmi_support(void)
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
+	 * are both either modified, or unchanged, we can use the same set of
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
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
