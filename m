Return-Path: <SRS0=MZYq=ZV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C925C432C0
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 03:20:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B0F62158A
	for <kvmarm@archiver.kernel.org>; Fri, 29 Nov 2019 03:20:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B0F62158A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D80244AEBC;
	Thu, 28 Nov 2019 22:20:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Ff4VqCBZAZn; Thu, 28 Nov 2019 22:20:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF9BB4AEAF;
	Thu, 28 Nov 2019 22:20:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDD2F4AE87
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 22:20:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zDra8wxHfRD9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 22:19:59 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 095FA4A8E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 22:19:59 -0500 (EST)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 09800991634F43F95A93;
 Fri, 29 Nov 2019 11:19:54 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 29 Nov 2019
 11:19:45 +0800
From: linmiaohe <linmiaohe@huawei.com>
To: <maz@kernel.org>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
 <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>,
 <suzuki.poulose@arm.com>, <christoffer.dall@arm.com>,
 <catalin.marinas@arm.com>, <eric.auger@redhat.com>,
 <gregkh@linuxfoundation.org>, <will@kernel.org>, <andre.przywara@arm.com>,
 <tglx@linutronix.de>
Subject: [PATCH] KVM: arm/arm64: Fix some obsolete comments
Date: Fri, 29 Nov 2019 11:19:47 +0800
Message-ID: <1574997587-20842-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

From: Miaohe Lin <linmiaohe@huawei.com>

Fix various comments, including comment typo, and obsolete comments
no longer make sense.
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 virt/kvm/arm/arch_timer.c    | 5 ++---
 virt/kvm/arm/arm.c           | 1 -
 virt/kvm/arm/vgic/vgic-its.c | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 73867f97040c..d8d2f4bec935 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -322,9 +322,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
 	}
 
 	/*
-	 * If the timer can fire now, we don't need to have a soft timer
-	 * scheduled for the future.  If the timer cannot fire at all,
-	 * then we also don't need a soft timer.
+	 * If the timer cannot fire at all, we don't need to have a
+	 * soft timer scheduled for the future.
 	 */
 	if (!kvm_timer_irq_can_fire(ctx)) {
 		soft_timer_cancel(&ctx->hrtimer);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 8de4daf25097..7687663ab71b 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -525,7 +525,6 @@ static bool need_new_vmid_gen(struct kvm_vmid *vmid)
 
 /**
  * update_vmid - Update the vmid with a valid VMID for the current generation
- * @kvm: The guest that struct vmid belongs to
  * @vmid: The stage-2 VMID information struct
  */
 static void update_vmid(struct kvm_vmid *vmid)
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 98c7360d9fb7..d64569b30b5c 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2564,7 +2564,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 }
 
 /**
- * vgic_its_save_tables_v0 - Save the ITS tables into guest ARM
+ * vgic_its_save_tables_v0 - Save the ITS tables into guest RAM
  * according to v0 ABI
  */
 static int vgic_its_save_tables_v0(struct vgic_its *its)
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
