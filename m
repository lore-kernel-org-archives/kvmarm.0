Return-Path: <SRS0=oEtv=WW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44CEC3A59F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Aug 2019 16:41:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29A53206BA
	for <kvmarm@archiver.kernel.org>; Mon, 26 Aug 2019 16:41:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29A53206BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63F874A5BF;
	Mon, 26 Aug 2019 12:41:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tjZMeW3Nqqti; Mon, 26 Aug 2019 12:41:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B9AD4A5C1;
	Mon, 26 Aug 2019 12:41:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EA7C4A5BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Aug 2019 12:41:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oRZmLLPdutgF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Aug 2019 12:41:17 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D46234A5BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Aug 2019 12:40:55 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 52465C224D703FD301BC;
 Tue, 27 Aug 2019 00:40:29 +0800 (CST)
Received: from linux-lLwqrf.huawei.com (10.175.104.237) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 27 Aug 2019 00:40:20 +0800
From: Heyi Guo <guoheyi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm/arm/vgic: fix potential deadlock when ap_list is long
Date: Tue, 27 Aug 2019 00:39:12 +0800
Message-ID: <1566837552-127854-1-git-send-email-guoheyi@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
X-Originating-IP: [10.175.104.237]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Heyi Guo <guoheyi@huawei.com>
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

If ap_list is longer than 256, merge_final() in sort_list() will call
comparison function with the same element just as below:

    do {
        /*
         * If the merge is highly unbalanced (e.g. the input is
         * already sorted), this loop may run many iterations.
         * Continue callbacks to the client even though no
         * element comparison is needed, so the client's cmp()
         * routine can invoke cond_resched() periodically.
         */
        if (unlikely(!++count))
            cmp(priv, b, b);

This will definitely cause deadlock in vgic_irq_cmp() and the call trace
is:

[ 2667.130283] Call trace:
[ 2667.130284] queued_spin_lock_slowpath+0x64/0x2a8
[ 2667.130284] vgic_irq_cmp+0xfc/0x130
[ 2667.130284] list_sort.part.0+0x1c0/0x268
[ 2667.130285] list_sort+0x18/0x28
[ 2667.130285] vgic_flush_lr_state+0x158/0x518
[ 2667.130285] kvm_vgic_flush_hwstate+0x70/0x108
[ 2667.130286] kvm_arch_vcpu_ioctl_run+0x114/0xa50
[ 2667.130286] kvm_vcpu_ioctl+0x490/0x8c8
[ 2667.130286] do_vfs_ioctl+0xc4/0x8c0
[ 2667.130287] ksys_ioctl+0x8c/0xa0
[ 2667.130287] __arm64_sys_ioctl+0x28/0x38
[ 2667.130287] el0_svc_common+0x78/0x130
[ 2667.130288] el0_svc_handler+0x38/0x78
[ 2667.130288] el0_svc+0x8/0xc

So return 0 immediately when a==b.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Heyi Guo <guoheyi@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 13d4b38..64ed0dc 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -254,6 +254,13 @@ static int vgic_irq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	bool penda, pendb;
 	int ret;
 
+	/*
+	 * list_sort may call this function with the same element when the list
+	 * is farely long.
+	 */
+	if (unlikely(a == b))
+		return 0;
+
 	raw_spin_lock(&irqa->irq_lock);
 	raw_spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
 
-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
