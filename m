Return-Path: <SRS0=8yD/=3Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5945DC3524D
	for <kvmarm@archiver.kernel.org>; Tue,  4 Feb 2020 09:11:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9B1A2087E
	for <kvmarm@archiver.kernel.org>; Tue,  4 Feb 2020 09:11:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9B1A2087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39E2B4A959;
	Tue,  4 Feb 2020 04:11:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3UXcyFvYURPq; Tue,  4 Feb 2020 04:11:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 258D24A5A3;
	Tue,  4 Feb 2020 04:11:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3217D4A4E5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Feb 2020 04:11:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QoAjwn838l2B for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Feb 2020 04:11:47 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B38A4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Feb 2020 04:11:47 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id CF96726141455001C1CD;
 Tue,  4 Feb 2020 17:11:43 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 4 Feb 2020 17:11:35 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <linux-kernel@vger.kernel.org>, <maz@kernel.org>
Subject: [PATCH 2/5] irqchip/gic-v4.1: Set vpe_l1_base for all redistributors
Date: Tue, 4 Feb 2020 17:09:37 +0800
Message-ID: <20200204090940.1225-3-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20200204090940.1225-1-yuzenghui@huawei.com>
References: <20200204090940.1225-1-yuzenghui@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: jason@lakedaemon.net, tglx@linutronix.de, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Currently, we will not set vpe_l1_page for the current RD if we can
inherit the vPE configuration table from another RD (or ITS), which
results in an inconsistency between RDs within the same CommonLPIAff
group.

Let's rename it to vpe_l1_base to indicate the base address of the
vPE configuration table of this RD, and set it properly for *all*
v4.1 redistributors.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 drivers/irqchip/irq-gic-v3-its.c   | 5 ++++-
 include/linux/irqchip/arm-gic-v3.h | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 992bc72cab6f..0f1fe56ce0af 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2376,6 +2376,8 @@ static u64 inherit_vpe_l1_table_from_its(void)
 			continue;
 
 		/* We have a winner! */
+		gic_data_rdist()->vpe_l1_base = its->tables[2].base;
+
 		val  = GICR_VPROPBASER_4_1_VALID;
 		if (baser & GITS_BASER_INDIRECT)
 			val |= GICR_VPROPBASER_4_1_INDIRECT;
@@ -2432,6 +2434,7 @@ static u64 inherit_vpe_l1_table_from_rd(cpumask_t **mask)
 		val = gits_read_vpropbaser(base + SZ_128K + GICR_VPROPBASER);
 		val &= ~GICR_VPROPBASER_4_1_Z;
 
+		gic_data_rdist()->vpe_l1_base = gic_data_rdist_cpu(cpu)->vpe_l1_base;
 		*mask = gic_data_rdist_cpu(cpu)->vpe_table_mask;
 
 		return val;
@@ -2542,7 +2545,7 @@ static int allocate_vpe_l1_table(void)
 	if (!page)
 		return -ENOMEM;
 
-	gic_data_rdist()->vpe_l1_page = page;
+	gic_data_rdist()->vpe_l1_base = page_address(page);
 	pa = virt_to_phys(page_address(page));
 	WARN_ON(!IS_ALIGNED(pa, psz));
 
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index f0b8ca766e7d..83439bfb6c5b 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -652,10 +652,10 @@ struct rdists {
 	struct {
 		void __iomem	*rd_base;
 		struct page	*pend_page;
-		struct page	*vpe_l1_page;
 		phys_addr_t	phys_base;
 		bool		lpi_enabled;
 		cpumask_t	*vpe_table_mask;
+		void		*vpe_l1_base;
 	} __percpu		*rdist;
 	phys_addr_t		prop_table_pa;
 	void			*prop_table_va;
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
