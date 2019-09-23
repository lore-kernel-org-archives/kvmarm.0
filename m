Return-Path: <SRS0=gg7X=XS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F02C4CED0
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:28:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7626B20665
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:28:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7626B20665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C654A682;
	Mon, 23 Sep 2019 14:28:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yikb7xu1JaRt; Mon, 23 Sep 2019 14:28:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 181444A5A6;
	Mon, 23 Sep 2019 14:28:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53F6F4A555
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:28:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oc0kYaBqliOw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Sep 2019 14:28:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71EB24A610
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:28:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33BFB237B;
 Mon, 23 Sep 2019 11:28:08 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 52D513F694;
 Mon, 23 Sep 2019 11:28:04 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 27/35] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI callbacks
Date: Mon, 23 Sep 2019 19:25:58 +0100
Message-Id: <20190923182606.32100-28-maz@kernel.org>
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

As for VLPIs, there is a number of configuration bits that cannot
be directly communicated through the normal irqchip API, and we
have to use our good old friend set_vcpu_affinity.

This is used to configure group and priority for a given vSGI.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 18 ++++++++++++++++++
 include/linux/irqchip/arm-gic-v4.h |  5 +++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 5e67dfe1c4b1..4aae9582182b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3737,6 +3737,23 @@ static int its_sgi_get_irqchip_state(struct irq_data *d,
 	return 0;
 }
 
+static int its_sgi_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+	struct its_cmd_info *info = vcpu_info;
+
+	switch (info->cmd_type) {
+	case PROP_UPDATE_SGI:
+		vpe->sgi_config[d->hwirq].priority = info->priority;
+		vpe->sgi_config[d->hwirq].group = info->group;
+		its_configure_sgi(d, false);
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
 static struct irq_chip its_sgi_irq_chip = {
 	.name			= "GICv4.1-sgi",
 	.irq_mask		= its_sgi_mask_irq,
@@ -3744,6 +3761,7 @@ static struct irq_chip its_sgi_irq_chip = {
 	.irq_set_affinity	= its_sgi_set_affinity,
 	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
 	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
+	.irq_set_vcpu_affinity	= its_sgi_set_vcpu_affinity,
 };
 
 static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 03bbd0aed2e2..6185926e4582 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -96,6 +96,7 @@ enum its_vcpu_info_cmd_type {
 	SCHEDULE_VPE,
 	DESCHEDULE_VPE,
 	INVALL_VPE,
+	PROP_UPDATE_SGI,
 };
 
 struct its_cmd_info {
@@ -108,6 +109,10 @@ struct its_cmd_info {
 			bool		g0en;
 			bool		g1en;
 		};
+		struct {
+			u8		priority;
+			bool		group;
+		};
 	};
 };
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
