Return-Path: <SRS0=LXG2=YP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3E4CA9EA0
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 11:06:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50F3A21872
	for <kvmarm@archiver.kernel.org>; Tue, 22 Oct 2019 11:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50F3A21872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A21AD4A990;
	Tue, 22 Oct 2019 07:06:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a1wcBcXoAM5Y; Tue, 22 Oct 2019 07:06:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8407A4A991;
	Tue, 22 Oct 2019 07:06:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC96E4A98F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 07:06:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gnnHRQxHwMNT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 07:06:39 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0914E4A968
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 07:06:39 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id A5F023B0D03149BE28A1;
 Tue, 22 Oct 2019 19:06:35 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 19:06:27 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <maz@kernel.org>
Subject: [PATCH] irqchip/gic-v3-its: Use the exact ITSList for VMOVP
Date: Tue, 22 Oct 2019 11:06:06 +0000
Message-ID: <1571742366-21008-1-git-send-email-yuzenghui@huawei.com>
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
even though some of them don't have the corrsponding vPE mapping at all.

Introduce get_its_list() to get the per-VM its_list_map, to indicate
which ITSs have vPE mappings for the given VM, and use this map as
the expected ITSList when building VMOVP.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---

I haven't seen any broken with the current its_list_map, but behavior
might differ between implementations.  Let's do what the spec expects
us to do and try not to confuse the implementation.  Or is there any
points I've missed?

 drivers/irqchip/irq-gic-v3-its.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c81da27044bf..eebee588ea30 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -175,6 +175,19 @@ static DEFINE_IDA(its_vpeid_ida);
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
 
+static inline u16 get_its_list(struct its_vm *vm)
+{
+	struct its_node *its;
+	unsigned long its_list;
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (vm->vlpi_count[its->list_nr])
+			set_bit(its->list_nr, &its_list);
+	}
+
+	return (u16)its_list;
+}
+
 static struct its_collection *dev_event_to_col(struct its_device *its_dev,
 					       u32 event)
 {
@@ -982,7 +995,6 @@ static void its_send_vmovp(struct its_vpe *vpe)
 	int col_id = vpe->col_idx;
 
 	desc.its_vmovp_cmd.vpe = vpe;
-	desc.its_vmovp_cmd.its_list = (u16)its_list_map;
 
 	if (!its_list_map) {
 		its = list_first_entry(&its_nodes, struct its_node, entry);
@@ -1003,6 +1015,7 @@ static void its_send_vmovp(struct its_vpe *vpe)
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
