Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB7CC433E2
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 13:19:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA01F20872
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 13:19:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA01F20872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E4E74B217;
	Tue, 15 Sep 2020 09:19:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YWDU-c6SQDoH; Tue, 15 Sep 2020 09:19:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E953D4B23C;
	Tue, 15 Sep 2020 09:19:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF3494B212
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 09:19:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y+Wy4hTq5jIt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 09:19:42 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 362644B1D2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 09:19:42 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 688A3C371012733F450F;
 Tue, 15 Sep 2020 21:19:37 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Tue, 15 Sep 2020 21:19:29 +0800
From: Xiaofei Tan <tanxiaofei@huawei.com>
To: <maz@kernel.org>, <james.morse@arm.com>, <julien.thierry.kdev@gmail.com>, 
 <suzuki.poulose@arm.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: arm64: fix doc warnings in mmu code
Date: Tue, 15 Sep 2020 21:18:10 +0800
Message-ID: <1600175890-7435-1-git-send-email-tanxiaofei@huawei.com>
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
arch/arm64/kvm/mmu.c:119: warning: Function parameter or member 'pudp'not described in 'stage2_dissolve_pud'
arch/arm64/kvm/mmu.c:119: warning: Excess function parameter 'pud' description in 'stage2_dissolve_pud'
arch/arm64/kvm/mmu.c:348: warning: Function parameter or member 'mmu' not described in '__unmap_stage2_range'
arch/arm64/kvm/mmu.c:348: warning: Function parameter or member 'may_block' not described in '__unmap_stage2_range'
arch/arm64/kvm/mmu.c:348: warning: Excess function parameter 'kvm' description in '__unmap_stage2_range'
arch/arm64/kvm/mmu.c:1474: warning: Function parameter or member 'writable' not described in 'kvm_phys_addr_ioremap'
arch/arm64/kvm/mmu.c:1536: warning: Function parameter or member 'mmu' not described in 'stage2_wp_pmds'
arch/arm64/kvm/mmu.c:1564: warning: Function parameter or member 'mmu' not described in 'stage2_wp_puds'
arch/arm64/kvm/mmu.c:1591: warning: Function parameter or member 'mmu' not described in 'stage2_wp_p4ds'
arch/arm64/kvm/mmu.c:1611: warning: Function parameter or member 'mmu' not described in 'stage2_wp_range'
arch/arm64/kvm/mmu.c:1611: warning: Excess function parameter 'kvm' description in 'stage2_wp_range'

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
---
 arch/arm64/kvm/mmu.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ba00bcc..c76add7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -111,7 +111,7 @@ static void stage2_dissolve_pmd(struct kvm_s2_mmu *mmu, phys_addr_t addr, pmd_t
  * stage2_dissolve_pud() - clear and flush huge PUD entry
  * @mmu:	pointer to mmu structure to operate on
  * @addr:	IPA
- * @pud:	pud pointer for IPA
+ * @pudp:	pud pointer for IPA
  *
  * Function clears a PUD entry, flushes addr 1st and 2nd stage TLBs.
  */
@@ -334,9 +334,10 @@ static void unmap_stage2_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 
 /**
  * unmap_stage2_range -- Clear stage2 page table entries to unmap a range
- * @kvm:   The VM pointer
+ * @mmu:   pointer to mmu structure to operate on
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
+ * @may_block: The flag that if block is allowed here
  *
  * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
  * be called while holding mmu_lock (unless for freeing the stage2 pgd before
@@ -1468,6 +1469,7 @@ static int stage2_pudp_test_and_clear_young(pud_t *pud)
  * @guest_ipa:	The IPA at which to insert the mapping
  * @pa:		The physical address of the device
  * @size:	The size of the mapping
+ * @writable:   If it is writable here
  */
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable)
@@ -1526,7 +1528,7 @@ static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
 
 /**
  * stage2_wp_pmds - write protect PUD range
- * kvm:		kvm instance for the VM
+ * @mmu:        pointer to mmu structure to operate on
  * @pud:	pointer to pud entry
  * @addr:	range start address
  * @end:	range end address
@@ -1555,6 +1557,7 @@ static void stage2_wp_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
 
 /**
  * stage2_wp_puds - write protect P4D range
+ * @mmu:        pointer to mmu structure to operate on
  * @p4d:	pointer to p4d entry
  * @addr:	range start address
  * @end:	range end address
@@ -1582,6 +1585,7 @@ static void  stage2_wp_puds(struct kvm_s2_mmu *mmu, p4d_t *p4d,
 
 /**
  * stage2_wp_p4ds - write protect PGD range
+ * @mmu:        pointer to mmu structure to operate on
  * @pgd:	pointer to pgd entry
  * @addr:	range start address
  * @end:	range end address
@@ -1603,7 +1607,7 @@ static void  stage2_wp_p4ds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 
 /**
  * stage2_wp_range() - write protect stage2 memory region range
- * @kvm:	The KVM pointer
+ * @mmu:        pointer to mmu structure to operate on
  * @addr:	Start address of range
  * @end:	End address of range
  */
-- 
2.8.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
