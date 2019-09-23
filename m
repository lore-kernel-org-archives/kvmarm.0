Return-Path: <SRS0=gg7X=XS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DBBC4CECF
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:27:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C243E20B7C
	for <kvmarm@archiver.kernel.org>; Mon, 23 Sep 2019 18:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C243E20B7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C47A4A652;
	Mon, 23 Sep 2019 14:27:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rClWL2NPhSm6; Mon, 23 Sep 2019 14:27:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0094A4A698;
	Mon, 23 Sep 2019 14:27:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADCBF4A595
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:27:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xuW9uQ4BbH-W for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Sep 2019 14:27:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C3D44A51F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Sep 2019 14:27:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 468001715;
 Mon, 23 Sep 2019 11:27:07 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C79A23F694;
 Mon, 23 Sep 2019 11:27:04 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/35] irqchip/gic-v4.1: Implement the v4.1 flavour of VMAPP
Date: Mon, 23 Sep 2019 19:25:42 +0100
Message-Id: <20190923182606.32100-12-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190923182606.32100-1-maz@kernel.org>
References: <20190923182606.32100-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
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

The ITS VMAPP command gains some new fields with GICv4.1:
- a default doorbell, which allows a single doorbell to be used for
  all the VLPIs routed to a given VPE
- a pointer to the configuration table (instead of having it in a register
  that gets context switched)
- a flag indicating whether this is the first map or the last unmap for
  this particulat VPE
- a flag indicating whether the pending table is known to be zeroed, or not

Plumb in the new fields in the VMAPP builder, and add the map/unmap
refcounting so that the ITS can do the right thing.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 60 +++++++++++++++++++++++++++---
 include/linux/irqchip/arm-gic-v4.h | 18 +++++++--
 2 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 58c7c40f5ad7..8d6deb75b973 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -422,6 +422,27 @@ static void its_encode_vpt_size(struct its_cmd_block *cmd, u8 vpt_size)
 	its_mask_encode(&cmd->raw_cmd[3], vpt_size, 4, 0);
 }
 
+static void its_encode_vconf_addr(struct its_cmd_block *cmd, u64 vconf_pa)
+{
+	its_mask_encode(&cmd->raw_cmd[0], vconf_pa >> 16, 51, 16);
+}
+
+static void its_encode_alloc(struct its_cmd_block *cmd, bool alloc)
+{
+	its_mask_encode(&cmd->raw_cmd[0], alloc, 8, 8);
+}
+
+static void its_encode_ptz(struct its_cmd_block *cmd, bool ptz)
+{
+	its_mask_encode(&cmd->raw_cmd[0], ptz, 9, 9);
+}
+
+static void its_encode_vmapp_default_db(struct its_cmd_block *cmd,
+					u32 vpe_db_lpi)
+{
+	its_mask_encode(&cmd->raw_cmd[1], vpe_db_lpi, 31, 0);
+}
+
 static inline void its_fixup_cmd(struct its_cmd_block *cmd)
 {
 	/* Let's fixup BE commands */
@@ -605,19 +626,45 @@ static struct its_vpe *its_build_vmapp_cmd(struct its_node *its,
 					   struct its_cmd_block *cmd,
 					   struct its_cmd_desc *desc)
 {
-	unsigned long vpt_addr;
+	unsigned long vpt_addr, vconf_addr;
 	u64 target;
-
-	vpt_addr = virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->vpt_page));
-	target = desc->its_vmapp_cmd.col->target_address + its->vlpi_redist_offset;
+	bool alloc;
 
 	its_encode_cmd(cmd, GITS_CMD_VMAPP);
 	its_encode_vpeid(cmd, desc->its_vmapp_cmd.vpe->vpe_id);
 	its_encode_valid(cmd, desc->its_vmapp_cmd.valid);
+
+	if (!desc->its_vmapp_cmd.valid) {
+		if (is_v4_1(its)) {
+			alloc = !atomic_dec_return(&desc->its_vmapp_cmd.vpe->vmapp_count);
+			its_encode_alloc(cmd, alloc);
+		}
+
+		goto out;
+	}
+
+	vpt_addr = virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->vpt_page));
+	target = desc->its_vmapp_cmd.col->target_address + its->vlpi_redist_offset;
+
 	its_encode_target(cmd, target);
 	its_encode_vpt_addr(cmd, vpt_addr);
 	its_encode_vpt_size(cmd, LPI_NRBITS - 1);
 
+	if (!is_v4_1(its))
+		goto out;
+
+	vconf_addr = virt_to_phys(page_address(desc->its_vmapp_cmd.vpe->its_vm->vprop_page));
+
+	alloc = atomic_inc_and_test(&desc->its_vmapp_cmd.vpe->vmapp_count);
+
+	its_encode_alloc(cmd, alloc);
+
+	/* We can only signal PTZ when alloc==1. Why do we have two bits? */
+	its_encode_ptz(cmd, alloc);
+	its_encode_vconf_addr(cmd, vconf_addr);
+	its_encode_vmapp_default_db(cmd, desc->its_vmapp_cmd.vpe->vpe_db_lpi);
+
+out:
 	its_fixup_cmd(cmd);
 
 	return valid_vpe(its, desc->its_vmapp_cmd.vpe);
@@ -3344,7 +3391,10 @@ static int its_vpe_init(struct its_vpe *vpe)
 
 	vpe->vpe_id = vpe_id;
 	vpe->vpt_page = vpt_page;
-	vpe->vpe_proxy_event = -1;
+	if (gic_rdists->has_rvpeid)
+		atomic_set(&vpe->vmapp_count, 0);
+	else
+		vpe->vpe_proxy_event = -1;
 
 	return 0;
 }
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index ab1396afe08a..6213ced6f199 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -37,8 +37,20 @@ struct its_vpe {
 	irq_hw_number_t		vpe_db_lpi;
 	/* VPE resident */
 	bool			resident;
-	/* VPE proxy mapping */
-	int			vpe_proxy_event;
+	union {
+		/* GICv4.0 implementations */
+		struct {
+			/* VPE proxy mapping */
+			int	vpe_proxy_event;
+			/* Implementation Defined Area Invalid */
+			bool	idai;
+		};
+		/* GICv4.1 implementations */
+		struct {
+			atomic_t vmapp_count;
+		};
+	};
+
 	/*
 	 * This collection ID is used to indirect the target
 	 * redistributor for this VPE. The ID itself isn't involved in
@@ -47,8 +59,6 @@ struct its_vpe {
 	u16			col_idx;
 	/* Unique (system-wide) VPE identifier */
 	u16			vpe_id;
-	/* Implementation Defined Area Invalid */
-	bool			idai;
 	/* Pending VLPIs on schedule out? */
 	bool			pending_last;
 };
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
