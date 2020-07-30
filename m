Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56C6C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5BEC520829
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aignaf4R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BEC520829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14FB94B4B9;
	Thu, 30 Jul 2020 11:34:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XRCq7FGMjZ0j; Thu, 30 Jul 2020 11:34:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AEDF4B4DE;
	Thu, 30 Jul 2020 11:34:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 314774B4D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Miau3UGVu5e0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:34:28 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C62C04B4D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:28 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 7F62221744;
 Thu, 30 Jul 2020 15:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596123268;
 bh=guUZzLqr8JTQk7v7W2gG+jK5DyMbupyyvDekgvvqjXs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Aignaf4RGUSsY1rj20z7YjkiuRGo220s17fWNf8S1dhNlOv9e7pblUs2ZkO2+QOif
 gke9nrg5MXqHrJ0d7FVhsPdm2ZiAr9gG7jeplYiisX9VY0KjzR1rEaEz7DRfeW9AOy
 bsjUxd/PEciFfVa1PhS/yqYD5YmegLBu9Sb0HaBI=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 04/20] KVM: arm64: Add support for creating kernel-agnostic
 stage-2 page tables
Date: Thu, 30 Jul 2020 16:33:50 +0100
Message-Id: <20200730153406.25136-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200730153406.25136-1-will@kernel.org>
References: <20200730153406.25136-1-will@kernel.org>
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

Introduce alloc() and free() functions to the generic page-table code
for guest stage-2 page-tables and plumb these into the existing KVM
page-table allocator. Subsequent patches will convert other operations
within the KVM allocator over to the generic code.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h    |  1 +
 arch/arm64/include/asm/kvm_pgtable.h | 17 ++++++++
 arch/arm64/kvm/mmu.c                 | 42 ++++++++------------
 arch/arm64/kvm/pgtable.c             | 58 ++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e1a32c0707bb..072ab1fac98a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -81,6 +81,7 @@ struct kvm_s2_mmu {
 	 */
 	pgd_t		*pgd;
 	phys_addr_t	pgd_phys;
+	void		*pgt_cookie;
 
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c607025e1a05..7b4df5d0d2b8 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -99,6 +99,23 @@ void kvm_pgtable_hyp_free_cookie(void *cookie);
 int kvm_pgtable_hyp_map(void *cookie, u64 addr, u64 size, u64 phys,
 			enum kvm_pgtable_prot prot);
 
+/**
+ * kvm_pgtable_stage2_alloc_cookie() - Allocate a guest stage-2 page-table.
+ * @kvm:	KVM structure representing the guest virtual machine.
+ *
+ * Return: An opaque cookie which can be used to manipulate the page-table.
+ */
+void *kvm_pgtable_stage2_alloc_cookie(struct kvm *kvm);
+
+/**
+ * kvm_pgtable_stage2_free_cookie() - Free an unused guest stage-2 page-table.
+ * @cookie:	Opaque cookie allocated by kvm_pgtable_stage2_alloc_cookie().
+ *
+ * The page-table is assumed to be unreachable by any hardware walkers prior
+ * to freeing and therefore no TLB invalidation is performed.
+ */
+void kvm_pgtable_stage2_free_cookie(void *cookie);
+
 /**
  * kvm_pgtable_get_pgd_phys() - Get physical pgd pointer for a page-table.
  * @cookie:	Opaque cookie allocated by kvm_pgtable_*_alloc_cookie().
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d5cb88a3c1e5..ecca611f208b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -696,35 +696,27 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
  * @kvm:	The pointer to the KVM structure
  * @mmu:	The pointer to the s2 MMU structure
  *
- * Allocates only the stage-2 HW PGD level table(s) of size defined by
- * stage2_pgd_size(mmu->kvm).
- *
+ * Allocates only the stage-2 HW PGD level table(s).
  * Note we don't need locking here as this is only called when the VM is
  * created, which can only be done once.
  */
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 {
-	phys_addr_t pgd_phys;
-	pgd_t *pgd;
 	int cpu;
+	void *cookie;
 
-	if (mmu->pgd != NULL) {
+	if (mmu->pgt_cookie != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
 
-	/* Allocate the HW PGD, making sure that each page gets its own refcount */
-	pgd = alloc_pages_exact(stage2_pgd_size(kvm), GFP_KERNEL | __GFP_ZERO);
-	if (!pgd)
+	cookie = kvm_pgtable_stage2_alloc_cookie(kvm);
+	if (!cookie)
 		return -ENOMEM;
 
-	pgd_phys = virt_to_phys(pgd);
-	if (WARN_ON(pgd_phys & ~kvm_vttbr_baddr_mask(kvm)))
-		return -EINVAL;
-
 	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
 	if (!mmu->last_vcpu_ran) {
-		free_pages_exact(pgd, stage2_pgd_size(kvm));
+		kvm_pgtable_stage2_free_cookie(cookie);
 		return -ENOMEM;
 	}
 
@@ -732,8 +724,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
 	mmu->kvm = kvm;
-	mmu->pgd = pgd;
-	mmu->pgd_phys = pgd_phys;
+	mmu->pgt_cookie = cookie;
+	mmu->pgd_phys = kvm_pgtable_get_pgd_phys(cookie);
+	mmu->pgd = __va(mmu->pgd_phys);
 	mmu->vmid.vmid_gen = 0;
 
 	return 0;
@@ -809,21 +802,20 @@ void stage2_unmap_vm(struct kvm *kvm)
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 {
 	struct kvm *kvm = mmu->kvm;
-	void *pgd = NULL;
+	void *cookie = NULL;
 
 	spin_lock(&kvm->mmu_lock);
-	if (mmu->pgd) {
-		unmap_stage2_range(mmu, 0, kvm_phys_size(kvm));
-		pgd = READ_ONCE(mmu->pgd);
+	cookie = mmu->pgt_cookie;
+	if (cookie) {
 		mmu->pgd = NULL;
+		mmu->pgd_phys = 0;
+		mmu->pgt_cookie = NULL;
+		free_percpu(mmu->last_vcpu_ran);
 	}
 	spin_unlock(&kvm->mmu_lock);
 
-	/* Free the HW pgd, one page at a time */
-	if (pgd) {
-		free_pages_exact(pgd, stage2_pgd_size(kvm));
-		free_percpu(mmu->last_vcpu_ran);
-	}
+	if (cookie)
+		kvm_pgtable_stage2_free_cookie(cookie);
 }
 
 static p4d_t *stage2_get_p4d(struct kvm_s2_mmu *mmu, struct kvm_mmu_memory_cache *cache,
diff --git a/arch/arm64/kvm/pgtable.c b/arch/arm64/kvm/pgtable.c
index b148c76f8b79..f05a45c02361 100644
--- a/arch/arm64/kvm/pgtable.c
+++ b/arch/arm64/kvm/pgtable.c
@@ -443,3 +443,61 @@ u64 kvm_pgtable_get_pgd_phys(void *cookie)
 	struct kvm_pgtable *pgt = cookie;
 	return __pa(pgt->pgd);
 }
+
+void *kvm_pgtable_stage2_alloc_cookie(struct kvm *kvm)
+{
+	size_t pgd_sz;
+	u64 vtcr = kvm->arch.vtcr;
+	struct kvm_pgtable *pgt = kzalloc(sizeof(*pgt), GFP_KERNEL);
+
+	if (!pgt)
+		return NULL;
+
+	pgt->ia_bits = VTCR_EL2_IPA(vtcr);
+	pgt->start_level = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
+	pgt->mmu = &kvm->arch.mmu;
+
+	pgd_sz = kvm_pgd_pages(pgt) * PAGE_SIZE;
+	pgt->pgd = alloc_pages_exact(pgd_sz, GFP_KERNEL | __GFP_ZERO);
+	if (!pgt->pgd) {
+		kfree(pgt);
+		pgt = NULL;
+	}
+
+	return pgt;
+}
+
+static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			      enum kvm_pgtable_walk_flags flag,
+			      void * const arg)
+{
+	kvm_pte_t pte = *ptep;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	put_page(virt_to_page(ptep));
+
+	if (kvm_pte_table(pte, level))
+		free_page((unsigned long)kvm_pte_follow(pte));
+
+	return 0;
+}
+
+void kvm_pgtable_stage2_free_cookie(void *cookie)
+{
+	size_t pgd_sz;
+	struct kvm_pgtable *pgt = cookie;
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_free_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF |
+			  KVM_PGTABLE_WALK_TABLE_POST,
+	};
+
+	if (kvm_pgtable_walk(cookie, 0, BIT(pgt->ia_bits), &walker))
+		kvm_err("Failed to free page-table pages\n");
+
+	pgd_sz = kvm_pgd_pages(pgt) * PAGE_SIZE;
+	free_pages_exact(pgt->pgd, pgd_sz);
+	kfree(pgt);
+}
-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
