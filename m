Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D54C43461
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 01:49:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A37B12072E
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 01:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A37B12072E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9CF4B643;
	Wed, 16 Sep 2020 21:49:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9QtA9FrEU4WS; Wed, 16 Sep 2020 21:49:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E35F34B635;
	Wed, 16 Sep 2020 21:49:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4494C4B5FE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 21:49:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2yGlrH2O2US8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Sep 2020 21:49:20 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 433F84B5F6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Sep 2020 21:49:20 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 58B289521B50BC4F38FB;
 Thu, 17 Sep 2020 09:49:16 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 09:49:05 +0800
From: Xiaofei Tan <tanxiaofei@huawei.com>
To: <maz@kernel.org>, <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>, 
 <suzuki.poulose@arm.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] KVM: arm64: fix doc warnings in mmu code
Date: Thu, 17 Sep 2020 09:47:49 +0800
Message-ID: <1600307269-50957-1-git-send-email-tanxiaofei@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Cc: linuxarm@huawei.com
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

Fix following warnings caused by mismatch bewteen function parameters
and comments.
arch/arm64/kvm/mmu.c:128: warning: Function parameter or member 'mmu' not described in '__unmap_stage2_range'
arch/arm64/kvm/mmu.c:128: warning: Function parameter or member 'may_block' not described in '__unmap_stage2_range'
arch/arm64/kvm/mmu.c:128: warning: Excess function parameter 'kvm' description in '__unmap_stage2_range'
arch/arm64/kvm/mmu.c:499: warning: Function parameter or member 'writable' not described in 'kvm_phys_addr_ioremap'
arch/arm64/kvm/mmu.c:538: warning: Function parameter or member 'mmu' not described in 'stage2_wp_range'
arch/arm64/kvm/mmu.c:538: warning: Excess function parameter 'kvm' description in 'stage2_wp_range'

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
---
 arch/arm64/kvm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e8a51799..aced343 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -114,9 +114,10 @@ static bool kvm_is_device_pfn(unsigned long pfn)
  */
 /**
  * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
- * @kvm:   The VM pointer
+ * @mmu:   The KVM stage-2 MMU pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
+ * @may_block: Whether or not we are permitted to block
  *
  * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
  * be called while holding mmu_lock (unless for freeing the stage2 pgd before
@@ -493,6 +494,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
  * @guest_ipa:	The IPA at which to insert the mapping
  * @pa:		The physical address of the device
  * @size:	The size of the mapping
+ * @writable:   Whether or not to create a writable mapping
  */
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable)
@@ -530,7 +532,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 
 /**
  * stage2_wp_range() - write protect stage2 memory region range
- * @kvm:	The KVM pointer
+ * @mmu:        The KVM stage-2 MMU pointer
  * @addr:	Start address of range
  * @end:	End address of range
  */
-- 
2.8.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
