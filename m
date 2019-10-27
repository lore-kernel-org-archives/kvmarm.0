Return-Path: <SRS0=uKin=YU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0531CA9EAF
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:43:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A4817222BD
	for <kvmarm@archiver.kernel.org>; Sun, 27 Oct 2019 14:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNhxUkok"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4817222BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD764A7FD;
	Sun, 27 Oct 2019 10:43:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cBKflRkzkfv2; Sun, 27 Oct 2019 10:43:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DEFD4A521;
	Sun, 27 Oct 2019 10:43:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E40C34A5A8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:43:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IyXlXC63k86q for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Oct 2019 10:43:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2D274A521
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Oct 2019 10:43:48 -0400 (EDT)
Received: from localhost.localdomain (82-132-239-15.dab.02.net [82.132.239.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 34C6F21E6F;
 Sun, 27 Oct 2019 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1572187428;
 bh=Zi3SgTZHLNbskJxSF49qTEustzLeR71mUmIkhQYy9qk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=SNhxUkokfKoP+8W407lcxfDMIBSGo5QL47MpJFZ4yq9CZUDpfKQ+HykFonzPA1j4R
 Wa875V3d66ikzI3/DO20IwoZ+viU8jUn4qOEYbCavkRevsTBgqnqOR+eQXPyyw9tYq
 zzM3jvgJ2KR7N2cnihslBo7o8cBi1Q/yKHFWiBRk=
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/36] irqchip/gic-v3-its: Add get_vlpi_map() helper
Date: Sun, 27 Oct 2019 14:42:05 +0000
Message-Id: <20191027144234.8395-8-maz@kernel.org>
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

Obtaining the mapping information for a VLPI is something quite common,
and the GICv4.1 code is going to make even more use of it. Expose it as
a separate helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 6c91c7feadf3..94c9c2e9f917 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1045,20 +1045,26 @@ static void its_send_vinvall(struct its_node *its, struct its_vpe *vpe)
 /*
  * irqchip functions - assumes MSI, mostly.
  */
+static struct its_vlpi_map *get_vlpi_map(struct irq_data *d)
+{
+	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+	u32 event = its_get_event_id(d);
+
+	if (!irqd_is_forwarded_to_vcpu(d))
+		return NULL;
+
+	return &its_dev->event_map.vlpi_maps[event];
+}
 
 static void lpi_write_config(struct irq_data *d, u8 clr, u8 set)
 {
+	struct its_vlpi_map *map = get_vlpi_map(d);
 	irq_hw_number_t hwirq;
 	void *va;
 	u8 *cfg;
 
-	if (irqd_is_forwarded_to_vcpu(d)) {
-		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
-		u32 event = its_get_event_id(d);
-		struct its_vlpi_map *map;
-
-		va = page_address(its_dev->event_map.vm->vprop_page);
-		map = &its_dev->event_map.vlpi_maps[event];
+	if (map) {
+		va = page_address(map->vm->vprop_page);
 		hwirq = map->vintid;
 
 		/* Remember the updated property */
@@ -1351,19 +1357,18 @@ static int its_vlpi_map(struct irq_data *d, struct its_cmd_info *info)
 static int its_vlpi_get(struct irq_data *d, struct its_cmd_info *info)
 {
 	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
-	u32 event = its_get_event_id(d);
+	struct its_vlpi_map *map = get_vlpi_map(d);
 	int ret = 0;
 
 	mutex_lock(&its_dev->event_map.vlpi_lock);
 
-	if (!its_dev->event_map.vm ||
-	    !its_dev->event_map.vlpi_maps[event].vm) {
+	if (!its_dev->event_map.vm || !map->vm) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	/* Copy our mapping information to the incoming request */
-	*info->map = its_dev->event_map.vlpi_maps[event];
+	*info->map = *map;
 
 out:
 	mutex_unlock(&its_dev->event_map.vlpi_lock);
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
