Return-Path: <SRS0=cDTT=YQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9619BCA9EAE
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 07:25:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EE997214B2
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 07:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE997214B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41F434A956;
	Wed, 23 Oct 2019 03:25:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ULX3wuMIyZsA; Wed, 23 Oct 2019 03:25:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30AC74A96F;
	Wed, 23 Oct 2019 03:25:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65BAD4A746
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 23:23:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nyNXDkNLB9Zs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 23:23:09 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C9554A669
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 23:23:09 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 962BE2CD66F9CF476FA8;
 Wed, 23 Oct 2019 11:23:05 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Wed, 23 Oct 2019 11:22:59 +0800
From: Mao Wenan <maowenan@huawei.com>
To: <maz@kernel.org>, <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>, 
 <suzuki.poulose@arm.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
 <steven.price@arm.com>
Subject: [PATCH] KVM: arm64: Select SCHED_INFO before SCHEDSTATS
Date: Wed, 23 Oct 2019 11:22:54 +0800
Message-ID: <20191023032254.159510-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Wed, 23 Oct 2019 03:25:45 -0400
Cc: Mao Wenan <maowenan@huawei.com>, kernel-janitors@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

If KVM=y, it will select SCHEDSTATS, below erros can
be seen:
kernel/sched/stats.h: In function rq_sched_info_arrive:
kernel/sched/stats.h:12:20: error: struct sched_info
has no member named run_delay
   rq->rq_sched_info.run_delay += delta;
                    ^
kernel/sched/stats.h:13:20: error: struct sched_info
has no member named pcount
   rq->rq_sched_info.pcount++;
                    ^
kernel/sched/stats.h: In function rq_sched_info_dequeued:
kernel/sched/stats.h:31:20: error: struct sched_info has
no member named run_delay
   rq->rq_sched_info.run_delay += delta;

These are because CONFIG_SCHED_INFO is not set, This patch 
is to select SCHED_INFO before SCHEDSTATS.

Fixes: 8564d6372a7d ("KVM: arm64: Support stolen time reporting via shared structure")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 arch/arm64/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index d8b88e4..3c46eac 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -39,6 +39,7 @@ config KVM
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
+	select SCHED_INFO
 	select SCHEDSTATS
 	---help---
 	  Support hosting virtualized guest machines.
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
