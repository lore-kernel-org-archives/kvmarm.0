Return-Path: <SRS0=uKin=YU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D246CA9EBF
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:43:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 40D0B21850
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sky7QoVE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40D0B21850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED1724A551;
	Sun, 27 Oct 2019 10:43:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KIYRfmOF4W9p; Sun, 27 Oct 2019 10:43:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCD404A50F;
	Sun, 27 Oct 2019 10:43:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 627344A4EB
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:43:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 19Wf9W1kXp+P for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Oct 2019 10:43:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 378214A529
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:43:22 -0400 (EDT)
Received: from localhost.localdomain (82-132-239-15.dab.02.net [82.132.239.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 42B09214AF;
 Sun, 27 Oct 2019 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1572187401;
 bh=cUEdEwphqN43cYOxa2q8QizaXOhiNpLrbbRlDlA67fU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=sky7QoVE+aOUCloU1W0N0ZxRF7ELtvLkESfQ1fXIRrobyIUb/3X8NdgVafHtQwyut
 NQnVXCUV6W0Dv5mOSRKmfT36XkRQCGNhCHN2QxfYjffWu2b2OVd5uIbR0FOy7oM5Jp
 rDUF6A62v6+F8c2hkEeqfYO7HL8q4rTMv+i5o+bI=
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/36] irqchip/gic-v3-its: Make is_v4 use a TYPER copy
Date: Sun, 27 Oct 2019 14:42:02 +0000
Message-Id: <20191027144234.8395-5-maz@kernel.org>
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

Instead of caching the GICv4 compatibility in a discrete way, cache the
TYPER register instead, which can then be used to implement the same
functionnality. This will get used more extensively in subsequent patches.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 3e33cdc08200..b3c9bc0c3ecd 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -102,6 +102,7 @@ struct its_node {
 	struct its_collection	*collections;
 	struct fwnode_handle	*fwnode_handle;
 	u64			(*get_msi_base)(struct its_device *its_dev);
+	u64			typer;
 	u64			cbaser_save;
 	u32			ctlr_save;
 	struct list_head	its_device_list;
@@ -112,10 +113,11 @@ struct its_node {
 	int			numa_node;
 	unsigned int		msi_domain_flags;
 	u32			pre_its_base; /* for Socionext Synquacer */
-	bool			is_v4;
 	int			vlpi_redist_offset;
 };
 
+#define is_v4(its)		(!!((its)->typer & GITS_TYPER_VLPIS))
+
 #define ITS_ITT_ALIGN		SZ_256
 
 /* The maximum number of VPEID bits supported by VLPI commands */
@@ -1019,7 +1021,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
 
 	/* Emit VMOVPs */
 	list_for_each_entry(its, &its_nodes, entry) {
-		if (!its->is_v4)
+		if (!is_v4(its))
 			continue;
 
 		if (!vpe->its_vm->vlpi_count[its->list_nr])
@@ -1430,7 +1432,7 @@ static int its_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
 	struct its_cmd_info *info = vcpu_info;
 
 	/* Need a v4 ITS */
-	if (!its_dev->its->is_v4)
+	if (!is_v4(its_dev->its))
 		return -EINVAL;
 
 	/* Unmap request? */
@@ -2394,7 +2396,7 @@ static bool its_alloc_vpe_table(u32 vpe_id)
 	list_for_each_entry(its, &its_nodes, entry) {
 		struct its_baser *baser;
 
-		if (!its->is_v4)
+		if (!is_v4(its))
 			continue;
 
 		baser = its_get_baser(its, GITS_BASER_TYPE_VCPU);
@@ -2882,7 +2884,7 @@ static void its_vpe_invall(struct its_vpe *vpe)
 	struct its_node *its;
 
 	list_for_each_entry(its, &its_nodes, entry) {
-		if (!its->is_v4)
+		if (!is_v4(its))
 			continue;
 
 		if (its_list_map && !vpe->its_vm->vlpi_count[its->list_nr])
@@ -3150,7 +3152,7 @@ static int its_vpe_irq_domain_activate(struct irq_domain *domain,
 	vpe->col_idx = cpumask_first(cpu_online_mask);
 
 	list_for_each_entry(its, &its_nodes, entry) {
-		if (!its->is_v4)
+		if (!is_v4(its))
 			continue;
 
 		its_send_vmapp(its, vpe, true);
@@ -3176,7 +3178,7 @@ static void its_vpe_irq_domain_deactivate(struct irq_domain *domain,
 		return;
 
 	list_for_each_entry(its, &its_nodes, entry) {
-		if (!its->is_v4)
+		if (!is_v4(its))
 			continue;
 
 		its_send_vmapp(its, vpe, false);
@@ -3614,12 +3616,12 @@ static int __init its_probe_one(struct resource *res,
 	INIT_LIST_HEAD(&its->entry);
 	INIT_LIST_HEAD(&its->its_device_list);
 	typer = gic_read_typer(its_base + GITS_TYPER);
+	its->typer = typer;
 	its->base = its_base;
 	its->phys_base = res->start;
 	its->ite_size = GITS_TYPER_ITT_ENTRY_SIZE(typer);
 	its->device_ids = GITS_TYPER_DEVBITS(typer);
-	its->is_v4 = !!(typer & GITS_TYPER_VLPIS);
-	if (its->is_v4) {
+	if (is_v4(its)) {
 		if (!(typer & GITS_TYPER_VMOVP)) {
 			err = its_compute_its_list_map(res, its_base);
 			if (err < 0)
@@ -3686,7 +3688,7 @@ static int __init its_probe_one(struct resource *res,
 	gits_write_cwriter(0, its->base + GITS_CWRITER);
 	ctlr = readl_relaxed(its->base + GITS_CTLR);
 	ctlr |= GITS_CTLR_ENABLE;
-	if (its->is_v4)
+	if (is_v4(its))
 		ctlr |= GITS_CTLR_ImDe;
 	writel_relaxed(ctlr, its->base + GITS_CTLR);
 
@@ -4011,7 +4013,7 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		return err;
 
 	list_for_each_entry(its, &its_nodes, entry)
-		has_v4 |= its->is_v4;
+		has_v4 |= is_v4(its);
 
 	if (has_v4 & rdists->has_vlpis) {
 		if (its_init_vpe_domain() ||
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
