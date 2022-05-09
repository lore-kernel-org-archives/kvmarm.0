Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3629FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E237E4B210;
	Tue, 10 May 2022 02:04:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zCfYNd2rQx9M; Tue, 10 May 2022 02:04:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B8DED4B2F4;
	Tue, 10 May 2022 02:04:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E7214B0C0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 19:59:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R0AyjFIbQ1DL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 19:59:37 -0400 (EDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com
 [209.85.208.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0A46B4B092
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 19:59:36 -0400 (EDT)
Received: by mail-lj1-f169.google.com with SMTP id t25so18939323ljd.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 16:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=sv3pTpJTnWXaUyOjFBwaWrS/CLWAom11yfRsP9pioX8=;
 b=VF6L1TPfm2H2grwGvQxjXB/rArUophBvKMYmM/4AEEpeIZrYdUdTkfOBkEk4BEbWI2
 /BgJZ8DPOFsMFZ5/prlhmlOCXI7dMWlqrjCriPK4EOPMoBMidR/ccweduFs1gDKmRT2a
 jSe0+YixmYg86Fdp+ChmxZ0pmebT4hiwVv3DgQ+7zzAAdiclAHaSsZx+fOvRaoxK4gQl
 ntcTyXAntp2EDiFAzJWUKf/TOAG3zn5txtEp+PpXundea+M6c7weB3Tkwug4AMtjQHXw
 PJuQq1IbklNK0Aix9p1bGOaT0nnOf65MjY4stPTNcj1Kn4OveQSBaQvqSlsF5pHRI33D
 4PtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=sv3pTpJTnWXaUyOjFBwaWrS/CLWAom11yfRsP9pioX8=;
 b=KXXcKst/jUipQDQhFo5s/wst84yg1Bu1RRmzq+s5PFQ+ZNJIOm4d9YAQ5pcF0DLWxS
 DFaPJIZBa9qQK0YlKirMppyp0Xk9GhiQDOkfpGNLOpzmRbBGNBCd6STcVc+Qo7Y3QZBV
 lzc0q4YeMWI/vHPHSNQUmpSpgtgVfA7FSABVQgV1OhnrVS9af3NodQiPD2FEwYfUrIqT
 psRVGRc5+NdiszmXDKywOFH2169lN3CpoXdu+MxrcygptIX1kwszCwJvdS/p87/iHGW3
 H4Vrf0nDtxS7J2dMR7K7m9IEFGrYcRMOWrxsDQVCPiEQgHFoL6jC0tI6kj+jXEW9JXWP
 Baug==
X-Gm-Message-State: AOAM533Rt91ZLZAP6y/h7iekK/AAfINR9ZjCb39s6ZMuD5wQdPmOmVZz
 q8V2eOQr+MagGzvqCl9R5VSmJDxyvBZDg6+aYYcwug==
X-Google-Smtp-Source: ABdhPJzzfhA9KvrCN94ITvdKe/AlJljESk7ftI2Q4cbLmACU7hg6vyw4MuMeMX20juJBAyGaRDpk8iTGMDcKRMFMUho=
X-Received: by 2002:a2e:9e54:0:b0:250:d6c8:c2a6 with SMTP id
 g20-20020a2e9e54000000b00250d6c8c2a6mr1219325ljk.16.1652140775207; Mon, 09
 May 2022 16:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-12-dmatlack@google.com>
 <YnRerE5+FpwkUdQE@google.com>
 <CALzav=de1=euis3WocTNBi+xNn1Ypo-GRROQNqmtAKk6q1NUqg@mail.gmail.com>
 <YnmcOdZILo2LqhAW@google.com>
In-Reply-To: <YnmcOdZILo2LqhAW@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 16:59:08 -0700
Message-ID: <CALzav=cPS82CyXD-90_K+pTaxBVDQicJ0er+LFdns5TqxA6ubA@mail.gmail.com>
Subject: Re: [PATCH v4 11/20] KVM: x86/mmu: Allow for NULL vcpu pointer in
 __kvm_mmu_get_shadow_page()
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

On Mon, May 9, 2022 at 3:57 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 09, 2022, David Matlack wrote:
> > On Thu, May 5, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Fri, Apr 22, 2022, David Matlack wrote:
> > > > Allow the vcpu pointer in __kvm_mmu_get_shadow_page() to be NULL. Rename
> > > > it to vcpu_or_null to prevent future commits from accidentally taking
> > > > dependency on it without first considering the NULL case.
> > > >
> > > > The vcpu pointer is only used for syncing indirect shadow pages in
> > > > kvm_mmu_find_shadow_page(). A vcpu pointer it not required for
> > > > correctness since unsync pages can simply be zapped. But this should
> > > > never occur in practice, since the only use-case for passing a NULL vCPU
> > > > pointer is eager page splitting which will only request direct shadow
> > > > pages (which can never be unsync).
> > > >
> > > > Even though __kvm_mmu_get_shadow_page() can gracefully handle a NULL
> > > > vcpu, add a WARN() that will fire if __kvm_mmu_get_shadow_page() is ever
> > > > called to get an indirect shadow page with a NULL vCPU pointer, since
> > > > zapping unsync SPs is a performance overhead that should be considered.
> > > >
> > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++--------
> > > >  1 file changed, 32 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 04029c01aebd..21407bd4435a 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -1845,16 +1845,27 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
> > > >         &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])     \
> > > >               if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
> > > >
> > > > -static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> > > > -                      struct list_head *invalid_list)
> > > > +static int __kvm_sync_page(struct kvm *kvm, struct kvm_vcpu *vcpu_or_null,
> > > > +                        struct kvm_mmu_page *sp,
> > > > +                        struct list_head *invalid_list)
> > > >  {
> > > > -     int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
> > > > +     int ret = -1;
> > > > +
> > > > +     if (vcpu_or_null)
> > >
> > > This should never happen.  I like the idea of warning early, but I really don't
> > > like that the WARN is far removed from the code that actually depends on @vcpu
> > > being non-NULL. Case in point, KVM should have bailed on the WARN and never
> > > reached this point.  And the inner __kvm_sync_page() is completely unnecessary.
> >
> > Yeah that's fair.
> >
> > >
> > > I also don't love the vcpu_or_null terminology; I get the intent, but it doesn't
> > > really help because understand why/when it's NULL.
> >
> > Eh, I don't think it needs to encode why or when. It just needs to
> > flag to the reader (and future code authors) that this vcpu pointer
> > (unlike all other vcpu pointers in KVM) is NULL in certain cases.
>
> My objection is that without the why/when, developers that aren't familiar with
> this code won't know the rules for using vcpu_or_null.  E.g. I don't want to end
> up with
>
>         if (vcpu_or_null)
>                 do x;
>         else
>                 do y;
>
> because inevitably it'll become unclear whether or not that code is actually _correct_.
> It might not #GP on a NULL pointer, but it doesn't mean it's correct.

Ah, right. And that's actually why I put the big comment and WARN in
__kvm_mmu_get_shadow_page(). Readers could easily jump to where
vcpu_or_null is passed in and see the rules around it. But if we move
the WARN to the kvm_sync_page() call, I agree it will be harder for
readers to know the rules and "vcpu_or_null" starts to become a risky
variable.

>
> > > I played around with casting, e.g. to/from an unsigned long or void *, to prevent
> > > usage, but that doesn't work very well because 'unsigned long' ends up being
> > > awkward/confusing, and 'void *' is easily lost on a function call.  And both
> > > lose type safety :-(
> >
> > Yet another shortcoming of C :(
>
> And lack of closures, which would work very well here.
>
> > (The other being our other discussion about the RET_PF* return codes
> > getting easily misinterpreted as KVM's magic return-to-user /
> > continue-running-guest return codes.)
> >
> > Makes me miss Rust!
> >
> > >
> > > All in all, I think I'd prefer this patch to simply be a KVM_BUG_ON() if
> > > kvm_mmu_find_shadow_page() encounters an unsync page.  Less churn, and IMO there's
> > > no real loss in robustness, e.g. we'd really have to screw up code review and
> > > testing to introduce a null vCPU pointer dereference in this code.
> >
> > Agreed about moving the check here and dropping __kvm_sync_page(). But
> > I would prefer to retain the vcpu_or_null name (or at least something
> > other than "vcpu" to indicate there's something non-standard about
> > this pointer).
>
> The least awful idea I've come up with is wrapping the vCPU in a struct, e.g.
>
>         struct sync_page_info {
>                 void *vcpu;
>         }
>
> That provides the contextual information I want, and also provides the hint that
> something is odd about the vcpu, which you want.  It's like a very poor man's closure :-)
>
> The struct could even be passed by value to avoid the miniscule overhead, and to
> make readers look extra hard because it's that much more wierd.

Interesting idea. I'll give it a shot.

>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3d102522804a..068be77a4fff 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2003,8 +2003,13 @@ static void clear_sp_write_flooding_count(u64 *spte)
>         __clear_sp_write_flooding_count(sptep_to_sp(spte));
>  }
>
> +/* Wrapper to make it difficult to dereference a potentially NULL @vcpu. */
> +struct sync_page_info {
> +       void *vcpu;
> +};
> +
>  static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
> -                                                    struct kvm_vcpu *vcpu,
> +                                                    struct sync_page_info spi,
>                                                      gfn_t gfn,
>                                                      struct hlist_head *sp_list,
>                                                      union kvm_mmu_page_role role)
> @@ -2041,6 +2046,13 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
>                         goto out;
>
>                 if (sp->unsync) {
> +                       /*
> +                        * Getting indirect shadow pages without a valid @spi
> +                        * is not supported, i.e. this should never happen.
> +                        */
> +                       if (KVM_BUG_ON(!spi.vcpu, kvm))
> +                               break;
> +
>                         /*
>                          * The page is good, but is stale.  kvm_sync_page does
>                          * get the latest guest state, but (unlike mmu_unsync_children)
> @@ -2053,7 +2065,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
>                          * If the sync fails, the page is zapped.  If so, break
>                          * in order to rebuild it.
>                          */
> -                       ret = kvm_sync_page(vcpu, sp, &invalid_list);
> +                       ret = kvm_sync_page(spi.vcpu, sp, &invalid_list);
>                         if (ret < 0)
>                                 break;
>
> @@ -2120,7 +2132,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
>  }
>
>  static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
> -                                                     struct kvm_vcpu *vcpu,
> +                                                     struct sync_page_info spi,
>                                                       struct shadow_page_caches *caches,
>                                                       gfn_t gfn,
>                                                       union kvm_mmu_page_role role)
> @@ -2131,7 +2143,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
>
>         sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>
> -       sp = kvm_mmu_find_shadow_page(kvm, vcpu, gfn, sp_list, role);
> +       sp = kvm_mmu_find_shadow_page(kvm, spi, gfn, sp_list, role);
>         if (!sp) {
>                 created = true;
>                 sp = kvm_mmu_alloc_shadow_page(kvm, caches, gfn, sp_list, role);
> @@ -2151,7 +2163,11 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
>                 .gfn_array_cache = &vcpu->arch.mmu_gfn_array_cache,
>         };
>
> -       return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
> +       struct sync_page_info spi = {
> +               .vcpu = vcpu,
> +       };
> +
> +       return __kvm_mmu_get_shadow_page(vcpu->kvm, spi, &caches, gfn, role);
>  }
>
>  static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
