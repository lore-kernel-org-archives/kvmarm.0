From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 59/59] irqchip/gic-v3-its: Workaround Huawei D05
 redistributor addressing
Date: Mon, 31 Jul 2017 18:26:37 +0100
Message-ID: <20170731172637.29355-60-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B5F449CBF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j-QS-vOkC+1f for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:27:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 079BF49C59
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:44 -0400 (EDT)
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

The ITSes on the Huawei D05 are broken when it comes to addressing
the redistributors, and need to be explicitely told to address
the VLPI page instead of the redistributor base address.

So let's add yet another quirk, fixing up the target address
in the command stream.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index e22c8746ce89..32d8697bcb15 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -103,6 +103,7 @@ struct its_node {
 	u32			device_ids;
 	int			numa_node;
 	bool			is_v4;
+	int			vlpi_redist_offset;
 };
 
 #define ITS_ITT_ALIGN		SZ_256
@@ -548,13 +549,15 @@ static struct its_vpe *its_build_vmapp_cmd(struct its_node *its,
 					   struct its_cmd_desc *desc)
 {
 	unsigned long vpt_addr;
+	u64 target;
 
 	vpt_addr = virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->vpt_page));
+	target = desc->its_vmapp_cmd.col->target_address + its->vlpi_redist_offset;
 
 	its_encode_cmd(cmd, GITS_CMD_VMAPP);
 	its_encode_vpeid(cmd, desc->its_vmapp_cmd.vpe->vpe_id);
 	its_encode_valid(cmd, desc->its_vmapp_cmd.valid);
-	its_encode_target(cmd, desc->its_vmapp_cmd.col->target_address);
+	its_encode_target(cmd, target);
 	its_encode_vpt_addr(cmd, vpt_addr);
 	its_encode_vpt_size(cmd, LPI_NRBITS - 1);
 
@@ -613,11 +616,14 @@ static struct its_vpe *its_build_vmovp_cmd(struct its_node *its,
 					   struct its_cmd_block *cmd,
 					   struct its_cmd_desc *desc)
 {
+	u64 target;
+
+	target = desc->its_vmapp_cmd.col->target_address + its->vlpi_redist_offset;
 	its_encode_cmd(cmd, GITS_CMD_VMOVP);
 	its_encode_seq_num(cmd, desc->its_vmovp_cmd.seq_num);
 	its_encode_its_list(cmd, desc->its_vmovp_cmd.its_list);
 	its_encode_vpeid(cmd, desc->its_vmovp_cmd.vpe->vpe_id);
-	its_encode_target(cmd, desc->its_vmovp_cmd.col->target_address);
+	its_encode_target(cmd, target);
 
 	its_fixup_cmd(cmd);
 
@@ -2668,6 +2674,17 @@ static void __maybe_unused its_enable_quirk_qdf2400_e0065(void *data)
 	its->ite_size = 16;
 }
 
+static void __maybe_unused its_enable_quirk_d05_vlpi_offset(void *data)
+{
+	struct its_node *its = data;
+
+	/*
+	 * D05 insists on using the wrong address for the VLPI
+	 * page. Trick it into doing the right thing...
+	 */
+	its->vlpi_redist_offset = SZ_128K;
+}
+
 static const struct gic_quirk its_quirks[] = {
 #ifdef CONFIG_CAVIUM_ERRATUM_22375
 	{
@@ -2694,6 +2711,12 @@ static const struct gic_quirk its_quirks[] = {
 	},
 #endif
 	{
+		.desc	= "ITS: D05 128kB VLPI offset",
+		.iidr	= 0x00000004,
+		.mask	= 0xffffffff,
+		.init	= its_enable_quirk_d05_vlpi_offset,
+	},
+	{
 	}
 };
 
-- 
2.11.0
