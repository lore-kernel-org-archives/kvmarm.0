Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92528C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E81D04B30C;
	Tue, 10 May 2022 02:04:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wEToYLDml8O3; Tue, 10 May 2022 02:04:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7F74B1FD;
	Tue, 10 May 2022 02:04:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D78CF49E2B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:04:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ArRlETBoCPyR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 17:04:35 -0400 (EDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com
 [209.85.208.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5794D49E1E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:04:35 -0400 (EDT)
Received: by mail-lj1-f176.google.com with SMTP id g16so18562526lja.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 14:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=c5LtGywQnrOXKM23KEYCQ2YGVv1HopC1il4VU9eUgxE=;
 b=sV2YUesPkqRi/0p/HKaHURPtcySE3DJDHUAAMBQSxIzugMHDsHPkIq11Za+WFAu9bG
 UFNluQRx+kZVfU1Vtrib+AkxMsIkIny3t4PMACdMOyXRiuQ3BV7xjp4iiFZLffs6uqze
 Buf1chdttyPGbxT1R1vPzc8JbwWHscDRqxY6beEcpNXYfRjzEDZQgwrYjE1nWuW4kT3S
 r7UDQP39oaM8dHixquIHqqJHb12gzWedDgD4NEt0oYk/gusriZ1/hMFoSsXvXhS3LLrE
 I++TRCKQ2rchxMyGjDtWbFmQK9zTpViB+qmuOZzTe79sfGNcC5vqhazohhKu7W6GIYxU
 eiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=c5LtGywQnrOXKM23KEYCQ2YGVv1HopC1il4VU9eUgxE=;
 b=V/MaVytt1mRzlZBAD6JWNwq76gMty1O2r0iMtFBhj2riRIpF+Vupq0U2YH+3kS7CNl
 MlC7t9avUpxnv1557XpMbNHUGxbTI67zQ4a1+5bdrYF4L2e8RhVUgCjRxzuWZ/YmpqsS
 O7QzV6tnkd+gmQjLH6J8NskUia2VVDHlf7dMWfsJS4v7io7Y+AHqriEiRCWSZhCFO3z0
 uiW+EScseZfkZ4mf9sO9M5l2UwqOBNA+rTe5XeFpy2oGd/F3WJ0PnFThKdzySIcQenap
 IAD5NLw3U5wOBN7VHLTEWCtCBocNhONqPxLsZICUsehQTTbIoc32jBftuQZgtRFCMddM
 krQw==
X-Gm-Message-State: AOAM532RnTVSNEDCSW5+nE6WUc0vIB2VoMbO1INTsxgX1m18E7oT5SXt
 Eetf9m0uJsNwX6k6Z3+9aB3+ebIcLOcZuvQ/b2tSlA==
X-Google-Smtp-Source: ABdhPJxAE3oSM612W5GV7m6rV0MnBAiT424gFGbU3VxZpyNw2tWnKhf1N6nGVWDl2btu9ErypG2EOm1F3IUMYGBbQWk=
X-Received: by 2002:a2e:9e54:0:b0:250:d6c8:c2a6 with SMTP id
 g20-20020a2e9e54000000b00250d6c8c2a6mr765147ljk.16.1652130273338; Mon, 09 May
 2022 14:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-4-dmatlack@google.com>
 <75fbbcb6-d9bb-3d30-0bf4-fbf925517d09@gmail.com>
In-Reply-To: <75fbbcb6-d9bb-3d30-0bf4-fbf925517d09@gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 14:04:06 -0700
Message-ID: <CALzav=dmseUw6khErkiSV7T5K88QvaRvWvBpvrb6VNOQTE3bQQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from
 parent
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

On Sat, May 7, 2022 at 1:28 AM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
>
>
> On 2022/4/23 05:05, David Matlack wrote:
> > Instead of computing the shadow page role from scratch for every new
> > page, derive most of the information from the parent shadow page.  This
> > avoids redundant calculations and reduces the number of parameters to
> > kvm_mmu_get_page().
> >
> > Preemptively split out the role calculation to a separate function for
> > use in a following commit.
> >
> > No functional change intended.
> >
> > Reviewed-by: Peter Xu <peterx@redhat.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c         | 96 +++++++++++++++++++++++-----------
> >   arch/x86/kvm/mmu/paging_tmpl.h |  9 ++--
> >   2 files changed, 71 insertions(+), 34 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index dc20eccd6a77..4249a771818b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2021,31 +2021,15 @@ static void clear_sp_write_flooding_count(u64 *spte)
> >       __clear_sp_write_flooding_count(sptep_to_sp(spte));
> >   }
> >
> > -static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > -                                          gfn_t gfn,
> > -                                          gva_t gaddr,
> > -                                          unsigned level,
> > -                                          bool direct,
> > -                                          unsigned int access)
> > +static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > +                                          union kvm_mmu_page_role role)
> >   {
> > -     union kvm_mmu_page_role role;
> >       struct hlist_head *sp_list;
> > -     unsigned quadrant;
> >       struct kvm_mmu_page *sp;
> >       int ret;
> >       int collisions = 0;
> >       LIST_HEAD(invalid_list);
> >
> > -     role = vcpu->arch.mmu->root_role;
> > -     role.level = level;
> > -     role.direct = direct;
> > -     role.access = access;
> > -     if (role.has_4_byte_gpte) {
> > -             quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
> > -             quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
> > -             role.quadrant = quadrant;
> > -     }
>
>
> I don't think replacing it with kvm_mmu_child_role() can reduce any calculations.
>
> role.level, role.direct, role.access and role.quadrant still need to be
> calculated.  And the old code is still in mmu_alloc_root().

You are correct. Instead of saying "less calculations" I should have
said "eliminates the dependency on vcpu->arch.mmu->root_role".

>
> I think kvm_mmu_get_shadow_page() can keep the those parameters and
> kvm_mmu_child_role() is only introduced for nested_mmu_get_sp_for_split().
>
> Both kvm_mmu_get_shadow_page() and nested_mmu_get_sp_for_split() call
> __kvm_mmu_get_shadow_page() which uses role as a parameter.

I agree this would work, but I think the end result would be more
difficult to read.

The way I've implemented it there are two ways the SP roles are calculated:

1. For root SPs: Derive the role from vCPU root_role and caller-provided inputs.
2. For child SPs: Derive the role from parent SP and caller-provided inputs.

Your proposal would still have two ways to calculate the SP role, but
split along a different dimension:

1. For vCPUs creating SPs: Derive the role from vCPU root_role and
caller-provided inputs.
2. For Eager Page Splitting creating SPs: Derive the role from parent
SP and caller-provided inputs.

With your proposal, it is less obvious that eager page splitting is
going to end up with the correct role. Whereas if we use the same
calculation for all child SPs, it is immediately obvious.

>
>
>
> > -
> >       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> >       for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> >               if (sp->gfn != gfn) {
> > @@ -2063,7 +2047,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >                        * Unsync pages must not be left as is, because the new
> >                        * upper-level page will be write-protected.
> >                        */
> > -                     if (level > PG_LEVEL_4K && sp->unsync)
> > +                     if (role.level > PG_LEVEL_4K && sp->unsync)
> >                               kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
> >                                                        &invalid_list);
> >                       continue;
> > @@ -2104,14 +2088,14 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >
> >       ++vcpu->kvm->stat.mmu_cache_miss;
> >
> > -     sp = kvm_mmu_alloc_page(vcpu, direct);
> > +     sp = kvm_mmu_alloc_page(vcpu, role.direct);
> >
> >       sp->gfn = gfn;
> >       sp->role = role;
> >       hlist_add_head(&sp->hash_link, sp_list);
> > -     if (!direct) {
> > +     if (!role.direct) {
> >               account_shadowed(vcpu->kvm, sp);
> > -             if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
> > +             if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
> >                       kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
> >       }
> >       trace_kvm_mmu_get_page(sp, true);
> > @@ -2123,6 +2107,51 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> >       return sp;
> >   }
> >
> > +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> > +{
> > +     struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> > +     union kvm_mmu_page_role role;
> > +
> > +     role = parent_sp->role;
> > +     role.level--;
> > +     role.access = access;
> > +     role.direct = direct;
> > +
> > +     /*
> > +      * If the guest has 4-byte PTEs then that means it's using 32-bit,
> > +      * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> > +      * directories, each mapping 1/4 of the guest's linear address space
> > +      * (1GiB). The shadow pages for those 4 page directories are
> > +      * pre-allocated and assigned a separate quadrant in their role.
>
>
> It is not going to be true in patchset:
> [PATCH V2 0/7] KVM: X86/MMU: Use one-off special shadow page for special roots
>
> https://lore.kernel.org/lkml/20220503150735.32723-1-jiangshanlai@gmail.com/
>
> The shadow pages for those 4 page directories are also allocated on demand.

Ack. I can even just drop this sentence in v5, it's just background information.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
