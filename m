From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 28/52] irqchip/gic-v3-its: Set implementation defined bit
 to enable VLPIs
Date: Wed, 28 Jun 2017 16:03:47 +0100
Message-ID: <20170628150411.15846-29-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EB7B40EB8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IRo1uS6tpC-e for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71CB449C0C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:16 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

A long time ago, GITS_CTLR[1] used to be called GITC_CTLR.EnableVLPI.
It has been subsequently deprecated and is now an "Implementation
Defined" bit that may ot may not be set for GICv4. Brilliant.

And the current crop of the FastModel requires that bit for VLPIs
to be enabled. Oh well... Let's set it and find out what breaks.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c   | 7 +++++--
 include/linux/irqchip/arm-gic-v3.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4979916cd3d7..3784bea2b994 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2552,7 +2552,7 @@ static int its_force_quiescent(void __iomem *base)
 		return 0;
 
 	/* Disable the generation of all interrupts to this ITS */
-	val &= ~GITS_CTLR_ENABLE;
+	val &= ~(GITS_CTLR_ENABLE | GITS_CTLR_ImDe);
 	writel_relaxed(val, base + GITS_CTLR);
 
 	/* Poll GITS_CTLR and wait until ITS becomes quiescent */
@@ -2818,7 +2818,10 @@ static int __init its_probe_one(struct resource *res,
 
 	gits_write_cwriter(0, its->base + GITS_CWRITER);
 	ctlr = readl_relaxed(its->base + GITS_CTLR);
-	writel_relaxed(ctlr | GITS_CTLR_ENABLE, its->base + GITS_CTLR);
+	ctlr |= GITS_CTLR_ENABLE;
+	if (its->is_v4)
+		ctlr |= GITS_CTLR_ImDe;
+	writel_relaxed(ctlr, its->base + GITS_CTLR);
 
 	err = its_init_domain(handle, its);
 	if (err)
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 6bc142cfa616..1ea576c8126f 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -298,6 +298,7 @@
 #define GITS_TRANSLATER			0x10040
 
 #define GITS_CTLR_ENABLE		(1U << 0)
+#define GITS_CTLR_ImDe			(1U << 1)
 #define	GITS_CTLR_ITS_NUMBER_SHIFT	4
 #define	GITS_CTLR_ITS_NUMBER		(0xFU << GITS_CTLR_ITS_NUMBER_SHIFT)
 #define GITS_CTLR_QUIESCENT		(1U << 31)
-- 
2.11.0
