From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 31/59] irqchip/gic-v4: Add VPE command interface
Date: Mon, 31 Jul 2017 18:26:09 +0100
Message-ID: <20170731172637.29355-32-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add the required interfaces to schedule a VPE and perform a
VINVALL command.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v4.c       | 25 +++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v4.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index f7fe6181ec8d..86b46fb532ab 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -71,3 +71,28 @@ void its_free_vcpu_irqs(struct its_vm *vm)
 	irq_domain_remove(vm->domain);
 	irq_domain_free_fwnode(vm->fwnode);
 }
+
+static int its_send_vpe_cmd(struct its_vpe *vpe, struct its_cmd_info *info)
+{
+	return irq_set_vcpu_affinity(vpe->irq, info);
+}
+
+int its_schedule_vpe(struct its_vpe *vpe, bool on)
+{
+	struct its_cmd_info info;
+
+	WARN_ON(preemptible());
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
index b31fb8aeba03..faaafd12d8c7 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -91,5 +91,7 @@ struct its_cmd_info {
 
 int its_alloc_vcpu_irqs(struct its_vm *vm);
 void its_free_vcpu_irqs(struct its_vm *vm);
+int its_schedule_vpe(struct its_vpe *vpe, bool on);
+int its_invall_vpe(struct its_vpe *vpe);
 
 #endif
-- 
2.11.0
