Return-Path: <SRS0=uKin=YU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0A7CA9EAF
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:43:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 83BDC222C1
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:43:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="OV3dt2ux"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83BDC222C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C6714AC85;
	Sun, 27 Oct 2019 10:43:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QX20kAo-RjEA; Sun, 27 Oct 2019 10:43:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C2B4A944;
	Sun, 27 Oct 2019 10:43:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7B94A551
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:43:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cLipVzktlPnh for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Oct 2019 10:43:39 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 129BD4A50F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:43:39 -0400 (EDT)
Received: from localhost.localdomain (82-132-239-15.dab.02.net [82.132.239.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D3C25214AF;
 Sun, 27 Oct 2019 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1572187418;
 bh=vb7tXsiKtk7C1d0EnILqFVVoK9y3ZGFerTetWrUIH0s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OV3dt2uxlj28ZGDi4PdCfmIeZGtmQCQUwK8AG8ubLsTDz4XOBf6erpQfdTIfls8jN
 KIm2KSHIbXciIeB6jI5hdBMxNxs4bQInDJpb6ZZ9O6xSAQbMP2cbk42Pt/HZkTbtdM
 KES5S+27qrjmJY/qba8y6fGtcUKQM/NLxNNOWuJg=
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/36] irqchip/gic-v3-its: Kill its->device_ids and use
 TYPER copy instead
Date: Sun, 27 Oct 2019 14:42:04 +0000
Message-Id: <20191027144234.8395-7-maz@kernel.org>
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

Now that we have a copy of TYPER in the ITS structure, rely on this
to provide the same service as its->device_ids, which gets axed.
Errata workarounds are now updating the cached fields instead of
requiring a separate field in the ITS structure.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 24 +++++++++++++-----------
 include/linux/irqchip/arm-gic-v3.h |  2 +-
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 3b046181ddfc..6c91c7feadf3 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -109,7 +109,6 @@ struct its_node {
 	struct list_head	its_device_list;
 	u64			flags;
 	unsigned long		list_nr;
-	u32			device_ids;
 	int			numa_node;
 	unsigned int		msi_domain_flags;
 	u32			pre_its_base; /* for Socionext Synquacer */
@@ -117,6 +116,7 @@ struct its_node {
 };
 
 #define is_v4(its)		(!!((its)->typer & GITS_TYPER_VLPIS))
+#define device_ids(its)		(FIELD_GET(GITS_TYPER_DEVBITS, (its)->typer) + 1)
 
 #define ITS_ITT_ALIGN		SZ_256
 
@@ -1938,9 +1938,9 @@ static bool its_parse_indirect_baser(struct its_node *its,
 	if (new_order >= MAX_ORDER) {
 		new_order = MAX_ORDER - 1;
 		ids = ilog2(PAGE_ORDER_TO_SIZE(new_order) / (int)esz);
-		pr_warn("ITS@%pa: %s Table too large, reduce ids %u->%u\n",
+		pr_warn("ITS@%pa: %s Table too large, reduce ids %llu->%u\n",
 			&its->phys_base, its_base_type_string[type],
-			its->device_ids, ids);
+			device_ids(its), ids);
 	}
 
 	*order = new_order;
@@ -1986,7 +1986,7 @@ static int its_alloc_tables(struct its_node *its)
 		case GITS_BASER_TYPE_DEVICE:
 			indirect = its_parse_indirect_baser(its, baser,
 							    psz, &order,
-							    its->device_ids);
+							    device_ids(its));
 			break;
 
 		case GITS_BASER_TYPE_VCPU:
@@ -2377,7 +2377,7 @@ static bool its_alloc_device_table(struct its_node *its, u32 dev_id)
 
 	/* Don't allow device id that exceeds ITS hardware limit */
 	if (!baser)
-		return (ilog2(dev_id) < its->device_ids);
+		return (ilog2(dev_id) < device_ids(its));
 
 	return its_alloc_table_entry(its, baser, dev_id);
 }
@@ -3229,8 +3229,9 @@ static bool __maybe_unused its_enable_quirk_cavium_22375(void *data)
 {
 	struct its_node *its = data;
 
-	/* erratum 22375: only alloc 8MB table size */
-	its->device_ids = 0x14;		/* 20 bits, 8MB */
+	/* erratum 22375: only alloc 8MB table size (20 bits) */
+	its->typer &= ~GITS_TYPER_DEVBITS;
+	its->typer |= FIELD_PREP(GITS_TYPER_DEVBITS, 20 - 1);
 	its->flags |= ITS_FLAGS_WORKAROUND_CAVIUM_22375;
 
 	return true;
@@ -3285,8 +3286,10 @@ static bool __maybe_unused its_enable_quirk_socionext_synquacer(void *data)
 		its->get_msi_base = its_irq_get_msi_base_pre_its;
 
 		ids = ilog2(pre_its_window[1]) - 2;
-		if (its->device_ids > ids)
-			its->device_ids = ids;
+		if (device_ids(its) > ids) {
+			its->typer &= ~GITS_TYPER_DEVBITS;
+			its->typer |= FIELD_PREP(GITS_TYPER_DEVBITS, ids - 1);
+		}
 
 		/* the pre-ITS breaks isolation, so disable MSI remapping */
 		its->msi_domain_flags &= ~IRQ_DOMAIN_FLAG_MSI_REMAP;
@@ -3519,7 +3522,7 @@ static int its_init_vpe_domain(void)
 	}
 
 	/* Use the last possible DevID */
-	devid = GENMASK(its->device_ids - 1, 0);
+	devid = GENMASK(device_ids(its) - 1, 0);
 	vpe_proxy.dev = its_create_device(its, devid, entries, false);
 	if (!vpe_proxy.dev) {
 		kfree(vpe_proxy.vpes);
@@ -3620,7 +3623,6 @@ static int __init its_probe_one(struct resource *res,
 	its->typer = typer;
 	its->base = its_base;
 	its->phys_base = res->start;
-	its->device_ids = GITS_TYPER_DEVBITS(typer);
 	if (is_v4(its)) {
 		if (!(typer & GITS_TYPER_VMOVP)) {
 			err = its_compute_its_list_map(res, its_base);
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 4bce7a904075..b6514e8893bf 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -337,7 +337,7 @@
 #define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
 #define GITS_TYPER_IDBITS_SHIFT		8
 #define GITS_TYPER_DEVBITS_SHIFT	13
-#define GITS_TYPER_DEVBITS(r)		((((r) >> GITS_TYPER_DEVBITS_SHIFT) & 0x1f) + 1)
+#define GITS_TYPER_DEVBITS		GENMASK_ULL(17, 13)
 #define GITS_TYPER_PTA			(1UL << 19)
 #define GITS_TYPER_HCC_SHIFT		24
 #define GITS_TYPER_HCC(r)		(((r) >> GITS_TYPER_HCC_SHIFT) & 0xff)
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
