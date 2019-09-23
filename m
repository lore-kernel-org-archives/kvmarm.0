Return-Path: <SRS0=gg7X=XS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8836C4CED0
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:27:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADD1C21783
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADD1C21783
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 686BE4A67B;
	Mon, 23 Sep 2019 14:27:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LQ54H4n8hCfC; Mon, 23 Sep 2019 14:27:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 538D74A595;
	Mon, 23 Sep 2019 14:27:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E0DD4A51F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:27:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CvPMy+VEpKcU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Sep 2019 14:27:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 996364A5C3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:27:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D2541AED;
 Mon, 23 Sep 2019 11:27:18 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 898363F694;
 Mon, 23 Sep 2019 11:27:15 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/35] irqchip/gic-v4.1: Plumb skeletal VPE irqchip
Date: Mon, 23 Sep 2019 19:25:45 +0100
Message-Id: <20190923182606.32100-15-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190923182606.32100-1-maz@kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
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

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c71aa0046bf0..4098ef6d030a 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3403,6 +3403,32 @@ static struct irq_chip its_vpe_irq_chip = {
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
@@ -3483,6 +3509,7 @@ static void its_vpe_irq_domain_free(struct irq_domain *domain,
 static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 				    unsigned int nr_irqs, void *args)
 {
+	struct irq_chip *irqchip = &its_vpe_irq_chip;
 	struct its_vm *vm = args;
 	unsigned long *bitmap;
 	struct page *vprop_page;
@@ -3510,6 +3537,9 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 	vm->nr_db_lpis = nr_ids;
 	vm->vprop_page = vprop_page;
 
+	if (gic_rdists->has_rvpeid)
+		irqchip = &its_vpe_4_1_irq_chip;
+
 	for (i = 0; i < nr_irqs; i++) {
 		vm->vpes[i]->vpe_db_lpi = base + i;
 		err = its_vpe_init(vm->vpes[i]);
@@ -3520,7 +3550,7 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
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
