Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFEB9C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81A2D40D01;
	Tue, 10 May 2022 02:04:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UnTHy-D301Kn; Tue, 10 May 2022 02:04:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34A7D4B2E0;
	Tue, 10 May 2022 02:04:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E618949F3E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:41:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dv299ZudvNTx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 17:41:22 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9735F49F3D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:41:22 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id d19so4483246lfj.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 14:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=O+5gvsFijOHeW3i755kklmCaNCPDrPNduHFLHJgoMI8=;
 b=bhNOFb/ujRVSbL/+KIKaKwcxZJXu5sdlVTvgox92xqawxOdyXcuhwJ/ZfiLwgx0zkB
 rWp2VUnHPTmRizZI0H5Zx//ET/GzJK7XbUChcnwYBowjffWiC66TqPhPeOAjx7U/8lEU
 6NjYacJEaLjLPNkd2nVuOzLxWGGzY0sfDNKLmTJFa/dkyzQ0VdeW/v6NwV2HTyXKeD2Z
 zoCOYbSPtT35iepPAdvX6k70g92evKNYXsqMRfnqzEfDBZrs1VoWHAabc+4tUzoGJJYG
 lem7Rxz5VSNBh0lcN1vobTMCOFZEi6iPdhDFYXf6567DJdjmYKSqGjoQL6J0+3OiPKFj
 sNhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=O+5gvsFijOHeW3i755kklmCaNCPDrPNduHFLHJgoMI8=;
 b=V02NkeFmumk9GIkIEne2Ge2yqX8pj1z5AXI7zWNgfKcLYNWhuR/FG8JpUkMQl4a3YD
 zQRqbIJy9UpdjRHRLJwwTMGClxG86bEIAIOzDUma+ux1CfYHLh56jjQwRmyI8UW7u5vc
 5MwdlXqFzP3Vwkv0dwS2+U08N8Ewq88Y1glxTgEzWbBSMvQzgS+cmUsVVuaYpFI2W8CS
 hBbIQuWqFF5CGcG20HaXYJFStgJVOGg1hZhBhDtvmXqAnGhG2Q0F+pYA0BLQDjYfZf0w
 /n1SqmT1xI9tO1Q2aEEdZoozUcIuyGxekAwgfatwfO0w2ZbA0Yx59BDdBBxaAHXWIu9r
 23EA==
X-Gm-Message-State: AOAM532Sbi5YkPhnFC9UIOanjFxEra89ewoiIiSzo648lfpKDY3xNCVw
 GLf4gIPeOk7f39diwFVnso0dt3T+5VT6JV9kbMYR4Q==
X-Google-Smtp-Source: ABdhPJynfBI2TATP0BS9cf2tDgm1Odlr/6us6YsCv+zgfrkGbMVsGuj1TtNZCdoktolPs7BHsN/YjWoS8WV1kehKsww=
X-Received: by 2002:a05:6512:398d:b0:473:a597:540a with SMTP id
 j13-20020a056512398d00b00473a597540amr14456367lfu.64.1652132481002; Mon, 09
 May 2022 14:41:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-21-dmatlack@google.com>
 <de48ed40-4e6e-c49d-426e-91aba4ce1337@gmail.com>
In-Reply-To: <de48ed40-4e6e-c49d-426e-91aba4ce1337@gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 14:40:54 -0700
Message-ID: <CALzav=dTmLLO1tLDuZyx6EPF3RbRi=BtpKiT0piU6xjW6f_LSw@mail.gmail.com>
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
To: Lai Jiangshan <jiangshanlai@gmail.com>
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

On Sat, May 7, 2022 at 12:51 AM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
>
> On 2022/4/23 05:05, David Matlack wrote:
> > Add support for Eager Page Splitting pages that are mapped by nested
> > MMUs. Walk through the rmap first splitting all 1GiB pages to 2MiB
> > pages, and then splitting all 2MiB pages to 4KiB pages.
> >
> > Note, Eager Page Splitting is limited to nested MMUs as a policy rather
> > than due to any technical reason (the sp->role.guest_mode check could
> > just be deleted and Eager Page Splitting would work correctly for all
> > shadow MMU pages). There is really no reason to support Eager Page
> > Splitting for tdp_mmu=N, since such support will eventually be phased
> > out, and there is no current use case supporting Eager Page Splitting on
> > hosts where TDP is either disabled or unavailable in hardware.
> > Furthermore, future improvements to nested MMU scalability may diverge
> > the code from the legacy shadow paging implementation. These
> > improvements will be simpler to make if Eager Page Splitting does not
> > have to worry about legacy shadow paging.
> >
> > Splitting huge pages mapped by nested MMUs requires dealing with some
> > extra complexity beyond that of the TDP MMU:
> >
> > (1) The shadow MMU has a limit on the number of shadow pages that are
> >      allowed to be allocated. So, as a policy, Eager Page Splitting
> >      refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
> >      pages available.
> >
> > (2) Splitting a huge page may end up re-using an existing lower level
> >      shadow page tables. This is unlike the TDP MMU which always allocates
> >      new shadow page tables when splitting.
> >
> > (3) When installing the lower level SPTEs, they must be added to the
> >      rmap which may require allocating additional pte_list_desc structs.
> >
> > Case (2) is especially interesting since it may require a TLB flush,
> > unlike the TDP MMU which can fully split huge pages without any TLB
> > flushes. Specifically, an existing lower level page table may point to
> > even lower level page tables that are not fully populated, effectively
> > unmapping a portion of the huge page, which requires a flush.
> >
> > This commit performs such flushes after dropping the huge page and
> > before installing the lower level page table. This TLB flush could
> > instead be delayed until the MMU lock is about to be dropped, which
> > would batch flushes for multiple splits.  However these flushes should
> > be rare in practice (a huge page must be aliased in multiple SPTEs and
> > have been split for NX Huge Pages in only some of them). Flushing
> > immediately is simpler to plumb and also reduces the chances of tripping
> > over a CPU bug (e.g. see iTLB multihit).
> >
> > Suggested-by: Peter Feiner <pfeiner@google.com>
> > [ This commit is based off of the original implementation of Eager Page
> >    Splitting from Peter in Google's kernel from 2016. ]
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >   .../admin-guide/kernel-parameters.txt         |   3 +-
> >   arch/x86/include/asm/kvm_host.h               |  20 ++
> >   arch/x86/kvm/mmu/mmu.c                        | 276 +++++++++++++++++-
> >   arch/x86/kvm/x86.c                            |   6 +
> >   4 files changed, 296 insertions(+), 9 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 3f1cc5e317ed..bc3ad3d4df0b 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2387,8 +2387,7 @@
> >                       the KVM_CLEAR_DIRTY ioctl, and only for the pages being
> >                       cleared.
> >
> > -                     Eager page splitting currently only supports splitting
> > -                     huge pages mapped by the TDP MMU.
> > +                     Eager page splitting is only supported when kvm.tdp_mmu=Y.
> >
> >                       Default is Y (on).
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 15131aa05701..5df4dff385a1 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1240,6 +1240,24 @@ struct kvm_arch {
> >       hpa_t   hv_root_tdp;
> >       spinlock_t hv_root_tdp_lock;
> >   #endif
> > +
> > +     /*
> > +      * Memory caches used to allocate shadow pages when performing eager
> > +      * page splitting. No need for a shadowed_info_cache since eager page
> > +      * splitting only allocates direct shadow pages.
> > +      */
> > +     struct kvm_mmu_memory_cache split_shadow_page_cache;
> > +     struct kvm_mmu_memory_cache split_page_header_cache;
> > +
> > +     /*
> > +      * Memory cache used to allocate pte_list_desc structs while splitting
> > +      * huge pages. In the worst case, to split one huge page, 512
> > +      * pte_list_desc structs are needed to add each lower level leaf sptep
> > +      * to the rmap plus 1 to extend the parent_ptes rmap of the lower level
> > +      * page table.
> > +      */
> > +#define SPLIT_DESC_CACHE_CAPACITY 513
> > +     struct kvm_mmu_memory_cache split_desc_cache;
> >   };
> >
> >
>
>
> I think it needs to document that the topup operations for these caches are
>
> protected by kvm->slots_lock.

Will do. Thanks!
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
