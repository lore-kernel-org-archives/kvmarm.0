Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649BFC433ED
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 02:36:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 272BE208FE
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 02:36:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 272BE208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4C6A4B293;
	Thu,  2 Jul 2020 22:36:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4pglMnl7zN+o; Thu,  2 Jul 2020 22:36:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 284DE4B2D2;
	Thu,  2 Jul 2020 22:36:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68FE74B278
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 22:36:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cos4+cjX5IlN for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 22:36:09 -0400 (EDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 675824B188
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 22:36:09 -0400 (EDT)
IronPort-SDR: Zwxr2z8bsX01QDxQ+sa1+Hc4THmypMkORh8Iti1CJMOqqn3ccZDfWUYAcn/9rexgoENrQSAZAu
 LyElNkSUhF0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="147086668"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; d="scan'208";a="147086668"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Jul 2020 19:36:06 -0700
IronPort-SDR: aAD7Igor/aJhvgoRuJMOkzXEimBaX/dwdVuoqHHUbB4xrTZG8WAcNp+LFgw2lirL57oTEED8AL
 9WwoWNCrU0cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; d="scan'208";a="278295782"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by orsmga003.jf.intel.com with ESMTP; 02 Jul 2020 19:36:06 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 18/21] KVM: arm64: Use common KVM implementation of MMU
 memory caches
Date: Thu,  2 Jul 2020 19:35:42 -0700
Message-Id: <20200703023545.8771-19-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200703023545.8771-1-sean.j.christopherson@intel.com>
References: <20200703023545.8771-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: linux-arch@vger.kernel.org, Junaid Shahid <junaids@google.com>,
 Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Ben Gardon <bgardon@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>, kvmarm@lists.cs.columbia.edu,
 Jim Mattson <jmattson@google.com>
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

Move to the common MMU memory cache implementation now that the common
code and arm64's existing code are semantically compatible.

No functional change intended.

Cc: Marc Zyngier <maz@kernel.org>
Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/arm64/include/asm/Kbuild      |  1 -
 arch/arm64/include/asm/kvm_host.h  | 12 -------
 arch/arm64/include/asm/kvm_types.h |  8 +++++
 arch/arm64/kvm/mmu.c               | 53 +++++++-----------------------
 4 files changed, 19 insertions(+), 55 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_types.h

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 35a68155cd0e..ff9cbb631212 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 generic-y += early_ioremap.h
-generic-y += kvm_types.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 335170b59899..23d1f41548f5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -97,18 +97,6 @@ struct kvm_arch {
 	bool return_nisv_io_abort_to_user;
 };
 
-#define KVM_NR_MEM_OBJS     40
-
-/*
- * We don't want allocation failures within the mmu code, so we preallocate
- * enough memory for a single page fault in a cache.
- */
-struct kvm_mmu_memory_cache {
-	int nobjs;
-	gfp_t gfp_zero;
-	void *objects[KVM_NR_MEM_OBJS];
-};
-
 struct kvm_vcpu_fault_info {
 	u32 esr_el2;		/* Hyp Syndrom Register */
 	u64 far_el2;		/* Hyp Fault Address Register */
diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
new file mode 100644
index 000000000000..9a126b9e2d7c
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM64_KVM_TYPES_H
+#define _ASM_ARM64_KVM_TYPES_H
+
+#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
+
+#endif /* _ASM_ARM64_KVM_TYPES_H */
+
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5220623a4efb..ba66e9a9bd3c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -124,37 +124,6 @@ static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
 	put_page(virt_to_page(pudp));
 }
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
-{
-	void *page;
-
-	if (cache->nobjs >= min)
-		return 0;
-	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT |
-					       cache->gfp_zero);
-		if (!page)
-			return -ENOMEM;
-		cache->objects[cache->nobjs++] = page;
-	}
-	return 0;
-}
-
-static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
-{
-	while (mc->nobjs)
-		free_page((unsigned long)mc->objects[--mc->nobjs]);
-}
-
-static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
-{
-	void *p;
-
-	BUG_ON(!mc || !mc->nobjs);
-	p = mc->objects[--mc->nobjs];
-	return p;
-}
-
 static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd, phys_addr_t addr)
 {
 	p4d_t *p4d_table __maybe_unused = stage2_p4d_offset(kvm, pgd, 0UL);
@@ -1131,7 +1100,7 @@ static p4d_t *stage2_get_p4d(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	if (stage2_pgd_none(kvm, *pgd)) {
 		if (!cache)
 			return NULL;
-		p4d = mmu_memory_cache_alloc(cache);
+		p4d = kvm_mmu_memory_cache_alloc(cache);
 		stage2_pgd_populate(kvm, pgd, p4d);
 		get_page(virt_to_page(pgd));
 	}
@@ -1149,7 +1118,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	if (stage2_p4d_none(kvm, *p4d)) {
 		if (!cache)
 			return NULL;
-		pud = mmu_memory_cache_alloc(cache);
+		pud = kvm_mmu_memory_cache_alloc(cache);
 		stage2_p4d_populate(kvm, p4d, pud);
 		get_page(virt_to_page(p4d));
 	}
@@ -1170,7 +1139,7 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	if (stage2_pud_none(kvm, *pud)) {
 		if (!cache)
 			return NULL;
-		pmd = mmu_memory_cache_alloc(cache);
+		pmd = kvm_mmu_memory_cache_alloc(cache);
 		stage2_pud_populate(kvm, pud, pmd);
 		get_page(virt_to_page(pud));
 	}
@@ -1376,7 +1345,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	if (stage2_pud_none(kvm, *pud)) {
 		if (!cache)
 			return 0; /* ignore calls from kvm_set_spte_hva */
-		pmd = mmu_memory_cache_alloc(cache);
+		pmd = kvm_mmu_memory_cache_alloc(cache);
 		stage2_pud_populate(kvm, pud, pmd);
 		get_page(virt_to_page(pud));
 	}
@@ -1401,7 +1370,7 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
 	if (pmd_none(*pmd)) {
 		if (!cache)
 			return 0; /* ignore calls from kvm_set_spte_hva */
-		pte = mmu_memory_cache_alloc(cache);
+		pte = kvm_mmu_memory_cache_alloc(cache);
 		kvm_pmd_populate(pmd, pte);
 		get_page(virt_to_page(pmd));
 	}
@@ -1468,7 +1437,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	phys_addr_t addr, end;
 	int ret = 0;
 	unsigned long pfn;
-	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, };
+	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
 
 	end = (guest_ipa + size + PAGE_SIZE - 1) & PAGE_MASK;
 	pfn = __phys_to_pfn(pa);
@@ -1479,8 +1448,8 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (writable)
 			pte = kvm_s2pte_mkwrite(pte);
 
-		ret = mmu_topup_memory_cache(&cache,
-					     kvm_mmu_cache_min_pages(kvm));
+		ret = kvm_mmu_topup_memory_cache(&cache,
+						 kvm_mmu_cache_min_pages(kvm));
 		if (ret)
 			goto out;
 		spin_lock(&kvm->mmu_lock);
@@ -1494,7 +1463,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	}
 
 out:
-	mmu_free_memory_cache(&cache);
+	kvm_mmu_free_memory_cache(&cache);
 	return ret;
 }
 
@@ -1880,7 +1849,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	mmap_read_unlock(current->mm);
 
 	/* We need minimum second+third level pages */
-	ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm));
+	ret = kvm_mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm));
 	if (ret)
 		return ret;
 
@@ -2303,7 +2272,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 
 void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 }
 
 phys_addr_t kvm_mmu_get_httbr(void)
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
