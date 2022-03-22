Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337F9C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC45F49EAA;
	Wed, 23 Mar 2022 05:57:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JFppd2CGdXKt; Wed, 23 Mar 2022 05:57:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DA784B089;
	Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8443049EAA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:09:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fmNiFgVC2BO2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 18:09:29 -0400 (EDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com
 [209.85.208.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D53049E1E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 18:09:28 -0400 (EDT)
Received: by mail-lj1-f173.google.com with SMTP id u3so25938593ljd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 15:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=YulFfxGuY3s5pZU2mZSRJ47ZNRwCdbPLLqIFBwNkP1w=;
 b=qZGito7rUgupqtfaAd4svmkZQfQWv/+FGxP7lfQo/9FKefYWqfZxVgM2UbTS2hzF/6
 Am/pdfCVWJZf0OUQgl29Mkd5wxd6RmGNbIJ+i4quxJGdXX3JM8hmrE74m8u/+DA9k+lx
 SOhfUBm0cUGCH73x0694q54PQATIgIG9REuIvlLhqTyMHAM0+fdLfHEFIw7gkrUJ90AU
 dQmTminPU88Y4AOtXY1+eLSCeHglaIgmLWMjDv9Pqgq/S3b/+UGHHV30UTdBbZISjo4E
 ubS0u1BpEQMxGkjc/OrpQPrLQHf73eswGXVmiJi9QoJnWiMR6reLnm7xvxkTqgvLszBF
 Z4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=YulFfxGuY3s5pZU2mZSRJ47ZNRwCdbPLLqIFBwNkP1w=;
 b=NSloN4vwwtWDoAQskdk3zGmODwLmhM4k8cTDqPaUncm21/fJ7WaZQM/cBa3pM/qh8X
 AopkwTkLuD/vVHm1Nczzl2uoEFMsCxuxi37Tcxy0m0jbUk6NwXKyF9zqD+Lh8mkTUmxz
 bXQSpW0iFNNNWUo0GC4l1DAWfozlAWHpRhqGlFugHlV+DleRWr019DBRHN6R99J3DVl3
 2KGtG5Bn8WpBADVF9BwvCsSCXu52Tix+/AXq6N6v7moF3fzHEq3B29MHOw0UyDD52ch1
 +22RUThnh2hV9svzSfz7Q1fM+zTAvbwpVDRWNMzlAudJeheP/JBEXBZQ+jyFratCKFs/
 q+5w==
X-Gm-Message-State: AOAM532zyDvsQmsvdAbocELW2tGvlFZiGDOeJyo7HFHqHXgl+xiyZSD2
 n0VbPa/BykCmik9qpPpAgXxBh7bDcK8jfqSVVaPdSQ==
X-Google-Smtp-Source: ABdhPJyo+PHJdKkv1Rsy+fLHM3hSBk/m9RSBycD2dahs0AuT8nMD+Oec514GvjsYeS1kaZZN/zRX88tmNvGh5X45Yv4=
X-Received: by 2002:a2e:9119:0:b0:247:e306:1379 with SMTP id
 m25-20020a2e9119000000b00247e3061379mr20328662ljg.361.1647986967344; Tue, 22
 Mar 2022 15:09:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-5-dmatlack@google.com>
 <YjBTal9gWoEKybxi@xz-m1.local>
In-Reply-To: <YjBTal9gWoEKybxi@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 15:09:00 -0700
Message-ID: <CALzav=ewmDSc+wviY17Fz_nD4TfRd=+h0h5-zPVgqhbxmuVq2Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/26] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
To: Peter Xu <peterx@redhat.com>
X-Mailman-Approved-At: Wed, 23 Mar 2022 05:57:13 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Tue, Mar 15, 2022 at 1:51 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:06AM +0000, David Matlack wrote:
> > Decompose kvm_mmu_get_page() into separate helper functions to increase
> > readability and prepare for allocating shadow pages without a vcpu
> > pointer.
> >
> > Specifically, pull the guts of kvm_mmu_get_page() into 3 helper
> > functions:
> >
> > __kvm_mmu_find_shadow_page() -
> >   Walks the page hash checking for any existing mmu pages that match the
> >   given gfn and role. Does not attempt to synchronize the page if it is
> >   unsync.
> >
> > kvm_mmu_find_shadow_page() -
> >   Wraps __kvm_mmu_find_shadow_page() and handles syncing if necessary.
> >
> > kvm_mmu_new_shadow_page()
> >   Allocates and initializes an entirely new kvm_mmu_page. This currently
> >   requries a vcpu pointer for allocation and looking up the memslot but
> >   that will be removed in a future commit.
> >
> >   Note, kvm_mmu_new_shadow_page() is temporary and will be removed in a
> >   subsequent commit. The name uses "new" rather than the more typical
> >   "alloc" to avoid clashing with the existing kvm_mmu_alloc_page().
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Looks good to me, a few nitpicks and questions below.
>
> > ---
> >  arch/x86/kvm/mmu/mmu.c         | 132 ++++++++++++++++++++++++---------
> >  arch/x86/kvm/mmu/paging_tmpl.h |   5 +-
> >  arch/x86/kvm/mmu/spte.c        |   5 +-
> >  3 files changed, 101 insertions(+), 41 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 23c2004c6435..80dbfe07c87b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2027,16 +2027,25 @@ static void clear_sp_write_flooding_count(u64 *spte)
> >       __clear_sp_write_flooding_count(sptep_to_sp(spte));
> >  }
> >
> > -static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > -                                          union kvm_mmu_page_role role)
> > +/*
> > + * Searches for an existing SP for the given gfn and role. Makes no attempt to
> > + * sync the SP if it is marked unsync.
> > + *
> > + * If creating an upper-level page table, zaps unsynced pages for the same
> > + * gfn and adds them to the invalid_list. It's the callers responsibility
> > + * to call kvm_mmu_commit_zap_page() on invalid_list.
> > + */
> > +static struct kvm_mmu_page *__kvm_mmu_find_shadow_page(struct kvm *kvm,
> > +                                                    gfn_t gfn,
> > +                                                    union kvm_mmu_page_role role,
> > +                                                    struct list_head *invalid_list)
> >  {
> >       struct hlist_head *sp_list;
> >       struct kvm_mmu_page *sp;
> >       int collisions = 0;
> > -     LIST_HEAD(invalid_list);
> >
> > -     sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> > -     for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> > +     sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> > +     for_each_valid_sp(kvm, sp, sp_list) {
> >               if (sp->gfn != gfn) {
> >                       collisions++;
> >                       continue;
> > @@ -2053,60 +2062,109 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> >                        * upper-level page will be write-protected.
> >                        */
> >                       if (role.level > PG_LEVEL_4K && sp->unsync)
> > -                             kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
> > -                                                      &invalid_list);
> > +                             kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
> > +
> >                       continue;
> >               }
> >
> > -             /* unsync and write-flooding only apply to indirect SPs. */
> > -             if (sp->role.direct)
> > -                     goto trace_get_page;
> > +             /* Write-flooding is only tracked for indirect SPs. */
> > +             if (!sp->role.direct)
> > +                     __clear_sp_write_flooding_count(sp);
> >
> > -             if (sp->unsync) {
> > -                     /*
> > -                      * The page is good, but is stale.  kvm_sync_page does
> > -                      * get the latest guest state, but (unlike mmu_unsync_children)
> > -                      * it doesn't write-protect the page or mark it synchronized!
> > -                      * This way the validity of the mapping is ensured, but the
> > -                      * overhead of write protection is not incurred until the
> > -                      * guest invalidates the TLB mapping.  This allows multiple
> > -                      * SPs for a single gfn to be unsync.
> > -                      *
> > -                      * If the sync fails, the page is zapped.  If so, break
> > -                      * in order to rebuild it.
> > -                      */
> > -                     if (!kvm_sync_page(vcpu, sp, &invalid_list))
> > -                             break;
> > +             goto out;
> > +     }
> >
> > -                     WARN_ON(!list_empty(&invalid_list));
> > -                     kvm_flush_remote_tlbs(vcpu->kvm);
> > -             }
> > +     sp = NULL;
> >
> > -             __clear_sp_write_flooding_count(sp);
> > +out:
> > +     if (collisions > kvm->stat.max_mmu_page_hash_collisions)
> > +             kvm->stat.max_mmu_page_hash_collisions = collisions;
> > +
> > +     return sp;
> > +}
> >
> > -trace_get_page:
> > -             trace_kvm_mmu_get_page(sp, false);
> > +/*
> > + * Looks up an existing SP for the given gfn and role if one exists. The
> > + * return SP is guaranteed to be synced.
> > + */
> > +static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm_vcpu *vcpu,
> > +                                                  gfn_t gfn,
> > +                                                  union kvm_mmu_page_role role)
> > +{
> > +     struct kvm_mmu_page *sp;
> > +     LIST_HEAD(invalid_list);
> > +
> > +     sp = __kvm_mmu_find_shadow_page(vcpu->kvm, gfn, role, &invalid_list);
> > +     if (!sp)
> >               goto out;
> > +
> > +     if (sp->unsync) {
> > +             /*
> > +              * The page is good, but is stale.  kvm_sync_page does
> > +              * get the latest guest state, but (unlike mmu_unsync_children)
> > +              * it doesn't write-protect the page or mark it synchronized!
> > +              * This way the validity of the mapping is ensured, but the
> > +              * overhead of write protection is not incurred until the
> > +              * guest invalidates the TLB mapping.  This allows multiple
> > +              * SPs for a single gfn to be unsync.
> > +              *
> > +              * If the sync fails, the page is zapped and added to the
> > +              * invalid_list.
> > +              */
> > +             if (!kvm_sync_page(vcpu, sp, &invalid_list)) {
> > +                     sp = NULL;
> > +                     goto out;
> > +             }
> > +
> > +             WARN_ON(!list_empty(&invalid_list));
>
> Not related to this patch because I think it's a pure movement here,
> however I have a question on why invalid_list is guaranteed to be empty..
>
> I'm thinking the case where when lookup the page we could have already
> called kvm_mmu_prepare_zap_page() there, then when reach here (which is the
> kvm_sync_page==true case) invalid_list shouldn't be touched in
> kvm_sync_page(), so it looks possible that it still contains some page to
> be commited?

I also had this question when I was re-organizing this code but
haven't had the time to look into it yet.

>
> > +             kvm_flush_remote_tlbs(vcpu->kvm);
> >       }
> >
> > +out:
>
> I'm wondering whether this "out" can be dropped.. with something like:
>
>         sp = __kvm_mmu_find_shadow_page(...);
>
>         if (sp && sp->unsync) {
>                 if (kvm_sync_page(vcpu, sp, &invalid_list)) {
>                         ..
>                 } else {
>                         sp = NULL;
>                 }
>         }

Sure will do. I used the goto to reduce the amount of indentation, but
I can definitely get rid of it.

>
> [...]
>
> > +static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > +                                          union kvm_mmu_page_role role)
> > +{
> > +     struct kvm_mmu_page *sp;
> > +     bool created = false;
> > +
> > +     sp = kvm_mmu_find_shadow_page(vcpu, gfn, role);
> > +     if (sp)
> > +             goto out;
> > +
> > +     created = true;
> > +     sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
> > +
> > +out:
> > +     trace_kvm_mmu_get_page(sp, created);
> >       return sp;
>
> Same here, wondering whether we could drop the "out" by:
>
>         sp = kvm_mmu_find_shadow_page(vcpu, gfn, role);
>         if (!sp) {
>                 created = true;
>                 sp = kvm_mmu_new_shadow_page(vcpu, gfn, role);
>         }
>
>         trace_kvm_mmu_get_page(sp, created);
>         return sp;

Ditto.

>
> Thanks,
>
> --
> Peter Xu
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
