Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDA5C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9278849EF2;
	Tue, 10 May 2022 02:04:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gBca4-lXkOsE; Tue, 10 May 2022 02:04:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75EFB4B2EF;
	Tue, 10 May 2022 02:04:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 657C549B13
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 18:10:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z0IaXolOBfNc for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 18:10:30 -0400 (EDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC60143482
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 18:10:29 -0400 (EDT)
Received: by mail-lf1-f44.google.com with SMTP id w19so26190056lfu.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 15:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Y3SxyHvVr6AH+P/u24p00J7QGdQlTw5xBytxlx411I4=;
 b=S60tcQa3hhufmPZu0YE5j8DGjNpr9+Xz6+r1QLkzNffsRYJt9O7Uiay7J06u+WGHsO
 FRdBDTXyRDxs0sb4jFpzyb0I2gAhY6qLwHxzn+fHbvRJYvkWt/mdu6HgDdDJMjaRhv4M
 k2v6WrcrLTxUT/6vuY/Fmao9um0wfDvw5AVQz0CPfJ1x3KdbKBcTcJliZIMHaLqe2N17
 wqg9E6EUiPqGOmUD2sHba1TaKRUGmx7ldg23iESQdhAnH9hPONHRzFuqQgy80qbRTXQ5
 sCNnWdqiDvc31mrZVe9lK6n7UCdLaBMArCHs9hIfjKPZR72os9w19C6XDfd+gMKjGurL
 ylfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Y3SxyHvVr6AH+P/u24p00J7QGdQlTw5xBytxlx411I4=;
 b=J03UusF96aJv4uZv8b+wAlonYccAAMQVY9KgaMPLVVcVEx70x/u6XuP5fQzcO7l5+F
 w+NktDucCUjC+H70fOQ5mO6lJmoPZKfjZPF5bNcuwpNm/TRu/vFWthkghUoxjEyEtDg7
 W4RWEcdApTSr+QfS38D7ybp/rSkD1C+o4fKCXEIZ0KNfi9vDnywS3S3VUIKYDIiWxmxn
 GvXA/ap4uEeGnODCqXZgLAJfJ7jrH83qYPMt54fFoHs7PQI1QZBkx9kEQGDHLSWWy+x5
 VCgUKKsah72qNllFH+zrb7nIKi5B0RnOmnOYWqxDCdHTdeEhq8u39HrXC0PlSn5fzczp
 Oe5Q==
X-Gm-Message-State: AOAM530k921t9cGapxSsI1oUNPwsSoVm3z5yn1YvJQjGvv1+SLRBaY/F
 WUVbHhj86LpOe12Weii8ki+qKDpy9BqsVRT5uL1OOQ==
X-Google-Smtp-Source: ABdhPJyR1jE0W+hmlWReJPCUYLeK5huzg3KxrqedKuY1tZTZITWULOmJnhwlVRMvBRaBsFK94zOY8WXJKHFijLCmdIM=
X-Received: by 2002:ac2:5399:0:b0:472:1f95:85df with SMTP id
 g25-20020ac25399000000b004721f9585dfmr14049979lfh.102.1652134228070; Mon, 09
 May 2022 15:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-4-dmatlack@google.com>
 <YnRGpDa/kG+9h7Jd@google.com>
In-Reply-To: <YnRGpDa/kG+9h7Jd@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 15:10:01 -0700
Message-ID: <CALzav=fK9T5YwbiTU1qq7DZuE3E+MVRGDTHpKch7W9jQ9AR8bA@mail.gmail.com>
Subject: Re: [PATCH v4 03/20] KVM: x86/mmu: Derive shadow MMU page role from
 parent
To: Sean Christopherson <seanjc@google.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>
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

On Thu, May 5, 2022 at 2:50 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
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
> >  arch/x86/kvm/mmu/mmu.c         | 96 +++++++++++++++++++++++-----------
> >  arch/x86/kvm/mmu/paging_tmpl.h |  9 ++--
> >  2 files changed, 71 insertions(+), 34 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index dc20eccd6a77..4249a771818b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2021,31 +2021,15 @@ static void clear_sp_write_flooding_count(u64 *spte)
> >       __clear_sp_write_flooding_count(sptep_to_sp(spte));
> >  }
> >
> > -static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > -                                          gfn_t gfn,
> > -                                          gva_t gaddr,
> > -                                          unsigned level,
> > -                                          bool direct,
> > -                                          unsigned int access)
> > +static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> > +                                          union kvm_mmu_page_role role)
> >  {
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
> > -
>
> When you rebase to kvm/queue, the helper will need to deal with
>
>         if (level <= vcpu->arch.mmu->cpu_role.base.level)
>                 role.passthrough = 0;
>
> KVM should never create a passthrough huge page, so I believe it's just a matter
> of adding yet another boolean param to kvm_mmu_child_role().

+Lai Jiangshan

It looks like only root pages can be passthrough, so
kvm_mmu_child_role() can hard-code passthrough to 0. Lai do you agree?

>
>
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
>
> ...
>
> > @@ -3310,12 +3338,21 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
> >       return ret;
> >  }
> >
> > -static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
> > +static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
> >                           u8 level, bool direct)
> >  {
> > +     union kvm_mmu_page_role role;
> >       struct kvm_mmu_page *sp;
> >
> > -     sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
> > +     role = vcpu->arch.mmu->root_role;
> > +     role.level = level;
> > +     role.direct = direct;
> > +     role.access = ACC_ALL;
> > +
> > +     if (role.has_4_byte_gpte)
> > +             role.quadrant = quadrant;
>
> Maybe add a comment explaining the PAE and 32-bit paging paths share a call for
> allocating PDPTEs?  Otherwise it looks like passing a non-zero quadrant when the
> guest doesn't have 4-byte PTEs should be a bug.
>
> Hmm, even better, if the check is moved to the caller, then this can be:
>
>         role.level = level;
>         role.direct = direct;
>         role.access = ACC_ALL;
>         role.quadrant = quadrant;
>
>         WARN_ON_ONCE(quadrant && !role.has_4_byte_gpte));
>         WARN_ON_ONCE(direct && role.has_4_byte_gpte));
>
> and no comment is necessary.

Sure.

>
> > +
> > +     sp = kvm_mmu_get_page(vcpu, gfn, role);
> >       ++sp->root_count;
> >
> >       return __pa(sp->spt);
> > @@ -3349,8 +3386,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >               for (i = 0; i < 4; ++i) {
> >                       WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
> >
> > -                     root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
> > -                                           i << 30, PT32_ROOT_LEVEL, true);
> > +                     root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), i,
>
> The @quadrant here can be hardcoded to '0', has_4_byte_gpte is guaranteed to be
> false if the MMU is direct.  And then in the indirect path, set gva (and then
> quadrant) based on 'i' iff the guest is using 32-bit paging.
>
> Probably worth making it a separate patch just in case I'm forgetting something.
> Lightly tested...

Looks sane. I'll incorporate something like this in v5.

>
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 5 May 2022 14:19:35 -0700
> Subject: [PATCH] KVM: x86/mmu: Pass '0' for @gva when allocating root with
>  8-byte gpte
>
> Pass '0' instead of the "real" gva when allocating a direct PAE root,
> a.k.a. a direct PDPTE, and when allocating indirect roots that shadow
> 64-bit / 8-byte GPTEs.
>
> Thee @gva is only needed if the root is shadowing 32-bit paging in the
> guest, in which case KVM needs to use different shadow pages for each of
> the two 4-byte GPTEs covered by KVM's 8-byte PAE SPTE.
>
> For direct MMUs, there's obviously no shadowing, and for indirect MMU
>
> In anticipation of moving the quadrant logic into mmu_alloc_root(), WARN
> if a non-zero @gva is passed for !4-byte GPTEs, and WARN if 4-byte GPTEs
> are ever combined with a direct root (there's no shadowing, so TDP roots
> should ignore the GPTE size).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dc20eccd6a77..6dfa3cfa8394 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3313,8 +3313,12 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
>  static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
>                             u8 level, bool direct)
>  {
> +       union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
>         struct kvm_mmu_page *sp;
>
> +       WARN_ON_ONCE(gva && !role.has_4_byte_gpte);
> +       WARN_ON_ONCE(direct && role.has_4_byte_gpte);
> +
>         sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
>         ++sp->root_count;
>
> @@ -3349,8 +3353,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>                 for (i = 0; i < 4; ++i) {
>                         WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
>
> -                       root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
> -                                             i << 30, PT32_ROOT_LEVEL, true);
> +                       root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), 0,
> +                                             PT32_ROOT_LEVEL, true);
>                         mmu->pae_root[i] = root | PT_PRESENT_MASK |
>                                            shadow_me_mask;
>                 }
> @@ -3435,6 +3439,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>         u64 pdptrs[4], pm_mask;
>         gfn_t root_gfn, root_pgd;
>         hpa_t root;
> +       gva_t gva;
>         unsigned i;
>         int r;
>
> @@ -3508,6 +3513,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>                 }
>         }
>
> +       gva = 0;
>         for (i = 0; i < 4; ++i) {
>                 WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
>
> @@ -3517,9 +3523,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>                                 continue;
>                         }
>                         root_gfn = pdptrs[i] >> PAGE_SHIFT;
> +               } else if (mmu->cpu_role.base.level == PT32_ROOT_LEVEL) {
> +                       gva = i << 30;
>                 }
>
> -               root = mmu_alloc_root(vcpu, root_gfn, i << 30,
> +               root = mmu_alloc_root(vcpu, root_gfn, gva,
>                                       PT32_ROOT_LEVEL, false);
>                 mmu->pae_root[i] = root | pm_mask;
>         }
>
> base-commit: 8bae380ad7dd3c31266d3685841ea4ce574d462d
> --
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
