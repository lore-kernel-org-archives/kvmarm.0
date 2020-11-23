Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B18AC2D0E4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 08:35:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ABAE220729
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 08:35:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABAE220729
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAFAF4BAA5;
	Mon, 23 Nov 2020 03:35:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q0aOulTsefMh; Mon, 23 Nov 2020 03:35:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5224BAAE;
	Mon, 23 Nov 2020 03:35:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FD5A4BA82
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 01:54:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x2C2+HqBG-rw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 01:54:52 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55AA84BA30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 01:54:51 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CfdDZ2yJ4zkdlm;
 Mon, 23 Nov 2020 14:54:22 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.187.74) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 23 Nov 2020 14:54:40 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, "Julien
 Thierry" <julien.thierry.kdev@gmail.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Eric Auger <eric.auger@redhat.com>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Christoffer Dall
 <christoffer.dall@arm.com>
Subject: [RFC PATCH v1 1/4] irqchip/gic-v4.1: Plumb get_irqchip_state VLPI
 callback
Date: Mon, 23 Nov 2020 14:54:07 +0800
Message-ID: <20201123065410.1915-2-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20201123065410.1915-1-lushenming@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Mon, 23 Nov 2020 03:35:49 -0500
Cc: Neo Jia <cjia@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, lushenming@huawei.com,
 Alex Williamson <alex.williamson@redhat.com>
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

From: Zenghui Yu <yuzenghui@huawei.com>

Up to now, the irq_get_irqchip_state() callback of its_irq_chip
leaves unimplemented since there is no architectural way to get
the VLPI's pending state before GICv4.1. Yeah, there has one in
v4.1 for VLPIs.

With GICv4.1, after unmapping the vPE, which cleans and invalidates
any caching of the VPT, we can get the VLPI's pending state by
peeking at the VPT. So we implement the irq_get_irqchip_state()
callback of its_irq_chip to do it.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 38 ++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 0fec31931e11..287003cacac7 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1695,6 +1695,43 @@ static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
 	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(d), msg);
 }
 
+static bool its_peek_vpt(struct its_vpe *vpe, irq_hw_number_t hwirq)
+{
+	int mask = hwirq % BITS_PER_BYTE;
+	void *va;
+	u8 *pt;
+
+	va = page_address(vpe->vpt_page);
+	pt = va + hwirq / BITS_PER_BYTE;
+
+	return !!(*pt & (1U << mask));
+}
+
+static int its_irq_get_irqchip_state(struct irq_data *d,
+				     enum irqchip_irq_state which, bool *val)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	struct its_vlpi_map *map = get_vlpi_map(d);
+
+	if (which != IRQCHIP_STATE_PENDING)
+		return -EINVAL;
+
+	/* not intended for physical LPI's pending state */
+	if (!map)
+		return -EINVAL;
+
+	/*
+	 * In GICv4.1, a VMAPP with {V,Alloc}=={0,1} cleans and invalidates
+	 * any caching of the VPT associated with the vPEID held in the GIC.
+	 */
+	if (!is_v4_1(its_dev->its) || atomic_read(&map->vpe->vmapp_count))
+		return -EACCES;
+
+	*val = its_peek_vpt(map->vpe, map->vintid);
+
+	return 0;
+}
+
 static int its_irq_set_irqchip_state(struct irq_data *d,
 				     enum irqchip_irq_state which,
 				     bool state)
@@ -1975,6 +2012,7 @@ static struct irq_chip its_irq_chip = {
 	.irq_eoi		= irq_chip_eoi_parent,
 	.irq_set_affinity	= its_set_affinity,
 	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
+	.irq_get_irqchip_state	= its_irq_get_irqchip_state,
 	.irq_set_irqchip_state	= its_irq_set_irqchip_state,
 	.irq_retrigger		= its_irq_retrigger,
 	.irq_set_vcpu_affinity	= its_irq_set_vcpu_affinity,
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
