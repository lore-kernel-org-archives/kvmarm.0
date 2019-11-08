Return-Path: <SRS0=fmje=ZA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9493FC6195
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 838B72245A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Nov 2019 14:43:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 838B72245A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35F044AEFE;
	Fri,  8 Nov 2019 09:43:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HQI+6LeRdNhH; Fri,  8 Nov 2019 09:43:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12E9E4AEE6;
	Fri,  8 Nov 2019 09:43:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C12604A946
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bupmqBSOxU20 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Nov 2019 09:43:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D3B84AF08
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Nov 2019 09:43:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38E0046A;
 Fri,  8 Nov 2019 06:43:09 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AB153F719;
 Fri,  8 Nov 2019 06:43:07 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Andrew Jones <drjones@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 14/17] arm: gic: Prepare for receiving GIC
 group 0 interrupts via FIQs
Date: Fri,  8 Nov 2019 14:42:37 +0000
Message-Id: <20191108144240.204202-15-andre.przywara@arm.com>
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

To differentiate between the two interrupt groups, we will configure
group 0 to be delivered as FIQs, while group 1 interrupts still use the
IRQ "pin".
For this we need to teach kvm-unit-tests to deal with FIQs, also need to
tell the VGIC to deliver FIQs. This requires some bits here and there to
be set, which are annoyingly different between GICv2 and GICv3.

Add the required code in the GIC library to easily enable FIQ delivery
later on, in gic.c.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 lib/arm/asm/arch_gicv3.h   |  7 +++++++
 lib/arm/asm/gic-v2.h       |  7 ++++++-
 lib/arm/asm/processor.h    | 10 ++++++++++
 lib/arm/gic-v2.c           | 34 +++++++++++++++++++++++++++++++++-
 lib/arm64/asm/arch_gicv3.h |  9 +++++++++
 lib/arm64/asm/processor.h  | 10 ++++++++++
 lib/arm64/processor.c      |  2 ++
 7 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
index 163008d..33fd75c 100644
--- a/lib/arm/asm/arch_gicv3.h
+++ b/lib/arm/asm/arch_gicv3.h
@@ -20,6 +20,7 @@
 #define ICC_EOIR0			__ACCESS_CP15(c12, 0,  c8, 1)
 #define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
 #define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
+#define ICC_IGRPEN0			__ACCESS_CP15(c12, 0, c12, 6)
 #define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
 
 static inline void gicv3_write_pmr(u32 val)
@@ -54,6 +55,12 @@ static inline void gicv3_write_eoir(u32 irq, int group)
 	isb();
 }
 
+static inline void gicv3_write_grpen0(u32 val)
+{
+	write_sysreg(val, ICC_IGRPEN0);
+	isb();
+}
+
 static inline void gicv3_write_grpen1(u32 val)
 {
 	write_sysreg(val, ICC_IGRPEN1);
diff --git a/lib/arm/asm/gic-v2.h b/lib/arm/asm/gic-v2.h
index b57ee35..ed083ea 100644
--- a/lib/arm/asm/gic-v2.h
+++ b/lib/arm/asm/gic-v2.h
@@ -14,7 +14,10 @@
 
 #define GICD_ENABLE			0x1
 
-#define GICC_ENABLE			0x1
+#define GICC_GRP0_ENABLE		0x1
+#define GICC_GRP1_ENABLE		0x2
+#define GICC_ACKCTL			0x4
+#define GICC_FIQEN			0x8
 #define GICC_IAR_INT_ID_MASK		0x3ff
 
 #ifndef __ASSEMBLY__
@@ -32,6 +35,8 @@ extern struct gicv2_data gicv2_data;
 
 extern int gicv2_init(void);
 extern void gicv2_enable_defaults(void);
+extern void gicv2_enable_group1(bool enable);
+extern void gicv2_enable_fiq(bool enable);
 extern u32 gicv2_read_iar(int group);
 extern u32 gicv2_iar_irqnr(u32 iar);
 extern void gicv2_write_eoir(u32 irqstat, int group);
diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index a8c4628..6b5dd1e 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -35,6 +35,16 @@ static inline unsigned long current_cpsr(void)
 
 #define current_mode() (current_cpsr() & MODE_MASK)
 
+static inline void local_fiq_enable(void)
+{
+	asm volatile("cpsie f" : : : "memory", "cc");
+}
+
+static inline void local_fiq_disable(void)
+{
+	asm volatile("cpsid f" : : : "memory", "cc");
+}
+
 static inline void local_irq_enable(void)
 {
 	asm volatile("cpsie i" : : : "memory", "cc");
diff --git a/lib/arm/gic-v2.c b/lib/arm/gic-v2.c
index d2af01e..360aaa3 100644
--- a/lib/arm/gic-v2.c
+++ b/lib/arm/gic-v2.c
@@ -23,7 +23,39 @@ void gicv2_enable_defaults(void)
 	writel(GICD_ENABLE, dist + GICD_CTLR);
 
 	writel(GICC_INT_PRI_THRESHOLD, cpu_base + GICC_PMR);
-	writel(GICC_ENABLE, cpu_base + GICC_CTLR);
+	writel(GICC_GRP0_ENABLE, cpu_base + GICC_CTLR);
+}
+
+void gicv2_enable_fiq(bool enable)
+{
+	void *cpu_base = gicv2_cpu_base();
+	u32 reg = readl(cpu_base + GICC_CTLR);
+
+	if (enable) {
+		reg |= GICC_GRP0_ENABLE;
+		reg |= GICC_FIQEN;
+	} else {
+		reg &= ~GICC_GRP0_ENABLE;
+		reg &= ~GICC_FIQEN;
+	}
+
+	writel(reg, cpu_base + GICC_CTLR);
+}
+
+void gicv2_enable_group1(bool enable)
+{
+	void *cpu_base = gicv2_cpu_base();
+	u32 reg = readl(cpu_base + GICC_CTLR);
+
+	if (enable) {
+		reg |= GICC_GRP1_ENABLE;
+		reg |= GICC_ACKCTL;
+	} else {
+		reg &= ~GICC_GRP1_ENABLE;
+		reg &= ~GICC_ACKCTL;
+	}
+
+	writel(reg, cpu_base + GICC_CTLR);
 }
 
 u32 gicv2_read_iar(int group)
diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
index 972b97e..6938bc5 100644
--- a/lib/arm64/asm/arch_gicv3.h
+++ b/lib/arm64/asm/arch_gicv3.h
@@ -14,8 +14,11 @@
 #define ICC_IAR0_EL1			sys_reg(3, 0, 12, 8, 0)
 #define ICC_EOIR0_EL1			sys_reg(3, 0, 12, 8, 1)
 #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
+#define ICC_IAR0_EL1			sys_reg(3, 0, 12, 8, 0)
 #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
+#define ICC_EOIR0_EL1			sys_reg(3, 0, 12, 8, 1)
 #define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
+#define ICC_GRPEN0_EL1			sys_reg(3, 0, 12, 12, 6)
 #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
 
 #ifndef __ASSEMBLY__
@@ -64,6 +67,12 @@ static inline void gicv3_write_eoir(u32 irq, int group)
 	isb();
 }
 
+static inline void gicv3_write_grpen0(u32 val)
+{
+	asm volatile("msr_s " xstr(ICC_GRPEN0_EL1) ", %0" : : "r" ((u64)val));
+	isb();
+}
+
 static inline void gicv3_write_grpen1(u32 val)
 {
 	asm volatile("msr_s " xstr(ICC_GRPEN1_EL1) ", %0" : : "r" ((u64)val));
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1d9223f..69086e9 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -68,6 +68,16 @@ static inline unsigned long current_level(void)
 	return el & 0xc;
 }
 
+static inline void local_fiq_enable(void)
+{
+	asm volatile("msr daifclr, #1" : : : "memory");
+}
+
+static inline void local_fiq_disable(void)
+{
+	asm volatile("msr daifset, #1" : : : "memory");
+}
+
 static inline void local_irq_enable(void)
 {
 	asm volatile("msr daifclr, #2" : : : "memory");
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 2a024e3..8d7b921 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -190,8 +190,10 @@ void vector_handlers_default_init(vector_fn *handlers)
 {
 	handlers[EL1H_SYNC]	= default_vector_sync_handler;
 	handlers[EL1H_IRQ]	= default_vector_irq_handler;
+	handlers[EL1H_FIQ]	= default_vector_irq_handler;
 	handlers[EL0_SYNC_64]	= default_vector_sync_handler;
 	handlers[EL0_IRQ_64]	= default_vector_irq_handler;
+	handlers[EL0_FIQ_64]	= default_vector_irq_handler;
 }
 
 /* Needed to compile with -Wmissing-prototypes */
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
