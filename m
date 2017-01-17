From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 31/33] irqchip/gic-v4: Add VLPI configuration interface
Date: Tue, 17 Jan 2017 10:20:52 +0000
Message-ID: <1484648454-21216-32-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DECB40967
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:20:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R1fJRURDHazN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:20:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B689540419
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:20:06 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Add the required interfaces to map, unmap and update a VLPI.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v4.c       | 29 +++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v4.h |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 7d74089..36ccaac 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -140,3 +140,32 @@ int its_invall_vpe(struct its_vpe *vpe)
 
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
+	return irq_set_vcpu_affinity(irq, &info);
+}
+
+int its_unmap_vlpi(int irq)
+{
+	struct its_cmd_info info = {
+		.cmd_type = UNMAP_VLPI,
+	};
+
+	return irq_set_vcpu_affinity(irq, &info);
+}
+
+int its_prop_update_vlpi(int irq, u8 config)
+{
+	struct its_cmd_info info = {
+		.cmd_type = PROP_UPDATE_VLPI,
+		.config   = config,
+	};
+
+	return irq_set_vcpu_affinity(irq, &info);
+}
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 1c58add..f85a929 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -93,5 +93,8 @@ int its_alloc_vcpu_irqs(struct its_vm *vm, struct its_vpe **vpes, int nr_vpes);
 void its_free_vcpu_irqs(struct its_vm *vm, int nr_vpes);
 int its_schedule_vpe(struct its_vpe *vpe, bool on);
 int its_invall_vpe(struct its_vpe *vpe);
+int its_map_vlpi(int irq, struct its_vlpi_map *map);
+int its_unmap_vlpi(int irq);
+int its_prop_update_vlpi(int irq, u8 config);
 
 #endif
-- 
2.1.4
