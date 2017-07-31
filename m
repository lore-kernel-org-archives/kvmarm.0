From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 28/59] irqchip/gic-v3-its: Allow doorbell interrupts to be
 injected/cleared
Date: Mon, 31 Jul 2017 18:26:06 +0100
Message-ID: <20170731172637.29355-29-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56FC249C33
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eqimppgkn2k6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:26:33 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D83C49C4A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:33 -0400 (EDT)
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

While the doorbell interrupts are usually driven by the HW itself,
having a way to trigger them independently has proved to be a
really useful debug feature. As it is actually very little code,
let's add it to the VPE irqchip operations.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 210840e0ec92..a177af0b1657 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2404,12 +2404,41 @@ static void its_vpe_unmask_irq(struct irq_data *d)
 	its_vpe_send_inv(d);
 }
 
+/* This is really a debug feature */
+static int its_vpe_set_irqchip_state(struct irq_data *d,
+				     enum irqchip_irq_state which,
+				     bool state)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+
+	if (which != IRQCHIP_STATE_PENDING)
+		return -EINVAL;
+
+	if (gic_rdists->has_direct_lpi) {
+		void __iomem *rdbase;
+
+		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
+		if (state)
+			gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_SETLPIR);
+		else
+			gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_CLRLPIR);
+	} else {
+		if (state)
+			its_vpe_send_cmd(vpe, its_send_int);
+		else
+			its_vpe_send_cmd(vpe, its_send_clear);
+	}
+
+	return 0;
+}
+
 static struct irq_chip its_vpe_irq_chip = {
 	.name			= "GICv4-vpe",
 	.irq_mask		= its_vpe_mask_irq,
 	.irq_unmask		= its_vpe_unmask_irq,
 	.irq_eoi		= irq_chip_eoi_parent,
 	.irq_set_affinity	= its_vpe_set_affinity,
+	.irq_set_irqchip_state	= its_vpe_set_irqchip_state,
 	.irq_set_vcpu_affinity	= its_vpe_set_vcpu_affinity,
 };
 
-- 
2.11.0
