From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 31/52] irqchip/gic-v4: Add VLPI configuration interface
Date: Wed, 28 Jun 2017 16:03:50 +0100
Message-ID: <20170628150411.15846-32-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B4A640DF9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u8duGbhYKrLt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D0949C26
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:21 -0400 (EDT)
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

Add the required interfaces to map, unmap and update a VLPI.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v4.c       | 42 ++++++++++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v4.h |  4 ++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 3c5ad70193ed..697d9dc1e005 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -81,3 +81,45 @@ int its_invall_vpe(struct its_vpe *vpe)
 
 	return its_send_vpe_cmd(vpe, &info);
 }
+
+int its_map_vlpi(int irq, struct its_vlpi_map *map)
+{
+	struct its_cmd_info info = {
+		.cmd_type = MAP_VLPI,
+		.map      = map,
+	};
+
+	/*
+	 * The host will never see that interrupt firing again, so it
+	 * is vital that we don't do any lazy masking.
+	 */
+	irq_set_status_flags(irq, IRQ_DISABLE_UNLAZY);
+
+	return irq_set_vcpu_affinity(irq, &info);
+}
+
+int its_get_vlpi(int irq, struct its_vlpi_map *map)
+{
+	struct its_cmd_info info = {
+		.cmd_type = GET_VLPI,
+		.map      = map,
+	};
+
+	return irq_set_vcpu_affinity(irq, &info);
+}
+
+int its_unmap_vlpi(int irq)
+{
+	irq_clear_status_flags(irq, IRQ_DISABLE_UNLAZY);
+	return irq_set_vcpu_affinity(irq, NULL);
+}
+
+int its_prop_update_vlpi(int irq, u8 config, bool inv)
+{
+	struct its_cmd_info info = {
+		.cmd_type = inv ? PROP_UPDATE_AND_INV_VLPI : PROP_UPDATE_VLPI,
+		.config   = config,
+	};
+
+	return irq_set_vcpu_affinity(irq, &info);
+}
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 97bb97a11fef..843c9ff29269 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -92,5 +92,9 @@ int its_alloc_vcpu_irqs(struct its_vm *vm);
 void its_free_vcpu_irqs(struct its_vm *vm);
 int its_schedule_vpe(struct its_vpe *vpe, bool on);
 int its_invall_vpe(struct its_vpe *vpe);
+int its_map_vlpi(int irq, struct its_vlpi_map *map);
+int its_get_vlpi(int irq, struct its_vlpi_map *map);
+int its_unmap_vlpi(int irq);
+int its_prop_update_vlpi(int irq, u8 config, bool inv);
 
 #endif
-- 
2.11.0
