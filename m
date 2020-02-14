Return-Path: <SRS0=Bd71=4C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8B6C3B19F
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 14:58:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C6D9424681
	for <kvmarm@archiver.kernel.org>; Fri, 14 Feb 2020 14:58:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWzX1W1n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6D9424681
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 717AF4AEAF;
	Fri, 14 Feb 2020 09:58:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X2XdGd7ir6e0; Fri, 14 Feb 2020 09:58:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0344E4AEEA;
	Fri, 14 Feb 2020 09:57:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FFA44AE9F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 09:57:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RGuae24DsuTL for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Feb 2020 09:57:56 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E40E4AEB5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Feb 2020 09:57:53 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 866042469A;
 Fri, 14 Feb 2020 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581692272;
 bh=e2zVYki0pGyroLA9GfqVl31JuEivIYApM5ERsSmzFao=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fWzX1W1nsLdWf6QDLkogVPIGq8r/TyaExJeTvHqqNXCozeRdlc5jjDylTXkizlG3z
 qHM4tKTazOGWlAFL0YO+LwndJRothjO3UIz7q/OG5So5pQu0Q6T2TtxHFxvKpiyKFW
 dH/NXsZabyptGV4MgmR0jDPQS93gYf7Gywfx4qmw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j2cPe-0057sw-R0; Fri, 14 Feb 2020 14:57:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state SGI
 callbacks
Date: Fri, 14 Feb 2020 14:57:24 +0000
Message-Id: <20200214145736.18550-9-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214145736.18550-1-maz@kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
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
index 1e448d9a16ea..a9753435c4ff 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3915,11 +3915,67 @@ static int its_sgi_set_affinity(struct irq_data *d,
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
index a89578884263..64da945486ac 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -345,6 +345,15 @@
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
@@ -368,6 +377,11 @@
 
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
