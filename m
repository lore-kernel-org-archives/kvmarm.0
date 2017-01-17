From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 17/33] irqchip/gic-v3-its: Add VLPI configuration hook
Date: Tue, 17 Jan 2017 10:20:38 +0000
Message-ID: <1484648454-21216-18-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add the skeleton irq_set_vcpu_affinity method that will be used
to configure VLPIs.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 0dbc8b0..1bd78ca 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -36,6 +36,7 @@
 
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v3.h>
+#include <linux/irqchip/arm-gic-v4.h>
 
 #include <asm/cputype.h>
 #include <asm/exception.h>
@@ -771,6 +772,37 @@ static int its_irq_set_irqchip_state(struct irq_data *d,
 	return 0;
 }
 
+static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	struct its_cmd_info *info = vcpu_info;
+	u32 event = its_get_event_id(d);
+
+	/* Need a v4 ITS */
+	if (!its_dev->its->is_v4 || !info)
+		return -EINVAL;
+
+	switch (info->cmd_type) {
+	case MAP_VLPI:
+	{
+		return 0;
+	}
+
+	case UNMAP_VLPI:
+	{
+		return 0;
+	}
+
+	case PROP_UPDATE_VLPI:
+	{
+		return 0;
+	}
+
+	default:
+		return -EINVAL;
+	}
+}
+
 static struct irq_chip its_irq_chip = {
 	.name			= "ITS",
 	.irq_mask		= its_mask_irq,
@@ -779,6 +811,7 @@ static struct irq_chip its_irq_chip = {
 	.irq_set_affinity	= its_set_affinity,
 	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
 	.irq_set_irqchip_state	= its_irq_set_irqchip_state,
+	.irq_set_vcpu_affinity	= its_irq_set_vcpu_affinity,
 };
 
 /*
-- 
2.1.4
