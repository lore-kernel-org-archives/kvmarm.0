Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF2AC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Apr 2022 19:48:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DCAF49F44;
	Thu, 14 Apr 2022 15:48:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EaPeNWFNBSqT; Thu, 14 Apr 2022 15:48:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CFB34B12C;
	Thu, 14 Apr 2022 15:48:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B5C340B78
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2022 12:51:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lMvj39IjnFAd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2022 12:51:03 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B3FD240B75
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2022 12:51:03 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id bq30so10155504lfb.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2022 09:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qvrUkzVKHcvjwS/dOYL2eAUFrCbo/ujl12UK6CglK68=;
 b=EIgRm51/IetvOo/3Yh3Gl6urcyZJ4z+1xaapljbLxnYp5lt3nSX5xOMs3YZubfLEcG
 qTqt560DVWAauBFHM0umldjq3mssFpTAQHvNUMujLASMc33xty+vXv9n59mX8ypWnR4e
 sqFEb6Yf1HjVrH36IqNy2C+RAeJrqmluUxzTaL46YfKtolRjMbUzhjsaqmCN87qH029g
 NT/eMmFuDtqB7yTkoWcCMpObiYtIBIVXM08BKFseEz9NnebwK0k5TjyqrqYjUpuzlolj
 4/FqwU2sWbRLnvUoi/r+4D1PmIWWY8qOzTCbaC/md3zdu+LEFNU7f7VbrAjMOOzhHRUn
 hAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qvrUkzVKHcvjwS/dOYL2eAUFrCbo/ujl12UK6CglK68=;
 b=wamD1D+qmvh9XXGaG6h/bCptOWtBzwaPiqIaaF7vfR8nVHxrDXmzkRKy9idveVbsNE
 bS3dlpIvl7EvbYUngM0OdcG3CbH4byrFzkBTXjDuBhBnvxUG/9zrPSg0L26OTI/1wwSK
 bwdJz0EC8VqiW5tnBIX7U4g43DE1onFPILIih6FLUAz8PkOp19H/9X4vsybVRQlsAnqw
 JoNdu3GXlXPzaGq5BGg6S950dJ1WEFs/QSI+yAYKr6mDc+3mbtrzBRrKxuJGhDyK0vnm
 +TJd+gv1NPuixz50+jn1PKU+SCvkYLaqAsLpnX0YYSGz5DZItiKQ8YmHXZunnaBgfb+k
 mP3A==
X-Gm-Message-State: AOAM530Kg3kBbecivV8skKLNKEEwB2p7Z3B5jWXfrEVQ82+FAQEUaV2O
 /UeTc9GLPXbfsUBcNkKwPPK311spsbqFAPhTVuSNXA==
X-Google-Smtp-Source: ABdhPJwTYmrgq+YiC1OHoIWKUV9qQJWQp/M3+brdX7k3OLjuX1IbMdBoJSptsooaePR2Njmi9uEyoVmsmBC+6Hmzymw=
X-Received: by 2002:a05:6512:1285:b0:46b:a899:1111 with SMTP id
 u5-20020a056512128500b0046ba8991111mr2524770lfs.190.1649955062178; Thu, 14
 Apr 2022 09:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
 <20220401175554.1931568-23-dmatlack@google.com>
 <YlDV27ediz+rBuLd@google.com>
In-Reply-To: <YlDV27ediz+rBuLd@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 14 Apr 2022 09:50:35 -0700
Message-ID: <CALzav=f7wtHtTi6z64Br8P_aKiNqHivMi7zwQDxFfqiPGXpBeA@mail.gmail.com>
Subject: Re: [PATCH v3 22/23] KVM: x86/mmu: Support Eager Page Splitting in
 the shadow MMU
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Thu, 14 Apr 2022 15:48:49 -0400
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

On Fri, Apr 8, 2022 at 5:40 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 01, 2022, David Matlack wrote:
> > Add support for Eager Page Splitting pages that are mapped by the shadow
> > MMU. Walk through the rmap first splitting all 1GiB pages to 2MiB pages,
> > and then splitting all 2MiB pages to 4KiB pages.
> >
> > Splitting huge pages mapped by the shadow MMU requries dealing with some
> > extra complexity beyond that of the TDP MMU:
> >
> > (1) The shadow MMU has a limit on the number of shadow pages that are
> >     allowed to be allocated. So, as a policy, Eager Page Splitting
> >     refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
> >     pages available.
> >
> > (2) Huge pages may be mapped by indirect shadow pages which have the
> >     possibility of being unsync. As a policy we opt not to split such
> >     pages as their translation may no longer be valid.
>
> This shouldn't be possible, shadow pages whose role is > 4k are always write-protected
> and not allowed to become unsync.

Ah ok, then the unsync check is unnecessary (or at least could WARN_ON()).

>
> >
> > (3) Splitting a huge page may end up re-using an existing lower level
> >     shadow page tables. This is unlike the TDP MMU which always allocates
> >     new shadow page tables when splitting.
>
> ...
>
> > +static void kvm_mmu_split_huge_page(struct kvm *kvm,
> > +                                 const struct kvm_memory_slot *slot,
> > +                                 u64 *huge_sptep, struct kvm_mmu_page **spp)
> > +
> > +{
> > +     struct kvm_mmu_memory_cache *cache = &kvm->arch.huge_page_split_desc_cache;
> > +     u64 huge_spte = READ_ONCE(*huge_sptep);
> > +     struct kvm_mmu_page *sp;
> > +     bool flush = false;
> > +     u64 *sptep, spte;
> > +     gfn_t gfn;
> > +     int index;
> > +
> > +     sp = kvm_mmu_get_sp_for_split(kvm, slot, huge_sptep, spp);
> > +
> > +     for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> > +             sptep = &sp->spt[index];
> > +             gfn = kvm_mmu_page_get_gfn(sp, index);
> > +
> > +             /*
> > +              * sp may have populated page table entries, e.g. if this huge
> > +              * page is aliased by multiple sptes with the same access
> > +              * permissions. We know the sptes will be mapping the same
> > +              * gfn-to-pfn translation since sp is direct. However, a given
> > +              * spte may point to an even lower level page table. We don't
> > +              * know if that lower level page table is completely filled in,
> > +              * i.e. we may be effectively unmapping a region of memory, so
> > +              * we must flush the TLB.
>
> Random side topic, please avoid "we" and other pronouns in comments and changelogs,
> it gets real easy to lose track of what a pronoun is referring to, especially in
> changelogs where "we" might be KVM, might be the kernel, might be the team that's
> using the patch, might be an author that's prone to illeism, etc...

Agreed. It's a bad habit of mine, and despite conscious effort to
limit use of "we" in my comments and change logs, it inevitably creeps
in. I'll do a pass on this series to get rid of the use of "we"
throughout.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
