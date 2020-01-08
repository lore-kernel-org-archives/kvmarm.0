Return-Path: <SRS0=HiVh=25=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134DBC33CB0
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C398A20880
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C398A20880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2A74B13A;
	Wed,  8 Jan 2020 15:27:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bcrrzLmusAkM; Wed,  8 Jan 2020 15:27:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CA784B176;
	Wed,  8 Jan 2020 15:27:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDB7F4B147
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hJaDxPuRusgY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jan 2020 15:27:07 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B0AD4B13A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:07 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 08 Jan 2020 12:27:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; d="scan'208";a="211658377"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:06 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 07/14] KVM: x86/mmu: Walk host page tables to find THP mappings
Date: Wed,  8 Jan 2020 12:24:41 -0800
Message-Id: <20200108202448.9669-8-sean.j.christopherson@intel.com>
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

Explicitly walk the host page tables to identify THP mappings instead
of relying solely on the metadata in struct page.  This sets the stage
for using a common method of identifying huge mappings regardless of the
underlying implementation (HugeTLB vs THB vs DAX), and hopefully avoids
the pitfalls of relying on metadata to identify THP mappings, e.g. see
commit 169226f7e0d2 ("mm: thp: handle page cache THP correctly in
PageTransCompoundMap") and the need for KVM to explicitly check for a
THP compound page.  KVM will also naturally work with 1gb THP pages, if
they are ever supported.

Walking the tables for THP mappings is likely marginally slower than
querying metadata, but a future patch will reuse the walk to identify
HugeTLB mappings, at which point eliminating the existing VMA lookup for
HugeTLB will make this a net positive.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Barret Rhoden <brho@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 30836899be73..4bd7f745b56d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3329,6 +3329,41 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
+static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
+				  kvm_pfn_t pfn)
+{
+	struct kvm_memory_slot *slot;
+	unsigned long hva;
+	pte_t *pte;
+	int level;
+
+	BUILD_BUG_ON(PT_PAGE_TABLE_LEVEL != (int)PG_LEVEL_4K ||
+		     PT_DIRECTORY_LEVEL != (int)PG_LEVEL_2M ||
+		     PT_PDPE_LEVEL != (int)PG_LEVEL_1G);
+
+	if (!PageCompound(pfn_to_page(pfn)))
+		return PT_PAGE_TABLE_LEVEL;
+
+	/*
+	 * Manually do the equivalent of kvm_vcpu_gfn_to_hva() to avoid the
+	 * "writable" check in __gfn_to_hva_many(), which will always fail on
+	 * read-only memslots due to gfn_to_hva() assuming writes.  Earlier
+	 * page fault steps have already verified the guest isn't writing a
+	 * read-only memslot.
+	 */
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	if (!memslot_valid_for_gpte(slot, true))
+		return PT_PAGE_TABLE_LEVEL;
+
+	hva = __gfn_to_hva_memslot(slot, gfn);
+
+	pte = lookup_address_in_mm(vcpu->kvm->mm, hva, &level);
+	if (unlikely(!pte))
+		return PT_PAGE_TABLE_LEVEL;
+
+	return level;
+}
+
 static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 					int max_level, kvm_pfn_t *pfnp,
 					int *levelp)
@@ -3344,10 +3379,11 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	    kvm_is_zone_device_pfn(pfn))
 		return;
 
-	if (!kvm_is_transparent_hugepage(pfn))
+	level = host_pfn_mapping_level(vcpu, gfn, pfn);
+	if (level == PT_PAGE_TABLE_LEVEL)
 		return;
 
-	level = PT_DIRECTORY_LEVEL;
+	level = min(level, max_level);
 
 	/*
 	 * mmu_notifier_retry() was successful and mmu_lock is held, so
-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
