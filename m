Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A708C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 06:04:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5193B40F93;
	Tue, 10 May 2022 02:04:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JldFbQDVkOKQ; Tue, 10 May 2022 02:04:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE1B44B2BF;
	Tue, 10 May 2022 02:04:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D48249F03
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:31:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sC4JSO+CUW12 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 17:31:41 -0400 (EDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C94F49F01
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 17:31:41 -0400 (EDT)
Received: by mail-lf1-f53.google.com with SMTP id w19so26056147lfu.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 14:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=t0kmXUFkEnnqKC9/sQ+0m3ugBE/G5/Z0l/BkNE/gds8=;
 b=BdJ89P7pwKQktoMATyevsOvT5VFT+xw7I8G3ieZ3PohzylwG947+aUTq7rIi7mu6sw
 rbvunQUi7D9Y2dC2O3GpZnq4iGvNjB8+txs9MrAEXhJ6LG6nw26rGuE9O+3Znay9iqMR
 clIMCPrJneX+9F6Rcq1e7rTcCoegMkdpEyo2JvIHyYvsmiTn8nKhFr8FifuTLM9ohfab
 cQSsH45pFWh8io6LMqdtp8aOAFKiiHh5MbHxWq/+lCtMX9s98a8M9/96jCGuO824cm/b
 7hNDNiXIMKyktw43l+RamUBXwYeBu7hSx04Ua7HjNIq+0L2hgW8QE3Wcw8xf0p2ZUAGk
 rP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=t0kmXUFkEnnqKC9/sQ+0m3ugBE/G5/Z0l/BkNE/gds8=;
 b=mwyyqFhkA7JhjJZWeYrgLpTMyFLMWvFHMhUYlH4clft8TF4+oLlkCC+lQSmL0QctB1
 WoEhh4ygplJQ0UnTUYW/PjJ+ooD1W7hZTr+UibrlQgipDTHrTF2CdTEGjB/5zOPw8ZXs
 yBKnBYK7P0NN+Kac4ukIapMtL9/sPSdzUTqYW/xvsTsSHEWYQcQy/RVeuM8u5ALy33bH
 tKO+nFaZCwzl81L/cP9EE1svd2Zffd0Ps+rkC8fvhdHXlhq40NVV0Ifu4JbSP4TFoo6Z
 LboMFBCvzo+rNIuns1VF8UdwbVpl/DF/a+AQoWZlsOaKnPE0vUixuWNy5D5dSlfMfDd0
 H7dg==
X-Gm-Message-State: AOAM531/oNy/9gUQv3bYH452fsxgwXXianImou3Pc99cMNLRU2izQE1z
 JvSQDB7UXsP6YPxkKdYMdvXIt1bgT1B+jF1bcaNLMw==
X-Google-Smtp-Source: ABdhPJzAW1GKaJd0gxsaE4D0hl1sp51777eCufAYMr+dFKb74Wcs3khrPmyQWdNS3nCNB5gg32yUvXVVNtOGgs4pisc=
X-Received: by 2002:ac2:5399:0:b0:472:1f95:85df with SMTP id
 g25-20020ac25399000000b004721f9585dfmr13934735lfh.102.1652131899487; Mon, 09
 May 2022 14:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-17-dmatlack@google.com>
 <Ynk/vnHQsXnZkMGT@google.com>
In-Reply-To: <Ynk/vnHQsXnZkMGT@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 9 May 2022 14:31:13 -0700
Message-ID: <CALzav=dZ+FQKGy=ujzV_bOCpX-UGuN-k02YugOSDYJUyax538w@mail.gmail.com>
Subject: Re: [PATCH v4 16/20] KVM: x86/mmu: Extend make_huge_page_split_spte()
 for the shadow MMU
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

On Mon, May 9, 2022 at 9:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > Currently make_huge_page_split_spte() assumes execute permissions can be
> > granted to any 4K SPTE when splitting huge pages. This is true for the
> > TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
> > shadowing a non-executable huge page.
> >
> > To fix this, pass in the child shadow page where the huge page will be
> > split and derive the execution permission from the shadow page's role.
> > This is correct because huge pages are always split with direct shadow
> > page and thus the shadow page role contains the correct access
> > permissions.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/spte.c    | 13 +++++++------
> >  arch/x86/kvm/mmu/spte.h    |  2 +-
> >  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
> >  3 files changed, 9 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> > index 4739b53c9734..9db98fbeee61 100644
> > --- a/arch/x86/kvm/mmu/spte.c
> > +++ b/arch/x86/kvm/mmu/spte.c
> > @@ -215,10 +215,11 @@ static u64 make_spte_executable(u64 spte)
> >   * This is used during huge page splitting to build the SPTEs that make up the
> >   * new page table.
> >   */
> > -u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
> > +u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
>
> Rather than pass in @sp, what about passing in @role?  Then the need for
> exec_allowed and child_level goes away (for whatever reason I reacted to the
> "allowed" part of exec_allowed).

I like it! Will do.

>
> E.g.
>
> ---
>  arch/x86/kvm/mmu/spte.c    | 11 +++++------
>  arch/x86/kvm/mmu/spte.h    |  3 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 9db98fbeee61..1b766e381727 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -215,10 +215,9 @@ static u64 make_spte_executable(u64 spte)
>   * This is used during huge page splitting to build the SPTEs that make up the
>   * new page table.
>   */
> -u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
> +u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
> +                             int index)
>  {
> -       bool exec_allowed = sp->role.access & ACC_EXEC_MASK;
> -       int child_level = sp->role.level;
>         u64 child_spte;
>
>         if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
> @@ -234,9 +233,9 @@ u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
>          * split. So we just have to OR in the offset to the page at the next
>          * lower level for the given index.
>          */
> -       child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
> +       child_spte |= (index * KVM_PAGES_PER_HPAGE(role.level)) << PAGE_SHIFT;
>
> -       if (child_level == PG_LEVEL_4K) {
> +       if (role.level == PG_LEVEL_4K) {
>                 child_spte &= ~PT_PAGE_SIZE_MASK;
>
>                 /*
> @@ -244,7 +243,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
>                  * the page executable as the NX hugepage mitigation no longer
>                  * applies.
>                  */
> -               if (exec_allowed && is_nx_huge_page_enabled())
> +               if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled())
>                         child_spte = make_spte_executable(child_spte);
>         }
>
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 921ea77f1b5e..80d36d0d9def 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>                unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
>                u64 old_spte, bool prefetch, bool can_unsync,
>                bool host_writable, u64 *new_spte);
> -u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index);
> +u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
> +                             int index);
>  u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
>  u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
>  u64 mark_spte_for_access_track(u64 spte);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 110a34ca41c2..c4c4bad69f38 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1469,7 +1469,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>          * not been linked in yet and thus is not reachable from any other CPU.
>          */
>         for (i = 0; i < PT64_ENT_PER_PAGE; i++)
> -               sp->spt[i] = make_huge_page_split_spte(huge_spte, sp, i);
> +               sp->spt[i] = make_huge_page_split_spte(huge_spte, sp->role, i);
>
>         /*
>          * Replace the huge spte with a pointer to the populated lower level
>
> base-commit: 721828e2397ab854b536de3ea10a9bc7962091a9
> --
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
