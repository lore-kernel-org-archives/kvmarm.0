Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C663AC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7536149EBF;
	Tue, 10 May 2022 02:04:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Un6WsbkL2070; Tue, 10 May 2022 02:04:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EE7C4B2D6;
	Tue, 10 May 2022 02:04:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 412AB411BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:34:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id doT05BmPVzYN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 17:34:55 -0400 (EDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com
 [209.85.208.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E889E410F7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:34:54 -0400 (EDT)
Received: by mail-lj1-f170.google.com with SMTP id s27so18623152ljd.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 14:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=tN7G2C4PQ3ma2oS8lsGwUMG2S6za5ikyX+q1/ZuZ/h0=;
 b=dnqffuw15iCZYQIzqr3eUW9WYZhCBFPccgCfdSUSeIwz2z5j/6sw6y5DSFHpwgaKwR
 YMoh/zK/zitW9WLxNfK2L4WV4dwQDsMck1fc8KCK3oEizhgnMZv6ZfQVIMhWhk0m7IkT
 k3NtwOMSCP/xsHIdEOMpAzD689LVJPO3xJYOtptqQY/9cupIecGTV/gkE3ZTFu7/HfUp
 wdYSHtOc6FHyUgZgVpawMDXejPCoB7XORrJ+zwveCOWDaVlt9aVx/qlwX7GGn2O0Q+uY
 W3zuml4Es+Jh8Bya8FiLAv/9ZQ9kN3abL7CZjJF1bib6+bZukU9329H+ux2av3qqrrr8
 lurg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=tN7G2C4PQ3ma2oS8lsGwUMG2S6za5ikyX+q1/ZuZ/h0=;
 b=bf0FjH9pMqNheU9SRxKICkWo+gRp7+XbS2RTONC7Ybwx1peJ6qbMljuAkp1AE0/2+i
 krjsMo5U1ules0PEOZRoUSANtCYvZnbzqFbeDKSM2Hns8Z/xBK3EuphVQWdq6Wo+xhoJ
 liuJig79mh7UAjdU2irNnfziqOE7C3gm/rADdU7IOxZzk06+pxUd7hc6n/iRPh/PNc1O
 SbSguRYWnU68Q6iKtXnpHGOJihQRauKSNqTBdDEzrfet6ZjN11akIzddASvQXmoXRpiM
 P59Xf83jgqPBjBDL2yIg9jEXSErU8CZpXMxaSMQKaDuA7bjr+j9+tSZX3ZwVf7qnwPGX
 QAsQ==
X-Gm-Message-State: AOAM531D+sESt1H3KC78KBnGlR3ttpD7KfBLZduP3p+5it8BnhM0Mxk2
 zA4h1Y1X0vNa/MsQIvKJnWuyMB1w38VU+GQe1uQiRg==
X-Google-Smtp-Source: ABdhPJwYgZHhvdFXOAHhV8tAaZIlptVAnf4MbnvZxg6VsGD7IQ1/g5BzdRDRYZ/yR4ilZw5IP/itbOlJUXnAeeSZevc=
X-Received: by 2002:a05:651c:b24:b0:250:6414:c91a with SMTP id
 b36-20020a05651c0b2400b002506414c91amr11545842ljr.198.1652132093384; Mon, 09
 May 2022 14:34:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-18-dmatlack@google.com>
 <YnlB8n8UMCuaCj1G@google.com>
In-Reply-To: <YnlB8n8UMCuaCj1G@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 14:34:27 -0700
Message-ID: <CALzav=fQoqet7-MnNvsJ-deJ7RxiuiH_bHMwAEHNuXJ1VGqg0Q@mail.gmail.com>
Subject: Re: [PATCH v4 17/20] KVM: x86/mmu: Zap collapsible SPTEs at all
 levels in the shadow MMU
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

On Mon, May 9, 2022 at 9:31 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Maybe a slight tweak to the shortlog?  "Zap collapsible SPTEs at all levels in
> the shadow MMU" left me wondering "when is KVM zapping at all levels?"
>
>   KVM: x86/mmu: Zap all possible levels in shadow MMU when collapsing SPTEs
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
> > in the rmap). This is fine for now KVM never creates intermediate huge
> > pages during dirty logging, i.e. a 1GiB page is never partially split to
> > a 2MiB page.
>
> "partially" is really confusing.  I think what you mean is that KVM can split a
> 1gb to a 2mb page, and not split all the way down to 4kb.  But "partially" makes
> it sound like KVM ends up with a huge SPTE that is half split or something.  I
> think you can just avoid that altogether and be more explicit:
>
>   i.e. a 1GiB pager is never split to just 2MiB, dirty logging always splits
>   down to 4KiB pages.
>
> > However, this will stop being true once the shadow MMU participates in
> > eager page splitting, which can in fact leave behind partially split
>
> "partially" again.  Maybe
>
>   which can in fact leave behind 2MiB pages after splitting 1GiB huge pages.

Looks good, I'll incorporate these edits into v5.

>
> > huge pages. In preparation for that change, change the shadow MMU to
> > iterate over all necessary levels when zapping collapsible SPTEs.
> >
> > No functional change intended.
> >
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
> >  1 file changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ed65899d15a2..479c581e8a96 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6098,18 +6098,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >       return need_tlb_flush;
> >  }
> >
> > +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> > +                                        const struct kvm_memory_slot *slot)
> > +{
> > +     /*
> > +      * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> > +      * pages that are already mapped at the maximum possible level.
> > +      */
> > +     if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> > +                           PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> > +                           true))
> > +             kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +}
> > +
> >  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >                                  const struct kvm_memory_slot *slot)
> >  {
> >       if (kvm_memslots_have_rmaps(kvm)) {
> >               write_lock(&kvm->mmu_lock);
> > -             /*
> > -              * Zap only 4k SPTEs since the legacy MMU only supports dirty
> > -              * logging at a 4k granularity and never creates collapsible
> > -              * 2m SPTEs during dirty logging.
> > -              */
> > -             if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
> > -                     kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +             kvm_rmap_zap_collapsible_sptes(kvm, slot);
> >               write_unlock(&kvm->mmu_lock);
> >       }
> >
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
