Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A54ECAAD8
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 08:36:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E5854BB98;
	Wed, 14 Sep 2022 04:36:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XbCgigYpo0Ql; Wed, 14 Sep 2022 04:36:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 005CB4BBAD;
	Wed, 14 Sep 2022 04:36:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58AAD4BB31
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XE2gI6GiUREJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 04:36:19 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C29B94BC17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:17 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 496BF6193B;
 Wed, 14 Sep 2022 08:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4586C43470;
 Wed, 14 Sep 2022 08:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663144576;
 bh=ubNg9OVluIpHWUzaM5PeEFYKW/9/pHn1I3EXbcq99vs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=FT1Yh7kJMUIlPN2g26Uvb8/u2+6YtmdhK3o0KdkZVJrULQa0vaT07STco+XVzcMLY
 60ZDUQ85zQZnyMmwEaokTLQ31qv6yiGN6ALWngmHQieDdJxejLZsoyWpJd1wZFEJyC
 8GSCEhvq3LyrcW0SpfEv2UN0W5FBMbMs9inLm+Ddv0tWPX2po8OIp5jpi8R7eHAM+v
 5/6ljTqMnkvCGk0GbpUg1epVINIdEpMRUqqBfZ9pMmgpkuWltZ06yqL3+8K1Fjyjwi
 e+xbRyVuKlAFkEdhTwbUs87DOJD9oJoXChnamkkk4VC46YqDHTUC9nMV+E+Z1YptMz
 95wTzqpim/7+w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 19/25] KVM: arm64: Instantiate guest stage-2 page-tables at
 EL2
Date: Wed, 14 Sep 2022 09:34:54 +0100
Message-Id: <20220914083500.5118-20-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
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

From: Quentin Perret <qperret@google.com>

Extend the initialisation of guest data structures within the pKVM
hypervisor at EL2 so that we instantiate a memory pool and a full
'struct kvm_s2_mmu' structure for each VM, with a stage-2 page-table
entirely independent from the one managed by the host at EL1.

The 'struct kvm_pgtable_mm_ops' used by the page-table code is populated
with a set of callbacks that can manage guest pages in the hypervisor
without any direct intervention from the host, allocating page-table
pages from the provided pool and returning these to the host on VM
teardown. To keep things simple, the stage-2 MMU for the guest is
configured identically to the host stage-2 in the VTCR register and so
the IPA size of the guest must match the PA size of the host.

For now, the new page-table is unused as there is no way for the host
to map anything into it. Yet.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |   6 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c  | 125 ++++++++++++++++++++++++-
 arch/arm64/kvm/mmu.c                   |   4 +-
 3 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index d176399dbfb5..5d456438445c 100644
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
@@ -36,6 +39,9 @@ struct pkvm_hyp_vm {
 
 	/* The guest's stage-2 page-table managed by the hypervisor. */
 	struct kvm_pgtable pgt;
+	struct kvm_pgtable_mm_ops mm_ops;
+	struct hyp_pool pool;
+	hyp_spinlock_t lock;
 
 	/*
 	 * The number of vcpus initialized and ready to run.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1c38451050e5..27b16a6b85bb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,6 +25,21 @@ struct host_mmu host_mmu;
 
 static struct hyp_pool host_s2_pool;
 
+static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
+#define current_vm (*this_cpu_ptr(&__current_vm))
+
+static void guest_lock_component(struct pkvm_hyp_vm *vm)
+{
+	hyp_spin_lock(&vm->lock);
+	current_vm = vm;
+}
+
+static void guest_unlock_component(struct pkvm_hyp_vm *vm)
+{
+	current_vm = NULL;
+	hyp_spin_unlock(&vm->lock);
+}
+
 static void host_lock_component(void)
 {
 	hyp_spin_lock(&host_mmu.lock);
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
 int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
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
 
 void reclaim_guest_pages(struct pkvm_hyp_vm *vm)
 {
+	void *pgd = vm->pgt.pgd;
 	unsigned long nr_pages;
 
 	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
-	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(vm->pgt.pgd), nr_pages));
+
+	guest_lock_component(vm);
+	kvm_pgtable_stage2_destroy(&vm->pgt);
+	vm->kvm.arch.mmu.pgd_phys = 0ULL;
+	guest_unlock_component(vm);
+
+	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(pgd), nr_pages));
 }
 
 int __pkvm_prot_finalize(void)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4b24e9e1e96b..e500539933ca 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -658,7 +658,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 		return -EINVAL;
 
 	phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
-	if (phys_shift) {
+	if (is_protected_kvm_enabled()) {
+		phys_shift = kvm_ipa_limit;
+	} else if (phys_shift) {
 		if (phys_shift > kvm_ipa_limit ||
 		    phys_shift < ARM64_MIN_PARANGE_BITS)
 			return -EINVAL;
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
