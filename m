From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 16/59] irqchip/gic-v3-its: Add VLPI configuration hook
Date: Mon, 31 Jul 2017 18:25:54 +0100
Message-ID: <20170731172637.29355-17-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA74949C54
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6FAeBP3pNfpD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:26:05 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C06E940D1A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:26:05 -0400 (EDT)
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

Add the skeleton irq_set_vcpu_affinity method that will be used
to configure VLPIs.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index bc396ab24037..9ef4f161690a 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -36,6 +36,7 @@
 
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v3.h>
+#include <linux/irqchip/arm-gic-v4.h>
 
 #include <asm/cputype.h>
 #include <asm/exception.h>
@@ -780,6 +781,28 @@ static int its_irq_set_irqchip_state(struct irq_data *d,
 	return 0;
 }
 
+static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	struct its_cmd_info *info = vcpu_info;
+
+	/* Need a v4 ITS */
+	if (!its_dev->its->is_v4 || !info)
+		return -EINVAL;
+
+	switch (info->cmd_type) {
+	case MAP_VLPI:
+
+	case GET_VLPI:
+
+	case PROP_UPDATE_VLPI:
+	case PROP_UPDATE_AND_INV_VLPI:
+
+	default:
+		return -EINVAL;
+	}
+}
+
 static struct irq_chip its_irq_chip = {
 	.name			= "ITS",
 	.irq_mask		= its_mask_irq,
@@ -788,6 +811,7 @@ static struct irq_chip its_irq_chip = {
 	.irq_set_affinity	= its_set_affinity,
 	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
 	.irq_set_irqchip_state	= its_irq_set_irqchip_state,
+	.irq_set_vcpu_affinity	= its_irq_set_vcpu_affinity,
 };
 
 /*
-- 
2.11.0
