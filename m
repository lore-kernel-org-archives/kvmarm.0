Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D705C2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:11:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C73220409
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:11:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C73220409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEBD64AF96;
	Tue, 24 Dec 2019 06:11:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UQAC6V+UfjLr; Tue, 24 Dec 2019 06:11:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 708E94AF83;
	Tue, 24 Dec 2019 06:11:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 608FC4AF49
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:11:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GCIHA7fvLIk1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 06:11:21 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70A674AF6D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:11:18 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iji5t-000169-6L; Tue, 24 Dec 2019 12:11:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/32] irqchip/gic-v4.1: Plumb skeletal VPE irqchip
Date: Tue, 24 Dec 2019 11:10:32 +0000
Message-Id: <20191224111055.11836-10-maz@kernel.org>
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

Just like for GICv4.0, each VPE has its own doorbell interrupt, and
thus an irqchip that manages them. Since the doorbell management is
quite different on GICv4.1, let's introduce an almost empty irqchip
the will get populated over the next new patches.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index fd9d3b6bb465..157f51398850 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3554,6 +3554,32 @@ static struct irq_chip its_vpe_irq_chip = {
 	.irq_set_vcpu_affinity	= its_vpe_set_vcpu_affinity,
 };
 
+static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
+{
+	struct its_cmd_info *info = vcpu_info;
+
+	switch (info->cmd_type) {
+	case SCHEDULE_VPE:
+		return 0;
+
+	case DESCHEDULE_VPE:
+		return 0;
+
+	case INVALL_VPE:
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static struct irq_chip its_vpe_4_1_irq_chip = {
+	.name			= "GICv4.1-vpe",
+	.irq_eoi		= irq_chip_eoi_parent,
+	.irq_set_affinity	= its_vpe_set_affinity,
+	.irq_set_vcpu_affinity	= its_vpe_4_1_set_vcpu_affinity,
+};
+
 static int its_vpe_id_alloc(void)
 {
 	return ida_simple_get(&its_vpeid_ida, 0, ITS_MAX_VPEID, GFP_KERNEL);
@@ -3634,6 +3660,7 @@ static void its_vpe_irq_domain_free(struct irq_domain *domain,
 static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 				    unsigned int nr_irqs, void *args)
 {
+	struct irq_chip *irqchip = &its_vpe_irq_chip;
 	struct its_vm *vm = args;
 	unsigned long *bitmap;
 	struct page *vprop_page;
@@ -3661,6 +3688,9 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 	vm->nr_db_lpis = nr_ids;
 	vm->vprop_page = vprop_page;
 
+	if (gic_rdists->has_rvpeid)
+		irqchip = &its_vpe_4_1_irq_chip;
+
 	for (i = 0; i < nr_irqs; i++) {
 		vm->vpes[i]->vpe_db_lpi = base + i;
 		err = its_vpe_init(vm->vpes[i]);
@@ -3671,7 +3701,7 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 		if (err)
 			break;
 		irq_domain_set_hwirq_and_chip(domain, virq + i, i,
-					      &its_vpe_irq_chip, vm->vpes[i]);
+					      irqchip, vm->vpes[i]);
 		set_bit(i, bitmap);
 	}
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
