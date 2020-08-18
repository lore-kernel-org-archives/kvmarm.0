Return-Path: <SRS0=un+q=B4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F0EC433DF
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 13:28:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7502207D3
	for <kvmarm@archiver.kernel.org>; Tue, 18 Aug 2020 13:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlNEHKq3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7502207D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 705AB4BD62;
	Tue, 18 Aug 2020 09:28:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sivdpJgvPW17; Tue, 18 Aug 2020 09:28:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 547FB4BED0;
	Tue, 18 Aug 2020 09:28:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 227D54BD7A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Aug 2020 09:28:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FmRp3j1eNXZC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Aug 2020 09:28:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E515A4BC5F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Aug 2020 09:28:45 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AC6212080C;
 Tue, 18 Aug 2020 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1597757325;
 bh=ACqhtHGEaXcrBdy4vRFcQ2jhx5ymsCcPP2XZ8YuvUwE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=QlNEHKq3zB5kDS/UJLZts++zk6rD69VpT8pmRQ6RsYv6BL4M2yjHqzCYZuGbbZmwK
 DVDb5HjM2dWKv34cezDdA7zOFZp2ZGmZq6E1sMKcqpaAL4WGgWkx4Cw/oWigdjTkaY
 vq0R5UHuf68kXhvsLkb1oGqu/1deBDvxrtb+56Uk=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 08/22] KVM: arm64: Convert kvm_phys_addr_ioremap() to
 generic page-table API
Date: Tue, 18 Aug 2020 14:28:04 +0100
Message-Id: <20200818132818.16065-9-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200818132818.16065-1-will@kernel.org>
References: <20200818132818.16065-1-will@kernel.org>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

Convert kvm_phys_addr_ioremap() to use kvm_pgtable_stage2_map() instead
of stage2_set_pte().

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 14 +-------------
 arch/arm64/kvm/mmu.c         | 24 ++++++++++--------------
 2 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 41ee8f3c0369..6f65d3841ec9 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -439,18 +439,6 @@ struct stage2_map_data {
 	struct kvm_mmu_memory_cache	*memcache;
 };
 
-static kvm_pte_t *stage2_memcache_alloc_page(struct stage2_map_data *data)
-{
-	kvm_pte_t *ptep = NULL;
-	struct kvm_mmu_memory_cache *mc = data->memcache;
-
-	/* Allocated with GFP_PGTABLE_USER, so no need to zero */
-	if (mc && mc->nobjs)
-		ptep = mc->objects[--mc->nobjs];
-
-	return ptep;
-}
-
 static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 				    struct stage2_map_data *data)
 {
@@ -531,7 +519,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
-	childp = stage2_memcache_alloc_page(data);
+	childp = kvm_mmu_memory_cache_alloc(data->memcache);
 	if (!childp)
 		return -ENOMEM;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index fdca6b69944b..d0c440e2622d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1154,32 +1154,28 @@ static int stage2_pudp_test_and_clear_young(pud_t *pud)
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable)
 {
-	phys_addr_t addr, end;
+	phys_addr_t addr;
 	int ret = 0;
-	unsigned long pfn;
 	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
+	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
+				     KVM_PGTABLE_PROT_R |
+				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
-	end = (guest_ipa + size + PAGE_SIZE - 1) & PAGE_MASK;
-	pfn = __phys_to_pfn(pa);
-
-	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
-		pte_t pte = kvm_pfn_pte(pfn, PAGE_S2_DEVICE);
-
-		if (writable)
-			pte = kvm_s2pte_mkwrite(pte);
-
+	for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
 		ret = kvm_mmu_topup_memory_cache(&cache,
 						 kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			break;
+
 		spin_lock(&kvm->mmu_lock);
-		ret = stage2_set_pte(&kvm->arch.mmu, &cache, addr, &pte,
-				     KVM_S2PTE_FLAG_IS_IOMAP);
+		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
+					     &cache);
 		spin_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
 
-		pfn++;
+		pa += PAGE_SIZE;
 	}
 
 	return ret;
-- 
2.28.0.220.ged08abb693-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
