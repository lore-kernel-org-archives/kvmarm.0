Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C38C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 09:57:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B40449F1F;
	Wed, 23 Mar 2022 05:57:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fCHfeotUo5K7; Wed, 23 Mar 2022 05:57:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A56024A0FC;
	Wed, 23 Mar 2022 05:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6721149F59
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 19:12:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fz11QOtwiCeb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 19:11:59 -0400 (EDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A78849F55
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 19:11:59 -0400 (EDT)
Received: by mail-lf1-f53.google.com with SMTP id p15so21582807lfk.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 16:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=9UcMI48nwlkJwzGQaLCymnATyeWxY7UI+r36M2RtgBY=;
 b=fVxGdQ0lDhy37Z3mtSn9xY39q7OFgGPiLVvBCZBV5MLaL5arrUVY6OErynD8FxEMEL
 NS1gJ05HdIVS+Pgcr24laaY+sIWghTb5+fnguG6H0C9zeaCUmVUu0AZH5JnvoaoTwg59
 POQ+tgNUyLE3ADxAARPe+4ZRRtZ9luy2kpH3uEmq3v6mwFbr/O68sTms15V0djO6aLxo
 x7UieZolXfsNJ3MOIXz2p8XksMfrnmK8cnLCrzklinwkz8wdIGIcrhiD6hMgg5HFHEDf
 4VR2h3LvbLeELpfPj3hMrqJeUDRIM3pFJVNCEwJi8DrM3ercUpht+SSoLebiwnMxmW48
 DLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9UcMI48nwlkJwzGQaLCymnATyeWxY7UI+r36M2RtgBY=;
 b=u/GacelYKg/71nIXtVCpR7HkjHkY3CCvuPg25799v+1zYSjW36JaFf6edZycThUMiL
 1T8lA8U/OMpRFoc0j15k+YFoERPWVCiyK5modTELgfxv+SOaZw738S7xHe1hyjTQcuek
 Mvaa2cqwWDM94Iec6/eFHYJDDv1X4c3BPDgws9geGAYB507U2Ku5kFx1RTZnE2cLRHZX
 jIrSOQAUH8+oDPFI+of5iIK8hWnph/RUPFU7U7Zmdxf7Jm8dLitVjZBKxJr//Tjf62h0
 JOQ3ZCesFZPVYaf1kIb7Dr6+1abdlg1HXvBK4qXfxYafXtw7XqNBRubWMi0abMYNFxod
 dKAg==
X-Gm-Message-State: AOAM532xaTZPaGYgMl+DwXxeNSz5Qo1Q9L1ptSVs5tAB4LDaCyQyBhNx
 WbmzuWomaNcAq7EBV4JJ2eS23E0VCxydLJefLjhkug==
X-Google-Smtp-Source: ABdhPJxKDtp0rtSym57kIIsqB7/r1k5Genfjt3dYPaXLz5oTghlutp4K5YtmVdgCQQDgsV2VunXL2dkkNqst+Dj4Qow=
X-Received: by 2002:a05:6512:128e:b0:44a:4067:9ffe with SMTP id
 u14-20020a056512128e00b0044a40679ffemr3096148lfs.64.1647990717672; Tue, 22
 Mar 2022 16:11:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-19-dmatlack@google.com>
 <YjGkmwBIwe64TjqA@xz-m1.local>
In-Reply-To: <YjGkmwBIwe64TjqA@xz-m1.local>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Mar 2022 16:11:31 -0700
Message-ID: <CALzav=fpydLJhE5m58od5rFEv0iGLHzkPaM4mN7XHv2WqF8ptg@mail.gmail.com>
Subject: Re: [PATCH v2 18/26] KVM: x86/mmu: Zap collapsible SPTEs at all
 levels in the shadow MMU
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

On Wed, Mar 16, 2022 at 1:49 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:20AM +0000, David Matlack wrote:
> > Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
> > in the rmap). This is fine for now KVM never creates intermediate huge
> > pages during dirty logging, i.e. a 1GiB page is never partially split to
> > a 2MiB page.
> >
> > However, this will stop being true once the shadow MMU participates in
> > eager page splitting, which can in fact leave behind partially split
> > huge pages. In preparation for that change, change the shadow MMU to
> > iterate over all necessary levels when zapping collapsible SPTEs.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++-------
> >  1 file changed, 19 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 89a7a8d7a632..2032be3edd71 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6142,18 +6142,30 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
> >       return need_tlb_flush;
> >  }
> >
> > +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> > +                                        const struct kvm_memory_slot *slot)
> > +{
> > +     bool flush;
> > +
> > +     /*
> > +      * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> > +      * pages that are already mapped at the maximum possible level.
> > +      */
> > +     flush = slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> > +                               PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> > +                               true);
> > +
> > +     if (flush)
> > +             kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +
> > +}
>
> Reviewed-by: Peter Xu <peterx@redhat.com>
>
> IMHO it looks cleaner to write it in the old way (drop the flush var).
> Maybe even unwrap the helper?

Unwrapping the helper and dropping the flush var makes the if
condition quite long and hard to read. But I think a compromise would
to have kvm_rmap_zap_collapsible_sptes() return flush and leave the
flush call in kvm_mmu_zap_collapsible_sptes().

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
