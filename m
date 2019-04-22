Return-Path: <SRS0=1O2p=SY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35264C10F11
	for <kvmarm@archiver.kernel.org>; Mon, 22 Apr 2019 19:43:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC4B52177B
	for <kvmarm@archiver.kernel.org>; Mon, 22 Apr 2019 19:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2nqmB2Uv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC4B52177B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 888FE4A4D2;
	Mon, 22 Apr 2019 15:43:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zX3pfTvbgebO; Mon, 22 Apr 2019 15:43:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F3B4A445;
	Mon, 22 Apr 2019 15:43:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDC514A445
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Apr 2019 15:43:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dtxy4suLEqdP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Apr 2019 15:43:10 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84A894A409
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Apr 2019 15:43:10 -0400 (EDT)
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net
 [73.47.72.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A45FE2177B;
 Mon, 22 Apr 2019 19:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1555962189;
 bh=0aOGSShikwhv7hLnbXCgOfbupt8Kq3tjNQFQg9NkC/s=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=2nqmB2Uvh9Sjy+XOTMjFmMRSOGq2TRhC6prYL8JiPxoiAME9e7ON3rfOhXyVZnBXf
 9bF0lvYJkYykGNG+0DdoAoOxqFAT/yy7BW6Zg+biWTye86ixM/4LwsvItiO31gku9j
 JhKrkodvrUIoCUCLa8ZVbcB+e+Hpoe0lgK1lwA5o=
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 36/98] KVM: arm/arm64: Fix handling of stage2 huge
 mappings
Date: Mon, 22 Apr 2019 15:41:03 -0400
Message-Id: <20190422194205.10404-36-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190422194205.10404-1-sashal@kernel.org>
References: <20190422194205.10404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190422194103.Ll6LdQnzlZTe-IdiP3IZNbv0JdkT0_K0XTP13rJG3h0@z>

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 3c3736cd32bf5197aed1410ae826d2d254a5b277 ]

We rely on the mmu_notifier call backs to handle the split/merge
of huge pages and thus we are guaranteed that, while creating a
block mapping, either the entire block is unmapped at stage2 or it
is missing permission.

However, we miss a case where the block mapping is split for dirty
logging case and then could later be made block mapping, if we cancel the
dirty logging. This not only creates inconsistent TLB entries for
the pages in the the block, but also leakes the table pages for
PMD level.

Handle this corner case for the huge mappings at stage2 by
unmapping the non-huge mapping for the block. This could potentially
release the upper level table. So we need to restart the table walk
once we unmap the range.

Fixes : ad361f093c1e31d ("KVM: ARM: Support hugetlbfs backed huge pages")
Reported-by: Zheng Xiang <zhengxiang9@huawei.com>
Cc: Zheng Xiang <zhengxiang9@huawei.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm/include/asm/stage2_pgtable.h |  2 +
 virt/kvm/arm/mmu.c                    | 59 +++++++++++++++++++--------
 2 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
index de2089501b8b..9e11dce55e06 100644
--- a/arch/arm/include/asm/stage2_pgtable.h
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -75,6 +75,8 @@ static inline bool kvm_stage2_has_pud(struct kvm *kvm)
 
 #define S2_PMD_MASK				PMD_MASK
 #define S2_PMD_SIZE				PMD_SIZE
+#define S2_PUD_MASK				PUD_MASK
+#define S2_PUD_SIZE				PUD_SIZE
 
 static inline bool kvm_stage2_has_pmd(struct kvm *kvm)
 {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 6dccb36465e6..7a0f9eeea68c 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1060,25 +1060,43 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 {
 	pmd_t *pmd, old_pmd;
 
+retry:
 	pmd = stage2_get_pmd(kvm, cache, addr);
 	VM_BUG_ON(!pmd);
 
 	old_pmd = *pmd;
+	/*
+	 * Multiple vcpus faulting on the same PMD entry, can
+	 * lead to them sequentially updating the PMD with the
+	 * same value. Following the break-before-make
+	 * (pmd_clear() followed by tlb_flush()) process can
+	 * hinder forward progress due to refaults generated
+	 * on missing translations.
+	 *
+	 * Skip updating the page table if the entry is
+	 * unchanged.
+	 */
+	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
+		return 0;
+
 	if (pmd_present(old_pmd)) {
 		/*
-		 * Multiple vcpus faulting on the same PMD entry, can
-		 * lead to them sequentially updating the PMD with the
-		 * same value. Following the break-before-make
-		 * (pmd_clear() followed by tlb_flush()) process can
-		 * hinder forward progress due to refaults generated
-		 * on missing translations.
+		 * If we already have PTE level mapping for this block,
+		 * we must unmap it to avoid inconsistent TLB state and
+		 * leaking the table page. We could end up in this situation
+		 * if the memory slot was marked for dirty logging and was
+		 * reverted, leaving PTE level mappings for the pages accessed
+		 * during the period. So, unmap the PTE level mapping for this
+		 * block and retry, as we could have released the upper level
+		 * table in the process.
 		 *
-		 * Skip updating the page table if the entry is
-		 * unchanged.
+		 * Normal THP split/merge follows mmu_notifier callbacks and do
+		 * get handled accordingly.
 		 */
-		if (pmd_val(old_pmd) == pmd_val(*new_pmd))
-			return 0;
-
+		if (!pmd_thp_or_huge(old_pmd)) {
+			unmap_stage2_range(kvm, addr & S2_PMD_MASK, S2_PMD_SIZE);
+			goto retry;
+		}
 		/*
 		 * Mapping in huge pages should only happen through a
 		 * fault.  If a page is merged into a transparent huge
@@ -1090,8 +1108,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 		 * should become splitting first, unmapped, merged,
 		 * and mapped back in on-demand.
 		 */
-		VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
-
+		WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
 		pmd_clear(pmd);
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
 	} else {
@@ -1107,6 +1124,7 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 {
 	pud_t *pudp, old_pud;
 
+retry:
 	pudp = stage2_get_pud(kvm, cache, addr);
 	VM_BUG_ON(!pudp);
 
@@ -1114,14 +1132,23 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 
 	/*
 	 * A large number of vcpus faulting on the same stage 2 entry,
-	 * can lead to a refault due to the
-	 * stage2_pud_clear()/tlb_flush(). Skip updating the page
-	 * tables if there is no change.
+	 * can lead to a refault due to the stage2_pud_clear()/tlb_flush().
+	 * Skip updating the page tables if there is no change.
 	 */
 	if (pud_val(old_pud) == pud_val(*new_pudp))
 		return 0;
 
 	if (stage2_pud_present(kvm, old_pud)) {
+		/*
+		 * If we already have table level mapping for this block, unmap
+		 * the range for this block and retry.
+		 */
+		if (!stage2_pud_huge(kvm, old_pud)) {
+			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
+			goto retry;
+		}
+
+		WARN_ON_ONCE(kvm_pud_pfn(old_pud) != kvm_pud_pfn(*new_pudp));
 		stage2_pud_clear(kvm, pudp);
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
 	} else {
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
