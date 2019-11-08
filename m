Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAA2FA372C
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0576C21D7F
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0576C21D7F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B19DB4AEF1;
	Fri,  8 Nov 2019 09:43:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YYEGCYtdY4XF; Fri,  8 Nov 2019 09:43:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF72B4AF1B;
	Fri,  8 Nov 2019 09:43:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0201A4AEDE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id spV9tozJIRN4 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 09:43:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B49274AC70
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:06 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88F9446A;
 Fri,  8 Nov 2019 06:43:06 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BB433F719;
 Fri,  8 Nov 2019 06:43:05 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 12/17] arm: gic: Change gic_read_iar() to take
 group parameter
Date: Fri,  8 Nov 2019 14:42:35 +0000
Message-Id: <20191108144240.204202-13-andre.przywara@arm.com>
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

Acknowledging a GIC group 0 interrupt requires us to use a different
system register on GICv3. To allow us to differentiate the two groups
later, add a group parameter to gic_read_iar(). For GICv2 we can use the
same CPU interface register to acknowledge group 0 as well, so we ignore
the parameter here.

For now this is still using group 1 on every caller.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c                  |  4 ++--
 arm/micro-bench.c          |  2 +-
 arm/pl031.c                |  2 +-
 arm/timer.c                |  2 +-
 lib/arm/asm/arch_gicv3.h   | 11 +++++++++--
 lib/arm/asm/gic-v2.h       |  2 +-
 lib/arm/asm/gic-v3.h       |  2 +-
 lib/arm/asm/gic.h          |  2 +-
 lib/arm/gic-v2.c           |  3 ++-
 lib/arm/gic.c              |  6 +++---
 lib/arm64/asm/arch_gicv3.h | 10 ++++++++--
 11 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index a0511e5..7be13a6 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -156,7 +156,7 @@ static void check_irqnr(u32 irqnr, int expected)
 
 static void irq_handler(struct pt_regs *regs __unused)
 {
-	u32 irqstat = gic_read_iar();
+	u32 irqstat = gic_read_iar(1);
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
 	if (irqnr == GICC_INT_SPURIOUS) {
@@ -288,7 +288,7 @@ static struct gic gicv3 = {
 
 static void ipi_clear_active_handler(struct pt_regs *regs __unused)
 {
-	u32 irqstat = gic_read_iar();
+	u32 irqstat = gic_read_iar(1);
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
 	if (irqnr != GICC_INT_SPURIOUS) {
diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 4612f41..2bfee68 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -33,7 +33,7 @@ static void ipi_irq_handler(struct pt_regs *regs)
 {
 	ipi_ready = false;
 	ipi_received = true;
-	gic_write_eoir(gic_read_iar());
+	gic_write_eoir(gic_read_iar(1));
 	ipi_ready = true;
 }
 
diff --git a/arm/pl031.c b/arm/pl031.c
index 5672f36..5be3d76 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -134,7 +134,7 @@ static void gic_irq_unmask(void)
 
 static void irq_handler(struct pt_regs *regs)
 {
-	u32 irqstat = gic_read_iar();
+	u32 irqstat = gic_read_iar(1);
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
 	gic_write_eoir(irqstat);
diff --git a/arm/timer.c b/arm/timer.c
index 0b808d5..e5cc3b4 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -150,7 +150,7 @@ static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
 static void irq_handler(struct pt_regs *regs)
 {
 	struct timer_info *info;
-	u32 irqstat = gic_read_iar();
+	u32 irqstat = gic_read_iar(1);
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
 	if (irqnr != GICC_INT_SPURIOUS)
diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
index 45b6096..52e7bba 100644
--- a/lib/arm/asm/arch_gicv3.h
+++ b/lib/arm/asm/arch_gicv3.h
@@ -16,6 +16,7 @@
 
 #define ICC_PMR				__ACCESS_CP15(c4, 0, c6, 0)
 #define ICC_SGI1R			__ACCESS_CP15_64(0, c12)
+#define ICC_IAR0			__ACCESS_CP15(c12, 0,  c8, 0)
 #define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
 #define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
 #define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
@@ -30,9 +31,15 @@ static inline void gicv3_write_sgi1r(u64 val)
 	write_sysreg(val, ICC_SGI1R);
 }
 
-static inline u32 gicv3_read_iar(void)
+static inline u32 gicv3_read_iar(int group)
 {
-	u32 irqstat = read_sysreg(ICC_IAR1);
+	u32 irqstat;
+
+	if (group == 0)
+		irqstat = read_sysreg(ICC_IAR0);
+	else
+		irqstat = read_sysreg(ICC_IAR1);
+
 	dsb(sy);
 	return irqstat;
 }
diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
index 1fcfd43..d50c610 100644
--- a/lib/arm/asm/gic-v2.h
+++ b/lib/arm/asm/gic-v2.h
@@ -32,7 +32,7 @@ extern struct gicv2_data gicv2_data;
 
 extern int gicv2_init(void);
 extern void gicv2_enable_defaults(void);
-extern u32 gicv2_read_iar(void);
+extern u32 gicv2_read_iar(int group);
 extern u32 gicv2_iar_irqnr(u32 iar);
 extern void gicv2_write_eoir(u32 irqstat);
 extern void gicv2_ipi_send_single(int irq, int cpu);
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 0a29610..ca19110 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -69,7 +69,7 @@ extern struct gicv3_data gicv3_data;
 
 extern int gicv3_init(void);
 extern void gicv3_enable_defaults(void);
-extern u32 gicv3_read_iar(void);
+extern u32 gicv3_read_iar(int group);
 extern u32 gicv3_iar_irqnr(u32 iar);
 extern void gicv3_write_eoir(u32 irqstat);
 extern void gicv3_ipi_send_single(int irq, int cpu);
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 21cdb58..09663e7 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -68,7 +68,7 @@ extern void gic_enable_defaults(void);
  * below will work with any supported gic version.
  */
 extern int gic_version(void);
-extern u32 gic_read_iar(void);
+extern u32 gic_read_iar(int group);
 extern u32 gic_iar_irqnr(u32 iar);
 extern void gic_write_eoir(u32 irqstat);
 extern void gic_ipi_send_single(int irq, int cpu);
diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
index dc6a97c..b60967e 100644
--- a/lib/arm/gic-v2.c
+++ b/lib/arm/gic-v2.c
@@ -26,8 +26,9 @@ void gicv2_enable_defaults(void)
 	writel(GICC_ENABLE, cpu_base + GICC_CTLR);
 }
 
-u32 gicv2_read_iar(void)
+u32 gicv2_read_iar(int group)
 {
+	/* GICv2 acks both group0 and group1 IRQs with the same register. */
 	return readl(gicv2_cpu_base() + GICC_IAR);
 }
 
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index cf4e811..b51eff5 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -12,7 +12,7 @@ struct gicv3_data gicv3_data;
 
 struct gic_common_ops {
 	void (*enable_defaults)(void);
-	u32 (*read_iar)(void);
+	u32 (*read_iar)(int group);
 	u32 (*iar_irqnr)(u32 iar);
 	void (*write_eoir)(u32 irqstat);
 	void (*ipi_send_single)(int irq, int cpu);
@@ -117,10 +117,10 @@ void gic_enable_defaults(void)
 	gic_common_ops->enable_defaults();
 }
 
-u32 gic_read_iar(void)
+u32 gic_read_iar(int group)
 {
 	assert(gic_common_ops && gic_common_ops->read_iar);
-	return gic_common_ops->read_iar();
+	return gic_common_ops->read_iar(group);
 }
 
 u32 gic_iar_irqnr(u32 iar)
diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
index a7994ec..876e1fc 100644
--- a/lib/arm64/asm/arch_gicv3.h
+++ b/lib/arm64/asm/arch_gicv3.h
@@ -11,6 +11,7 @@
 #include <asm/sysreg.h>
 
 #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
+#define ICC_IAR0_EL1			sys_reg(3, 0, 12, 8, 0)
 #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
 #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
 #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
@@ -38,10 +39,15 @@ static inline void gicv3_write_sgi1r(u64 val)
 	asm volatile("msr_s " xstr(ICC_SGI1R_EL1) ", %0" : : "r" (val));
 }
 
-static inline u32 gicv3_read_iar(void)
+static inline u32 gicv3_read_iar(int group)
 {
 	u64 irqstat;
-	asm volatile("mrs_s %0, " xstr(ICC_IAR1_EL1) : "=r" (irqstat));
+
+	if (group == 0)
+		asm volatile("mrs_s %0, " xstr(ICC_IAR0_EL1) : "=r" (irqstat));
+	else
+		asm volatile("mrs_s %0, " xstr(ICC_IAR1_EL1) : "=r" (irqstat));
+
 	dsb(sy);
 	return (u64)irqstat;
 }
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
