Return-Path: <SRS0=uKin=YU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B152CA9EAF
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:43:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F24E521D81
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3tfEgPe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F24E521D81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA1374AC6C;
	Sun, 27 Oct 2019 10:43:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F+qwWIkEPxxc; Sun, 27 Oct 2019 10:43:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE2C74A4EB;
	Sun, 27 Oct 2019 10:43:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C2B4AC6B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:43:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v0liRK2Cgdp5 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Oct 2019 10:43:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 833334AC77
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:43:16 -0400 (EDT)
Received: from localhost.localdomain (82-132-239-15.dab.02.net [82.132.239.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DD54A21D80;
 Sun, 27 Oct 2019 14:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1572187395;
 bh=lI2QXY7N7bzfzjYxpUeVKdkpqmi/gFe1igoOk4VTDhY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=k3tfEgPeAGNL5pMWkLAu/fHtKhzlAlb//jmUGrwJErRWDmISl7cpWfYwYxLT3bWus
 IXYOesQ9uxPZft7sxauxH9ZXsuL35MWfiNZYFsiNqy410jck/v4AajgNf99UXPur/n
 QnVhyraB2KEx44DX+AVD4HRHTa1+7j3q+EFFoRNg=
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/36] irqchip/gic-v3-its: Allow LPI invalidation via the
 DirectLPI interface
Date: Sun, 27 Oct 2019 14:42:01 +0000
Message-Id: <20191027144234.8395-4-maz@kernel.org>
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

We currently don't make much use of the DirectLPI feature, and it would
be beneficial to do this more, if only because it becomes a mandatory
feature for GICv4.1.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 40 +++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 58cb233cf138..3e33cdc08200 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -175,6 +175,12 @@ static DEFINE_IDA(its_vpeid_ida);
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
 
+static inline u32 its_get_event_id(struct irq_data *d)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	return d->hwirq - its_dev->event_map.lpi_base;
+}
+
 static struct its_collection *dev_event_to_col(struct its_device *its_dev,
 					       u32 event)
 {
@@ -183,6 +189,13 @@ static struct its_collection *dev_event_to_col(struct its_device *its_dev,
 	return its->collections + its_dev->event_map.col_map[event];
 }
 
+static struct its_collection *irq_to_col(struct irq_data *d)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+
+	return dev_event_to_col(its_dev, its_get_event_id(d));
+}
+
 static struct its_collection *valid_col(struct its_collection *col)
 {
 	if (WARN_ON_ONCE(col->target_address & GENMASK_ULL(15, 0)))
@@ -1031,12 +1044,6 @@ static void its_send_vinvall(struct its_node *its, struct its_vpe *vpe)
  * irqchip functions - assumes MSI, mostly.
  */
 
-static inline u32 its_get_event_id(struct irq_data *d)
-{
-	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
-	return d->hwirq - its_dev->event_map.lpi_base;
-}
-
 static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
 {
 	irq_hw_number_t hwirq;
@@ -1081,12 +1088,28 @@ static void wait_for_syncr(void __iomem *rdbase)
 		cpu_relax();
 }
 
+static void direct_lpi_inv(struct irq_data *d)
+{
+	struct its_collection *col;
+	void __iomem *rdbase;
+
+	/* Target the redistributor this LPI is currently routed to */
+	col = irq_to_col(d);
+	rdbase = per_cpu_ptr(gic_rdists->rdist, col->col_id)->rd_base;
+	gic_write_lpir(d->hwirq, rdbase + GICR_INVLPIR);
+
+	wait_for_syncr(rdbase);
+}
+
 static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 
 	lpi_write_config(d, clr, set);
-	its_send_inv(its_dev, its_get_event_id(d));
+	if (gic_rdists->has_direct_lpi && !irqd_is_forwarded_to_vcpu(d))
+		direct_lpi_inv(d);
+	else
+		its_send_inv(its_dev, its_get_event_id(d));
 }
 
 static void its_vlpi_set_doorbell(struct irq_data *d, bool enable)
@@ -2917,8 +2940,9 @@ static void its_vpe_send_inv(struct irq_data *d)
 	if (gic_rdists->has_direct_lpi) {
 		void __iomem *rdbase;
 
+		/* Target the redistributor this VPE is currently known on */
 		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
-		gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_INVLPIR);
+		gic_write_lpir(d->parent_data->hwirq, rdbase + GICR_INVLPIR);
 		wait_for_syncr(rdbase);
 	} else {
 		its_vpe_send_cmd(vpe, its_send_inv);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
