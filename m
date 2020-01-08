Return-Path: <SRS0=HiVh=25=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TVD_SUBJ_WIPE_DEBT,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FE9C33CB8
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C964620692
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C964620692
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 580DA4B16E;
	Wed,  8 Jan 2020 15:27:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Grga29JrYp-w; Wed,  8 Jan 2020 15:27:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 211804B161;
	Wed,  8 Jan 2020 15:27:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C300E4B130
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 20gNqWmB-s7s for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jan 2020 15:27:08 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 808F94B127
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:08 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 08 Jan 2020 12:27:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; d="scan'208";a="211658398"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:07 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 13/14] KVM: x86/mmu: Remove lpage_is_disallowed() check from
 set_spte()
Date: Wed,  8 Jan 2020 12:24:47 -0800
Message-Id: <20200108202448.9669-14-sean.j.christopherson@intel.com>
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

Remove the late "lpage is disallowed" check from set_spte() now that the
initial check is performed after acquiring mmu_lock.  Fold the guts of
the remaining helper, __mmu_gfn_lpage_is_disallowed(), into
kvm_mmu_hugepage_adjust() to eliminate the unnecessary slot !NULL check.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 39 +++------------------------------------
 1 file changed, 3 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f2667fe0dc75..1e4e0ac169a7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1264,28 +1264,6 @@ static void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	list_del(&sp->lpage_disallowed_link);
 }
 
-static bool __mmu_gfn_lpage_is_disallowed(gfn_t gfn, int level,
-					  struct kvm_memory_slot *slot)
-{
-	struct kvm_lpage_info *linfo;
-
-	if (slot) {
-		linfo = lpage_info_slot(gfn, slot, level);
-		return !!linfo->disallow_lpage;
-	}
-
-	return true;
-}
-
-static bool mmu_gfn_lpage_is_disallowed(struct kvm_vcpu *vcpu, gfn_t gfn,
-					int level)
-{
-	struct kvm_memory_slot *slot;
-
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	return __mmu_gfn_lpage_is_disallowed(gfn, level, slot);
-}
-
 static inline bool memslot_valid_for_gpte(struct kvm_memory_slot *slot,
 					  bool no_dirty_log)
 {
@@ -3078,18 +3056,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	spte |= (u64)pfn << PAGE_SHIFT;
 
 	if (pte_access & ACC_WRITE_MASK) {
-
-		/*
-		 * Legacy code to handle an obsolete scenario where a different
-		 * vcpu creates new sp in the window between this vcpu's query
-		 * of lpage_is_disallowed() and acquiring mmu_lock.  No longer
-		 * necessary now that lpage_is_disallowed() is called after
-		 * acquiring mmu_lock.
-		 */
-		if (level > PT_PAGE_TABLE_LEVEL &&
-		    mmu_gfn_lpage_is_disallowed(vcpu, gfn, level))
-			goto done;
-
 		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
 
 		/*
@@ -3121,7 +3087,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 set_pte:
 	if (mmu_spte_update(sptep, spte))
 		ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
-done:
 	return ret;
 }
 
@@ -3309,6 +3274,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 				   int max_level, kvm_pfn_t *pfnp)
 {
 	struct kvm_memory_slot *slot;
+	struct kvm_lpage_info *linfo;
 	kvm_pfn_t pfn = *pfnp;
 	kvm_pfn_t mask;
 	int level;
@@ -3326,7 +3292,8 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
 	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
-		if (!__mmu_gfn_lpage_is_disallowed(gfn, max_level, slot))
+		linfo = lpage_info_slot(gfn, slot, max_level);
+		if (!linfo->disallow_lpage)
 			break;
 	}
 
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
