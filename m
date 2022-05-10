Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C951C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51AAE4B2D8;
	Tue, 10 May 2022 02:04:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TLaGFUHFu81I; Tue, 10 May 2022 02:04:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 053AC4B305;
	Tue, 10 May 2022 02:04:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 124D24B12C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 22:58:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6ZzHNIB3OCpc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 22:58:33 -0400 (EDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com
 [209.85.219.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 86CBB49F5F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 22:58:33 -0400 (EDT)
Received: by mail-yb1-f170.google.com with SMTP id j2so28401826ybu.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 19:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=H8vraaQ5DcI+D+0VuVsldMnCsgIP6A3AxiIuSgPst5A=;
 b=JOPZlXRgydWmpz8uA0xOm6wWnl9Z7zRiSI0SVu2npoaABUbsdaXM+wylhI7nYW7Jeo
 57tp6eb0kioeoSnR1ZtAZKPQkvR6S0wR2iInhkH2sQ/janeJmmc1swUVLQGX7VquVkSR
 UXQ0TrhDT6nL1Rf4hL37fMI4cFvZpimbDkTLcO695MZojQ/NjmZpMs2THG4gNeKuxIKg
 T2QD5oTBr/3M6oXr06jdo2BrUWfZdVMxkG2uQnPQ5Gq9XoXr54rKccgp0BIG/qEUkQWZ
 S5gue3ZYJAucMw1UNFtI8IxxV2oCBKWisTMPPquxzR5cL859C9Yw/aoWu5D2PII1H4mE
 RmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=H8vraaQ5DcI+D+0VuVsldMnCsgIP6A3AxiIuSgPst5A=;
 b=3PPGVk8KcNRCdIt5bS/eO2ks26ZZgiDi6OKqXtDE3sTzEgosbaFhiPv4sLYWsO65iF
 8xco4fxT9LsY8EmUjz9afwf5OjZRgglNA2nNIhYHvY8SkBfstppzdvUpKSYwB/XamtKy
 Oc9Vxrh5IT/kc1IZvhKmmR5uMBah7+hgRVpSAHiK77sZ94FUPflTD37EDC7ChouK6iMS
 iJ7i4ZbURb7m1PiTMht18Eh2suz7t1kwB5Tz++qPHFw+oBX1X9qGKyEr8LKtbz1uqsgA
 koBb1acCxO+O3pjPX+ENJcvYoW2T5pmUCmKHztvqANqhwI3ryj+oQcCInWA7K4fVMuBe
 JX8w==
X-Gm-Message-State: AOAM531v4U5eiVkVnvHlRFET7CH02K7sDMnVZ/eoGn+SzDYkLA7izNHC
 Xxfv99ODzndj+te9XpWkhhAGCLHukz1zl38RAvw=
X-Google-Smtp-Source: ABdhPJydqtRDCx7YVD91pCtY2A1j8buOSkHSwNAiYxv+11DpIiZ1RPo0iEDLLhyzzPzAxWfqFKDtVaJ1lPhnNJMV2bc=
X-Received: by 2002:a25:2082:0:b0:649:f60b:112a with SMTP id
 g124-20020a252082000000b00649f60b112amr14983003ybg.428.1652151512922; Mon, 09
 May 2022 19:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-4-dmatlack@google.com>
 <75fbbcb6-d9bb-3d30-0bf4-fbf925517d09@gmail.com>
 <CALzav=dmseUw6khErkiSV7T5K88QvaRvWvBpvrb6VNOQTE3bQQ@mail.gmail.com>
In-Reply-To: <CALzav=dmseUw6khErkiSV7T5K88QvaRvWvBpvrb6VNOQTE3bQQ@mail.gmail.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Tue, 10 May 2022 10:58:21 +0800
Message-ID: <CAJhGHyDQn=atFmn5o2TREW9cSY5Tv1F1vsSekzor6uYQxDgcfQ@mail.gmail.com>
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from
 parent
To: David Matlack <dmatlack@google.com>
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

()

On Tue, May 10, 2022 at 5:04 AM David Matlack <dmatlack@google.com> wrote:
>
> On Sat, May 7, 2022 at 1:28 AM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
> >
> >
> >
> > On 2022/4/23 05:05, David Matlack wrote:
> > > Instead of computing the shadow page role from scratch for every new
> > > page, derive most of the information from the parent shadow page.  This
> > > avoids redundant calculations and reduces the number of parameters to
> > > kvm_mmu_get_page().
> > >
> > > Preemptively split out the role calculation to a separate function for
> > > use in a following commit.
> > >
> > > No functional change intended.
> > >
> > > Reviewed-by: Peter Xu <peterx@redhat.com>
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >   arch/x86/kvm/mmu/mmu.c         | 96 +++++++++++++++++++++++-----------
> > >   arch/x86/kvm/mmu/paging_tmpl.h |  9 ++--
> > >   2 files changed, 71 insertions(+), 34 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index dc20eccd6a77..4249a771818b 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -2021,31 +2021,15 @@ static void clear_sp_write_flooding_count(u64 *spte)
> > >       __clear_sp_write_flooding_count(sptep_to_sp(spte));
> > >   }
> > >
> > > -static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > > -                                          gfn_t gfn,
> > > -                                          gva_t gaddr,
> > > -                                          unsigned level,
> > > -                                          bool direct,
> > > -                                          unsigned int access)
> > > +static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > > +                                          union kvm_mmu_page_role role)
> > >   {
> > > -     union kvm_mmu_page_role role;
> > >       struct hlist_head *sp_list;
> > > -     unsigned quadrant;
> > >       struct kvm_mmu_page *sp;
> > >       int ret;
> > >       int collisions = 0;
> > >       LIST_HEAD(invalid_list);
> > >
> > > -     role = vcpu->arch.mmu->root_role;
> > > -     role.level = level;
> > > -     role.direct = direct;
> > > -     role.access = access;
> > > -     if (role.has_4_byte_gpte) {
> > > -             quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
> > > -             quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
> > > -             role.quadrant = quadrant;
> > > -     }
> >
> >
> > I don't think replacing it with kvm_mmu_child_role() can reduce any calculations.
> >
> > role.level, role.direct, role.access and role.quadrant still need to be
> > calculated.  And the old code is still in mmu_alloc_root().
>
> You are correct. Instead of saying "less calculations" I should have
> said "eliminates the dependency on vcpu->arch.mmu->root_role".
>
> >
> > I think kvm_mmu_get_shadow_page() can keep the those parameters and
> > kvm_mmu_child_role() is only introduced for nested_mmu_get_sp_for_split().
> >
> > Both kvm_mmu_get_shadow_page() and nested_mmu_get_sp_for_split() call
> > __kvm_mmu_get_shadow_page() which uses role as a parameter.
>
> I agree this would work, but I think the end result would be more
> difficult to read.
>
> The way I've implemented it there are two ways the SP roles are calculated:
>
> 1. For root SPs: Derive the role from vCPU root_role and caller-provided inputs.
> 2. For child SPs: Derive the role from parent SP and caller-provided inputs.
>
> Your proposal would still have two ways to calculate the SP role, but
> split along a different dimension:
>
> 1. For vCPUs creating SPs: Derive the role from vCPU root_role and
> caller-provided inputs.
> 2. For Eager Page Splitting creating SPs: Derive the role from parent
> SP and caller-provided inputs.
>
> With your proposal, it is less obvious that eager page splitting is
> going to end up with the correct role. Whereas if we use the same
> calculation for all child SPs, it is immediately obvious.


In this patchset, there are still two ways to calculate the SP role
including the one in mmu_alloc_root() which I dislike.

The old code is just moved into mmu_alloc_root() even kvm_mmu_child_role()
is introduced.

>
> >
> >
> >
> > > -
> > >       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> > >       for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> > >               if (sp->gfn != gfn) {
> > > @@ -2063,7 +2047,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > >                        * Unsync pages must not be left as is, because the new
> > >                        * upper-level page will be write-protected.
> > >                        */
> > > -                     if (level > PG_LEVEL_4K && sp->unsync)
> > > +                     if (role.level > PG_LEVEL_4K && sp->unsync)
> > >                               kvm_mmu_prepare_zap_page(vcpu->kvm, sp,
> > >                                                        &invalid_list);
> > >                       continue;
> > > @@ -2104,14 +2088,14 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > >
> > >       ++vcpu->kvm->stat.mmu_cache_miss;
> > >
> > > -     sp = kvm_mmu_alloc_page(vcpu, direct);
> > > +     sp = kvm_mmu_alloc_page(vcpu, role.direct);
> > >
> > >       sp->gfn = gfn;
> > >       sp->role = role;
> > >       hlist_add_head(&sp->hash_link, sp_list);
> > > -     if (!direct) {
> > > +     if (!role.direct) {
> > >               account_shadowed(vcpu->kvm, sp);
> > > -             if (level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
> > > +             if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))
> > >                       kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
> > >       }
> > >       trace_kvm_mmu_get_page(sp, true);
> > > @@ -2123,6 +2107,51 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > >       return sp;
> > >   }
> > >
> > > +static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
> > > +{
> > > +     struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
> > > +     union kvm_mmu_page_role role;
> > > +
> > > +     role = parent_sp->role;
> > > +     role.level--;
> > > +     role.access = access;
> > > +     role.direct = direct;
> > > +
> > > +     /*
> > > +      * If the guest has 4-byte PTEs then that means it's using 32-bit,
> > > +      * 2-level, non-PAE paging. KVM shadows such guests using 4 PAE page
> > > +      * directories, each mapping 1/4 of the guest's linear address space
> > > +      * (1GiB). The shadow pages for those 4 page directories are
> > > +      * pre-allocated and assigned a separate quadrant in their role.
> >
> >
> > It is not going to be true in patchset:
> > [PATCH V2 0/7] KVM: X86/MMU: Use one-off special shadow page for special roots
> >
> > https://lore.kernel.org/lkml/20220503150735.32723-1-jiangshanlai@gmail.com/
> >
> > The shadow pages for those 4 page directories are also allocated on demand.
>
> Ack. I can even just drop this sentence in v5, it's just background information.

No, if one-off special shadow pages are used.

kvm_mmu_child_role() should be:

+       if (role.has_4_byte_gpte) {
+               if (role.level == PG_LEVEL_4K)
+                       role.quadrant = (sptep - parent_sp->spt) % 2;
+               if (role.level == PG_LEVEL_2M)
+                       role.quadrant = (sptep - parent_sp->spt) % 4;
+       }


And if one-off special shadow pages are merged first.  You don't
need any calculation in mmu_alloc_root(), you can just directly use
    sp = kvm_mmu_get_page(vcpu, gfn, vcpu->arch.mmu->root_role);
because vcpu->arch.mmu->root_role is always the real role of the root
sp no matter if it is a normall root sp or an one-off special sp.

I hope you will pardon me for my touting my patchset and asking
people to review them in your threads.

Thanks
Lai
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
