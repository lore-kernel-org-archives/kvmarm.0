From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/6] irqchip: GIC: Use chip_data instead of handler_data for
 cascaded interrupts
Date: Thu,  9 Jul 2015 14:19:09 +0100
Message-ID: <1436447951-22357-5-git-send-email-marc.zyngier@arm.com>
References: <1436447951-22357-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9EBE583D7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:07:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tfwdyF5DLc-O for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 09:07:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F532583C5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:07:49 -0400 (EDT)
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

When used as a primary interrupt controller, the GIC driver uses
irq_data->chip_data to extract controller-specific information.

When used as a secondary interrupt controller, it uses handler_data
instead. As this difference is relatively pointless and only creates
confusion, change the secondary path to match what the rest of the
driver does.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index e264675..3c7f3a4 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -298,7 +298,7 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 
 static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct gic_chip_data *chip_data = irq_get_handler_data(irq);
+	struct gic_chip_data *chip_data = irq_get_chip_data(irq);
 	struct irq_chip *chip = irq_get_chip(irq);
 	unsigned int cascade_irq, gic_irq;
 	unsigned long status;
@@ -341,7 +341,7 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 {
 	if (gic_nr >= MAX_GIC_NR)
 		BUG();
-	if (irq_set_handler_data(irq, &gic_data[gic_nr]) != 0)
+	if (irq_set_chip_data(irq, &gic_data[gic_nr]) != 0)
 		BUG();
 	irq_set_chained_handler(irq, gic_handle_cascade_irq);
 }
-- 
2.1.4
