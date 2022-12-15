Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DDF210D
	for <kvmarm@lists.linux.dev>; Thu, 15 Dec 2022 07:20:22 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id js9so9580335pjb.2
        for <kvmarm@lists.linux.dev>; Wed, 14 Dec 2022 23:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4uLeHcZtzofTghZFHPOPuZ9VgdcE81MAIlKpIRuDJg=;
        b=IwzHNMOm4TvS7kkfFEjAJOWMP9YW2EYrO0MMRKT/jg27AsW0WlwRdcLD96qzPSJcfX
         pQKKTmr2X2RKIg/BhprlLIqDSoy1+iDp+dtLOqJrP/d7w7qcX7t+OgShWHND/7vTjG4Y
         Q6Roz1gbwEqC99XkPSrYrtLbCtGCzHEEHyy32bhQJJq29mDQK92h4JXK/pWXTr63KQqu
         uPGNZzq+TfPKjunZyG//wCHotmbf1a1dg0+rp5OhtojJ9U0XP0ycqNaWuvhj2ywByGMJ
         ephbpBk6dUwYjaM5jwk8Gg9A/g2U11YxQ9214Uq5KuTh8BUANseKHXTsBT2mFG/2xi52
         +F7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4uLeHcZtzofTghZFHPOPuZ9VgdcE81MAIlKpIRuDJg=;
        b=3YdQoZ+rmem7J3D6GrZ3h97bMv4zFy6hY3eU8/caykhm8yWPCY5iTFclw/ApKdNIwl
         /5HgwMqzFVCygsC6y3CcHRPMTQahNnf+u/r1CqiGn+FDEgesAX2XU0fqKoa9G15pShX8
         1uZJe3ZFw1vtrQE1MtsBnVacFNK4BDYaPo6RSXAFjPIhoEWa761UxybAKobw0c6Es8S1
         vLfeAfuD9GuL/E1WwohDAUc/sVQ+sLOVGGOnZCS+EB1aZYb9Y7dKC2auegO9BZcrPSA8
         RVEu1nTCy4b+U1WXeZDAc9MkILIXlS7BNW2IxEZPhRlZxbakmN+aD7JvQduPtlpOJxKM
         nMzQ==
X-Gm-Message-State: ANoB5pmTj7dwWuykxJwxPBmjQlpaABgqZy/0vHni5tB/IweiVnZvZDYl
	I/NkQPOUndLYAGP0HaqiYOoLpARaH3HfYEBr4f0=
X-Google-Smtp-Source: AA0mqf70UYNX/pPo/w6ANwfR+n34rLQhoD2MXPvsGPOcNr9eDBW5vpBxbT/XZ+XrXkJH0q3VVxI89RaN33bsL4wogUY=
X-Received: by 2002:a17:903:3052:b0:189:651c:f023 with SMTP id
 u18-20020a170903305200b00189651cf023mr64145214pla.78.1671088821805; Wed, 14
 Dec 2022 23:20:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com> <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com> <CAJhGHyBbjyKVEv3KcoOcPGQ28753FjR_rc9uNDEF3Dd-gNTRGQ@mail.gmail.com>
 <Y5onJulY3UQJNrmW@google.com>
In-Reply-To: <Y5onJulY3UQJNrmW@google.com>
From: Lai Jiangshan <jiangshanlai@gmail.com>
Date: Thu, 15 Dec 2022 15:20:09 +0800
Message-ID: <CAJhGHyBKttit3okKbBsG2U7y4Fr8TjVWHVTQWrcCr8JcUcgtSQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Yang, Weijiang" <weijiang.yang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	"Amit, Nadav" <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, 
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221215072009.AbLV1WGJX-h2QUFPgO0Vkti35okZLzaka3IB0HVGfGw@z>

On Thu, Dec 15, 2022 at 3:42 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Dec 14, 2022, Lai Jiangshan wrote:
> > On Tue, Dec 13, 2022 at 1:47 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > >
> > > My preference would be to leave .smm in x86's page role.  IMO, defining multiple
> > > address spaces to support SMM emulation was a mistake that should be contained to
> > > SMM, i.e. should never be used for any other feature.  And with CONFIG_KVM_SMM,
> > > even x86 can opt out.
> > >
> >
> >
> > I think the name ASID in kvm/x86 should be used for vmcb's ASID,
> > vmcs's VPID, and PCID. Using the name ASID for other purposes
> > would only result in unnecessary confusion.
>
> I agree in principle, but at this point fixing the problem would require a lot of
> churn since "as_id" is pervasive throughout the memslots code.
>
> It should be possible though, as I don't think anything in KVM's uAPI explicitly
> takes an as_id, i.e. it's KVM-internal terminology for the most part.
>
> > There is a bug for shadow paging when it uses two separate sets
> > of memslots which are using two sets of rmap and page-tracking.
> >
> > When SMM world is writing to a non-SMM page which happens to be
> > a guest pagetable in the non-SMM world, the write operation will
> > go smoothly without specially handled and the shadow page for the guest
> > pagetable is neither unshadowed nor marked unsync.  The shadow paging
> > code is unaware that the shadow page has deviated from the guest
> > pagetable.
>
> Won't the unsync code work as intended?  for_each_gfn_valid_sp_with_gptes()
> doesn't consume the slot and I don't see any explicit filtering on role.smm,
> i.e. should unsync all SPTEs for the gfn.
>
> Addressing the page-track case is a bit gross, but doesn't appear to be too
> difficult.  I wouldn't be surprised if there are other SMM => non-SMM bugs lurking
> though.
>
> ---
>  arch/x86/include/asm/kvm_page_track.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c                |  7 +++---
>  arch/x86/kvm/mmu/mmu_internal.h       |  3 ++-
>  arch/x86/kvm/mmu/page_track.c         | 32 +++++++++++++++++++--------
>  arch/x86/kvm/mmu/spte.c               |  2 +-
>  5 files changed, 31 insertions(+), 15 deletions(-)

Could you send the patch in a new thread, please?

I will add my reviewed-by then.

It still lacks the parts that do write protection for sp->gfn.
kvm_vcpu_write_protect_gfn() has to handle the two worlds.
account_shadowed() and kvm_slot_page_track_add_page() have also
to handle the two worlds.

And I don't think there is any page-table in SMM-world, so
kvm_slot_page_track_is_active() can just skip the SMM-world
and check the non-SMM world only.

Thanks
Lai

>
> diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> index eb186bc57f6a..fdd9de31e160 100644
> --- a/arch/x86/include/asm/kvm_page_track.h
> +++ b/arch/x86/include/asm/kvm_page_track.h
> @@ -63,7 +63,7 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
>  void kvm_slot_page_track_remove_page(struct kvm *kvm,
>                                      struct kvm_memory_slot *slot, gfn_t gfn,
>                                      enum kvm_page_track_mode mode);
> -bool kvm_slot_page_track_is_active(struct kvm *kvm,
> +bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
>                                    const struct kvm_memory_slot *slot,
>                                    gfn_t gfn, enum kvm_page_track_mode mode);
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 254bc46234e0..1c2200042133 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2715,9 +2715,10 @@ static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>   * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
>   * be write-protected.
>   */
> -int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
> +int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
>                             gfn_t gfn, bool can_unsync, bool prefetch)
>  {
> +       struct kvm *kvm = vcpu->kvm;
>         struct kvm_mmu_page *sp;
>         bool locked = false;
>
> @@ -2726,7 +2727,7 @@ int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
>          * track machinery is used to write-protect upper-level shadow pages,
>          * i.e. this guards the role.level == 4K assertion below!
>          */
> -       if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
> +       if (kvm_slot_page_track_is_active(vcpu, slot, gfn, KVM_PAGE_TRACK_WRITE))
>                 return -EPERM;
>
>         /*
> @@ -4127,7 +4128,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
>          * guest is writing the page which is write tracked which can
>          * not be fixed by page fault handler.
>          */
> -       if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
> +       if (kvm_slot_page_track_is_active(vcpu, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
>                 return true;
>
>         return false;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index ac00bfbf32f6..38040ab27986 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -156,7 +156,8 @@ static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
>         return kvm_x86_ops.cpu_dirty_log_size && sp->role.guest_mode;
>  }
>
> -int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
> +int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu,
> +                           const struct kvm_memory_slot *slot,
>                             gfn_t gfn, bool can_unsync, bool prefetch);
>
>  void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
> diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> index 2e09d1b6249f..0e9bc837257e 100644
> --- a/arch/x86/kvm/mmu/page_track.c
> +++ b/arch/x86/kvm/mmu/page_track.c
> @@ -18,6 +18,7 @@
>
>  #include "mmu.h"
>  #include "mmu_internal.h"
> +#include "smm.h"
>
>  bool kvm_page_track_write_tracking_enabled(struct kvm *kvm)
>  {
> @@ -171,27 +172,40 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
>  }
>  EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
>
> +static bool __kvm_slot_page_track_is_active(const struct kvm_memory_slot *slot,
> +                                           gfn_t gfn, enum kvm_page_track_mode mode)
> +{
> +       int index;
> +
> +       if (!slot)
> +               return false;
> +
> +       index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
> +       return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
> +}
> +
>  /*
>   * check if the corresponding access on the specified guest page is tracked.
>   */
> -bool kvm_slot_page_track_is_active(struct kvm *kvm,
> +bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
>                                    const struct kvm_memory_slot *slot,
>                                    gfn_t gfn, enum kvm_page_track_mode mode)
>  {
> -       int index;
> -
>         if (WARN_ON(!page_track_mode_is_valid(mode)))
>                 return false;
>
> -       if (!slot)
> -               return false;
> -
>         if (mode == KVM_PAGE_TRACK_WRITE &&
> -           !kvm_page_track_write_tracking_enabled(kvm))
> +           !kvm_page_track_write_tracking_enabled(vcpu->kvm))
>                 return false;
>
> -       index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
> -       return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
> +       if (__kvm_slot_page_track_is_active(slot, gfn, mode))
> +               return true;
> +
> +       if (!is_smm(vcpu))
> +               return false;
> +
> +       return __kvm_slot_page_track_is_active(gfn_to_memslot(vcpu->kvm, gfn),
> +                                              gfn, mode);
>  }
>
>  void kvm_page_track_cleanup(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index c0fd7e049b4e..89ddd113c1b9 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -220,7 +220,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>                  * e.g. it's write-tracked (upper-level SPs) or has one or more
>                  * shadow pages and unsync'ing pages is not allowed.
>                  */
> -               if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
> +               if (mmu_try_to_unsync_pages(vcpu, slot, gfn, can_unsync, prefetch)) {
>                         pgprintk("%s: found shadow page for %llx, marking ro\n",
>                                  __func__, gfn);
>                         wrprot = true;
>
> base-commit: e0ef1f14e97ff65adf6e2157952dbbd1e482065c
> --
>
