Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5568DC2D0D5
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:40:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A0A22071A
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:40:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A0A22071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6FC24AF5D;
	Tue, 24 Dec 2019 06:40:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cCqozwwtqhfQ; Tue, 24 Dec 2019 06:40:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0EEC4AF58;
	Tue, 24 Dec 2019 06:40:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E734AF55
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:40:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OmDKHSLoeywY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 06:40:41 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6EFF84AF4D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:40:41 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iji62-000169-M8; Tue, 24 Dec 2019 12:11:27 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 18/32] irqchip/gic-v4.1: Plumb skeletal VSGI irqchip
Date: Tue, 24 Dec 2019 11:10:41 +0000
Message-Id: <20191224111055.11836-19-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191224111055.11836-1-maz@kernel.org>
References: <20191224111055.11836-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, tglx@linutronix.de, jason@lakedaemon.net,
 lorenzo.pieralisi@arm.com, Andrew.Murray@arm.com, yuzenghui@huawei.com,
 rrichter@marvell.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Since GICv4.1 has the capability to inject 16 SGIs into each VPE,
and that I'm keen not to invent too many specific interfaces to
manupulate these interrupts, let's pretend that each of these SGIs
is an actual Linux interrupt.

For that matter, let's introduce a minimal irqchip and irqdomain
setup that will get fleshed up in the following patches.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 68 +++++++++++++++++++++++++++++-
 drivers/irqchip/irq-gic-v4.c       |  8 +++-
 include/linux/irqchip/arm-gic-v4.h |  9 +++-
 3 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 2f94fae67dfd..b38823b9c27f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3740,6 +3740,67 @@ static struct irq_chip its_vpe_4_1_irq_chip = {
 	.irq_set_vcpu_affinity	= its_vpe_4_1_set_vcpu_affinity,
 };
 
+static int its_sgi_set_affinity(struct irq_data *d,
+				const struct cpumask *mask_val,
+				bool force)
+{
+	return -EINVAL;
+}
+
+static struct irq_chip its_sgi_irq_chip = {
+	.name			= "GICv4.1-sgi",
+	.irq_set_affinity	= its_sgi_set_affinity,
+};
+
+static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
+				    unsigned int virq, unsigned int nr_irqs,
+				    void *args)
+{
+	struct its_vpe *vpe = args;
+	int i;
+
+	/* Yes, we do want 16 SGIs */
+	WARN_ON(nr_irqs != 16);
+
+	for (i = 0; i < 16; i++) {
+		vpe->sgi_config[i].priority = 0;
+		vpe->sgi_config[i].enabled = false;
+		vpe->sgi_config[i].group = false;
+
+		irq_domain_set_hwirq_and_chip(domain, virq + i, i,
+					      &its_sgi_irq_chip, vpe);
+		irq_set_status_flags(virq + i, IRQ_DISABLE_UNLAZY);
+	}
+
+	return 0;
+}
+
+static void its_sgi_irq_domain_free(struct irq_domain *domain,
+				    unsigned int virq,
+				    unsigned int nr_irqs)
+{
+	/* Nothing to do */
+}
+
+static int its_sgi_irq_domain_activate(struct irq_domain *domain,
+				       struct irq_data *d, bool reserve)
+{
+	return 0;
+}
+
+static void its_sgi_irq_domain_deactivate(struct irq_domain *domain,
+					  struct irq_data *d)
+{
+	/* Nothing to do */
+}
+
+static struct irq_domain_ops its_sgi_domain_ops = {
+	.alloc		= its_sgi_irq_domain_alloc,
+	.free		= its_sgi_irq_domain_free,
+	.activate	= its_sgi_irq_domain_activate,
+	.deactivate	= its_sgi_irq_domain_deactivate,
+};
+
 static int its_vpe_id_alloc(void)
 {
 	return ida_simple_get(&its_vpeid_ida, 0, ITS_MAX_VPEID, GFP_KERNEL);
@@ -4781,8 +4842,13 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		rdists->has_rvpeid = false;
 
 	if (has_v4 & rdists->has_vlpis) {
+		struct irq_domain_ops *sgi_ops = NULL;
+
+		if (has_v4_1)
+			sgi_ops = &its_sgi_domain_ops;
+
 		if (its_init_vpe_domain() ||
-		    its_init_v4(parent_domain, &its_vpe_domain_ops)) {
+		    its_init_v4(parent_domain, &its_vpe_domain_ops, sgi_ops)) {
 			rdists->has_vlpis = false;
 			pr_err("ITS: Disabling GICv4 support\n");
 		}
diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 45969927cc81..c01910d53f9e 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -85,6 +85,7 @@
 
 static struct irq_domain *gic_domain;
 static const struct irq_domain_ops *vpe_domain_ops;
+static const struct irq_domain_ops *sgi_domain_ops;
 
 int its_alloc_vcpu_irqs(struct its_vm *vm)
 {
@@ -216,12 +217,15 @@ int its_prop_update_vlpi(int irq, u8 config, bool inv)
 	return irq_set_vcpu_affinity(irq, &info);
 }
 
-int its_init_v4(struct irq_domain *domain, const struct irq_domain_ops *ops)
+int its_init_v4(struct irq_domain *domain,
+		const struct irq_domain_ops *vpe_ops,
+		const struct irq_domain_ops *sgi_ops)
 {
 	if (domain) {
 		pr_info("ITS: Enabling GICv4 support\n");
 		gic_domain = domain;
-		vpe_domain_ops = ops;
+		vpe_domain_ops = vpe_ops;
+		sgi_domain_ops = sgi_ops;
 		return 0;
 	}
 
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index d9c34968467a..30b4855bf766 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -49,6 +49,11 @@ struct its_vpe {
 		};
 		/* GICv4.1 implementations */
 		struct {
+			struct {
+				u8	priority;
+				bool	enabled;
+				bool	group;
+			}			sgi_config[16];
 			atomic_t vmapp_count;
 		};
 	};
@@ -118,6 +123,8 @@ int its_unmap_vlpi(int irq);
 int its_prop_update_vlpi(int irq, u8 config, bool inv);
 
 struct irq_domain_ops;
-int its_init_v4(struct irq_domain *domain, const struct irq_domain_ops *ops);
+int its_init_v4(struct irq_domain *domain,
+		const struct irq_domain_ops *vpe_ops,
+		const struct irq_domain_ops *sgi_ops);
 
 #endif
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
