Return-Path: <SRS0=HiVh=25=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9444BC33CA9
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5749B20692
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5749B20692
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03CC24B15D;
	Wed,  8 Jan 2020 15:27:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rdjYnaxLjXwi; Wed,  8 Jan 2020 15:27:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B45EB4B179;
	Wed,  8 Jan 2020 15:27:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C49784B12F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hV7qC5rv4iBD for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jan 2020 15:27:07 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 875A64B133
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:07 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 08 Jan 2020 12:27:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; d="scan'208";a="211658374"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:06 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 06/14] KVM: x86/mmu: Refactor THP adjust to prep for changing
 query
Date: Wed,  8 Jan 2020 12:24:40 -0800
Message-Id: <20200108202448.9669-7-sean.j.christopherson@intel.com>
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

Refactor transparent_hugepage_adjust() in preparation for walking the
host page tables to identify hugepage mappings, initially for THP pages,
and eventualy for HugeTLB and DAX-backed pages as well.  The latter
cases support 1gb pages, i.e. the adjustment logic needs access to the
max allowed level.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 44 +++++++++++++++++-----------------
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +--
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8ca6cd04cdf1..30836899be73 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3329,33 +3329,34 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
-static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
-					gfn_t gfn, kvm_pfn_t *pfnp,
+static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
+					int max_level, kvm_pfn_t *pfnp,
 					int *levelp)
 {
 	kvm_pfn_t pfn = *pfnp;
 	int level = *levelp;
+	kvm_pfn_t mask;
+
+	if (max_level == PT_PAGE_TABLE_LEVEL || level > PT_PAGE_TABLE_LEVEL)
+		return;
+
+	if (is_error_noslot_pfn(pfn) || kvm_is_reserved_pfn(pfn) ||
+	    kvm_is_zone_device_pfn(pfn))
+		return;
+
+	if (!kvm_is_transparent_hugepage(pfn))
+		return;
+
+	level = PT_DIRECTORY_LEVEL;
 
 	/*
-	 * Check if it's a transparent hugepage. If this would be an
-	 * hugetlbfs page, level wouldn't be set to
-	 * PT_PAGE_TABLE_LEVEL and there would be no adjustment done
-	 * here.
+	 * mmu_notifier_retry() was successful and mmu_lock is held, so
+	 * the pmd can't be split from under us.
 	 */
-	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
-	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
-	    kvm_is_transparent_hugepage(pfn)) {
-		unsigned long mask;
-
-		/*
-		 * mmu_notifier_retry() was successful and mmu_lock is held, so
-		 * the pmd can't be split from under us.
-		 */
-		*levelp = level = PT_DIRECTORY_LEVEL;
-		mask = KVM_PAGES_PER_HPAGE(level) - 1;
-		VM_BUG_ON((gfn & mask) != (pfn & mask));
-		*pfnp = pfn & ~mask;
-	}
+	*levelp = level;
+	mask = KVM_PAGES_PER_HPAGE(level) - 1;
+	VM_BUG_ON((gfn & mask) != (pfn & mask));
+	*pfnp = pfn & ~mask;
 }
 
 static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
@@ -3395,8 +3396,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
 
-	if (likely(max_level > PT_PAGE_TABLE_LEVEL))
-		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
+	transparent_hugepage_adjust(vcpu, gfn, max_level, &pfn, &level);
 
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
 	for_each_shadow_entry(vcpu, gpa, it) {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b53bed3c901c..0029f7870865 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -673,8 +673,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	gfn = gw->gfn | ((addr & PT_LVL_OFFSET_MASK(gw->level)) >> PAGE_SHIFT);
 	base_gfn = gfn;
 
-	if (max_level > PT_PAGE_TABLE_LEVEL)
-		transparent_hugepage_adjust(vcpu, gw->gfn, &pfn, &hlevel);
+	transparent_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn, &hlevel);
 
 	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
 
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
