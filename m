Return-Path: <SRS0=uKin=YU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FCACCA9EBC
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:45:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC4EA21D80
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:45:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyQ3KDW0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC4EA21D80
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75C224AC9B;
	Sun, 27 Oct 2019 10:45:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Wx5OJ8w9jzHC; Sun, 27 Oct 2019 10:45:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D1A84AC7B;
	Sun, 27 Oct 2019 10:45:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A59024AC65
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:45:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id evordDPOkavb for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Oct 2019 10:45:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89B454A50F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:45:22 -0400 (EDT)
Received: from localhost.localdomain (82-132-239-15.dab.02.net [82.132.239.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 79AE321D7F;
 Sun, 27 Oct 2019 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1572187521;
 bh=FzgKMCYjRYf3HWs4mtVHwQgc+VtCzxmMq/IIStKY2AI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=NyQ3KDW0gBq7sUEWrJ5I2NQvlvsBZ3fZdZJxciE9qFFJ+w7YnFIagcgXHmQOLIRBl
 IOv4UPcFUFUN6opfivFoKBiJaazY5I+CAY8lNobjZ16YggGa2g51E6IAaoP9wJQ5LU
 J7xyZT1i7OJ/D77pDnOZW+CREGTA1qxDma6EQ4xI=
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 21/36] irqchip/gic-v4.1: Allow direct invalidation of VLPIs
Date: Sun, 27 Oct 2019 14:42:19 +0000
Message-Id: <20191027144234.8395-22-maz@kernel.org>
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

Just like for INVALL, GICv4.1 has grown a VPE-aware INVLPI register.
Let's plumb it in and make use of the DirectLPI code in that case.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 53 ++++++++++++++++++++----------
 include/linux/irqchip/arm-gic-v3.h |  1 +
 2 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 75c4d1a6f20d..df259e202482 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -203,11 +203,26 @@ static struct its_collection *dev_event_to_col(struct its_device *its_dev,
 	return its->collections + its_dev->event_map.col_map[event];
 }
 
-static struct its_collection *irq_to_col(struct irq_data *d)
+static struct its_vlpi_map *get_vlpi_map(struct irq_data *d)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	u32 event = its_get_event_id(d);
+
+	if (!irqd_is_forwarded_to_vcpu(d))
+		return NULL;
 
-	return dev_event_to_col(its_dev, its_get_event_id(d));
+	return &its_dev->event_map.vlpi_maps[event];
+}
+
+static int irq_to_cpuid(struct irq_data *d)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	struct its_vlpi_map *map = get_vlpi_map(d);
+
+	if (map)
+		return map->vpe->col_idx;
+
+	return its_dev->event_map.col_map[its_get_event_id(d)];
 }
 
 static struct its_collection *valid_col(struct its_collection *col)
@@ -1147,17 +1162,6 @@ static void its_send_invdb(struct its_node *its, struct its_vpe *vpe)
 /*
  * irqchip functions - assumes MSI, mostly.
  */
-static struct its_vlpi_map *get_vlpi_map(struct irq_data *d)
-{
-	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
-	u32 event = its_get_event_id(d);
-
-	if (!irqd_is_forwarded_to_vcpu(d))
-		return NULL;
-
-	return &its_dev->event_map.vlpi_maps[event];
-}
-
 static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
 {
 	struct its_vlpi_map *map = get_vlpi_map(d);
@@ -1200,13 +1204,25 @@ static void wait_for_syncr(void __iomem *rdbase)
 
 static void direct_lpi_inv(struct irq_data *d)
 {
-	struct its_collection *col;
+	struct its_vlpi_map *map = get_vlpi_map(d);
 	void __iomem *rdbase;
+	u64 val;
+
+	if (map) {
+		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+
+		WARN_ON(!is_v4_1(its_dev->its));
+
+		val  = GICR_INVLPIR_V;
+		val |= FIELD_PREP(GICR_INVLPIR_VPEID, map->vpe->vpe_id);
+		val |= FIELD_PREP(GICR_INVLPIR_INTID, map->vintid);
+	} else {
+		val = d->hwirq;
+	}
 
 	/* Target the redistributor this LPI is currently routed to */
-	col = irq_to_col(d);
-	rdbase = per_cpu_ptr(gic_rdists->rdist, col->col_id)->rd_base;
-	gic_write_lpir(d->hwirq, rdbase + GICR_INVLPIR);
+	rdbase = per_cpu_ptr(gic_rdists->rdist, irq_to_cpuid(d))->rd_base;
+	gic_write_lpir(val, rdbase + GICR_INVLPIR);
 
 	wait_for_syncr(rdbase);
 }
@@ -1216,7 +1232,8 @@ static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 
 	lpi_write_config(d, clr, set);
-	if (gic_rdists->has_direct_lpi && !irqd_is_forwarded_to_vcpu(d))
+	if (gic_rdists->has_direct_lpi &&
+	    (is_v4_1(its_dev->its) || !irqd_is_forwarded_to_vcpu(d)))
 		direct_lpi_inv(d);
 	else
 		its_send_inv(its_dev, its_get_event_id(d));
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index b69f60792554..5f3278cbf247 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -247,6 +247,7 @@
 #define GICR_TYPER_COMMON_LPI_AFF	GENMASK_ULL(25, 24)
 #define GICR_TYPER_AFFINITY		GENMASK_ULL(63, 32)
 
+#define GICR_INVLPIR_INTID		GENMASK_ULL(31, 0)
 #define GICR_INVLPIR_VPEID		GENMASK_ULL(47, 32)
 #define GICR_INVLPIR_V			GENMASK_ULL(63, 63)
 
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
