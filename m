Return-Path: <SRS0=uKin=YU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961BBCA9EAF
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:46:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CA5021D80
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pu/vsRSg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CA5021D80
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0538E4AC7A;
	Sun, 27 Oct 2019 10:46:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wJU0PG6IRpMi; Sun, 27 Oct 2019 10:46:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3E704AC95;
	Sun, 27 Oct 2019 10:46:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 918054AC6A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:46:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fF8-il9m9edF for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Oct 2019 10:46:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74B664A418
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:46:26 -0400 (EDT)
Received: from localhost.localdomain (82-132-239-15.dab.02.net [82.132.239.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EBE28214AF;
 Sun, 27 Oct 2019 14:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1572187585;
 bh=RC8PT828U5r9ePm7PoxGLyz3E90+A4ElBuLqHTunDEs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=pu/vsRSgrOcaIz4jh+LFvVm2i2DH3zcyczc9zpMfbpwDU2nFre9U9dPaSl9Buf85Y
 F3/h8dabvSGNa74F6NR8XFQwVhLwZE5h5HCtu0eJwwdyINiHgLOAQApdp0G9rRP2Q+
 N5FzIlZVWzstXZ+ht2gsVc3S58ynfc4UPh6yT5ik=
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 32/36] irqchip/gic-v4.1: Eagerly vmap vPEs
Date: Sun, 27 Oct 2019 14:42:30 +0000
Message-Id: <20191027144234.8395-33-maz@kernel.org>
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

Now that we have HW-accelerated SGIs being delivered to VPEs, it
becomes required to map the VPEs on all ITSs instead of relying
on the lazy approach that we would use when using the ITS-list
mechanism.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 39 +++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 03ba4964a7f5..796c5937ec15 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1419,12 +1419,31 @@ static int its_irq_set_irqchip_state(struct irq_data *d,
 	return 0;
 }
 
+/*
+ * Two favourable cases:
+ *
+ * (a) Either we have a GICv4.1, and all vPEs have to be mapped at all times
+ *     for vSGI delivery
+ *
+ * (b) Or the ITSs do not use a list map, meaning that VMOVP is cheap enough
+ *     and we're better off mapping all VPEs always
+ *
+ * If neither (a) nor (b) is true, then we map vPEs on demand.
+ *
+ */
+static bool gic_requires_eager_mapping(void)
+{
+	if (!its_list_map || gic_rdists->has_rvpeid)
+		return true;
+
+	return false;
+}
+
 static void its_map_vm(struct its_node *its, struct its_vm *vm)
 {
 	unsigned long flags;
 
-	/* Not using the ITS list? Everything is always mapped. */
-	if (!its_list_map)
+	if (gic_requires_eager_mapping())
 		return;
 
 	raw_spin_lock_irqsave(&vmovp_lock, flags);
@@ -1458,7 +1477,7 @@ static void its_unmap_vm(struct its_node *its, struct its_vm *vm)
 	unsigned long flags;
 
 	/* Not using the ITS list? Everything is always mapped. */
-	if (!its_list_map)
+	if (gic_requires_eager_mapping())
 		return;
 
 	raw_spin_lock_irqsave(&vmovp_lock, flags);
@@ -3964,8 +3983,12 @@ static int its_vpe_irq_domain_activate(struct irq_domain *domain,
 	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
 	struct its_node *its;
 
-	/* If we use the list map, we issue VMAPP on demand... */
-	if (its_list_map)
+	/*
+	 * If we use the list map, we issue VMAPP on demand... Unless
+	 * we're on a GICv4.1 and we eagerly map the VPE on all ITSs
+	 * so that VSGIs can work.
+	 */
+	if (!gic_requires_eager_mapping())
 		return 0;
 
 	/* Map the VPE to the first possible CPU */
@@ -3991,10 +4014,10 @@ static void its_vpe_irq_domain_deactivate(struct irq_domain *domain,
 	struct its_node *its;
 
 	/*
-	 * If we use the list map, we unmap the VPE once no VLPIs are
-	 * associated with the VM.
+	 * If we use the list map on GICv4.0, we unmap the VPE once no
+	 * VLPIs are associated with the VM.
 	 */
-	if (its_list_map)
+	if (!gic_requires_eager_mapping())
 		return;
 
 	list_for_each_entry(its, &its_nodes, entry) {
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
