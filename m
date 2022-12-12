Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2BAC4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 18:24:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4511B4B948;
	Mon, 12 Dec 2022 13:24:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9HFqcsADhSFc; Mon, 12 Dec 2022 13:24:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71D7B4B953;
	Mon, 12 Dec 2022 13:24:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3C004B948
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 13:24:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RW0+MslswBe6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 13:24:43 -0500 (EST)
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com
 [209.85.219.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17CC14B947
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 13:24:43 -0500 (EST)
Received: by mail-qv1-f43.google.com with SMTP id h10so8774424qvq.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 10:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=AMcXpU9xF78qNj4uAPl+XF5OMVRy/HcRZ5eu+9Qyxok=;
 b=OwsVpfa01F6Vy1licgfoHfJAh300jir6SR8hGTbRWrx9HTeKg0xZPDCCt+5dd8pusT
 rGbZhVXiQHmIzMeTkfc1aGvwobd/+EdNM6SkF1+VCoUAjUvpbe2hwVzUKkOJuIryOnpw
 kLa95FwRX0IoFYtBZqP2gfUz2LRqfHCcykOPBEuMfRc4Ujt0DOtkDDvFOxcjg/diyIy0
 gPjUEEWEcA4PXdH/TbGxgRrm5JPZ5fSs/GawoWTfeOJEebJzDbDnqJgKFGzQd/JOIVEB
 aRc3NjkudM2tmCsD1JTWZGQLR/EoV9nXjRPHQn7ZIol/iewVFH6MQhvEfI/MCwJPODcm
 v7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=AMcXpU9xF78qNj4uAPl+XF5OMVRy/HcRZ5eu+9Qyxok=;
 b=zPV5hLIRh6RpoOw9kQwbhAD4mqTFAn7m2WN6gPSJfEL5NFhYmPnFSuXx2IduDHdFBK
 0rGDl0vIdVz84pLhXGy2VEvGmX8NrSx/j48sAwtX0A8zLIblTC1YFPKutJk/2C8NMEq6
 ETz0OMRuCt2IBltAjX43xnFa2tNDorx/Kbf+g9OcP2Mp++rZMHcvveFDEmDplqBK66gt
 hM0XPYxdSgaOXLQCze9cHIQ55dmd61Wj/dbOzIwbHfRwgJDmUqJhJY5ZZUnXbRbjxAVz
 tsQ+qsswzKxqRS6QNRCqBq7jY8nWIfmG5Mw9vW1whEPlSDP6826ffLeZEVOclYExe51P
 JK7A==
X-Gm-Message-State: ANoB5pmYygnAqWyiICbkTfZt8hj/2VKMpw4z11gaeR2K2/tlENCCm1cz
 WKfksno2omaeTPbN81Ja/4G66t4h2nKAWuQBy8NqYg==
X-Google-Smtp-Source: AA0mqf6fu7BuuPFxqp6T8XG4FGosl4ytNjM6B55YI7JB6FeyGgrfnzSzOHl5Ktl+KxaL+Yjgll/5/5F5JDyyvFAZIlg=
X-Received: by 2002:a0c:e6a9:0:b0:4bb:892a:fc11 with SMTP id
 j9-20020a0ce6a9000000b004bb892afc11mr68548097qvn.28.1670869482342; Mon, 12
 Dec 2022 10:24:42 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-11-dmatlack@google.com>
In-Reply-To: <20221208193857.4090582-11-dmatlack@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 12 Dec 2022 10:24:31 -0800
Message-ID: <CANgfPd-DaxszBe6vLQGe=LKNKx8bDX-AC_30qLVAyYkQXwN7WA@mail.gmail.com>
Subject: Re: [RFC PATCH 10/37] KVM: MMU: Move struct kvm_page_fault to common
 code
To: David Matlack <dmatlack@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
>
> Move struct kvm_page_fault to common code. This will be used in a future
> commit to move the TDP MMU to common code.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/include/asm/kvm/mmu_types.h | 20 +++++++
>  arch/x86/kvm/mmu/mmu.c               | 19 +++----
>  arch/x86/kvm/mmu/mmu_internal.h      | 79 ++++++----------------------
>  arch/x86/kvm/mmu/mmutrace.h          |  2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h       | 14 ++---
>  arch/x86/kvm/mmu/tdp_mmu.c           |  6 +--
>  include/kvm/mmu_types.h              | 44 ++++++++++++++++
>  7 files changed, 100 insertions(+), 84 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm/mmu_types.h b/arch/x86/include/asm/kvm/mmu_types.h
> index affcb520b482..59d1be85f4b7 100644
> --- a/arch/x86/include/asm/kvm/mmu_types.h
> +++ b/arch/x86/include/asm/kvm/mmu_types.h
> @@ -5,6 +5,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/list.h>
>  #include <linux/types.h>
> +#include <linux/kvm_types.h>
>
>  /*
>   * This is a subset of the overall kvm_cpu_role to minimize the size of
> @@ -115,4 +116,23 @@ struct kvm_mmu_page_arch {
>         atomic_t write_flooding_count;
>  };
>
> +struct kvm_page_fault_arch {
> +       const u32 error_code;
> +
> +       /* x86-specific error code bits */
> +       const bool present;
> +       const bool rsvd;
> +       const bool user;
> +
> +       /* Derived from mmu and global state.  */
> +       const bool is_tdp;
> +       const bool nx_huge_page_workaround_enabled;
> +
> +       /*
> +        * Whether a >4KB mapping can be created or is forbidden due to NX
> +        * hugepages.
> +        */
> +       bool huge_page_disallowed;
> +};
> +
>  #endif /* !__ASM_KVM_MMU_TYPES_H */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e47f35878ab5..0593d4a60139 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3092,7 +3092,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>         struct kvm_memory_slot *slot = fault->slot;
>         kvm_pfn_t mask;
>
> -       fault->huge_page_disallowed = fault->exec && fault->nx_huge_page_workaround_enabled;
> +       fault->arch.huge_page_disallowed =
> +               fault->exec && fault->arch.nx_huge_page_workaround_enabled;
>
>         if (unlikely(fault->max_level == PG_LEVEL_4K))
>                 return;
> @@ -3109,7 +3110,7 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>          */
>         fault->req_level = kvm_mmu_max_mapping_level(vcpu->kvm, slot,
>                                                      fault->gfn, fault->max_level);
> -       if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
> +       if (fault->req_level == PG_LEVEL_4K || fault->arch.huge_page_disallowed)
>                 return;
>
>         /*
> @@ -3158,7 +3159,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                  * We cannot overwrite existing page tables with an NX
>                  * large page, as the leaf could be executable.
>                  */
> -               if (fault->nx_huge_page_workaround_enabled)
> +               if (fault->arch.nx_huge_page_workaround_enabled)
>                         disallowed_hugepage_adjust(fault, *it.sptep, it.level);
>
>                 base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
> @@ -3170,7 +3171,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                         continue;
>
>                 link_shadow_page(vcpu, it.sptep, sp);
> -               if (fault->huge_page_disallowed)
> +               if (fault->arch.huge_page_disallowed)
>                         account_nx_huge_page(vcpu->kvm, sp,
>                                              fault->req_level >= it.level);
>         }
> @@ -3221,7 +3222,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>                                    struct kvm_page_fault *fault,
>                                    unsigned int access)
>  {
> -       gva_t gva = fault->is_tdp ? 0 : fault->addr;
> +       gva_t gva = fault->arch.is_tdp ? 0 : fault->addr;
>
>         vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
>                              access & shadow_mmio_access_mask);
> @@ -3255,7 +3256,7 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
>          * generation number.  Refreshing the MMIO generation needs to go down
>          * the slow path.  Note, EPT Misconfigs do NOT set the PRESENT flag!
>          */
> -       if (fault->rsvd)
> +       if (fault->arch.rsvd)
>                 return false;
>
>         /*
> @@ -3273,7 +3274,7 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
>          *    SPTE is MMU-writable (determined later), the fault can be fixed
>          *    by setting the Writable bit, which can be done out of mmu_lock.
>          */
> -       if (!fault->present)
> +       if (!fault->arch.present)
>                 return !kvm_ad_enabled();
>
>         /*
> @@ -4119,10 +4120,10 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
>                                          struct kvm_page_fault *fault)
>  {
> -       if (unlikely(fault->rsvd))
> +       if (unlikely(fault->arch.rsvd))
>                 return false;
>
> -       if (!fault->present || !fault->write)
> +       if (!fault->arch.present || !fault->write)
>                 return false;
>
>         /*
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index af2ae4887e35..4abb80a3bd01 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -77,60 +77,6 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
>         return READ_ONCE(nx_huge_pages) && !kvm->arch.disable_nx_huge_pages;
>  }
>
> -struct kvm_page_fault {
> -       /* arguments to kvm_mmu_do_page_fault.  */
> -       const gpa_t addr;
> -       const u32 error_code;
> -       const bool prefetch;
> -
> -       /* Derived from error_code.  */
> -       const bool exec;
> -       const bool write;
> -       const bool present;
> -       const bool rsvd;
> -       const bool user;
> -
> -       /* Derived from mmu and global state.  */
> -       const bool is_tdp;
> -       const bool nx_huge_page_workaround_enabled;
> -
> -       /*
> -        * Whether a >4KB mapping can be created or is forbidden due to NX
> -        * hugepages.
> -        */
> -       bool huge_page_disallowed;
> -
> -       /*
> -        * Maximum page size that can be created for this fault; input to
> -        * FNAME(fetch), direct_map() and kvm_tdp_mmu_map().
> -        */
> -       u8 max_level;
> -
> -       /*
> -        * Page size that can be created based on the max_level and the
> -        * page size used by the host mapping.
> -        */
> -       u8 req_level;
> -
> -       /*
> -        * Page size that will be created based on the req_level and
> -        * huge_page_disallowed.
> -        */
> -       u8 goal_level;
> -
> -       /* Shifted addr, or result of guest page table walk if addr is a gva.  */
> -       gfn_t gfn;
> -
> -       /* The memslot containing gfn. May be NULL. */
> -       struct kvm_memory_slot *slot;
> -
> -       /* Outputs of kvm_faultin_pfn.  */
> -       unsigned long mmu_seq;
> -       kvm_pfn_t pfn;
> -       hva_t hva;
> -       bool map_writable;
> -};
> -
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>
>  /*
> @@ -164,22 +110,27 @@ enum {
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>                                         u32 err, bool prefetch)
>  {
> +       bool is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault);
>         struct kvm_page_fault fault = {
>                 .addr = cr2_or_gpa,
> -               .error_code = err,
> -               .exec = err & PFERR_FETCH_MASK,
> -               .write = err & PFERR_WRITE_MASK,
> -               .present = err & PFERR_PRESENT_MASK,
> -               .rsvd = err & PFERR_RSVD_MASK,
> -               .user = err & PFERR_USER_MASK,
>                 .prefetch = prefetch,
> -               .is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
> -               .nx_huge_page_workaround_enabled =
> -                       is_nx_huge_page_enabled(vcpu->kvm),
> +
> +               .write = err & PFERR_WRITE_MASK,
> +               .exec = err & PFERR_FETCH_MASK,
>
>                 .max_level = KVM_MAX_HUGEPAGE_LEVEL,
>                 .req_level = PG_LEVEL_4K,
>                 .goal_level = PG_LEVEL_4K,
> +
> +               .arch = {
> +                       .error_code = err,
> +                       .present = err & PFERR_PRESENT_MASK,
> +                       .rsvd = err & PFERR_RSVD_MASK,
> +                       .user = err & PFERR_USER_MASK,
> +                       .is_tdp = is_tdp,
> +                       .nx_huge_page_workaround_enabled =
> +                               is_nx_huge_page_enabled(vcpu->kvm),
> +               },
>         };
>         int r;
>
> @@ -196,7 +147,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>         if (!prefetch)
>                 vcpu->stat.pf_taken++;
>
> -       if (IS_ENABLED(CONFIG_RETPOLINE) && fault.is_tdp)
> +       if (IS_ENABLED(CONFIG_RETPOLINE) && fault.arch.is_tdp)
>                 r = kvm_tdp_page_fault(vcpu, &fault);
>         else
>                 r = vcpu->arch.mmu->page_fault(vcpu, &fault);
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index 335f26dabdf3..b01767acf073 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -270,7 +270,7 @@ TRACE_EVENT(
>         TP_fast_assign(
>                 __entry->vcpu_id = vcpu->vcpu_id;
>                 __entry->cr2_or_gpa = fault->addr;
> -               __entry->error_code = fault->error_code;
> +               __entry->error_code = fault->arch.error_code;
>                 __entry->sptep = sptep;
>                 __entry->old_spte = old_spte;
>                 __entry->new_spte = *sptep;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 18bb92b70a01..daf9c7731edc 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -698,7 +698,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>                  * We cannot overwrite existing page tables with an NX
>                  * large page, as the leaf could be executable.
>                  */
> -               if (fault->nx_huge_page_workaround_enabled)
> +               if (fault->arch.nx_huge_page_workaround_enabled)
>                         disallowed_hugepage_adjust(fault, *it.sptep, it.level);
>
>                 base_gfn = fault->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
> @@ -713,7 +713,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>                         continue;
>
>                 link_shadow_page(vcpu, it.sptep, sp);
> -               if (fault->huge_page_disallowed)
> +               if (fault->arch.huge_page_disallowed)
>                         account_nx_huge_page(vcpu->kvm, sp,
>                                              fault->req_level >= it.level);
>         }
> @@ -793,8 +793,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>         int r;
>         bool is_self_change_mapping;
>
> -       pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
> -       WARN_ON_ONCE(fault->is_tdp);
> +       pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->arch.error_code);
> +       WARN_ON_ONCE(fault->arch.is_tdp);
>
>         /*
>          * Look up the guest pte for the faulting address.
> @@ -802,7 +802,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>          * The bit needs to be cleared before walking guest page tables.
>          */
>         r = FNAME(walk_addr)(&walker, vcpu, fault->addr,
> -                            fault->error_code & ~PFERR_RSVD_MASK);
> +                            fault->arch.error_code & ~PFERR_RSVD_MASK);
>
>         /*
>          * The page is not mapped by the guest.  Let the guest handle it.
> @@ -830,7 +830,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>         vcpu->arch.write_fault_to_shadow_pgtable = false;
>
>         is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
> -             &walker, fault->user, &vcpu->arch.write_fault_to_shadow_pgtable);
> +             &walker, fault->arch.user, &vcpu->arch.write_fault_to_shadow_pgtable);
>
>         if (is_self_change_mapping)
>                 fault->max_level = PG_LEVEL_4K;
> @@ -846,7 +846,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>          * we will cache the incorrect access into mmio spte.
>          */
>         if (fault->write && !(walker.pte_access & ACC_WRITE_MASK) &&
> -           !is_cr0_wp(vcpu->arch.mmu) && !fault->user && fault->slot) {
> +           !is_cr0_wp(vcpu->arch.mmu) && !fault->arch.user && fault->slot) {
>                 walker.pte_access |= ACC_WRITE_MASK;
>                 walker.pte_access &= ~ACC_USER_MASK;
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 66231c7ed31e..4940413d3767 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1156,7 +1156,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
>                 int r;
>
> -               if (fault->nx_huge_page_workaround_enabled)
> +               if (fault->arch.nx_huge_page_workaround_enabled)
>                         disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
>
>                 if (iter.level == fault->goal_level)
> @@ -1181,7 +1181,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                 sp = tdp_mmu_alloc_sp(vcpu);
>                 tdp_mmu_init_child_sp(sp, &iter);
>
> -               sp->arch.nx_huge_page_disallowed = fault->huge_page_disallowed;
> +               sp->arch.nx_huge_page_disallowed = fault->arch.huge_page_disallowed;
>
>                 if (is_shadow_present_pte(iter.old_spte))
>                         r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
> @@ -1197,7 +1197,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>                         goto retry;
>                 }
>
> -               if (fault->huge_page_disallowed &&
> +               if (fault->arch.huge_page_disallowed &&
>                     fault->req_level >= iter.level) {
>                         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>                         track_possible_nx_huge_page(kvm, sp);
> diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
> index a9da33d4baa8..9f0ca920bf68 100644
> --- a/include/kvm/mmu_types.h
> +++ b/include/kvm/mmu_types.h
> @@ -66,4 +66,48 @@ struct kvm_mmu_page {
>         struct kvm_mmu_page_arch arch;
>  };
>
> +struct kvm_page_fault {
> +       /* The raw faulting address. */
> +       const gpa_t addr;
> +
> +       /* Whether the fault was synthesized to prefetch a mapping. */
> +       const bool prefetch;
> +
> +       /* Information about the cause of the fault. */
> +       const bool write;
> +       const bool exec;
> +
> +       /* Shifted addr, or result of guest page table walk if shadow paging. */
> +       gfn_t gfn;

Is this redundant to have in common code? If we're not doing common
shadow paging, then this is just addr shifted. Would this be better
placed in the arch specific struct?

> +
> +       /* The memslot that contains @gfn. May be NULL. */
> +       struct kvm_memory_slot *slot;
> +
> +       /* Maximum page size that can be created for this fault. */
> +       u8 max_level;
> +
> +       /*
> +        * Page size that can be created based on the max_level and the page
> +        * size used by the host mapping.
> +        */
> +       u8 req_level;
> +
> +       /* Final page size that will be created. */
> +       u8 goal_level;
> +
> +       /*
> +        * The value of kvm->mmu_invalidate_seq before fetching the host
> +        * mapping. Used to verify that the host mapping has not changed
> +        * after grabbing the MMU lock.
> +        */
> +       unsigned long mmu_seq;

Should this be ifdef'ed with  KVM_ARCH_WANT_MMU_NOTIFIER?

> +
> +       /* Information about the host mapping. */
> +       kvm_pfn_t pfn;
> +       hva_t hva;
> +       bool map_writable;
> +
> +       struct kvm_page_fault_arch arch;
> +};
> +
>  #endif /* !__KVM_MMU_TYPES_H */
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
