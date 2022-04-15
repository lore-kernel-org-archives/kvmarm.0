Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020E3C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 16 Apr 2022 08:34:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E921411C7;
	Sat, 16 Apr 2022 04:34:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HEcNnZEdnVVt; Sat, 16 Apr 2022 04:34:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE73540F9C;
	Sat, 16 Apr 2022 04:34:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C7A849EE1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 19:35:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hws-+uNHo4Xk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2022 19:35:52 -0400 (EDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com
 [209.85.208.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0CD549EDF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 19:35:52 -0400 (EDT)
Received: by mail-lj1-f177.google.com with SMTP id r18so10941098ljp.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2022 16:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=zYpJfqJx7d2DxTmeeTs+ZELB+v0k+j7qa41wmKEfKm8=;
 b=aoNecNfazUQ5134uApw0neMDbp1NXEfEPzly1IRzewTBXD7Vwjsy502V4Z4aYMz//k
 x0pTxEQV+ZXR8or+WZYvhy0YNEoqs0vpxkN7Tior9AU2V8lI6+ZPhm1WqTZfFuhqaq3H
 8KK0tPENoezQkx02qVXWQLFKDwfproboTCwZt5ieVpXxQjNYejuFohswv3sjXU4VC/qu
 K9ZO9J9Dqa+9WBymz2MrOLQ+MLHLNInH+88+n7DOmxcq6N0nBOUANZNW8G6aNJBUE6cP
 hNrw5yVfRDEpsa6GzdWDQCmlLVONgTzAZ/ufu7xSTVag9CzUrl+XnMvjBii/gPEMCSmR
 ZUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=zYpJfqJx7d2DxTmeeTs+ZELB+v0k+j7qa41wmKEfKm8=;
 b=X0eXUISbyT10LUMPz9OjoIJM1sDu69ampD2G951ZZ0y55m7hMuBVHjiFyorcQRoxNV
 l9N5WcNHnGC9Wtw5NK6qgCPrg5ag7ev/wyEuKGP1Z+n61eO3qctebvZAboOyxTWVhS1L
 B9Iks7ZI2L4e3p52toY+eMtfAGO5UljgakdjKKxHh+KIEfPEVWueZDP2mANTDeu1Dpw9
 4KGPALQxyQ9kuH7oRosDivShw06tGqS9upEsKbEKOHBx+9cf9LnGmQ4Xp/K+YO6ixuqO
 Y2pd+yK/Jkn2PbAl7NIvml1wbr6q/Luuy224VFQd/vWwAjdEoRVyzRH/T5ZiLZb7/nZi
 4amQ==
X-Gm-Message-State: AOAM5327vkYlfnngnZCagLLnmtqvBKFtWhVhaAOrdcq793K06U20CU1h
 y74KpIsojeZ16GRrsndf7RuPgraD/uBgXpb0CkUPDg==
X-Google-Smtp-Source: ABdhPJzttRIHPAm85L+ywCTI9gtoFQQ9orr9JaLUs7ZlPkwgkiihGblTNr8Csv/qy/WzICTS1ipzGaW1zUtuHswHYWw=
X-Received: by 2002:a05:651c:179f:b0:24b:1406:5f55 with SMTP id
 bn31-20020a05651c179f00b0024b14065f55mr730237ljb.361.1650065751025; Fri, 15
 Apr 2022 16:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 15 Apr 2022 16:35:24 -0700
Message-ID: <CALzav=c6jQ53G-2gEZYasH_b4_hLYtNAD5pW1TXSfPWxLf3_qw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To: Oliver Upton <oupton@google.com>
X-Mailman-Approved-At: Sat, 16 Apr 2022 04:33:59 -0400
Cc: kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Ben Gardon <bgardon@google.com>, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, KVMARM <kvmarm@lists.cs.columbia.edu>,
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

On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
>
> Presently KVM only takes a read lock for stage 2 faults if it believes
> the fault can be fixed by relaxing permissions on a PTE (write unprotect
> for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> predictably can pile up all the vCPUs in a sufficiently large VM.
>
> The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> MMU protected by the combination of a read-write lock and RCU, allowing
> page walkers to traverse in parallel.
>
> This series is strongly inspired by the mechanics of the TDP MMU,
> making use of RCU to protect parallel walks. Note that the TLB
> invalidation mechanics are a bit different between x86 and ARM, so we
> need to use the 'break-before-make' sequence to split/collapse a
> block/table mapping, respectively.

An alternative (or perhaps "v2" [1]) is to make x86's TDP MMU
arch-neutral and port it to support ARM's stage-2 MMU. This is based
on a few observations:

- The problems that motivated the development of the TDP MMU are not
x86-specific (e.g. parallelizing faults during the post-copy phase of
Live Migration).
- The synchronization in the TDP MMU (read/write lock, RCU for PT
freeing, atomic compare-exchanges for modifying PTEs) is complex, but
would be equivalent across architectures.
- Eventually RISC-V is going to want similar performance (my
understanding is RISC-V MMU is already a copy-paste of the ARM MMU),
and it'd be a shame to re-implement TDP MMU synchronization a third
time.
- The TDP MMU includes support for various performance features that
would benefit other architectures, such as eager page splitting,
deferred zapping, lockless write-protection resolution, and (coming
soon) in-place huge page promotion.
- And then there's the obvious wins from less code duplication in KVM
(e.g. get rid of the RISC-V MMU copy, increased code test coverage,
...).

The side of this I haven't really looked into yet is ARM's stage-2
MMU, and how amenable it would be to being managed by the TDP MMU. But
I assume it's a conventional page table structure mapping GPAs to
HPAs, which is the most important overlap.

That all being said, an arch-neutral TDP MMU would be a larger, more
complex code change than something like this series (hence my "v2"
caveat above). But I wanted to get this idea out there since the
rubber is starting to hit the road on improving ARM MMU scalability.

[1] "v2" as in the "next evolution" sense, not the "PATCH v2" sense :)





>
> Nonetheless, using atomics on the break side allows fault handlers to
> acquire exclusive access to a PTE (lets just call it locked). Once the
> PTE lock is acquired it is then safe to assume exclusive access.
>
> Special consideration is required when pruning the page tables in
> parallel. Suppose we are collapsing a table into a block. Allowing
> parallel faults means that a software walker could be in the middle of
> a lower level traversal when the table is unlinked. Table
> walkers that prune the paging structures must now 'lock' all descendent
> PTEs, effectively asserting exclusive ownership of the substructure
> (no other walker can install something to an already locked pte).
>
> Additionally, for parallel walks we need to punt the freeing of table
> pages to the next RCU sync, as there could be multiple observers of the
> table until all walkers exit the RCU critical section. For this I
> decided to cram an rcu_head into page private data for every table page.
> We wind up spending a bit more on table pages now, but lazily allocating
> for rcu callbacks probably doesn't make a lot of sense. Not only would
> we need a large cache of them (think about installing a level 1 block)
> to wire up callbacks on all descendent tables, but we also then need to
> spend memory to actually free memory.
>
> I tried to organize these patches as best I could w/o introducing
> intermediate breakage.
>
> The first 5 patches are meant mostly as prepatory reworks, and, in the
> case of RCU a nop.
>
> Patch 6 is quite large, but I had a hard time deciding how to change the
> way we link/unlink tables to use atomics without breaking things along
> the way.
>
> Patch 7 probably should come before patch 6, as it informs the other
> read-side fault (perm relax) about when a map is in progress so it'll
> back off.
>
> Patches 8-10 take care of the pruning case, actually locking the child ptes
> instead of simply dropping table page references along the way. Note
> that we cannot assume a pte points to a table/page at this point, hence
> the same helper is called for pre- and leaf-traversal. Guide the
> recursion based on what got yanked from the PTE.
>
> Patches 11-14 wire up everything to schedule rcu callbacks on
> to-be-freed table pages. rcu_barrier() is called on the way out from
> tearing down a stage 2 page table to guarantee all memory associated
> with the VM has actually been cleaned up.
>
> Patches 15-16 loop in the fault handler to the new table traversal game.
>
> Lastly, patch 17 is a nasty bit of debugging residue to spot possible
> table page leaks. Please don't laugh ;-)
>
> Smoke tested with KVM selftests + kvm_page_table_test w/ 2M hugetlb to
> exercise the table pruning code. Haven't done anything beyond this,
> sending as an RFC now to get eyes on the code.
>
> Applies to commit fb649bda6f56 ("Merge tag 'block-5.18-2022-04-15' of
> git://git.kernel.dk/linux-block")
>
> Oliver Upton (17):
>   KVM: arm64: Directly read owner id field in stage2_pte_is_counted()
>   KVM: arm64: Only read the pte once per visit
>   KVM: arm64: Return the next table from map callbacks
>   KVM: arm64: Protect page table traversal with RCU
>   KVM: arm64: Take an argument to indicate parallel walk
>   KVM: arm64: Implement break-before-make sequence for parallel walks
>   KVM: arm64: Enlighten perm relax path about parallel walks
>   KVM: arm64: Spin off helper for initializing table pte
>   KVM: arm64: Tear down unlinked page tables in parallel walk
>   KVM: arm64: Assume a table pte is already owned in post-order
>     traversal
>   KVM: arm64: Move MMU cache init/destroy into helpers
>   KVM: arm64: Stuff mmu page cache in sub struct
>   KVM: arm64: Setup cache for stage2 page headers
>   KVM: arm64: Punt last page reference to rcu callback for parallel walk
>   KVM: arm64: Allow parallel calls to kvm_pgtable_stage2_map()
>   KVM: arm64: Enable parallel stage 2 MMU faults
>   TESTONLY: KVM: arm64: Add super lazy accounting of stage 2 table pages
>
>  arch/arm64/include/asm/kvm_host.h     |   5 +-
>  arch/arm64/include/asm/kvm_mmu.h      |   2 +
>  arch/arm64/include/asm/kvm_pgtable.h  |  14 +-
>  arch/arm64/kvm/arm.c                  |   4 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c |  13 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c       |  13 +-
>  arch/arm64/kvm/hyp/pgtable.c          | 518 +++++++++++++++++++-------
>  arch/arm64/kvm/mmu.c                  | 120 ++++--
>  8 files changed, 503 insertions(+), 186 deletions(-)
>
> --
> 2.36.0.rc0.470.gd361397f0d-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
