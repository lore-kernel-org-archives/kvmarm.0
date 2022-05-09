Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B81C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AE614B137;
	Tue, 10 May 2022 02:04:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0fw0Ojg3Augt; Tue, 10 May 2022 02:04:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 58A354B1F7;
	Tue, 10 May 2022 02:04:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 147B849F46
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:44:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uc591DBgC7zG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 17:44:48 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 740F643C96
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:44:48 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id t25so26080572lfg.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 14:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9xP9hLvPwnUH8e9dgAvhQrikoxQHFodB+z+wqUWV91k=;
 b=rS5oGooY0KklvJmBrLth8CCp/JghorHPD5I3RfSvIosSZ6sp55/tniDhAAT0E+7aVj
 g4vHRlFWlxdE48xcOdm1UGRx5vvHrjQA4yj4rNzUcJN05d+wRPZMxyPB9wbS/fksVtyL
 4pHst3TQ1NhkStcR0pxLZJnLRmxdxvumOQqRxZfZxkz7vHK4FxDkwSx2F+OcEUbhq2TK
 gOoFwoafn+Lw2NzKm4LnEkvwpLsU+8VRDHco1PUj98ET1R9k948SMnjxiMHhbTofnSyd
 AYNwtBJ321iTNxiCRZXhLnNDXQIJvuJjargWNdsqhm5B5B5ANl/Qpr9bpTDWLIIuUCD8
 1yrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9xP9hLvPwnUH8e9dgAvhQrikoxQHFodB+z+wqUWV91k=;
 b=qrKjwhSdQiIMa4vUxTBRLtTvxyOQf1nMkTgOXQBTsLmqoFnzN3K2GObSprw2N4Zl3L
 ZeSOAuQWCCnD4a53a4iLdiTfxuiJzqSBEiOKXxvMQhW9/rVHvB6HAZSEE4tCr9fu/DD5
 j+tU2QRhCMEemHqntJcnJOesphdWI/RW5w/UCUn28HVfW7bka0/XmnnQFmw4OqYeInI9
 zr60r3zFMFqa7hN2rGlFhfyGwtkbZnHPDMRe2L0iEfSKsLnOIz+oOWKEwumH7LavFVU8
 fro7m86eoVbVjxUaqoBbPDiXvfLyfMKvMFfLLJq3BYYmysUCQnnJCcu9VKtm+38g4Vg4
 FfzA==
X-Gm-Message-State: AOAM533tkl9ic0jfferKR3hTkFh144Q/GImuPpNAx5GslnJaESYKMT8m
 l2I7ytko/b2rir1quR4/VT0nAfUP1rfftd3/gUBASA==
X-Google-Smtp-Source: ABdhPJx3BtgeAqKYip4mEOFwVPQ8MYIyXpXFHYcWEc3DABXKaw2hfpEtfVb5UyzuC5+W/qADzrNyQ8ZO+QHAsNRqGl8=
X-Received: by 2002:ac2:4c54:0:b0:473:a414:1768 with SMTP id
 o20-20020ac24c54000000b00473a4141768mr14007574lfk.537.1652132686814; Mon, 09
 May 2022 14:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-21-dmatlack@google.com>
 <YnlFzMpJZNfFuFic@google.com>
In-Reply-To: <YnlFzMpJZNfFuFic@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 14:44:20 -0700
Message-ID: <CALzav=fTTf8=u1i0pePxAHtuHr4Q_+N1-d8x09MtRk+6y250rw@mail.gmail.com>
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Tue, 10 May 2022 02:04:42 -0400
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

On Mon, May 9, 2022 at 9:48 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > +static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> > +{
> > +     if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > +             return true;
> > +
> > +     /*
> > +      * In the worst case, SPLIT_DESC_CACHE_CAPACITY descriptors are needed
> > +      * to split a single huge page. Calculating how many are actually needed
> > +      * is possible but not worth the complexity.
> > +      */
> > +     return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_CAPACITY) ||
> > +             need_topup(&kvm->arch.split_page_header_cache, 1) ||
> > +             need_topup(&kvm->arch.split_shadow_page_cache, 1);
>
> Uber nit that Paolo will make fun of me for... please align indentiation
>
>         return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_CAPACITY) ||
>                need_topup(&kvm->arch.split_page_header_cache, 1) ||
>                need_topup(&kvm->arch.split_shadow_page_cache, 1);

Will do.

>
> > +static void nested_mmu_split_huge_page(struct kvm *kvm,
> > +                                    const struct kvm_memory_slot *slot,
> > +                                    u64 *huge_sptep)
> > +
> > +{
> > +     struct kvm_mmu_memory_cache *cache = &kvm->arch.split_desc_cache;
> > +     u64 huge_spte = READ_ONCE(*huge_sptep);
> > +     struct kvm_mmu_page *sp;
> > +     bool flush = false;
> > +     u64 *sptep, spte;
> > +     gfn_t gfn;
> > +     int index;
> > +
> > +     sp = nested_mmu_get_sp_for_split(kvm, huge_sptep);
> > +
> > +     for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> > +             sptep = &sp->spt[index];
> > +             gfn = kvm_mmu_page_get_gfn(sp, index);
> > +
> > +             /*
> > +              * The SP may already have populated SPTEs, e.g. if this huge
> > +              * page is aliased by multiple sptes with the same access
> > +              * permissions. These entries are guaranteed to map the same
> > +              * gfn-to-pfn translation since the SP is direct, so no need to
> > +              * modify them.
> > +              *
> > +              * However, if a given SPTE points to a lower level page table,
> > +              * that lower level page table may only be partially populated.
> > +              * Installing such SPTEs would effectively unmap a potion of the
> > +              * huge page, which requires a TLB flush.
>
> Maybe explain why a TLB flush is required?  E.g. "which requires a TLB flush as
> a subsequent mmu_notifier event on the unmapped region would fail to detect the
> need to flush".

Will do.

>
> > +static bool nested_mmu_skip_split_huge_page(u64 *huge_sptep)
>
> "skip" is kinda odd terminology.  It reads like a command, but it's actually
> querying state _and_ it's returning a boolean, which I've learned to hate :-)
>
> I don't see any reason for a helper, there's one caller and it can just do
> "continue" directly.

Will do.

>
> > +static void kvm_nested_mmu_try_split_huge_pages(struct kvm *kvm,
> > +                                             const struct kvm_memory_slot *slot,
> > +                                             gfn_t start, gfn_t end,
> > +                                             int target_level)
> > +{
> > +     int level;
> > +
> > +     /*
> > +      * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
> > +      * down to the target level. This ensures pages are recursively split
> > +      * all the way to the target level. There's no need to split pages
> > +      * already at the target level.
> > +      */
> > +     for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
>
> Unnecessary braces.

The brace is unnecessary, but when the inner statement is split across
multiple lines I tend to prefer using braces. (That's why I did the
same in the other patch and you had the same feedback.) I couldn't
find any guidance about this in CodingStyle so I'm fine with getting
rid of the braces if that's what you prefer.

> > +             slot_handle_level_range(kvm, slot,
> > +                                     nested_mmu_try_split_huge_pages,
> > +                                     level, level, start, end - 1,
> > +                                     true, false);
>
> IMO it's worth running over by 4 chars to drop 2 lines:

Will do.

>
>         for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--)
>                 slot_handle_level_range(kvm, slot, nested_mmu_try_split_huge_pages,
>                                         level, level, start, end - 1, true, false);
> > +     }
> > +}
> > +
> >  /* Must be called with the mmu_lock held in write-mode. */
>
> Add a lockdep assertion, not a comment.

Agreed but this is an existing comment, so better left to a separate patch.

>
> >  void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
> >                                  const struct kvm_memory_slot *memslot,
> >                                  u64 start, u64 end,
> >                                  int target_level)
> >  {
> > -     if (is_tdp_mmu_enabled(kvm))
> > -             kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
> > -                                              target_level, false);
> > +     if (!is_tdp_mmu_enabled(kvm))
> > +             return;
> > +
> > +     kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level,
> > +                                      false);
> > +
> > +     if (kvm_memslots_have_rmaps(kvm))
> > +             kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end,
> > +                                                 target_level);
> >
> >       /*
> >        * A TLB flush is unnecessary at this point for the same resons as in
> > @@ -6051,10 +6304,19 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
> >       u64 start = memslot->base_gfn;
> >       u64 end = start + memslot->npages;
> >
> > -     if (is_tdp_mmu_enabled(kvm)) {
> > -             read_lock(&kvm->mmu_lock);
> > -             kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
> > -             read_unlock(&kvm->mmu_lock);
> > +     if (!is_tdp_mmu_enabled(kvm))
> > +             return;
> > +
> > +     read_lock(&kvm->mmu_lock);
> > +     kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level,
> > +                                      true);
>
> Eh, let this poke out.

Will do :)

>
> > +     read_unlock(&kvm->mmu_lock);
> > +
> > +     if (kvm_memslots_have_rmaps(kvm)) {
> > +             write_lock(&kvm->mmu_lock);
> > +             kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end,
> > +                                                 target_level);
> > +             write_unlock(&kvm->mmu_lock);
>
> Super duper nit: all other flows do rmaps first, than TDP MMU.  Might as well keep
> that ordering here, otherwise it suggests there's a reason to be different.

Will do.
>
> >       }
> >
> >       /*
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ab336f7c82e4..e123e24a130f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12161,6 +12161,12 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
> >                * page faults will create the large-page sptes.
> >                */
> >               kvm_mmu_zap_collapsible_sptes(kvm, new);
> > +
> > +             /*
> > +              * Free any memory left behind by eager page splitting. Ignore
> > +              * the module parameter since userspace might have changed it.
> > +              */
> > +             free_split_caches(kvm);
> >       } else {
> >               /*
> >                * Initially-all-set does not require write protecting any page,
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
