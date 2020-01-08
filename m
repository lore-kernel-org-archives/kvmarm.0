Return-Path: <SRS0=HiVh=25=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69234C33CAD
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B55B208E4
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B55B208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C91CB4B167;
	Wed,  8 Jan 2020 15:27:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OCD76Irx1I+i; Wed,  8 Jan 2020 15:27:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AD1B4B13D;
	Wed,  8 Jan 2020 15:27:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDD2F4B118
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0EaD1J3woPiD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jan 2020 15:27:08 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7F9224B141
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:08 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 08 Jan 2020 12:27:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; d="scan'208";a="211658395"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:07 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 12/14] KVM: x86/mmu: Fold max_mapping_level() into
 kvm_mmu_hugepage_adjust()
Date: Wed,  8 Jan 2020 12:24:46 -0800
Message-Id: <20200108202448.9669-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200108202448.9669-1-sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Paul Mackerras <paulus@ozlabs.org>,
 linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Dave Jiang <dave.jiang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com,
 Barret Rhoden <brho@google.com>, kvm-ppc@vger.kernel.org,
 Liran Alon <liran.alon@oracle.com>, Andy Lutomirski <luto@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Jason Zeng <jason.zeng@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

Fold max_mapping_level() into kvm_mmu_hugepage_adjust() now that HugeTLB
mappings are handled in kvm_mmu_hugepage_adjust(), i.e. there isn't a
need to pre-calculate the max mapping level.  Co-locating all hugepage
checks eliminates a memslot lookup, at the cost of performing the
__mmu_gfn_lpage_is_disallowed() checks while holding mmu_lock.

The latency of lpage_is_disallowed() is likely negligible relative to
the rest of the code run while holding mmu_lock, and can be offset to
some extent by eliminating the mmu_gfn_lpage_is_disallowed() check in
set_spte() in a future patch.  Eliminating the check in set_spte() is
made possible by performing the initial lpage_is_disallowed() checks
while holding mmu_lock.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 60 ++++++++++++++--------------------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 --
 2 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f93b0c5e4170..f2667fe0dc75 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1310,27 +1310,6 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return slot;
 }
 
-static int max_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
-			     int max_level)
-{
-	struct kvm_memory_slot *slot;
-
-	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
-		return PT_PAGE_TABLE_LEVEL;
-
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	if (!memslot_valid_for_gpte(slot, true))
-		return PT_PAGE_TABLE_LEVEL;
-
-	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
-	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
-		if (!__mmu_gfn_lpage_is_disallowed(gfn, max_level, slot))
-			break;
-	}
-
-	return max_level;
-}
-
 /*
  * About rmap_head encoding:
  *
@@ -3101,10 +3080,11 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (pte_access & ACC_WRITE_MASK) {
 
 		/*
-		 * Other vcpu creates new sp in the window between
-		 * max_mapping_level() and acquiring mmu-lock. We can
-		 * allow guest to retry the access, the mapping can
-		 * be fixed if guest refault.
+		 * Legacy code to handle an obsolete scenario where a different
+		 * vcpu creates new sp in the window between this vcpu's query
+		 * of lpage_is_disallowed() and acquiring mmu_lock.  No longer
+		 * necessary now that lpage_is_disallowed() is called after
+		 * acquiring mmu_lock.
 		 */
 		if (level > PT_PAGE_TABLE_LEVEL &&
 		    mmu_gfn_lpage_is_disallowed(vcpu, gfn, level))
@@ -3295,9 +3275,8 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 }
 
 static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
-				  kvm_pfn_t pfn)
+				  kvm_pfn_t pfn, struct kvm_memory_slot *slot)
 {
-	struct kvm_memory_slot *slot;
 	unsigned long hva;
 	pte_t *pte;
 	int level;
@@ -3310,16 +3289,13 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 		return PT_PAGE_TABLE_LEVEL;
 
 	/*
-	 * Manually do the equivalent of kvm_vcpu_gfn_to_hva() to avoid the
+	 * Note, using the already-retrieved memslot and __gfn_to_hva_memslot()
+	 * is not solely for performance, it's also necessary to avoid the
 	 * "writable" check in __gfn_to_hva_many(), which will always fail on
 	 * read-only memslots due to gfn_to_hva() assuming writes.  Earlier
 	 * page fault steps have already verified the guest isn't writing a
 	 * read-only memslot.
 	 */
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	if (!memslot_valid_for_gpte(slot, true))
-		return PT_PAGE_TABLE_LEVEL;
-
 	hva = __gfn_to_hva_memslot(slot, gfn);
 
 	pte = lookup_address_in_mm(vcpu->kvm->mm, hva, &level);
@@ -3332,18 +3308,32 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 				   int max_level, kvm_pfn_t *pfnp)
 {
+	struct kvm_memory_slot *slot;
 	kvm_pfn_t pfn = *pfnp;
 	kvm_pfn_t mask;
 	int level;
 
-	if (max_level == PT_PAGE_TABLE_LEVEL)
+	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
 		return PT_PAGE_TABLE_LEVEL;
 
 	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn) ||
 	    kvm_is_zone_device_pfn(pfn))
 		return PT_PAGE_TABLE_LEVEL;
 
-	level = host_pfn_mapping_level(vcpu, gfn, pfn);
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	if (!memslot_valid_for_gpte(slot, true))
+		return PT_PAGE_TABLE_LEVEL;
+
+	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
+	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
+		if (!__mmu_gfn_lpage_is_disallowed(gfn, max_level, slot))
+			break;
+	}
+
+	if (max_level == PT_PAGE_TABLE_LEVEL)
+		return PT_PAGE_TABLE_LEVEL;
+
+	level = host_pfn_mapping_level(vcpu, gfn, pfn, slot);
 	if (level == PT_PAGE_TABLE_LEVEL)
 		return level;
 
@@ -4182,8 +4172,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (lpage_disallowed)
 		max_level = PT_PAGE_TABLE_LEVEL;
 
-	max_level = max_mapping_level(vcpu, gfn, max_level);
-
 	if (fast_page_fault(vcpu, gpa, error_code))
 		return RET_PF_RETRY;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0560982eda8b..ea174d85700a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -817,8 +817,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	else
 		max_level = walker.level;
 
-	max_level = max_mapping_level(vcpu, walker.gfn, max_level);
-
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
