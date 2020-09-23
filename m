Return-Path: <SRS0=p5Xi=DA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0B2C2D0A8
	for <kvmarm@archiver.kernel.org>; Wed, 23 Sep 2020 11:57:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E1CC221EB
	for <kvmarm@archiver.kernel.org>; Wed, 23 Sep 2020 11:57:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E1CC221EB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4AE4B24F;
	Wed, 23 Sep 2020 07:57:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BI5WPWI34-Wj; Wed, 23 Sep 2020 07:57:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E0454B264;
	Wed, 23 Sep 2020 07:57:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C80844B258
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Sep 2020 07:57:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HuRYomvJUY3I for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Sep 2020 07:57:37 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A53B4B251
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Sep 2020 07:57:37 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 0D990BDCBA1CA8749091;
 Wed, 23 Sep 2020 19:57:31 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.185.226) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 23 Sep 2020 19:57:22 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] KVM: arm64: vgic: Drop CPUHP_AP_KVM_ARM_VGIC_STARTING state
Date: Wed, 23 Sep 2020 19:56:38 +0800
Message-ID: <20200923115638.1829-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org
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

This state is not used by KVM/arm64 code anymore.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---

But to be honest, I failed to track that in which commit this state
became unused...

 include/linux/cpuhotplug.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index bf9181cef444..25f448e0b4ca 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -137,7 +137,6 @@ enum cpuhp_state {
 	CPUHP_AP_HYPERV_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
-	CPUHP_AP_KVM_ARM_VGIC_STARTING,
 	CPUHP_AP_KVM_ARM_TIMER_STARTING,
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
