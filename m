Return-Path: <SRS0=vYaB=VV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788BCC7618B
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 09:04:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 39E9F2190F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 09:04:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39E9F2190F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA9D74A57D;
	Wed, 24 Jul 2019 05:04:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cwSdEJ2HfH0N; Wed, 24 Jul 2019 05:04:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1C614A55A;
	Wed, 24 Jul 2019 05:04:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43DCB4A533
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 05:04:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TBfrqHHbNa8s for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jul 2019 05:04:49 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14B234A57D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 05:04:49 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 430EAFC4DDA07AF281AB;
 Wed, 24 Jul 2019 17:04:46 +0800 (CST)
Received: from localhost (10.177.19.122) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 17:04:41 +0800
From: Xiangyou Xie <xiexiangyou@huawei.com>
To: <marc.zyngier@arm.com>
Subject: [PATCH 2/3] KVM: arm/arm64: vgic-its: Do not execute invalidate
 MSI-LPI translation cache on movi command
Date: Wed, 24 Jul 2019 17:04:36 +0800
Message-ID: <20190724090437.49952-3-xiexiangyou@huawei.com>
X-Mailer: git-send-email 2.10.0.windows.1
In-Reply-To: <20190724090437.49952-1-xiexiangyou@huawei.com>
References: <20190724090437.49952-1-xiexiangyou@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.177.19.122]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

It is not necessary to invalidate the lpi translation cache when the
virtual machine executes the movi instruction to adjust the affinity of
the interrupt. Irqbalance will adjust the interrupt affinity in a short
period of time to achieve the purpose of interrupting load balancing,
but this does not affect the contents of the lpi translation cache.

Signed-off-by: Xiangyou Xie <xiexiangyou@huawei.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 792d90b..66e93ab 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -907,8 +907,6 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	ite->collection = collection;
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
-	vgic_its_invalidate_cache(kvm);
-
 	return update_affinity(ite->irq, vcpu);
 }
 
-- 
1.8.3.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
