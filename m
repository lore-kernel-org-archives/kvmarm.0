Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469FFC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 13:49:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEFAC61584
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 13:49:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEFAC61584
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 678D04B82F;
	Mon, 10 May 2021 09:49:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WgkHdeqOIiln; Mon, 10 May 2021 09:49:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A85284B847;
	Mon, 10 May 2021 09:49:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F0CD4B83C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 09:49:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oOei39x4BWVI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 09:49:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22F944B6EB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 09:49:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E8CF86157F;
 Mon, 10 May 2021 13:49:25 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lg6Hk-000Rol-7i; Mon, 10 May 2021 14:49:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 9/9] irqchip/apple-aic: Advertise some level of vGICv3
 compatibility
Date: Mon, 10 May 2021 14:48:24 +0100
Message-Id: <20210510134824.1910399-10-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510134824.1910399-1-maz@kernel.org>
References: <20210510134824.1910399-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st,
 mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Hector Martin <marcan@marcan.st>
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

The CPUs in the Apple M1 SoC partially implement a virtual GICv3
CPU interface, although one that is incapable of HW deactivation
of interrupts.

Advertise the support to KVM.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-apple-aic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/irqchip/irq-apple-aic.c b/drivers/irqchip/irq-apple-aic.c
index c179e27062fd..a44370c018e2 100644
--- a/drivers/irqchip/irq-apple-aic.c
+++ b/drivers/irqchip/irq-apple-aic.c
@@ -50,6 +50,7 @@
 #include <linux/cpuhotplug.h>
 #include <linux/io.h>
 #include <linux/irqchip.h>
+#include <linux/irqchip/arm-vgic-info.h>
 #include <linux/irqdomain.h>
 #include <linux/limits.h>
 #include <linux/of_address.h>
@@ -787,6 +788,11 @@ static int aic_init_cpu(unsigned int cpu)
 	return 0;
 }
 
+static struct gic_kvm_info vgic_info __initdata = {
+	.type			= GIC_V3,
+	.no_hw_deactivation	= true,
+};
+
 static int __init aic_of_ic_init(struct device_node *node, struct device_node *parent)
 {
 	int i;
@@ -843,6 +849,8 @@ static int __init aic_of_ic_init(struct device_node *node, struct device_node *p
 			  "irqchip/apple-aic/ipi:starting",
 			  aic_init_cpu, NULL);
 
+	vgic_set_kvm_info(&vgic_info);
+
 	pr_info("Initialized with %d IRQs, %d FIQs, %d vIPIs\n",
 		irqc->nr_hw, AIC_NR_FIQ, AIC_NR_SWIPI);
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
