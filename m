Return-Path: <SRS0=cDTT=YQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC370CA9EAE
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 03:47:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5E0B2214B2
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 03:47:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E0B2214B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4B694A854;
	Tue, 22 Oct 2019 23:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id avVtX+vPOXLc; Tue, 22 Oct 2019 23:47:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A758D4A945;
	Tue, 22 Oct 2019 23:47:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8FFF4A8AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 23:47:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dmsTwCrXxEBl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 23:47:09 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D48A4A854
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 23:47:08 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 11F378013A1F00FE87B2;
 Wed, 23 Oct 2019 11:46:58 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 23 Oct 2019 11:46:51 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <maz@kernel.org>
Subject: [PATCH v2] irqchip/gic-v3-its: Use the exact ITSList for VMOVP
Date: Wed, 23 Oct 2019 03:46:26 +0000
Message-ID: <1571802386-2680-1-git-send-email-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: jason@lakedaemon.net, jiayanlei@huawei.com, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On a system without Single VMOVP support (say GITS_TYPER.VMOVP == 0),
we will map vPEs only on ITSs that will actually control interrupts
for the given VM.  And when moving a vPE, the VMOVP command will be
issued only for those ITSs.

But when issuing VMOVPs we seemed fail to present the exact ITSList
to ITSs who are actually included in the synchronization operation.
The its_list_map we're currently using includes all ITSs in the system,
even though some of them don't have the corresponding vPE mapping at all.

Introduce get_its_list() to get the per-VM its_list_map, to indicate
which ITSs have vPE mappings for the given VM, and use this map as
the expected ITSList when building VMOVP. This is hopefully a performance
gain not to do some synchronization with those unsuspecting ITSs.
And initialize the whole command descriptor to zero at beginning, since
the seq_num and its_list should be RES0 when GITS_TYPER.VMOVP == 1.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---

Changes since v1:
 - Initialize the whole VMOVP command descriptor to zero at beginning,
   since the seq_num and its_list fields should be RES0 when
   GITS_TYPER.VMOVP == 1.
 - Initialize "its_list" to zero in get_its_list().
 - Skip non v4 ITSs when computing the per-VM its_list_map.
 - Other cleanups.

 drivers/irqchip/irq-gic-v3-its.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c81da27044bf..0b35fcb71203 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -175,6 +175,22 @@ static DEFINE_IDA(its_vpeid_ida);
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
 
+static u16 get_its_list(struct its_vm *vm)
+{
+	struct its_node *its;
+	unsigned long its_list = 0;
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (!its->is_v4)
+			continue;
+
+		if (vm->vlpi_count[its->list_nr])
+			__set_bit(its->list_nr, &its_list);
+	}
+
+	return (u16)its_list;
+}
+
 static struct its_collection *dev_event_to_col(struct its_device *its_dev,
 					       u32 event)
 {
@@ -976,17 +992,15 @@ static void its_send_vmapp(struct its_node *its,
 
 static void its_send_vmovp(struct its_vpe *vpe)
 {
-	struct its_cmd_desc desc;
+	struct its_cmd_desc desc = {};
 	struct its_node *its;
 	unsigned long flags;
 	int col_id = vpe->col_idx;
 
 	desc.its_vmovp_cmd.vpe = vpe;
-	desc.its_vmovp_cmd.its_list = (u16)its_list_map;
 
 	if (!its_list_map) {
 		its = list_first_entry(&its_nodes, struct its_node, entry);
-		desc.its_vmovp_cmd.seq_num = 0;
 		desc.its_vmovp_cmd.col = &its->collections[col_id];
 		its_send_single_vcommand(its, its_build_vmovp_cmd, &desc);
 		return;
@@ -1003,6 +1017,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
 	raw_spin_lock_irqsave(&vmovp_lock, flags);
 
 	desc.its_vmovp_cmd.seq_num = vmovp_seq_num++;
+	desc.its_vmovp_cmd.its_list = get_its_list(vpe->its_vm);
 
 	/* Emit VMOVPs */
 	list_for_each_entry(its, &its_nodes, entry) {
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
