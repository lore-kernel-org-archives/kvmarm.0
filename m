Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3280ECE589
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B0D4621D56
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0D4621D56
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69B9A4A6CE;
	Tue,  1 Oct 2019 06:23:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fks61K16AE9U; Tue,  1 Oct 2019 06:23:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EED14A6D8;
	Tue,  1 Oct 2019 06:23:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23BFE4A6C8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cPzcc5A6ZFTs for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 06:23:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 146D54A69C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0A9A1000;
 Tue,  1 Oct 2019 03:23:46 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8609C3F739;
 Tue,  1 Oct 2019 03:23:45 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 06/19] arm64: timer: Write to ICENABLER
 to disable timer IRQ
Date: Tue,  1 Oct 2019 11:23:10 +0100
Message-Id: <20191001102323.27628-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com
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

According the Generic Interrupt Controller versions 2, 3 and 4 architecture
specifications, a write of 0 to the GIC{D,R}_ISENABLER{,0} registers is
ignored; this is also how KVM emulates the corresponding register. Write
instead to the ICENABLER register when disabling the timer interrupt.

Note that fortunately for us, the timer test was still working as intended
because KVM does the sensible thing and all interrupts are disabled by
default when creating a VM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/gic-v3.h |  1 +
 lib/arm/asm/gic.h    |  1 +
 arm/timer.c          | 22 +++++++++++-----------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 347be2f9da17..0dc838b3ab2d 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -31,6 +31,7 @@
 /* Re-Distributor registers, offsets from SGI_base */
 #define GICR_IGROUPR0			GICD_IGROUPR
 #define GICR_ISENABLER0			GICD_ISENABLER
+#define GICR_ICENABLER0			GICD_ICENABLER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
 
 #define ICC_SGI1R_AFFINITY_1_SHIFT	16
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index f6dfb907a7d5..a67111607bcf 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -15,6 +15,7 @@
 #define GICD_IIDR			0x0008
 #define GICD_IGROUPR			0x0080
 #define GICD_ISENABLER			0x0100
+#define GICD_ICENABLER			0x0180
 #define GICD_ISPENDR			0x0200
 #define GICD_ICPENDR			0x0280
 #define GICD_ISACTIVER			0x0300
diff --git a/arm/timer.c b/arm/timer.c
index f2f60192ba62..78f0dd870993 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -17,6 +17,9 @@
 #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
 
 static void *gic_ispendr;
+static void *gic_isenabler;
+static void *gic_icenabler;
+
 static bool ptimer_unsupported;
 
 static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
@@ -132,19 +135,12 @@ static struct timer_info ptimer_info = {
 
 static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
 {
-	u32 val = 0;
+	u32 val = 1 << PPI(info->irq);
 
 	if (enabled)
-		val = 1 << PPI(info->irq);
-
-	switch (gic_version()) {
-	case 2:
-		writel(val, gicv2_dist_base() + GICD_ISENABLER + 0);
-		break;
-	case 3:
-		writel(val, gicv3_sgi_base() + GICR_ISENABLER0);
-		break;
-	}
+		writel(val, gic_isenabler);
+	else
+		writel(val, gic_icenabler);
 }
 
 static void irq_handler(struct pt_regs *regs)
@@ -305,9 +301,13 @@ static void test_init(void)
 	switch (gic_version()) {
 	case 2:
 		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
+		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
+		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
 		break;
 	case 3:
 		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
+		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
+		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
 		break;
 	}
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
