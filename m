From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 10/33] irqchip/gic-v4-its: Allow use of indirect VCPU
 tables
Date: Tue, 17 Jan 2017 10:20:31 +0000
Message-ID: <1484648454-21216-11-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86241405E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M5HGP5AyFQ1S for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADF7040783
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:37 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

The VCPU tables can be quite sparse as well, and it makes sense
to use indirect tables as well if possible.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c92ff4d..14305db1 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1060,10 +1060,13 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 	return 0;
 }
 
-static bool its_parse_baser_device(struct its_node *its, struct its_baser *baser,
-				   u32 psz, u32 *order)
+static bool its_parse_indirect_baser(struct its_node *its,
+				     struct its_baser *baser,
+				     u32 psz, u32 *order)
 {
-	u64 esz = GITS_BASER_ENTRY_SIZE(its_read_baser(its, baser));
+	u64 tmp = its_read_baser(its, baser);
+	u64 type = GITS_BASER_TYPE(tmp);
+	u64 esz = GITS_BASER_ENTRY_SIZE(tmp);
 	u64 val = GITS_BASER_InnerShareable | GITS_BASER_WaWb;
 	u32 ids = its->device_ids;
 	u32 new_order = *order;
@@ -1102,8 +1105,9 @@ static bool its_parse_baser_device(struct its_node *its, struct its_baser *baser
 	if (new_order >= MAX_ORDER) {
 		new_order = MAX_ORDER - 1;
 		ids = ilog2(PAGE_ORDER_TO_SIZE(new_order) / (int)esz);
-		pr_warn("ITS@%pa: Device Table too large, reduce ids %u->%u\n",
-			&its->phys_base, its->device_ids, ids);
+		pr_warn("ITS@%pa: %s Table too large, reduce ids %u->%u\n",
+			&its->phys_base, its_base_type_string[type],
+			its->device_ids, ids);
 	}
 
 	*order = new_order;
@@ -1154,8 +1158,10 @@ static int its_alloc_tables(struct its_node *its)
 		if (type == GITS_BASER_TYPE_NONE)
 			continue;
 
-		if (type == GITS_BASER_TYPE_DEVICE)
-			indirect = its_parse_baser_device(its, baser, psz, &order);
+		if (type == GITS_BASER_TYPE_DEVICE ||
+		    type == GITS_BASER_TYPE_VCPU)
+			indirect = its_parse_indirect_baser(its, baser,
+							    psz, &order);
 
 		err = its_setup_baser(its, baser, cache, shr, psz, order, indirect);
 		if (err < 0) {
-- 
2.1.4
