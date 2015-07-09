From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/6] irqchip: GICv3: Skip LPI deactivation
Date: Thu,  9 Jul 2015 14:19:08 +0100
Message-ID: <1436447951-22357-4-git-send-email-marc.zyngier@arm.com>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AE56583CF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:07:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jRyurcQTiuQS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 09:07:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CEB3583AA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:07:47 -0400 (EDT)
In-Reply-To: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: kvm@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Contrary to other GICv3 interrupts, LPIs do not have an active state
by virtue of being edge-triggered only (they only have a pending state).

Given this, there is no point trying to deactivate them, and we can
skip the ICC_DIR_EL1 entierely.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 49768fc..e02592b 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -295,10 +295,14 @@ static int gic_irq_get_irqchip_state(struct irq_data *d,
 
 static void gic_eoi_irq(struct irq_data *d)
 {
-	if (static_key_true(&supports_deactivate))
+	if (static_key_true(&supports_deactivate)) {
+		/* No need to deactivate an LPI */
+		if (gic_irq(d) >= 8192)
+			return;
 		gic_write_dir(gic_irq(d));
-	else
+	} else {
 		gic_write_eoir(gic_irq(d));
+	}
 }
 
 static int gic_set_type(struct irq_data *d, unsigned int type)
-- 
2.1.4
