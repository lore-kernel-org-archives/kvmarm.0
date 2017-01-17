From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 30/33] irqchip/gic-v4: Add VPE command interface
Date: Tue, 17 Jan 2017 10:20:51 +0000
Message-ID: <1484648454-21216-31-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B7A40960
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:20:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aPQnXAbgfuuf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:20:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC5C4099C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:20:05 -0500 (EST)
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

Add the required interfaces to schedule a VPE and perform a
VINVALL command.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v4.c       | 31 +++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v4.h |  2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index b9a0b34..7d74089 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -109,3 +109,34 @@ void its_free_vcpu_irqs(struct its_vm *vm, int nr_vpes)
 
 	irq_domain_free_irqs(irq, nr_vpes);
 }
+
+static int its_send_vpe_cmd(struct its_vpe *vpe, struct its_cmd_info *info)
+{
+	unsigned int irq;
+	irq_hw_number_t hwirq;
+
+	WARN_ON(preemptible());
+
+	hwirq = vpe->vpe_db_lpi - vpe->its_vm->db_lpi_base;
+	irq = irq_find_mapping(vpe->its_vm->domain, hwirq);
+
+	return irq_set_vcpu_affinity(irq, info);
+}
+
+int its_schedule_vpe(struct its_vpe *vpe, bool on)
+{
+	struct its_cmd_info info;
+
+	info.cmd_type = on ? SCHEDULE_VPE : DESCHEDULE_VPE;
+
+	return its_send_vpe_cmd(vpe, &info);
+}
+
+int its_invall_vpe(struct its_vpe *vpe)
+{
+	struct its_cmd_info info = {
+		.cmd_type = INVALL_VPE,
+	};
+
+	return its_send_vpe_cmd(vpe, &info);
+}
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 2463d70..1c58add 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -91,5 +91,7 @@ struct its_cmd_info {
 
 int its_alloc_vcpu_irqs(struct its_vm *vm, struct its_vpe **vpes, int nr_vpes);
 void its_free_vcpu_irqs(struct its_vm *vm, int nr_vpes);
+int its_schedule_vpe(struct its_vpe *vpe, bool on);
+int its_invall_vpe(struct its_vpe *vpe);
 
 #endif
-- 
2.1.4
