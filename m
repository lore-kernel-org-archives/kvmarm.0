Return-Path: <SRS0=HiVh=25=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37981C33CA4
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B890E20880
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jan 2020 20:27:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B890E20880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CAC74B118;
	Wed,  8 Jan 2020 15:27:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DfeRYRBH4UzT; Wed,  8 Jan 2020 15:27:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6B234B131;
	Wed,  8 Jan 2020 15:27:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B85C4B135
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ukRo1DDu1iZf for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jan 2020 15:27:05 -0500 (EST)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4F8A4B10F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jan 2020 15:27:05 -0500 (EST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
 by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 08 Jan 2020 12:27:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; d="scan'208";a="211658348"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
 by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 12:27:04 -0800
From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 00/14] KVM: x86/mmu: Huge page fixes, cleanup, and DAX
Date: Wed,  8 Jan 2020 12:24:34 -0800
Message-Id: <20200108202448.9669-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
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

This series is a mix of bug fixes, cleanup and new support in KVM's
handling of huge pages.  The series initially stemmed from a syzkaller
bug report[1], which is fixed by patch 02, "mm: thp: KVM: Explicitly
check for THP when populating secondary MMU".

While investigating options for fixing the syzkaller bug, I realized KVM
could reuse the approach from Barret's series to enable huge pages for DAX
mappings in KVM[2] for all types of huge mappings, i.e. walk the host page
tables instead of querying metadata (patches 05 - 09).

Walking the host page tables sidesteps the issues with refcounting and
identifying THP mappings (in theory), and using a common method for
identifying huge mappings should improve (haven't actually measured) KVM's
overall page fault latency by eliminating the vma lookup that is currently
used to identify HugeTLB mappings.  Eliminating the HugeTLB specific code
also allows for additional cleanup (patches 10 - 13).

Testing the page walk approach revealed several pre-existing bugs that
are included here (patches 01, 03 and 04) because the changes interact
with the rest of the series, e.g. without the read-only memslots fix,
walking the host page tables without explicitly filtering out HugeTLB
mappings would pick up read-only memslots and introduce a completely
unintended functional change.

Lastly, with the page walk infrastructure in place, supporting DAX-based
huge mappings becomes a trivial change (patch 14).

Based on kvm/queue, commit e41a90be9659 ("KVM: x86/mmu: WARN if root_hpa
is invalid when handling a page fault")

Paolo, assuming I understand your workflow, patch 01 can be squashed with
the buggy commit as it's still sitting in kvm/queue.

[1] https://lkml.kernel.org/r/0000000000003cffc30599d3d1a0@google.com
[2] https://lkml.kernel.org/r/20191212182238.46535-1-brho@google.com

Sean Christopherson (14):
  KVM: x86/mmu: Enforce max_level on HugeTLB mappings
  mm: thp: KVM: Explicitly check for THP when populating secondary MMU
  KVM: Use vcpu-specific gva->hva translation when querying host page
    size
  KVM: Play nice with read-only memslots when querying host page size
  x86/mm: Introduce lookup_address_in_mm()
  KVM: x86/mmu: Refactor THP adjust to prep for changing query
  KVM: x86/mmu: Walk host page tables to find THP mappings
  KVM: x86/mmu: Drop level optimization from fast_page_fault()
  KVM: x86/mmu: Rely on host page tables to find HugeTLB mappings
  KVM: x86/mmu: Remove obsolete gfn restoration in FNAME(fetch)
  KVM: x86/mmu: Zap any compound page when collapsing sptes
  KVM: x86/mmu: Fold max_mapping_level() into kvm_mmu_hugepage_adjust()
  KVM: x86/mmu: Remove lpage_is_disallowed() check from set_spte()
  KVM: x86/mmu: Use huge pages for DAX-backed files

 arch/powerpc/kvm/book3s_xive_native.c |   2 +-
 arch/x86/include/asm/pgtable_types.h  |   4 +
 arch/x86/kvm/mmu/mmu.c                | 208 ++++++++++----------------
 arch/x86/kvm/mmu/paging_tmpl.h        |  29 +---
 arch/x86/mm/pageattr.c                |  11 ++
 include/linux/huge_mm.h               |   6 +
 include/linux/kvm_host.h              |   3 +-
 mm/huge_memory.c                      |  11 ++
 virt/kvm/arm/mmu.c                    |   8 +-
 virt/kvm/kvm_main.c                   |  24 ++-
 10 files changed, 145 insertions(+), 161 deletions(-)

-- 
2.24.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
