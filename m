Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAAEC5DF60
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A08B222C9
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A08B222C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 419994AEEA;
	Fri,  8 Nov 2019 09:43:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lEQXLfvy6ouQ; Fri,  8 Nov 2019 09:43:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E85D14AF1D;
	Fri,  8 Nov 2019 09:43:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 815744AEDE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4gipEGHsB5pX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 09:43:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5F24AEEB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA773AB6;
 Fri,  8 Nov 2019 06:43:07 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD5B53F719;
 Fri,  8 Nov 2019 06:43:06 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 13/17] arm: gic: Change write_eoir() to take
 group parameter
Date: Fri,  8 Nov 2019 14:42:36 +0000
Message-Id: <20191108144240.204202-14-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191108144240.204202-1-andre.przywara@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

EOIing GIC group 0 interrupt requires us to use a different
system register on GICv3. To allow us to differentiate the two groups
later, add a group parameter to write_eoir(). For GICv2 we can use the
same CPU interface register to EOI group 0 IRQs as well, so we ignore
the parameter here.

For now this is still using group 1 on every caller.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c                  |  2 +-
 arm/micro-bench.c          |  6 +++---
 arm/pl031.c                |  2 +-
 arm/timer.c                |  2 +-
 lib/arm/asm/arch_gicv3.h   |  8 ++++++--
 lib/arm/asm/gic-v2.h       |  2 +-
 lib/arm/asm/gic-v3.h       |  2 +-
 lib/arm/asm/gic.h          |  2 +-
 lib/arm/gic-v2.c           |  2 +-
 lib/arm/gic.c              |  6 +++---
 lib/arm64/asm/arch_gicv3.h | 10 ++++++++--
 11 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 7be13a6..c68b5b5 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -165,7 +165,7 @@ static void irq_handler(struct pt_regs *regs __unused)
 		return;
 	}
 
-	gic_write_eoir(irqstat);
+	gic_write_eoir(irqstat, 1);
 
 	smp_rmb(); /* pairs with wmb in stats_reset */
 	++acked[smp_processor_id()];
diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 2bfee68..a8f100f 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -27,13 +27,13 @@ static u32 cntfrq;
 
 static volatile bool ipi_ready, ipi_received;
 static void *vgic_dist_base;
-static void (*write_eoir)(u32 irqstat);
+static void (*write_eoir)(u32 irqstat, int group);
 
 static void ipi_irq_handler(struct pt_regs *regs)
 {
 	ipi_ready = false;
 	ipi_received = true;
-	gic_write_eoir(gic_read_iar(1));
+	gic_write_eoir(gic_read_iar(1), 1);
 	ipi_ready = true;
 }
 
@@ -135,7 +135,7 @@ static void eoi_exec(void)
 	int spurious_id = 1023; /* writes to EOI are ignored */
 
 	/* Avoid measuring assert(..) in gic_write_eoir */
-	write_eoir(spurious_id);
+	write_eoir(spurious_id, 1);
 }
 
 struct exit_test {
diff --git a/arm/pl031.c b/arm/pl031.c
index 5be3d76..7103e7b 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -137,7 +137,7 @@ static void irq_handler(struct pt_regs *regs)
 	u32 irqstat = gic_read_iar(1);
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
-	gic_write_eoir(irqstat);
+	gic_write_eoir(irqstat, 1);
 
 	if (irqnr == pl031_irq) {
 		report("  RTC RIS == 1", readl(&pl031->ris) == 1);
diff --git a/arm/timer.c b/arm/timer.c
index e5cc3b4..642e715 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -154,7 +154,7 @@ static void irq_handler(struct pt_regs *regs)
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
 	if (irqnr != GICC_INT_SPURIOUS)
-		gic_write_eoir(irqstat);
+		gic_write_eoir(irqstat, 1);
 
 	if (irqnr == PPI(vtimer_info.irq)) {
 		info = &vtimer_info;
diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
index 52e7bba..163008d 100644
--- a/lib/arm/asm/arch_gicv3.h
+++ b/lib/arm/asm/arch_gicv3.h
@@ -17,6 +17,7 @@
 #define ICC_PMR				__ACCESS_CP15(c4, 0, c6, 0)
 #define ICC_SGI1R			__ACCESS_CP15_64(0, c12)
 #define ICC_IAR0			__ACCESS_CP15(c12, 0,  c8, 0)
+#define ICC_EOIR0			__ACCESS_CP15(c12, 0,  c8, 1)
 #define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
 #define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
 #define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
@@ -44,9 +45,12 @@ static inline u32 gicv3_read_iar(int group)
 	return irqstat;
 }
 
-static inline void gicv3_write_eoir(u32 irq)
+static inline void gicv3_write_eoir(u32 irq, int group)
 {
-	write_sysreg(irq, ICC_EOIR1);
+	if (group == 0)
+		write_sysreg(irq, ICC_EOIR0);
+	else
+		write_sysreg(irq, ICC_EOIR1);
 	isb();
 }
 
diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
index d50c610..b57ee35 100644
--- a/lib/arm/asm/gic-v2.h
+++ b/lib/arm/asm/gic-v2.h
@@ -34,7 +34,7 @@ extern int gicv2_init(void);
 extern void gicv2_enable_defaults(void);
 extern u32 gicv2_read_iar(int group);
 extern u32 gicv2_iar_irqnr(u32 iar);
-extern void gicv2_write_eoir(u32 irqstat);
+extern void gicv2_write_eoir(u32 irqstat, int group);
 extern void gicv2_ipi_send_single(int irq, int cpu);
 extern void gicv2_ipi_send_mask(int irq, const cpumask_t *dest);
 
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index ca19110..210e07a 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -71,7 +71,7 @@ extern int gicv3_init(void);
 extern void gicv3_enable_defaults(void);
 extern u32 gicv3_read_iar(int group);
 extern u32 gicv3_iar_irqnr(u32 iar);
-extern void gicv3_write_eoir(u32 irqstat);
+extern void gicv3_write_eoir(u32 irqstat, int group);
 extern void gicv3_ipi_send_single(int irq, int cpu);
 extern void gicv3_ipi_send_mask(int irq, const cpumask_t *dest);
 extern void gicv3_set_redist_base(size_t stride);
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 09663e7..c4fedd6 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -70,7 +70,7 @@ extern void gic_enable_defaults(void);
 extern int gic_version(void);
 extern u32 gic_read_iar(int group);
 extern u32 gic_iar_irqnr(u32 iar);
-extern void gic_write_eoir(u32 irqstat);
+extern void gic_write_eoir(u32 irqstat, int group);
 extern void gic_ipi_send_single(int irq, int cpu);
 extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
 
diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
index b60967e..d2af01e 100644
--- a/lib/arm/gic-v2.c
+++ b/lib/arm/gic-v2.c
@@ -37,7 +37,7 @@ u32 gicv2_iar_irqnr(u32 iar)
 	return iar & GICC_IAR_INT_ID_MASK;
 }
 
-void gicv2_write_eoir(u32 irqstat)
+void gicv2_write_eoir(u32 irqstat, int group)
 {
 	writel(irqstat, gicv2_cpu_base() + GICC_EOIR);
 }
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index b51eff5..b9e64b9 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -14,7 +14,7 @@ struct gic_common_ops {
 	void (*enable_defaults)(void);
 	u32 (*read_iar)(int group);
 	u32 (*iar_irqnr)(u32 iar);
-	void (*write_eoir)(u32 irqstat);
+	void (*write_eoir)(u32 irqstat, int group);
 	void (*ipi_send_single)(int irq, int cpu);
 	void (*ipi_send_mask)(int irq, const cpumask_t *dest);
 };
@@ -129,10 +129,10 @@ u32 gic_iar_irqnr(u32 iar)
 	return gic_common_ops->iar_irqnr(iar);
 }
 
-void gic_write_eoir(u32 irqstat)
+void gic_write_eoir(u32 irqstat, int group)
 {
 	assert(gic_common_ops && gic_common_ops->write_eoir);
-	gic_common_ops->write_eoir(irqstat);
+	gic_common_ops->write_eoir(irqstat, group);
 }
 
 void gic_ipi_send_single(int irq, int cpu)
diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
index 876e1fc..972b97e 100644
--- a/lib/arm64/asm/arch_gicv3.h
+++ b/lib/arm64/asm/arch_gicv3.h
@@ -12,6 +12,7 @@
 
 #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 #define ICC_IAR0_EL1			sys_reg(3, 0, 12, 8, 0)
+#define ICC_EOIR0_EL1			sys_reg(3, 0, 12, 8, 1)
 #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
 #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
 #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
@@ -52,9 +53,14 @@ static inline u32 gicv3_read_iar(int group)
 	return (u64)irqstat;
 }
 
-static inline void gicv3_write_eoir(u32 irq)
+static inline void gicv3_write_eoir(u32 irq, int group)
 {
-	asm volatile("msr_s " xstr(ICC_EOIR1_EL1) ", %0" : : "r" ((u64)irq));
+	if (group == 0)
+		asm volatile("msr_s " xstr(ICC_EOIR0_EL1) ", %0"
+			     : : "r" ((u64)irq));
+	else
+		asm volatile("msr_s " xstr(ICC_EOIR1_EL1) ", %0"
+			     : : "r" ((u64)irq));
 	isb();
 }
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
