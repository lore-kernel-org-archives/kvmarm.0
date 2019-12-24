Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84E9C2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:42:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 986A620706
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 11:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 986A620706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F9EA4AF31;
	Tue, 24 Dec 2019 06:42:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vIyeGJTuIbK6; Tue, 24 Dec 2019 06:42:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F97B4AF21;
	Tue, 24 Dec 2019 06:42:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 975604AF21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:42:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g7G5GLf9HfnU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 06:42:47 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A96C04AF1F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 06:42:47 -0500 (EST)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by cheepnis.misterjones.org with esmtpsa
 (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128) (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iji67-000169-7U; Tue, 24 Dec 2019 12:11:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 22/32] irqchip/gic-v4.1: Plumb set_vcpu_affinity SGI
 callbacks
Date: Tue, 24 Dec 2019 11:10:45 +0000
Message-Id: <20191224111055.11836-23-maz@kernel.org>
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
index 47d63a5b43ff..5126bdcfe079 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3886,6 +3886,23 @@ static int its_sgi_get_irqchip_state(struct irq_data *d,
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
@@ -3893,6 +3910,7 @@ static struct irq_chip its_sgi_irq_chip = {
 	.irq_set_affinity	= its_sgi_set_affinity,
 	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
 	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
+	.irq_set_vcpu_affinity	= its_sgi_set_vcpu_affinity,
 };
 
 static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 30b4855bf766..a1a9d40266f5 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -98,6 +98,7 @@ enum its_vcpu_info_cmd_type {
 	SCHEDULE_VPE,
 	DESCHEDULE_VPE,
 	INVALL_VPE,
+	PROP_UPDATE_SGI,
 };
 
 struct its_cmd_info {
@@ -110,6 +111,10 @@ struct its_cmd_info {
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
