Return-Path: <SRS0=uKin=YU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5A5CA9EBC
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:46:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87E2221D80
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bmDWKx11"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87E2221D80
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F3404A4DF;
	Sun, 27 Oct 2019 10:46:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Udfn+4Bf2Rvw; Sun, 27 Oct 2019 10:46:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A9F14A7FE;
	Sun, 27 Oct 2019 10:46:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A1EC4A51D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:45:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cj6NuU66z5ka for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Oct 2019 10:45:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FE344A588
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:45:57 -0400 (EDT)
Received: from localhost.localdomain (82-132-239-15.dab.02.net [82.132.239.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A52C521726;
 Sun, 27 Oct 2019 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1572187556;
 bh=ziUIhoTUlVs+k2kjQOK0Igcf1cXP8akgwKfUmLFB3oE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bmDWKx111VIJookxfnPaqIwSYt3TIqs/phurD5G99zuGIko69LXYKpg3GODSkeyDj
 oEX8UjUnZOgsa2b09U09jZE28AurDSv+WldN1C0Qk65WVoodvUxbclIkjkl01xXjQQ
 3HLG+OdWNs8HAxcBxZjeA8r1K7iqR73/nKDoJd/g=
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 27/36] irqchip/gic-v4.1: Plumb get/set_irqchip_state SGI
 callbacks
Date: Sun, 27 Oct 2019 14:42:25 +0000
Message-Id: <20191027144234.8395-28-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191027144234.8395-1-maz@kernel.org>
References: <20191027144234.8395-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Jayachandran C <jnair@marvell.com>, Thomas Gleixner <tglx@linutronix.de>
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

To implement the get/set_irqchip_state callbacks (limited to the
PENDING state), we have to use a particular set of hacks:

- Reading the pending state is done by using a pair of new redistributor
  registers (GICR_VSGIR, GICR_VSGIPENDR), which allow the 16 interrupts
  state to be retrieved.
- Setting the pending state is done by generating it as we'd otherwise do
  for a guest (writing to GITS_SGIR)
- Clearing the pending state is done by emiting a VSGI command with the
  "clear" bit set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 56 ++++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h | 14 ++++++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index b9cef419f006..58dd497dc274 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3690,11 +3690,67 @@ static int its_sgi_set_affinity(struct irq_data *d,
 	return -EINVAL;
 }
 
+static int its_sgi_set_irqchip_state(struct irq_data *d,
+				     enum irqchip_irq_state which,
+				     bool state)
+{
+	if (which != IRQCHIP_STATE_PENDING)
+		return -EINVAL;
+
+	if (state) {
+		struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+		struct its_node *its = find_4_1_its();
+		u64 val;
+
+		val  = FIELD_PREP(GITS_SGIR_VPEID, vpe->vpe_id);
+		val |= FIELD_PREP(GITS_SGIR_VINTID, d->hwirq);
+		writeq_relaxed(val, its->sgir_base + GITS_SGIR - SZ_128K);
+	} else {
+		its_configure_sgi(d, true);
+	}
+
+	return 0;
+}
+
+static int its_sgi_get_irqchip_state(struct irq_data *d,
+				     enum irqchip_irq_state which, bool *val)
+{
+	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
+	void __iomem *base = gic_data_rdist_cpu(vpe->col_idx)->rd_base + SZ_128K;
+	u32 count = 1000000;	/* 1s! */
+	u32 status;
+
+	if (which != IRQCHIP_STATE_PENDING)
+		return -EINVAL;
+
+	writel_relaxed(vpe->vpe_id, base + GICR_VSGIR);
+	do {
+		status = readl_relaxed(base + GICR_VSGIPENDR);
+		if (!(status & GICR_VSGIPENDR_BUSY))
+			goto out;
+
+		count--;
+		if (!count) {
+			pr_err_ratelimited("Unable to get SGI status\n");
+			goto out;
+		}
+		cpu_relax();
+		udelay(1);
+	} while(count);
+
+out:
+	*val = !!(status & (1 << d->hwirq));
+
+	return 0;
+}
+
 static struct irq_chip its_sgi_irq_chip = {
 	.name			= "GICv4.1-sgi",
 	.irq_mask		= its_sgi_mask_irq,
 	.irq_unmask		= its_sgi_unmask_irq,
 	.irq_set_affinity	= its_sgi_set_affinity,
+	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
+	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
 };
 
 static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c73176d3ab2b..cb8563554ed2 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -340,6 +340,15 @@
 #define GICR_VPENDBASER_4_1_VGRP1EN	(1ULL << 58)
 #define GICR_VPENDBASER_4_1_VPEID	GENMASK_ULL(15, 0)
 
+#define GICR_VSGIR			0x0080
+
+#define GICR_VSGIR_VPEID		GENMASK(15, 0)
+
+#define GICR_VSGIPENDR			0x0088
+
+#define GICR_VSGIPENDR_BUSY		(1U << 31)
+#define GICR_VSGIPENDR_PENDING		GENMASK(15, 0)
+
 /*
  * ITS registers, offsets from ITS_base
  */
@@ -363,6 +372,11 @@
 
 #define GITS_TRANSLATER			0x10040
 
+#define GITS_SGIR			0x20020
+
+#define GITS_SGIR_VPEID			GENMASK_ULL(47, 32)
+#define GITS_SGIR_VINTID		GENMASK_ULL(7, 0)
+
 #define GITS_CTLR_ENABLE		(1U << 0)
 #define GITS_CTLR_ImDe			(1U << 1)
 #define	GITS_CTLR_ITS_NUMBER_SHIFT	4
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
