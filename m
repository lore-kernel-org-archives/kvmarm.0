Return-Path: <SRS0=Ladk=4V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35685C3F2D1
	for <kvmarm@archiver.kernel.org>; Wed,  4 Mar 2020 20:34:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E20682146E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Mar 2020 20:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMZEVqv4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E20682146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B6CE4AF95;
	Wed,  4 Mar 2020 15:34:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mNIdsB3LvQpr; Wed,  4 Mar 2020 15:34:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD89B4AFC6;
	Wed,  4 Mar 2020 15:34:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C4804AFDA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 15:34:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nNMvwLs6z-cG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2020 15:34:50 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FC6C4AFC0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2020 15:34:45 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9849724679;
 Wed,  4 Mar 2020 20:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1583354084;
 bh=mjd4h8wsO7GO4FNYyLMX6kiNqR+30OF1Rvy8SpKjZfY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=AMZEVqv4HH+RdGkzhkkaOPeXifQc+Ve9y2NCE8Rd24fv5/OeLktJ24eYDfxqzV9QG
 p1Tw/g/l9gez+BbMqO6gJmcMN7YH9H+Govb8FPxf+xJXOKG47OmOYPaH20QLO/A42R
 l4Xjfx1gKoIj7aV+zG746ecZWBmd+xpyj1+coW9Y=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j9aj4-00A59R-Um; Wed, 04 Mar 2020 20:34:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 07/23] irqchip/gic-v4.1: Map the ITS SGIR register page
Date: Wed,  4 Mar 2020 20:33:14 +0000
Message-Id: <20200304203330.4967-8-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304203330.4967-1-maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com,
 eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
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

One of the new features of GICv4.1 is to allow virtual SGIs to be
directly signaled to a VPE. For that, the ITS has grown a new
64kB page containing only a single register that is used to
signal a SGI to a given VPE.

Add a second mapping covering this new 64kB range, and take this
opportunity to limit the original mapping to 64kB, which is enough
to cover the span of the ITS registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index bcc1a0957cda..54d6fdf7a28e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -96,6 +96,7 @@ struct its_node {
 	struct mutex		dev_alloc_lock;
 	struct list_head	entry;
 	void __iomem		*base;
+	void __iomem		*sgir_base;
 	phys_addr_t		phys_base;
 	struct its_cmd_block	*cmd_base;
 	struct its_cmd_block	*cmd_write;
@@ -4456,7 +4457,7 @@ static int __init its_probe_one(struct resource *res,
 	struct page *page;
 	int err;
 
-	its_base = ioremap(res->start, resource_size(res));
+	its_base = ioremap(res->start, SZ_64K);
 	if (!its_base) {
 		pr_warn("ITS@%pa: Unable to map ITS registers\n", &res->start);
 		return -ENOMEM;
@@ -4507,6 +4508,13 @@ static int __init its_probe_one(struct resource *res,
 
 		if (is_v4_1(its)) {
 			u32 svpet = FIELD_GET(GITS_TYPER_SVPET, typer);
+
+			its->sgir_base = ioremap(res->start + SZ_128K, SZ_64K);
+			if (!its->sgir_base) {
+				err = -ENOMEM;
+				goto out_free_its;
+			}
+
 			its->mpidr = readl_relaxed(its_base + GITS_MPIDR);
 
 			pr_info("ITS@%pa: Using GICv4.1 mode %08x %08x\n",
@@ -4520,7 +4528,7 @@ static int __init its_probe_one(struct resource *res,
 				get_order(ITS_CMD_QUEUE_SZ));
 	if (!page) {
 		err = -ENOMEM;
-		goto out_free_its;
+		goto out_unmap_sgir;
 	}
 	its->cmd_base = (void *)page_address(page);
 	its->cmd_write = its->cmd_base;
@@ -4587,6 +4595,9 @@ static int __init its_probe_one(struct resource *res,
 	its_free_tables(its);
 out_free_cmd:
 	free_pages((unsigned long)its->cmd_base, get_order(ITS_CMD_QUEUE_SZ));
+out_unmap_sgir:
+	if (its->sgir_base)
+		iounmap(its->sgir_base);
 out_free_its:
 	kfree(its);
 out_unmap:
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
