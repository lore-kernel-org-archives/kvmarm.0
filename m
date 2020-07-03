Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574C6C433E8
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 02:36:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1A53820B1F
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 02:36:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A53820B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3F6D4B258;
	Thu,  2 Jul 2020 22:36:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4cjblgScpDjC; Thu,  2 Jul 2020 22:36:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8B5A4B2B6;
	Thu,  2 Jul 2020 22:36:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85E3C4B296
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 22:36:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i1JbCCnmC4xc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 22:36:08 -0400 (EDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44D944B266
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 22:36:08 -0400 (EDT)
IronPort-SDR: rgjGERLmMDWo4jW/xXZ6NH/yFu/jcR2WfUe+rV7e7vO6Qpby7bjhlqaN/0Nir5ZFGQf7go+izw
 uWvA6kR2L6XQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="147086664"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; d="scan'208";a="147086664"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
 by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Jul 2020 19:36:06 -0700
IronPort-SDR: wdofXoBQ7O4RSLs3kdT9NlCDg6+esQG+qoZkHWC2FeM4yyMi4mJo1gcV+m5xEzsyabUFxV03FD
 gp02tyv7cjSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; d="scan'208";a="278295759"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
 by orsmga003.jf.intel.com with ESMTP; 02 Jul 2020 19:36:05 -0700
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 13/21] KVM: x86/mmu: Prepend "kvm_" to memory cache helpers
 that will be global
Date: Thu,  2 Jul 2020 19:35:37 -0700
Message-Id: <20200703023545.8771-14-sean.j.christopherson@intel.com>
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

Rename the memory helpers that will soon be moved to common code and be
made globaly available via linux/kvm_host.h.  "mmu" alone is not a
sufficient namespace for globally available KVM symbols.

Opportunistically add "nr_" in mmu_memory_cache_free_objects() to make
it clear the function returns the number of free objects, as opposed to
freeing existing objects.

Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 586d63de0e78..f4c8dae476bb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1071,7 +1071,7 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 		return (void *)__get_free_page(gfp_flags);
 }
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
+static int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 {
 	void *obj;
 
@@ -1086,12 +1086,12 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
 	return 0;
 }
 
-static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *mc)
+static int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 {
 	return mc->nobjs;
 }
 
-static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+static void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 {
 	while (mc->nobjs) {
 		if (mc->kmem_cache)
@@ -1106,33 +1106,33 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	int r;
 
 	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				   1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
+	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
-				   PT64_ROOT_MAX_LEVEL);
+	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
+				       PT64_ROOT_MAX_LEVEL);
 	if (r)
 		return r;
 	if (maybe_indirect) {
-		r = mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
-					   PT64_ROOT_MAX_LEVEL);
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
+					       PT64_ROOT_MAX_LEVEL);
 		if (r)
 			return r;
 	}
-	return mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
-				      PT64_ROOT_MAX_LEVEL);
+	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
+					  PT64_ROOT_MAX_LEVEL);
 }
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
-	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
+static void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 {
 	void *p;
 
@@ -1146,7 +1146,7 @@ static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
 
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
-	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
@@ -1417,7 +1417,7 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_memory_cache *mc;
 
 	mc = &vcpu->arch.mmu_pte_list_desc_cache;
-	return mmu_memory_cache_free_objects(mc);
+	return kvm_mmu_memory_cache_nr_free_objects(mc);
 }
 
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
@@ -2104,10 +2104,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 {
 	struct kvm_mmu_page *sp;
 
-	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	if (!direct)
-		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	/*
-- 
2.26.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
