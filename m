Return-Path: <SRS0=uMsW=Y5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1399C5DF61
	for <kvmarm@archiver.kernel.org>; Tue,  5 Nov 2019 20:30:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 685D521A4A
	for <kvmarm@archiver.kernel.org>; Tue,  5 Nov 2019 20:30:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 685D521A4A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 112494ACCD;
	Tue,  5 Nov 2019 15:30:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o7U-bfqOsF1w; Tue,  5 Nov 2019 15:30:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 213094AEA8;
	Tue,  5 Nov 2019 15:30:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AE2E4A968
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Nov 2019 15:29:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id soDEAdMcrtsR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Nov 2019 15:29:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27B174ACC2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Nov 2019 15:29:57 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99640970;
 Tue,  5 Nov 2019 12:29:56 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC0B73FE76;
 Tue,  5 Nov 2019 03:04:06 -0800 (PST)
From: Christoffer Dall <christoffer.dall@arm.com>
To: kvm@vger.kernel.org
Subject: [PATCH v4 3/5] KVM: x86: Rename mmu_memory_cache to kvm_mmu_memcache
Date: Tue,  5 Nov 2019 12:03:55 +0100
Message-Id: <20191105110357.8607-4-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191105110357.8607-1-christoffer.dall@arm.com>
References: <20191105110357.8607-1-christoffer.dall@arm.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Mike Rapoport <rppt@linux.ibm.com>, Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

As we have moved the mmu memory cache definitions and functions to
common code, they are exported as symols to the rest of the kernel.

Let's rename the functions and data types to have a kvm_ prefix to make
it clear where these functions belong and take this chance to rename
memory_cache to memcache to avoid overly long lines.

This is a bit tedious on the callsites but ends up looking more
palatable.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/x86/include/asm/kvm_host.h  |  6 ++---
 arch/x86/include/asm/kvm_types.h |  4 ++--
 arch/x86/kvm/mmu.c               | 38 ++++++++++++++++----------------
 arch/x86/kvm/paging_tmpl.h       |  4 ++--
 include/linux/kvm_host.h         | 14 ++++++------
 include/linux/kvm_types.h        |  6 ++---
 virt/kvm/kvm_main.c              | 14 ++++++------
 7 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e5080b618f3c..47e183ca0fb2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -586,9 +586,9 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu *walk_mmu;
 
-	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
-	struct kvm_mmu_memory_cache mmu_page_cache;
-	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	struct kvm_mmu_memcache mmu_pte_list_desc_cache;
+	struct kvm_mmu_memcache mmu_page_cache;
+	struct kvm_mmu_memcache mmu_page_header_cache;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
index 40428651dc7a..d391490ab8d1 100644
--- a/arch/x86/include/asm/kvm_types.h
+++ b/arch/x86/include/asm/kvm_types.h
@@ -2,8 +2,8 @@
 #ifndef _ASM_X86_KVM_TYPES_H
 #define _ASM_X86_KVM_TYPES_H
 
-#define KVM_ARCH_WANT_MMU_MEMORY_CACHE
+#define KVM_ARCH_WANT_MMU_MEMCACHE
 
-#define KVM_NR_MEM_OBJS 40
+#define KVM_MMU_NR_MEMCACHE_OBJS 40
 
 #endif /* _ASM_X86_KVM_TYPES_H */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index abcdb47b0ac7..431ac346a1e8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1017,35 +1017,35 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
-static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
+static int kvm_mmu_topup_memcaches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+	r = kvm_mmu_topup_memcache(&vcpu->arch.mmu_pte_list_desc_cache,
 				   pte_list_desc_cache, 8 + PTE_PREFETCH_NUM);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
+	r = kvm_mmu_topup_memcache_page(&vcpu->arch.mmu_page_cache, 8);
 	if (r)
 		goto out;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
+	r = kvm_mmu_topup_memcache(&vcpu->arch.mmu_page_header_cache,
 				   mmu_page_header_cache, 4);
 out:
 	return r;
 }
 
-static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
+static void kvm_mmu_free_memcaches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+	kvm_mmu_free_memcache(&vcpu->arch.mmu_pte_list_desc_cache,
 				pte_list_desc_cache);
-	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
+	kvm_mmu_free_memcache_page(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memcache(&vcpu->arch.mmu_page_header_cache,
 				mmu_page_header_cache);
 }
 
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
-	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	return kvm_mmu_memcache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
@@ -1371,10 +1371,10 @@ static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
 
 static bool rmap_can_add(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_memory_cache *cache;
+	struct kvm_mmu_memcache *cache;
 
 	cache = &vcpu->arch.mmu_pte_list_desc_cache;
-	return mmu_memory_cache_free_objects(cache);
+	return kvm_mmu_memcache_free_objects(cache);
 }
 
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
@@ -2062,10 +2062,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 {
 	struct kvm_mmu_page *sp;
 
-	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
+	sp = kvm_mmu_memcache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->spt = kvm_mmu_memcache_alloc(&vcpu->arch.mmu_page_cache);
 	if (!direct)
-		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
+		sp->gfns = kvm_mmu_memcache_alloc(&vcpu->arch.mmu_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	/*
@@ -4005,7 +4005,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = kvm_mmu_topup_memcaches(vcpu);
 	if (r)
 		return r;
 
@@ -4121,7 +4121,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = kvm_mmu_topup_memcaches(vcpu);
 	if (r)
 		return r;
 
@@ -5102,7 +5102,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = kvm_mmu_topup_memcaches(vcpu);
 	if (r)
 		goto out;
 	r = mmu_alloc_roots(vcpu);
@@ -5280,7 +5280,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	 * or not since pte prefetch is skiped if it does not have
 	 * enough objects in the cache.
 	 */
-	mmu_topup_memory_caches(vcpu);
+	kvm_mmu_topup_memcaches(vcpu);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
 
@@ -6169,7 +6169,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_unload(vcpu);
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
-	mmu_free_memory_caches(vcpu);
+	kvm_mmu_free_memcaches(vcpu);
 }
 
 void kvm_mmu_module_exit(void)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7d5cdb3af594..106bb08c11ee 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -765,7 +765,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
-	r = mmu_topup_memory_caches(vcpu);
+	r = kvm_mmu_topup_memcaches(vcpu);
 	if (r)
 		return r;
 
@@ -885,7 +885,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 	 * No need to check return value here, rmap_can_add() can
 	 * help us to skip pte prefetch later.
 	 */
-	mmu_topup_memory_caches(vcpu);
+	kvm_mmu_topup_memcaches(vcpu);
 
 	if (!VALID_PAGE(root_hpa)) {
 		WARN_ON(1);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 612922d440cc..c832b925d4ee 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -788,15 +788,15 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
-#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
-int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+#ifdef KVM_ARCH_WANT_MMU_MEMCACHE
+int kvm_mmu_topup_memcache(struct kvm_mmu_memcache *cache,
 			   struct kmem_cache *base_cache, int min);
-int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache);
-void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
+int kvm_mmu_memcache_free_objects(struct kvm_mmu_memcache *cache);
+void kvm_mmu_free_memcache(struct kvm_mmu_memcache *mc,
 			   struct kmem_cache *cache);
-int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min);
-void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc);
-void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+int kvm_mmu_topup_memcache_page(struct kvm_mmu_memcache *cache, int min);
+void kvm_mmu_free_memcache_page(struct kvm_mmu_memcache *mc);
+void *kvm_mmu_memcache_alloc(struct kvm_mmu_memcache *mc);
 #endif
 
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index ca7d3b3c8487..bfe59aa55736 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -50,14 +50,14 @@ struct gfn_to_hva_cache {
 	struct kvm_memory_slot *memslot;
 };
 
-#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
+#ifdef KVM_ARCH_WANT_MMU_MEMCACHE
 /*
  * We don't want allocation failures within the mmu code, so we preallocate
  * enough memory for a single page fault in a cache.
  */
-struct kvm_mmu_memory_cache {
+struct kvm_mmu_memcache {
 	int nobjs;
-	void *objects[KVM_NR_MEM_OBJS];
+	void *objects[KVM_MMU_NR_MEMCACHE_OBJS];
 };
 #endif
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a4e8297152e9..278a881ca3e3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -289,8 +289,8 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
-#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
-int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+#ifdef KVM_ARCH_WANT_MMU_MEMCACHE
+int kvm_mmu_topup_memcache(struct kvm_mmu_memcache *cache,
 			   struct kmem_cache *base_cache, int min)
 {
 	void *obj;
@@ -306,19 +306,19 @@ int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 	return 0;
 }
 
-int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
+int kvm_mmu_memcache_free_objects(struct kvm_mmu_memcache *cache)
 {
 	return cache->nobjs;
 }
 
-void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
+void kvm_mmu_free_memcache(struct kvm_mmu_memcache *mc,
 			   struct kmem_cache *cache)
 {
 	while (mc->nobjs)
 		kmem_cache_free(cache, mc->objects[--mc->nobjs]);
 }
 
-int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min)
+int kvm_mmu_topup_memcache_page(struct kvm_mmu_memcache *cache, int min)
 {
 	void *page;
 
@@ -333,13 +333,13 @@ int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min)
 	return 0;
 }
 
-void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
+void kvm_mmu_free_memcache_page(struct kvm_mmu_memcache *mc)
 {
 	while (mc->nobjs)
 		free_page((unsigned long)mc->objects[--mc->nobjs]);
 }
 
-void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
+void *kvm_mmu_memcache_alloc(struct kvm_mmu_memcache *mc)
 {
 	void *p;
 
-- 
2.18.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
