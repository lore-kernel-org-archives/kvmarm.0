Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEBB4BAAA
	for <kvmarm@lists.linux.dev>; Mon, 19 Feb 2024 18:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708369110; cv=none; b=LuLc0B1nPaWDhmhegOJPti3mdsriuo+Y89KU2ZNfNlm0xWK1mH3/jZTp5mJiOlkTz4sDY8x0WNHJtUaTxFGAQf7LwFnDi8TmwyJTgJ1YHoqFDoB6Rztf3c0mj8Cu+Cb8/bNbOGjA8vO4JBRRByXta6VG5xD2LscvNHh3259hp9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708369110; c=relaxed/simple;
	bh=AVsdCCM8FvfXsv0NexSqvyqeP7RkJJs+vf3bnHoUDbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEEZVaSXJk5SEo99cJEdBq9k86kNS3Eork1ejWZFe4ABpNF/3OTTcxGZYHz/2dNGbqFR2pfAOFMNodNf/2u38SrGHa+LBibXeSioVQ/K+1bzxqDHhW+i1RL8N0N6x1SQUH5R6A5Y119Zu9ijUcHAyRK8GoMnL1BZtiyrl6D6xK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=erdwcROx; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="erdwcROx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708369107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O6mYbl34iGDajSSuwNwYK5N248BsKIXOEJAXAf9uLUE=;
	b=erdwcROxjTVj9GYsF9NxwZtHNpUShYCx45EDDOMeS+jAJihxWdrPa0U1lhk/4/FnuC7+2g
	6JUYy8lf8giYc6dFvutLvzVCiE2tKOwcceN27OylehFuPrm9rlUze2Uoy930paO+8vWiFX
	OVADPtybepCZRTctZIlkmbbnW0WSTKY=
From: Oliver Upton <oliver.upton@linux.dev>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] irqchip/gic-v3-its: Print the vPE table installed in redistributor
Date: Mon, 19 Feb 2024 18:58:08 +0000
Message-ID: <20240219185809.286724-4-oliver.upton@linux.dev>
In-Reply-To: <20240219185809.286724-1-oliver.upton@linux.dev>
References: <20240219185809.286724-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hindsight is 20/20 of course, but the recent vPE table programming bug
could've been root caused a bit more quickly if we print the table
getting installed at every redistributor.

Promote to pr_info() and add some additional context, such as the
provenance of the installed vPE table.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 drivers/irqchip/irq-gic-v3-its.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 63d1743f08cc..c3ef9665a2ad 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2835,7 +2835,8 @@ static int allocate_vpe_l1_table(void)
 	u64 val, gpsz, npg, pa;
 	unsigned int psz = SZ_64K;
 	unsigned int np, epp, esz;
-	struct page *page;
+	struct page *page = NULL;
+	bool from_its = false;
 
 	if (!gic_rdists->has_rvpeid)
 		return 0;
@@ -2865,8 +2866,10 @@ static int allocate_vpe_l1_table(void)
 		return -ENOMEM;
 
 	val = inherit_vpe_l1_table_from_its();
-	if (val & GICR_VPROPBASER_4_1_VALID)
+	if (val & GICR_VPROPBASER_4_1_VALID) {
+		from_its = true;
 		goto out;
+	}
 
 	/* First probe the page size */
 	val = FIELD_PREP(GICR_VPROPBASER_4_1_PAGE_SIZE, GIC_PAGE_SIZE_64K);
@@ -2945,9 +2948,12 @@ static int allocate_vpe_l1_table(void)
 	gicr_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
 	cpumask_set_cpu(smp_processor_id(), gic_data_rdist()->vpe_table_mask);
 
-	pr_debug("CPU%d: VPROPBASER = %llx %*pbl\n",
-		 smp_processor_id(), val,
-		 cpumask_pr_args(gic_data_rdist()->vpe_table_mask));
+	pr_info("CPU%d: Using %s vPE table @%llx (%s)\n",
+		smp_processor_id(),
+		(val & GICR_VPROPBASER_4_1_INDIRECT) ? "indirect" : "direct",
+		val & GICR_VPROPBASER_4_1_ADDR,
+		(page) ? "allocated" :
+			 ((from_its) ? "inherited from ITS" : "inherited from RD"));
 
 	return 0;
 }
-- 
2.44.0.rc0.258.g7320e95886-goog

