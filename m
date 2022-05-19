Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6C4C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 861204B211;
	Thu, 19 May 2022 09:44:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FPELGoWRaUFf; Thu, 19 May 2022 09:44:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B8704B33E;
	Thu, 19 May 2022 09:44:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D355F4B370
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Inm5Zxo5+r55 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:43:57 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E1684B32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1B70A61783;
 Thu, 19 May 2022 13:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E856C34119;
 Thu, 19 May 2022 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967836;
 bh=KTS0y+H0adznlFudoodX9+FGRdBy3wYYcqFTBfMRCQU=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=UdTvL+c34+yJHNIRCs4Pb/Dsx7F0JahVjbJZ7ysUGQeBe656/JAQ7v0fAh3JfyDO1
 SRhbZ7Oosgm3WF283Dvg9L6lfF6z7oH3iMKdJ/G6Luad+CmGXrBKUsHK045k+zO/o7
 oOb8zX0s5NNFfH8g1iwpJSJCbBCUl+1oKw4SkqiqzSf81KTEDEa+eYO9gRmtR7ORWz
 fO7MaBiBZpSwRYdh7jPxXc/430TB9AYuD1EzCGfIru2KjO8N9XHPbqgC7GMG16hrlA
 O1qyO8mOkLTPY96B2o4lSV9vYrkOImiKPoK7p3+9pfT2qKA0za8Hbncrx4L8NeAQ17
 Z/TpMGUl3qtow==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 23/89] KVM: arm64: Instantiate guest stage-2 page-tables at EL2
Date: Thu, 19 May 2022 14:40:58 +0100
Message-Id: <20220519134204.5379-24-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

Extend the shadow initialisation at EL2 so that we instantiate a memory
pool and a full 'struct kvm_s2_mmu' structure for each VM, with a
stage-2 page-table entirely independent from the one managed by the host
at EL1.

For now, the new page-table is unused as there is no way for the host
to map anything into it. Yet.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |   6 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c  | 127 ++++++++++++++++++++++++-
 2 files changed, 130 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index dc06b043bd83..f841e2b252cd 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -9,6 +9,9 @@
 
 #include <asm/kvm_pkvm.h>
 
+#include <nvhe/gfp.h>
+#include <nvhe/spinlock.h>
+
 /*
  * Holds the relevant data for maintaining the vcpu state completely at hyp.
  */
@@ -37,6 +40,9 @@ struct kvm_shadow_vm {
 	size_t shadow_area_size;
 
 	struct kvm_pgtable pgt;
+	struct kvm_pgtable_mm_ops mm_ops;
+	struct hyp_pool pool;
+	hyp_spinlock_t lock;
 
 	/* Array of the shadow state per vcpu. */
 	struct kvm_shadow_vcpu_state shadow_vcpu_states[0];
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 707bd832145f..992ef4b668b4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,6 +25,21 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
+static DEFINE_PER_CPU(struct kvm_shadow_vm *, __current_vm);
+#define current_vm (*this_cpu_ptr(&__current_vm))
+
+static void guest_lock_component(struct kvm_shadow_vm *vm)
+{
+	hyp_spin_lock(&vm->lock);
+	current_vm = vm;
+}
+
+static void guest_unlock_component(struct kvm_shadow_vm *vm)
+{
+	current_vm = NULL;
+	hyp_spin_unlock(&vm->lock);
+}
+
 static void host_lock_component(void)
 {
 	hyp_spin_lock(&host_kvm.lock);
@@ -140,18 +155,124 @@ int kvm_host_prepare_stage2(void *pgt_pool_base)
 	return 0;
 }
 
+static bool guest_stage2_force_pte_cb(u64 addr, u64 end,
+				      enum kvm_pgtable_prot prot)
+{
+	return true;
+}
+
+static void *guest_s2_zalloc_pages_exact(size_t size)
+{
+	void *addr = hyp_alloc_pages(&current_vm->pool, get_order(size));
+
+	WARN_ON(size != (PAGE_SIZE << get_order(size)));
+	hyp_split_page(hyp_virt_to_page(addr));
+
+	return addr;
+}
+
+static void guest_s2_free_pages_exact(void *addr, unsigned long size)
+{
+	u8 order = get_order(size);
+	unsigned int i;
+
+	for (i = 0; i < (1 << order); i++)
+		hyp_put_page(&current_vm->pool, addr + (i * PAGE_SIZE));
+}
+
+static void *guest_s2_zalloc_page(void *mc)
+{
+	struct hyp_page *p;
+	void *addr;
+
+	addr = hyp_alloc_pages(&current_vm->pool, 0);
+	if (addr)
+		return addr;
+
+	addr = pop_hyp_memcache(mc, hyp_phys_to_virt);
+	if (!addr)
+		return addr;
+
+	memset(addr, 0, PAGE_SIZE);
+	p = hyp_virt_to_page(addr);
+	memset(p, 0, sizeof(*p));
+	p->refcount = 1;
+
+	return addr;
+}
+
+static void guest_s2_get_page(void *addr)
+{
+	hyp_get_page(&current_vm->pool, addr);
+}
+
+static void guest_s2_put_page(void *addr)
+{
+	hyp_put_page(&current_vm->pool, addr);
+}
+
+static void clean_dcache_guest_page(void *va, size_t size)
+{
+	__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
+	hyp_fixmap_unmap();
+}
+
+static void invalidate_icache_guest_page(void *va, size_t size)
+{
+	__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)), size);
+	hyp_fixmap_unmap();
+}
+
 int kvm_guest_prepare_stage2(struct kvm_shadow_vm *vm, void *pgd)
 {
-	vm->pgt.pgd = pgd;
+	struct kvm_s2_mmu *mmu = &vm->kvm.arch.mmu;
+	unsigned long nr_pages;
+	int ret;
+
+	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
+	ret = hyp_pool_init(&vm->pool, hyp_virt_to_pfn(pgd), nr_pages, 0);
+	if (ret)
+		return ret;
+
+	hyp_spin_lock_init(&vm->lock);
+	vm->mm_ops = (struct kvm_pgtable_mm_ops) {
+		.zalloc_pages_exact	= guest_s2_zalloc_pages_exact,
+		.free_pages_exact	= guest_s2_free_pages_exact,
+		.zalloc_page		= guest_s2_zalloc_page,
+		.phys_to_virt		= hyp_phys_to_virt,
+		.virt_to_phys		= hyp_virt_to_phys,
+		.page_count		= hyp_page_count,
+		.get_page		= guest_s2_get_page,
+		.put_page		= guest_s2_put_page,
+		.dcache_clean_inval_poc	= clean_dcache_guest_page,
+		.icache_inval_pou	= invalidate_icache_guest_page,
+	};
+
+	guest_lock_component(vm);
+	ret = __kvm_pgtable_stage2_init(mmu->pgt, mmu, &vm->mm_ops, 0,
+					guest_stage2_force_pte_cb);
+	guest_unlock_component(vm);
+	if (ret)
+		return ret;
+
+	vm->kvm.arch.mmu.pgd_phys = __hyp_pa(vm->pgt.pgd);
+
 	return 0;
 }
 
 void reclaim_guest_pages(struct kvm_shadow_vm *vm)
 {
-	unsigned long nr_pages;
+	unsigned long nr_pages, pfn;
 
 	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
-	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
+	pfn = hyp_virt_to_pfn(vm->pgt.pgd);
+
+	guest_lock_component(vm);
+	kvm_pgtable_stage2_destroy(&vm->pgt);
+	vm->kvm.arch.mmu.pgd_phys = 0ULL;
+	guest_unlock_component(vm);
+
+	WARN_ON(__pkvm_hyp_donate_host(pfn, nr_pages));
 }
 
 int __pkvm_prot_finalize(void)
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
