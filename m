Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37F4C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Apr 2022 21:59:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AAA549F20;
	Fri, 15 Apr 2022 17:59:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Q0tJ+UO+1vz; Fri, 15 Apr 2022 17:59:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 183A9402DB;
	Fri, 15 Apr 2022 17:59:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F43A49EE8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fmUMRt06szdm for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 17:59:09 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C9E449ED3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 17:59:09 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 k20-20020a5e9314000000b00649d55ffa67so5415730iom.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 14:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=azDjsls2ryR6MvWQFRJeidQvMbLl/RHlutDUFGfidAA=;
 b=St531rEB8UEZ21SaQwTTbIns6sfG2sQXxLuoLYkm2ISxMGI/wJkdfTpDg/wdOjVd6u
 5NgtnY1srEpZgvXon4FAZpeLfDIiZr0tsroBjIOvySTRgLGmE1lKquuTRLkiW+BdwiJX
 u5e2iX5vFXKK6FzVPrRHhi8bmCjQNt180OYAsPlgS58CqOAD+XDVxLvcI5+rz836fDV0
 S4qWTFlKLSB3nDd2HmJcWFiqKhkDpj55dxeIduTAEpbTpKgOpI/pcexEL0Gpu4GfY3b/
 W09FwZGDQ3ZVIEU8EGV5KGCTli+M0U/j//S4bQF+bDil4Oss9TqOnbR5akxyOmNhJciY
 7kbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=azDjsls2ryR6MvWQFRJeidQvMbLl/RHlutDUFGfidAA=;
 b=fX6ElNnM/pbZwOW0u8/5XOCSHTPBoORWfmJSEj0ONWet1XtMJ2Gx358KFyVN1GJzxD
 Kh06vW/j41mAiyxCmNhxhpLk1eOrLCo+Ne8bf2Qok8XjHutFpBT7hqXK05j3af9dtl/M
 wmc+00Tw1/AKiRkPMty6QlHpweKMd+Z7IuHq8aXHi3ONAChuKJjfy0qVTvPV9cz+o+al
 f0Uf8ifmrD/UPg3vIS8oesJ6Y04zw37Vdl/11Wn/GMN4KD0dAxVREvV4zENtgW0wVrJV
 WTLH0STUR80WhywYOUPJlX+KjDT98eDtTtBuIHhnnyyBAJkJyN8sOOm9Lyw7rwfrWYZo
 qoTA==
X-Gm-Message-State: AOAM531Bgy2oU4BnqX4u64aJAq9KoodFyPJx5DSLNAwHHG9+q4ypxXko
 snYc++iIrPJH0/RqhxAjN3AMdpzzpD3IxvvSqRTaRa937ngPG1lxye2swsIQwi0IK1SJlJVxB9E
 nVjNv1grQskTs2hUxnMmb25MHDQIK9C449LqfVnjbVeBlZkktMJyrtru//G5kX9mwTww3ag==
X-Google-Smtp-Source: ABdhPJyaiGfZk8c4zniStiF0Dq12dWJ0NDJB0+KYENL3HMx1WDG/wo59ZZ+XTTzQKwEfJUnyLOdPyHvyxnU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:29d2:b0:64c:753c:c490
 with SMTP id
 z18-20020a05660229d200b0064c753cc490mr347648ioq.90.1650059948422; Fri, 15 Apr
 2022 14:59:08 -0700 (PDT)
Date: Fri, 15 Apr 2022 21:58:44 +0000
Message-Id: <20220415215901.1737897-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Presently KVM only takes a read lock for stage 2 faults if it believes
the fault can be fixed by relaxing permissions on a PTE (write unprotect
for dirty logging). Otherwise, stage 2 faults grab the write lock, which
predictably can pile up all the vCPUs in a sufficiently large VM.

The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
MMU protected by the combination of a read-write lock and RCU, allowing
page walkers to traverse in parallel.

This series is strongly inspired by the mechanics of the TDP MMU,
making use of RCU to protect parallel walks. Note that the TLB
invalidation mechanics are a bit different between x86 and ARM, so we
need to use the 'break-before-make' sequence to split/collapse a
block/table mapping, respectively.

Nonetheless, using atomics on the break side allows fault handlers to
acquire exclusive access to a PTE (lets just call it locked). Once the
PTE lock is acquired it is then safe to assume exclusive access.

Special consideration is required when pruning the page tables in
parallel. Suppose we are collapsing a table into a block. Allowing
parallel faults means that a software walker could be in the middle of
a lower level traversal when the table is unlinked. Table
walkers that prune the paging structures must now 'lock' all descendent
PTEs, effectively asserting exclusive ownership of the substructure
(no other walker can install something to an already locked pte).

Additionally, for parallel walks we need to punt the freeing of table
pages to the next RCU sync, as there could be multiple observers of the
table until all walkers exit the RCU critical section. For this I
decided to cram an rcu_head into page private data for every table page.
We wind up spending a bit more on table pages now, but lazily allocating
for rcu callbacks probably doesn't make a lot of sense. Not only would
we need a large cache of them (think about installing a level 1 block)
to wire up callbacks on all descendent tables, but we also then need to
spend memory to actually free memory.

I tried to organize these patches as best I could w/o introducing
intermediate breakage.

The first 5 patches are meant mostly as prepatory reworks, and, in the
case of RCU a nop.

Patch 6 is quite large, but I had a hard time deciding how to change the
way we link/unlink tables to use atomics without breaking things along
the way.

Patch 7 probably should come before patch 6, as it informs the other
read-side fault (perm relax) about when a map is in progress so it'll
back off.

Patches 8-10 take care of the pruning case, actually locking the child ptes
instead of simply dropping table page references along the way. Note
that we cannot assume a pte points to a table/page at this point, hence
the same helper is called for pre- and leaf-traversal. Guide the
recursion based on what got yanked from the PTE.

Patches 11-14 wire up everything to schedule rcu callbacks on
to-be-freed table pages. rcu_barrier() is called on the way out from
tearing down a stage 2 page table to guarantee all memory associated
with the VM has actually been cleaned up.

Patches 15-16 loop in the fault handler to the new table traversal game.

Lastly, patch 17 is a nasty bit of debugging residue to spot possible
table page leaks. Please don't laugh ;-)

Smoke tested with KVM selftests + kvm_page_table_test w/ 2M hugetlb to
exercise the table pruning code. Haven't done anything beyond this,
sending as an RFC now to get eyes on the code.

Applies to commit fb649bda6f56 ("Merge tag 'block-5.18-2022-04-15' of
git://git.kernel.dk/linux-block")

Oliver Upton (17):
  KVM: arm64: Directly read owner id field in stage2_pte_is_counted()
  KVM: arm64: Only read the pte once per visit
  KVM: arm64: Return the next table from map callbacks
  KVM: arm64: Protect page table traversal with RCU
  KVM: arm64: Take an argument to indicate parallel walk
  KVM: arm64: Implement break-before-make sequence for parallel walks
  KVM: arm64: Enlighten perm relax path about parallel walks
  KVM: arm64: Spin off helper for initializing table pte
  KVM: arm64: Tear down unlinked page tables in parallel walk
  KVM: arm64: Assume a table pte is already owned in post-order
    traversal
  KVM: arm64: Move MMU cache init/destroy into helpers
  KVM: arm64: Stuff mmu page cache in sub struct
  KVM: arm64: Setup cache for stage2 page headers
  KVM: arm64: Punt last page reference to rcu callback for parallel walk
  KVM: arm64: Allow parallel calls to kvm_pgtable_stage2_map()
  KVM: arm64: Enable parallel stage 2 MMU faults
  TESTONLY: KVM: arm64: Add super lazy accounting of stage 2 table pages

 arch/arm64/include/asm/kvm_host.h     |   5 +-
 arch/arm64/include/asm/kvm_mmu.h      |   2 +
 arch/arm64/include/asm/kvm_pgtable.h  |  14 +-
 arch/arm64/kvm/arm.c                  |   4 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  13 +-
 arch/arm64/kvm/hyp/nvhe/setup.c       |  13 +-
 arch/arm64/kvm/hyp/pgtable.c          | 518 +++++++++++++++++++-------
 arch/arm64/kvm/mmu.c                  | 120 ++++--
 8 files changed, 503 insertions(+), 186 deletions(-)

-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
