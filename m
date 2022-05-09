Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15704C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7340E4B17B;
	Tue, 10 May 2022 02:04:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6fNSX6W+HHKD; Tue, 10 May 2022 02:04:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2928D4B1E0;
	Tue, 10 May 2022 02:04:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD1A74A014
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 16:53:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rFAbVPawg4oY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 16:53:48 -0400 (EDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DEDC49F4A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 16:53:48 -0400 (EDT)
Received: by mail-lf1-f41.google.com with SMTP id u23so20226361lfc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 13:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=juLv0tHpYyniXYJdhCO4IxrUzdGFAB7hgGLuXWxzzfQ=;
 b=sRZ7gFCnwGjke9Wy7MLVeZ5O0pOeCU9NprkShjZhbejgMypvTgHE4yc3vifvxCNILW
 kSIZJ/CoKbTAq+5dr8eFKZdVdVqRgUP3XWXoOUKk8XQb5nTv6W54BQcarUUUYhRKizgk
 iujC3c1SKkL5XlpepNx1f1AOO4+7qMzGYgwTIZbbi1ptSn1ndmsmXhHpMMm6s2ZfSFZt
 pyvC4L5K+czwRFO5op8YzGtjjgsEOAWeR0E5RddYpLcOWTKUCY9qQr3k+FTZxfIfuAj6
 WIByklV6HkfKOcUB6vX/KH6jQodXZaEnZQc4VvsVPJbH0jRYWbhBUGhaj43wbYvDlPJb
 4UaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=juLv0tHpYyniXYJdhCO4IxrUzdGFAB7hgGLuXWxzzfQ=;
 b=1tGIYpM0OhjkiPca9ZhPb3EgpMfJq9v2kXlxJS7zhY6d5y6OhlpgzcWUspd3xSaGXw
 zsjJISkQjaPw6EMSo66CFkBavueMwYxGIV5B+sm67npmM0+jpX4rAMxU4G0ztJQir6En
 sdBlgwf2I5iAcsEQbazA/M4FHVheEvuD/yr0ZOWQpTmxEcu+cpM+/7uZvC0Z2wkk2WMO
 Ktb1Qg7M6Bgaox++twSiH/op482+bZiUKcTvl/NmpK5l9PtnfC2xuleNQabErf89KRCs
 TMQZ8vQmaZpiGPD1tG3q+0CO/ITrHA7rgAEXbqkt1XHrUBJ+gyCWlMwwReS/YebvJW4g
 uYkA==
X-Gm-Message-State: AOAM530zT2Anz++wo5oECkYElqagvDUCiyXJ8NR0KFHbUSDWSzC4COZs
 UQXitWPNm1t7wV8s08QHcW3Wiy8VGMrIycjown170w==
X-Google-Smtp-Source: ABdhPJwFVmz6RcyS9btj/o1ZoybvFtU4h2ot2/ATLJyzYvOdSTHlqVpOgczeC9S/D+0ST2v4E6oNv/tLBiH0Fcx36+k=
X-Received: by 2002:a19:8c1a:0:b0:472:315:48db with SMTP id
 o26-20020a198c1a000000b00472031548dbmr13897928lfd.235.1652129626813; Mon, 09
 May 2022 13:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-6-dmatlack@google.com>
 <YnRLVB+t0bLBeu+/@google.com>
In-Reply-To: <YnRLVB+t0bLBeu+/@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 13:53:20 -0700
Message-ID: <CALzav=cRwx2qSvtt1r=4W1b81jTjVMA4rZBxbtrmCwd_91__yg@mail.gmail.com>
Subject: Re: [PATCH v4 05/20] KVM: x86/mmu: Consolidate shadow page allocation
 and initialization
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

On Thu, May 5, 2022 at 3:10 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Consolidate kvm_mmu_alloc_page() and kvm_mmu_alloc_shadow_page() under
> > the latter so that all shadow page allocation and initialization happens
> > in one place.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++----------------------
> >  1 file changed, 17 insertions(+), 22 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 5582badf4947..7d03320f6e08 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1703,27 +1703,6 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
> >       mmu_spte_clear_no_track(parent_pte);
> >  }
> >
> > -static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
> > -{
> > -     struct kvm_mmu_page *sp;
> > -
> > -     sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > -     sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > -     if (!direct)
> > -             sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> > -     set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > -
> > -     /*
> > -      * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> > -      * depends on valid pages being added to the head of the list.  See
> > -      * comments in kvm_zap_obsolete_pages().
> > -      */
> > -     sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> > -     list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> > -     kvm_mod_used_mmu_pages(vcpu->kvm, +1);
> > -     return sp;
> > -}
> > -
> >  static void mark_unsync(u64 *spte);
> >  static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
> >  {
> > @@ -2100,7 +2079,23 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
> >                                                     struct hlist_head *sp_list,
> >                                                     union kvm_mmu_page_role role)
> >  {
> > -     struct kvm_mmu_page *sp = kvm_mmu_alloc_page(vcpu, role.direct);
> > +     struct kvm_mmu_page *sp;
> > +
> > +     sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > +     sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > +     if (!role.direct)
> > +             sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> > +
> > +     set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > +
> > +     /*
> > +      * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> > +      * depends on valid pages being added to the head of the list.  See
> > +      * comments in kvm_zap_obsolete_pages().
> > +      */
> > +     sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> > +     list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> > +     kvm_mod_used_mmu_pages(vcpu->kvm, +1);
>
> To reduce churn later on, what about opportunistically grabbing vcpu->kvm in a
> local variable in this patch?
>
> Actually, at that point, it's a super trivial change, so you can probably just drop
>
>         KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()
>
> and do the vcpu/kvm swap as part of
>
>         KVM: x86/mmu: Pass memory caches to allocate SPs separately

I'm not sure it's any less churn, it's just doing the same amount of
changes in fewer commits. Is there a benefit of using less commits? I
can only think of downsides (harder to review, harder to bisect).

>
> >       sp->gfn = gfn;
> >       sp->role = role;
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
