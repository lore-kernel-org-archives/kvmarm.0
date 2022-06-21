Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32604C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 13:59:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBEED4B4F3;
	Wed, 22 Jun 2022 09:59:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SThFBcRs5No3; Wed, 22 Jun 2022 09:59:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5034E4B4F7;
	Wed, 22 Jun 2022 09:59:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51A4D4B2BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:25:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KmU08fdMXLI4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jun 2022 13:25:15 -0400 (EDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com
 [209.85.167.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC1DA4B2BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:25:14 -0400 (EDT)
Received: by mail-lf1-f51.google.com with SMTP id j21so10420572lfe.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 10:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=QxmNtn8D9Dq51lR45DZiK36aZDbgyY5PoNiGUjl0icA=;
 b=Ld+SXs+fbT42PedNRfBVwRPd4bGGEqJzfB0snipjuJDtE6hrnQapdgsyRXKLSaFLEF
 SeHC6LW/bNPOFZSmvGwC4yAulJod6HrkGlu2Q/HxkdPrvSMwginiMcuAwi+HJb8SrgJm
 Dg6a3LD574NJUNbQRoUEz/Z1/AYz/ywSt/LWvYmn69UESDBDxp/43gcSdd5zuehSKpxe
 5WfN11Dha6FzU37T6JD8yt50/Xsib8ACxxj6Hje3zAyjKUSYqWhA7ZK5VnJqJf5fs9Z0
 Wrc1cadDRYy1qG2WhCErGy19AwynWxr/HW00aYN4nILtBmD3ttCewO3nVp93ciSI0h92
 1qgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=QxmNtn8D9Dq51lR45DZiK36aZDbgyY5PoNiGUjl0icA=;
 b=R1A00E/ARhya8N/xCEkTrGRZymnIfapLQERdGPstDyA73XV3Ym7++YxesLK7CoYHnR
 mw9CQq5rzYAA+O349YM85omHcKv1/WvXBddIapIln9polxEjUOGd1aEkdVEuAGTFdNjf
 bXf/FYGMckz6Kd7I+l/xovSzw89xNY9EG4R9UTeRqNfi6xMbC0ImUKXj29RAZ07BQxYL
 C8flmfObzVuiorgZR6bSwd4KBxInK3lrG5+bUSJK3nfx601+FLEb9vsJ55ZDivzLc6n8
 YG7bSB6uI7DoSyjcB6TH0xdCPIJomIpNODMdYzIphJc7AAuWB4i/X9D0/n3awN6vsVPm
 CiRQ==
X-Gm-Message-State: AJIora8bicmCjaEafmceJDdtQTOoUMMqa3KRAQ3HrWMTLAPiVdYW+iDa
 ey17t+2Eb+EGuOFg71QQAHNHy9OfHHLvlIvyZzQ1jA==
X-Google-Smtp-Source: AGRyM1s5cjr8sQNsMbvjgG6SWuG6iDiSvWJI9kOqfmURFLq5B+Ub8Rt52OPf2QusJc1z0mMA44WZn84iXTKx0ZqHfTo=
X-Received: by 2002:a05:6512:4004:b0:479:1d77:4e43 with SMTP id
 br4-20020a056512400400b004791d774e43mr17252143lfb.537.1655832313238; Tue, 21
 Jun 2022 10:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-20-dmatlack@google.com>
 <Yqyzavjp9eS9p4+m@google.com>
In-Reply-To: <Yqyzavjp9eS9p4+m@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 21 Jun 2022 10:24:46 -0700
Message-ID: <CALzav=dG9f2X8GBLjQgR-Lj4yPKX2Adg3C+9_9aC83A7mzmbtw@mail.gmail.com>
Subject: Re: [PATCH v6 19/22] KVM: x86/mmu: Zap collapsible SPTEs in shadow
 MMU at all possible levels
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Wed, 22 Jun 2022 09:59:03 -0400
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
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

On Fri, Jun 17, 2022 at 10:01 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 16, 2022, David Matlack wrote:
> > Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU. This
> > is fine for now since KVM never creates intermediate huge pages during
> > dirty logging. In other words, KVM always replaces 1GiB pages directly
> > with 4KiB pages, so there is no reason to look for collapsible 2MiB
> > pages.
> >
> > However, this will stop being true once the shadow MMU participates in
> > eager page splitting. During eager page splitting, each 1GiB is first
> > split into 2MiB pages and then those are split into 4KiB pages. The
> > intermediate 2MiB pages may be left behind if an error condition causes
> > eager page splitting to bail early.
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
> > index f83de72feeac..a5d96d452f42 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -6177,18 +6177,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
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
>
> No need to wrap, "true" fits easily on the previous line.  That said, I don't see
> any point in adding a helper.  It's highly unlike there will be another caller,
> and IMO it's not any more readable since I have to go look at another function
> when reading kvm_mmu_zap_collapsible_sptes().

I could see an argument for readability either way. Putting it in a
helper function abstracts away the details, which would aid
readability if the reader does not care about the implementation
details of the rmap case.

I also have been thinking about splitting the rmap stuff out of mmu.c
(e.g. into rmap.c or shadow_mmu.c) to mirror the TDP MMU. That way we
can have a more clear split between the TDP MMU and shadow MMU, each
with their own file, and with higher level MMU operations that need to
operate on either or both MMUs living in mmu.c.

>
> With some gentle massaging, the comment can squeeze onto two lines even with the
> extra level of indentation.
>
>                 /*
>                  * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1, there's no need to zap
>                  * pages that are already mapped at the maximum hugepage level.
>                  */
>                 if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
>                                       PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true)
>                         kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
>
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
> > 2.36.0.550.gb090851708-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
