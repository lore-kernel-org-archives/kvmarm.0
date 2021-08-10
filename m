Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 023AAC4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 07:02:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9197C60FC4
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 07:02:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9197C60FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30AC54B099;
	Tue, 10 Aug 2021 03:02:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3-ufCXdM6diO; Tue, 10 Aug 2021 03:02:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 521364B0CC;
	Tue, 10 Aug 2021 03:02:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D23040874
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 03:02:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7o-xaGDOv382 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 03:02:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 192914B08B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 03:02:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D39AB1042;
 Tue, 10 Aug 2021 00:02:06 -0700 (PDT)
Received: from p8cg001049571a15.arm.com (unknown [10.163.67.89])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 76C913F718;
 Tue, 10 Aug 2021 00:02:03 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/5] KVM: arm64: Drop direct PAGE_[SHIFT|SIZE] usage as page
 size
Date: Tue, 10 Aug 2021 12:32:37 +0530
Message-Id: <1628578961-29097-2-git-send-email-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

All instances here could just directly test against CONFIG_ARM64_XXK_PAGES
instead of evaluating via PAGE_SHIFT or PAGE_SIZE. With this change, there
will be no such usage left.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 6 +++---
 arch/arm64/mm/mmu.c          | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 05321f4165e3..a6112b6d6ef6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -85,7 +85,7 @@ static bool kvm_level_supports_block_mapping(u32 level)
 	 * Reject invalid block mappings and don't bother with 4TB mappings for
 	 * 52-bit PAs.
 	 */
-	return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
+	return !(level == 0 || (!IS_ENABLED(CONFIG_ARM64_4K_PAGES) && level == 1));
 }
 
 static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
@@ -155,7 +155,7 @@ static u64 kvm_pte_to_phys(kvm_pte_t pte)
 {
 	u64 pa = pte & KVM_PTE_ADDR_MASK;
 
-	if (PAGE_SHIFT == 16)
+	if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
 		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
 
 	return pa;
@@ -165,7 +165,7 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
 {
 	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
 
-	if (PAGE_SHIFT == 16)
+	if (IS_ENABLED(CONFIG_ARM64_64K_PAGES))
 		pte |= FIELD_PREP(KVM_PTE_ADDR_51_48, pa >> 48);
 
 	return pte;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 9ff0de1b2b93..8fdfca179815 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -296,7 +296,7 @@ static void alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 static inline bool use_1G_block(unsigned long addr, unsigned long next,
 			unsigned long phys)
 {
-	if (PAGE_SHIFT != 12)
+	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES))
 		return false;
 
 	if (((addr | next | phys) & ~PUD_MASK) != 0)
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
