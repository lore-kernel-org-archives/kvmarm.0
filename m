From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [RFC PATCH 1/8] irqchip/gic-v3-its: Change unsigned types for AArch32
 compatibility
Date: Fri, 21 Oct 2016 10:36:34 +0100
Message-ID: <1477042601-15227-2-git-send-email-vladimir.murzin@arm.com>
References: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE7FC49B40
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BMdXcZR+PykQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 05:26:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97BB249B3D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:26:39 -0400 (EDT)
In-Reply-To: <1477042601-15227-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, kbuild-all@01.org
List-Id: kvmarm@lists.cs.columbia.edu

Make sure that constants which are supposed to be applied on 64-bit
data is actually unsigned long long, so they won't be truncated when
used in 32-bit mode.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c   |   28 ++++++++++++++--------------
 include/linux/irqchip/arm-gic-v3.h |    4 ++--
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 003495d..dcc8c76 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -196,7 +196,7 @@ struct its_cmd_block {
 
 static void its_encode_cmd(struct its_cmd_block *cmd, u8 cmd_nr)
 {
-	cmd->raw_cmd[0] &= ~0xffUL;
+	cmd->raw_cmd[0] &= ~0xffULL;
 	cmd->raw_cmd[0] |= cmd_nr;
 }
 
@@ -208,43 +208,43 @@ static void its_encode_devid(struct its_cmd_block *cmd, u32 devid)
 
 static void its_encode_event_id(struct its_cmd_block *cmd, u32 id)
 {
-	cmd->raw_cmd[1] &= ~0xffffffffUL;
+	cmd->raw_cmd[1] &= ~0xffffffffULL;
 	cmd->raw_cmd[1] |= id;
 }
 
 static void its_encode_phys_id(struct its_cmd_block *cmd, u32 phys_id)
 {
-	cmd->raw_cmd[1] &= 0xffffffffUL;
+	cmd->raw_cmd[1] &= 0xffffffffULL;
 	cmd->raw_cmd[1] |= ((u64)phys_id) << 32;
 }
 
 static void its_encode_size(struct its_cmd_block *cmd, u8 size)
 {
-	cmd->raw_cmd[1] &= ~0x1fUL;
+	cmd->raw_cmd[1] &= ~0x1fULL;
 	cmd->raw_cmd[1] |= size & 0x1f;
 }
 
 static void its_encode_itt(struct its_cmd_block *cmd, u64 itt_addr)
 {
-	cmd->raw_cmd[2] &= ~0xffffffffffffUL;
-	cmd->raw_cmd[2] |= itt_addr & 0xffffffffff00UL;
+	cmd->raw_cmd[2] &= ~0xffffffffffffULL;
+	cmd->raw_cmd[2] |= itt_addr & 0xffffffffff00ULL;
 }
 
 static void its_encode_valid(struct its_cmd_block *cmd, int valid)
 {
-	cmd->raw_cmd[2] &= ~(1UL << 63);
+	cmd->raw_cmd[2] &= ~(1ULL << 63);
 	cmd->raw_cmd[2] |= ((u64)!!valid) << 63;
 }
 
 static void its_encode_target(struct its_cmd_block *cmd, u64 target_addr)
 {
-	cmd->raw_cmd[2] &= ~(0xffffffffUL << 16);
-	cmd->raw_cmd[2] |= (target_addr & (0xffffffffUL << 16));
+	cmd->raw_cmd[2] &= ~(0xffffffffULL << 16);
+	cmd->raw_cmd[2] |= (target_addr & (0xffffffffULL << 16));
 }
 
 static void its_encode_collection(struct its_cmd_block *cmd, u16 col)
 {
-	cmd->raw_cmd[2] &= ~0xffffUL;
+	cmd->raw_cmd[2] &= ~0xffffULL;
 	cmd->raw_cmd[2] |= col;
 }
 
@@ -657,8 +657,8 @@ static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
 	its = its_dev->its;
 	addr = its->phys_base + GITS_TRANSLATER;
 
-	msg->address_lo		= addr & ((1UL << 32) - 1);
-	msg->address_hi		= addr >> 32;
+	msg->address_lo		= lower_32_bits(addr);
+	msg->address_hi		= upper_32_bits(addr);
 	msg->data		= its_get_event_id(d);
 
 	iommu_dma_map_msi_msg(d->irq, msg);
@@ -935,9 +935,9 @@ static int its_setup_baser(struct its_node *its, struct its_baser *baser,
 	}
 
 	if (val != tmp) {
-		pr_err("ITS@%pa: %s doesn't stick: %lx %lx\n",
+		pr_err("ITS@%pa: %s doesn't stick: %llx %llx\n",
 		       &its->phys_base, its_base_type_string[type],
-		       (unsigned long) val, (unsigned long) tmp);
+		       val, tmp);
 		free_pages((unsigned long)base, order);
 		return -ENXIO;
 	}
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index b7e3431..5118d3a 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -239,7 +239,7 @@
 #define GITS_TYPER_PTA			(1UL << 19)
 #define GITS_TYPER_HWCOLLCNT_SHIFT	24
 
-#define GITS_CBASER_VALID			(1UL << 63)
+#define GITS_CBASER_VALID			(1ULL << 63)
 #define GITS_CBASER_SHAREABILITY_SHIFT		(10)
 #define GITS_CBASER_INNER_CACHEABILITY_SHIFT	(59)
 #define GITS_CBASER_OUTER_CACHEABILITY_SHIFT	(53)
@@ -265,7 +265,7 @@
 
 #define GITS_BASER_NR_REGS		8
 
-#define GITS_BASER_VALID			(1UL << 63)
+#define GITS_BASER_VALID			(1ULL << 63)
 #define GITS_BASER_INDIRECT			(1ULL << 62)
 
 #define GITS_BASER_INNER_CACHEABILITY_SHIFT	(59)
-- 
1.7.9.5
