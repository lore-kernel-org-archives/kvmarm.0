Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA237C43219
	for <kvmarm@archiver.kernel.org>; Tue, 26 Apr 2022 21:19:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E96340C95;
	Tue, 26 Apr 2022 17:19:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K+9zw7j-DO8Q; Tue, 26 Apr 2022 17:19:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7B084B1F0;
	Tue, 26 Apr 2022 17:19:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFB584B1AB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 15:34:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MnJ6hep7q+Op for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2022 15:34:05 -0400 (EDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
 [209.85.128.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B222C4B192
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 15:34:05 -0400 (EDT)
Received: by mail-wm1-f43.google.com with SMTP id
 m22-20020a05600c3b1600b00393ed50777aso2208004wms.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2022 12:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=HdglKt24ulKLWyX0LsILT516ozly9pUWvxRymOVkqGI=;
 b=D9ihhOYCzfSq6PHe75gU3OheUI3W9iH7N3JyrClUp6au/zHYy/RjIQ+jFjvmiw3I9o
 uU7o/2RsJb0OvTjqDki2JlEYfTgugeTS76dPfA3259nEGmWh42vCXrHa6/5V7/2johUN
 +QaWhuSllkcd3/yIwhHQc0dL4v+1u2xt3a0+X1HNRFS3ddbQntWN7TwV79pXNZP4tjWY
 q9oDYLmA6GmRpsibkQ3SJm8PJsmjU0ySPtDfndPYlEEAFXG22uifNwS/0VoF2zqchWyZ
 YeBZmMfcWMAOzmPfGY/zoiJYCO20nTusS/8yz+ffjxEMcUZ2DMbLY7V/1myPVVFJC4B1
 X+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=HdglKt24ulKLWyX0LsILT516ozly9pUWvxRymOVkqGI=;
 b=QtvSyzWdrUMb5dKp4QN+t1xdCTUxZZaTHklXcO1hvsaLZRHScNlkx87PvYRexoC/vd
 7XHfO1MWpUpUOi7OBqEFmeKdydhWta/SrEFqTpHNiNOui8voSlILXhhcrrvG1ryFprom
 VU49jV0wZTr8m1iCca2SU0k2iqdL+34KIEF8+uL2aeLAoGZaPze3CUuCOGDdqKYutOkF
 1gYjURxkuqX16zjpTgu5hX1bG6I8AlIypDLoLT5ISaETM5cn8+r1qnjwkCk+lpWnuTrp
 vGNwxHZKhaix9v7sgbpfs2u4qJ0YKhTdJNRVkbysaYBaZorvJHB59dWk8afkiiuvpfP9
 axyg==
X-Gm-Message-State: AOAM532za1IcDAF2ncqkqeAdqftXNnxDGny6Ucod518+aVgd2jrw1Gbg
 eDySPdBm87PzJQtconDoj8S1SM15SmkP3wHTrSuw8w==
X-Google-Smtp-Source: ABdhPJxfcXYYWDf1qEw77YopXVh9hGlDN3ohweZv6hh7qehoXVg7JxTIKYy8mWq0Lcp0jdkpbGhhqEQXGML1k1dn1J0=
X-Received: by 2002:a05:600c:4e46:b0:393:f5fb:b3df with SMTP id
 e6-20020a05600c4e4600b00393f5fbb3dfmr4865915wmq.80.1651001644438; Tue, 26 Apr
 2022 12:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220426053904.3684293-1-yosryahmed@google.com>
 <20220426053904.3684293-5-yosryahmed@google.com>
 <874k2falbk.wl-maz@kernel.org>
In-Reply-To: <874k2falbk.wl-maz@kernel.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 26 Apr 2022 12:33:28 -0700
Message-ID: <CAJD7tkZ-mrhCXoR0ZONjJ7kuAuzWED8Dcjkw6mv812-3uSo_Cg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64/mmu: count KVM page table pages in
 pagetable stats
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Tue, 26 Apr 2022 17:19:39 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Linux-MM <linux-mm@kvack.org>, kvmarm@lists.cs.columbia.edu,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Shakeel Butt <shakeelb@google.com>, Atish Patra <atishp@atishpatra.org>,
 cgroups@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-mips@vger.kernel.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kvm-riscv@lists.infradead.org, Johannes Weiner <hannes@cmpxchg.org>,
 linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
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

Thanks a lot for taking the time to look at this!

On Tue, Apr 26, 2022 at 8:58 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 26 Apr 2022 06:39:02 +0100,
> Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > Count the pages used by KVM in arm64 for page tables in pagetable stats.
> >
> > Account pages allocated for PTEs in pgtable init functions and
> > kvm_set_table_pte().
> >
> > Since most page table pages are freed using put_page(), add a helper
> > function put_pte_page() that checks if this is the last ref for a pte
> > page before putting it, and unaccounts stats accordingly.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  arch/arm64/kernel/image-vars.h |  3 ++
> >  arch/arm64/kvm/hyp/pgtable.c   | 50 +++++++++++++++++++++-------------
> >  2 files changed, 34 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> > index 241c86b67d01..25bf058714f6 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -143,6 +143,9 @@ KVM_NVHE_ALIAS(__hyp_rodata_end);
> >  /* pKVM static key */
> >  KVM_NVHE_ALIAS(kvm_protected_mode_initialized);
> >
> > +/* Called by kvm_account_pgtable_pages() to update pagetable stats */
> > +KVM_NVHE_ALIAS(__mod_lruvec_page_state);
>
> This cannot be right. It means that this function will be called
> directly from the EL2 code when in protected mode, and will result in
> extreme fireworks.  There is no way you can call core kernel stuff
> like this from this context.
>
> Please do not add random symbols to this list just for the sake of
> being able to link the kernel.

Excuse my ignorance, this is my first time touching kvm code. Thanks a
lot for pointing this out.

>
> > +
> >  #endif /* CONFIG_KVM */
> >
> >  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 2cb3867eb7c2..53e13c3313e9 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -152,6 +152,7 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
> >
> >       WARN_ON(kvm_pte_valid(old));
> >       smp_store_release(ptep, pte);
> > +     kvm_account_pgtable_pages((void *)childp, +1);
>
> Why the + sign?

I am following conventions in other existing stat accounting hooks
(e.g. kvm_mod_used_mmu_pages(vcpu->kvm, +1) call in
arch/x86/kvm/mmu/mmu.c), but I can certainly remove it if you think
this is better.

>
> >  }
> >
> >  static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
> > @@ -326,6 +327,14 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
> >       return ret;
> >  }
> >
> > +static void put_pte_page(kvm_pte_t *ptep, struct kvm_pgtable_mm_ops *mm_ops)
> > +{
> > +     /* If this is the last page ref, decrement pagetable stats first. */
> > +     if (!mm_ops->page_count || mm_ops->page_count(ptep) == 1)
> > +             kvm_account_pgtable_pages((void *)ptep, -1);
> > +     mm_ops->put_page(ptep);
> > +}
> > +
> >  struct hyp_map_data {
> >       u64                             phys;
> >       kvm_pte_t                       attr;
> > @@ -488,10 +497,10 @@ static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >
> >       dsb(ish);
> >       isb();
> > -     mm_ops->put_page(ptep);
> > +     put_pte_page(ptep, mm_ops);
> >
> >       if (childp)
> > -             mm_ops->put_page(childp);
> > +             put_pte_page(childp, mm_ops);
> >
> >       return 0;
> >  }
> > @@ -522,6 +531,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
> >       pgt->pgd = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
> >       if (!pgt->pgd)
> >               return -ENOMEM;
> > +     kvm_account_pgtable_pages((void *)pgt->pgd, +1);
> >
> >       pgt->ia_bits            = va_bits;
> >       pgt->start_level        = KVM_PGTABLE_MAX_LEVELS - levels;
> > @@ -541,10 +551,10 @@ static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> >       if (!kvm_pte_valid(pte))
> >               return 0;
> >
> > -     mm_ops->put_page(ptep);
> > +     put_pte_page(ptep, mm_ops);
> >
> >       if (kvm_pte_table(pte, level))
> > -             mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
> > +             put_pte_page(kvm_pte_follow(pte, mm_ops), mm_ops);
>
> OK, I see the pattern. I don't think this workable as such. I'd rather
> the callbacks themselves (put_page, zalloc_page*) call into the
> accounting code when it makes sense, rather than spreading the
> complexity and having to special case the protected case.
>

This makes sense. I am working on moving calls to
kvm_account_pgtable_pages to callbacks in mmu.c in the next version
(stage2_memcache_zalloc_page, kvm_host_put_page, etc).


> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
