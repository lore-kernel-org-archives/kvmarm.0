Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D04A184E
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 15:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E24C433C1;
	Sat, 12 Nov 2022 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668266299;
	bh=N1lvdzOYkno02VRjgE4wei/91aU/IVY+saEmNSO/OW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSd+Y3riE+xEL5NKlxcIRfhpzLA27/++/HWkitNB8PWTj7D4EVOwSQ1FdXPLgF4Mw
	 YJZz2o481uNPcsXOfAQBEY579Ss2lrjqRQL0wo2EpBJLuXK5dbULZIh4Bdnsk4zHaP
	 1C5r0+9buycOeNl8vurPCel8owFROWIc1XDdP4DuHanQJtIsd5SwiOGQRy6dapO/Et
	 l24UxBCjNpnQBk1fdUNEYMkRYVTjKKcXUbC9nfGBPXpKMpEOoKC5GbrAmc+3dwgLs0
	 Dg35e0KaVAbd+xXN337qCyoEdmoXmulmcGNdr3o9NQMAyQG2q3ovboTqA3ZjCuHcLO
	 wOHhiWWcydO3A==
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
Subject: [PATCH v2 12/14] arm64/nmi: Add handling of superpriority interrupts as NMIs
Date: Sat, 12 Nov 2022 15:17:06 +0000
Message-Id: <20221112151708.175147-13-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221112151708.175147-1-broonie@kernel.org>
References: <20221112151708.175147-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7547; i=broonie@kernel.org; h=from:subject; bh=N1lvdzOYkno02VRjgE4wei/91aU/IVY+saEmNSO/OW0=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjb7jx9sJ0vw8au9tMb14VV31d82WJOXn9drkeG3Lr aki1UOmJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY2+48QAKCRAk1otyXVSH0E3mB/ 9pzZjWBcG70v80z0Efs5DMuELiyZ8PnjbaXzyIsptUr6fEddt/Slk8X2/JtCXuRwUrCPmikgXiEkaA yd4stgmEZngy3W+X/20zak5eBSOAuHcRW36ijeG7Twu/c6fv1H8CxPvDxXu3vVW6zkhv4sajyqFlzp n7ypLgQOO75fD6mAFvBu1rv1KhBUbEsDZIU464jat07uO0BBAoEi5DWOZmOK8gszZTiUnVv5ww26ks lWPyL5Nx4948mvBT5+sLxO+sYy+vtndY1LPe4KHYY+oAPVpNqbNJIDw2ZaAiLDwrSwB2jC7CrpkFUZ mfPRTWhUWYy8Snflzal/Fv7O3IWdMQ
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

Our goal with superpriority interrupts is to use them as NMIs, taking
advantage of the much smaller regions where they are masked to allow
prompt handling of the most time critical interrupts.

When an interrupt configured with superpriority we will enter EL1 as
normal for any interrupt, the presence of a superpriority interrupt is
indicated with a status bit in ISR_EL1. We use this to check for the
presence of a superpriority interrupt before we unmask anything in
elX_interrupt(), reporting without unmasking any interrupts. If no
superpriority interrupt is present then we handle normal interrupts as
normal, superpriority interrupts will be unmasked while doing so as a
result of setting DAIF_PROCCTX.

Both IRQs and FIQs may be configured with superpriority so we handle
both, passing an additional root handler into the elX_interrupt()
function along with the mask for the bit in ISR_EL1 which indicates the
presence of the relevant kind of superpriority interrupt. These root
handlers can be configured by the interrupt controller similarly to the
root handlers for normal interrupts using the newly added
set_handle_nmi_irq() and set_handle_nmi_fiq() functions.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/irq.h     |  2 ++
 arch/arm64/kernel/entry-common.c | 55 +++++++++++++++++++++++++++-----
 arch/arm64/kernel/irq.c          | 32 +++++++++++++++++++
 3 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/irq.h b/arch/arm64/include/asm/irq.h
index fac08e18bcd5..2ab05d899bf6 100644
--- a/arch/arm64/include/asm/irq.h
+++ b/arch/arm64/include/asm/irq.h
@@ -8,6 +8,8 @@
 
 struct pt_regs;
 
+int set_handle_nmi_irq(void (*handle_irq)(struct pt_regs *));
+int set_handle_nmi_fiq(void (*handle_fiq)(struct pt_regs *));
 int set_handle_irq(void (*handle_irq)(struct pt_regs *));
 #define set_handle_irq	set_handle_irq
 int set_handle_fiq(void (*handle_fiq)(struct pt_regs *));
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index 9173fad279af..eb6fc718737e 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -278,6 +278,8 @@ static void do_interrupt_handler(struct pt_regs *regs,
 	set_irq_regs(old_regs);
 }
 
+extern void (*handle_arch_nmi_irq)(struct pt_regs *);
+extern void (*handle_arch_nmi_fiq)(struct pt_regs *);
 extern void (*handle_arch_irq)(struct pt_regs *);
 extern void (*handle_arch_fiq)(struct pt_regs *);
 
@@ -453,6 +455,14 @@ asmlinkage void noinstr el1h_64_sync_handler(struct pt_regs *regs)
 	}
 }
 
+static __always_inline void __el1_nmi(struct pt_regs *regs,
+				      void (*handler)(struct pt_regs *))
+{
+	arm64_enter_nmi(regs);
+	do_interrupt_handler(regs, handler);
+	arm64_exit_nmi(regs);
+}
+
 static __always_inline void __el1_pnmi(struct pt_regs *regs,
 				       void (*handler)(struct pt_regs *))
 {
@@ -474,9 +484,19 @@ static __always_inline void __el1_irq(struct pt_regs *regs,
 
 	exit_to_kernel_mode(regs);
 }
-static void noinstr el1_interrupt(struct pt_regs *regs,
-				  void (*handler)(struct pt_regs *))
+
+static void noinstr el1_interrupt(struct pt_regs *regs, u64 nmi_flag,
+				  void (*handler)(struct pt_regs *),
+				  void (*nmi_handler)(struct pt_regs *))
 {
+	if (system_uses_nmi()) {
+		/* Is there a NMI to handle? */
+		if (read_sysreg(isr_el1) & nmi_flag) {
+			__el1_nmi(regs, nmi_handler);
+			return;
+		}
+	}
+
 	write_sysreg(DAIF_PROCCTX_NOIRQ, daif);
 
 	if (IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) && !interrupts_enabled(regs))
@@ -487,12 +507,12 @@ static void noinstr el1_interrupt(struct pt_regs *regs,
 
 asmlinkage void noinstr el1h_64_irq_handler(struct pt_regs *regs)
 {
-	el1_interrupt(regs, handle_arch_irq);
+	el1_interrupt(regs, ISR_EL1_IS, handle_arch_irq, handle_arch_nmi_irq);
 }
 
 asmlinkage void noinstr el1h_64_fiq_handler(struct pt_regs *regs)
 {
-	el1_interrupt(regs, handle_arch_fiq);
+	el1_interrupt(regs, ISR_EL1_FS, handle_arch_fiq, handle_arch_nmi_fiq);
 }
 
 asmlinkage void noinstr el1h_64_error_handler(struct pt_regs *regs)
@@ -701,11 +721,30 @@ asmlinkage void noinstr el0t_64_sync_handler(struct pt_regs *regs)
 	}
 }
 
-static void noinstr el0_interrupt(struct pt_regs *regs,
-				  void (*handler)(struct pt_regs *))
+static void noinstr el0_interrupt(struct pt_regs *regs, u64 nmi_flag,
+				  void (*handler)(struct pt_regs *),
+				  void (*nmi_handler)(struct pt_regs *))
 {
 	enter_from_user_mode(regs);
 
+	if (system_uses_nmi()) {
+		/* Is there a NMI to handle? */
+		if (read_sysreg(isr_el1) & nmi_flag) {
+			/*
+			 * Any system with FEAT_NMI should not be
+			 * affected by Spectre v2 so we don't mitigate
+			 * here.
+			 */
+
+			arm64_enter_nmi(regs);
+			do_interrupt_handler(regs, nmi_handler);
+			arm64_exit_nmi(regs);
+
+			exit_to_user_mode(regs);
+			return;
+		}
+	}
+
 	write_sysreg(DAIF_PROCCTX_NOIRQ, daif);
 
 	if (regs->pc & BIT(55))
@@ -720,7 +759,7 @@ static void noinstr el0_interrupt(struct pt_regs *regs,
 
 static void noinstr __el0_irq_handler_common(struct pt_regs *regs)
 {
-	el0_interrupt(regs, handle_arch_irq);
+	el0_interrupt(regs, ISR_EL1_IS, handle_arch_irq, handle_arch_nmi_irq);
 }
 
 asmlinkage void noinstr el0t_64_irq_handler(struct pt_regs *regs)
@@ -730,7 +769,7 @@ asmlinkage void noinstr el0t_64_irq_handler(struct pt_regs *regs)
 
 static void noinstr __el0_fiq_handler_common(struct pt_regs *regs)
 {
-	el0_interrupt(regs, handle_arch_fiq);
+	el0_interrupt(regs, ISR_EL1_FS, handle_arch_fiq, handle_arch_nmi_fiq);
 }
 
 asmlinkage void noinstr el0t_64_fiq_handler(struct pt_regs *regs)
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 38dbd3828f13..77a1ea90b244 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -85,6 +85,16 @@ void do_softirq_own_stack(void)
 }
 #endif
 
+static void default_handle_nmi_irq(struct pt_regs *regs)
+{
+	panic("Superpriority IRQ taken without a root NMI IRQ handler\n");
+}
+
+static void default_handle_nmi_fiq(struct pt_regs *regs)
+{
+	panic("Superpriority FIQ taken without a root NMI FIQ handler\n");
+}
+
 static void default_handle_irq(struct pt_regs *regs)
 {
 	panic("IRQ taken without a root IRQ handler\n");
@@ -95,9 +105,31 @@ static void default_handle_fiq(struct pt_regs *regs)
 	panic("FIQ taken without a root FIQ handler\n");
 }
 
+void (*handle_arch_nmi_irq)(struct pt_regs *) __ro_after_init = default_handle_nmi_irq;
+void (*handle_arch_nmi_fiq)(struct pt_regs *) __ro_after_init = default_handle_nmi_fiq;
 void (*handle_arch_irq)(struct pt_regs *) __ro_after_init = default_handle_irq;
 void (*handle_arch_fiq)(struct pt_regs *) __ro_after_init = default_handle_fiq;
 
+int __init set_handle_nmi_irq(void (*handle_nmi_irq)(struct pt_regs *))
+{
+	if (handle_arch_nmi_irq != default_handle_nmi_irq)
+		return -EBUSY;
+
+	handle_arch_nmi_irq = handle_nmi_irq;
+	pr_info("Root superpriority IRQ handler: %ps\n", handle_nmi_irq);
+	return 0;
+}
+
+int __init set_handle_nmi_fiq(void (*handle_nmi_fiq)(struct pt_regs *))
+{
+	if (handle_arch_nmi_fiq != default_handle_nmi_fiq)
+		return -EBUSY;
+
+	handle_arch_nmi_fiq = handle_nmi_fiq;
+	pr_info("Root superpriority FIQ handler: %ps\n", handle_nmi_fiq);
+	return 0;
+}
+
 int __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 {
 	if (handle_arch_irq != default_handle_irq)
-- 
2.30.2

