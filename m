Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6E81A0BD1
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733844601; cv=none; b=BXhAUamogbYJPxNouzNiA0SiJW4fWxBRobwhPf+K7QbKyWko3YzLOnJ9PvD1AuKJARU6Oo43hNJW3/iE+YMfvCjrR8/Q19cfNq4wnqgz6AJp+W3JTDieYrh3U6AJ6raBHDRNPEdFPPLjJSTwoEuo6yBB7FzJ54N1Pl4C9a+7l1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733844601; c=relaxed/simple;
	bh=Ftg4loZLuAZjVclMlrHD4ge6jWg64HZAD6eY521DTWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/jzTUME0XT7Zi47h47ab1d3bNRwU+4cZ+2ZZvyAdtLn6DmKzqucQlaGL1JuOVUy3UbQJqKWouPY80Ap9BxtaZp2L8Bijst8z1a2npSHlkgIL36xx51R5lCRm15RLTfBGsPIe6d4DZCdrLrgmqW01NXX2S7NhuEeHfYwgIbO7vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TntlXjcT; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TntlXjcT"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d27243ba8bso8509930a12.2
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 07:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733844598; x=1734449398; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RdjKxo+NrUniCbPIw5SczIYsjDTY5YJeEg6pDWYTro4=;
        b=TntlXjcTEfZIIlulRoo6btTSz/JJHVmMN/cv68Nwg4HTEmtpQp8+snX4UiGB8KHXJ5
         vAMCewFD/ovm/qElxfpgpbrTyrjAx399ca8T8gZpSIoRQDl5jIYdxy+BZZrUVel0mmE0
         A5muqytUNzjOc6yvRYrPrrMJMIVFt9Z8O2wsP8darx3cVYS4bZYaFpdD0/KK5JSS+fyC
         Vo7NdgyLk1D37XxrEOaCqDxzbEiZzgT1wSQR4/T3AVQHbq9noNPFo+jyJBU91l22E7vq
         av7rAUsIE5cvwtRhzXYHts0Urk7+RwiQw1qXFgfCx9X2ZtSHmFC517BIRtZ22OicLBqK
         ruSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733844598; x=1734449398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RdjKxo+NrUniCbPIw5SczIYsjDTY5YJeEg6pDWYTro4=;
        b=OnA8wRnKUwGdA1sSJxdn9mIOkcOHo3jpGhwNSPaI/67kXr4lfWewSdTbqBI2St1hnd
         zBlGjcufn9CLZDYeDRkYpC85N8+zvo0te1r/2ZfiVFQ1c9ZBSSM7kMjZKsov3uaA/KcW
         KVHm6frGpNypfoxS1XFZUphGUkVWDYnfR0UAhVkC23SUqkpbsN/KglGglHsxDJS5kLXB
         /ULFJdDiUbcAVRgIqRh5pe/p7gVqL+xlIWg7DbhFzvyOkGhLPZJNnI3PSR1phdf/jG9g
         cvgm3Wjnw2M8OMw2sbsCwfHlxVVStwKC9x92G8EGGRCOz5BmP0elcaN67a/KzN+EjXB3
         893Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/VEHhBq4VEE7Q/f8LI5pALcWqE6ave5AXAYyPuZa7UzIWsHHVbSO3tk3PFD3j9m6e1b6nh6c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyra6w4L2ABt2HmXTJ/caYRs4XLgnmq+Dd+klhyOU5BSl9AuwWM
	I7YeyBvKcV3tRl9X8lqoa9LS9Fr6Iz57/5FrBN4vzfJ2U+ZSAf+/BykvLXh2Bohv2cCdFiWP19s
	MJg==
X-Gm-Gg: ASbGncstm/NzJ2CJpmXGd+q4chfsn/Ev3xqFiWAr2eaFBWcQOaFibjThA1yKpOV4rZr
	9T+FwJpCeI1esQqRZXgNL0An5QhobxXsVOyD8HfHc6NdSeC1L4v+gvC+RnjLZafqb72pdlV/YLG
	stYhU+/oSWeN5XQjHljO7tqfxS3DH4u4HMF9XwPoaCMZrYqOcVeukJySSm5IwhAVUp+pD/Gr6Nk
	GikqhsbwaIcsdMswDCjHA1zTYSAT9I7Dnf3rzlcLO3xEO9sHvE54Gkjf3TLv4cxszzWtYdEHI7e
	yvUq2mRtli+l
X-Google-Smtp-Source: AGHT+IGg6WnoskYZdn9xOLfCiAAV+gyaqLcb0WFqoPlhvQYJd6IR9c361Akqel8PHMAiNRU5MHkhRA==
X-Received: by 2002:a05:6402:1e90:b0:5d0:d610:caa2 with SMTP id 4fb4d7f45d1cf-5d4185fe2aamr5885624a12.26.1733844597597;
        Tue, 10 Dec 2024 07:29:57 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3d76f3892sm5560295a12.28.2024.12.10.07.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 07:29:57 -0800 (PST)
Date: Tue, 10 Dec 2024 15:29:54 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/18] KVM: arm64: Move host page ownership tracking
 to the hyp vmemmap
Message-ID: <Z1heckLsqrCBF6Nw@google.com>
References: <20241203103735.2267589-1-qperret@google.com>
 <20241203103735.2267589-5-qperret@google.com>
 <CA+EHjTx13V1BcyWEAjNSC0JCxr+dSUvutC7z2KSRu_8jwV_Vxw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTx13V1BcyWEAjNSC0JCxr+dSUvutC7z2KSRu_8jwV_Vxw@mail.gmail.com>

Hey Fuad,

On Tuesday 10 Dec 2024 at 13:02:45 (+0000), Fuad Tabba wrote:
> Hi Quentin,
> 
> On Tue, 3 Dec 2024 at 10:37, Quentin Perret <qperret@google.com> wrote:
> >
> > We currently store part of the page-tracking state in PTE software bits
> > for the host, guests and the hypervisor. This is sub-optimal when e.g.
> > sharing pages as this forces to break block mappings purely to support
> > this software tracking. This causes an unnecessarily fragmented stage-2
> > page-table for the host in particular when it shares pages with Secure,
> > which can lead to measurable regressions. Moreover, having this state
> > stored in the page-table forces us to do multiple costly walks on the
> > page transition path, hence causing overhead.
> >
> > In order to work around these problems, move the host-side page-tracking
> > logic from SW bits in its stage-2 PTEs to the hypervisor's vmemmap.
> >
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/nvhe/memory.h |  6 +-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 94 ++++++++++++++++--------
> >  arch/arm64/kvm/hyp/nvhe/setup.c          |  7 +-
> >  3 files changed, 71 insertions(+), 36 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > index 88cb8ff9e769..08f3a0416d4c 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> > @@ -8,7 +8,7 @@
> >  #include <linux/types.h>
> >
> >  /*
> > - * SW bits 0-1 are reserved to track the memory ownership state of each page:
> > + * Bits 0-1 are reserved to track the memory ownership state of each page:
> >   *   00: The page is owned exclusively by the page-table owner.
> >   *   01: The page is owned by the page-table owner, but is shared
> >   *       with another entity.
> 
> Not shown in this patch, but a couple of lines below, you might want
> to update the comment on PKVM_NOPAGE to fix the reference to "PTE's SW
> bits":

I actually think the comment is still correct -- PKVM_NOPAGE never goes
in the software bits, with or without this patch, so I figured we could
leave it as-is. But happy to reword if you have a good idea :)

> > /* Meta-states which aren't encoded directly in the PTE's SW bits */
> > PKVM_NOPAGE = BIT(2),
> 
> > @@ -44,7 +44,9 @@ static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
> >  struct hyp_page {
> >         u16 refcount;
> >         u8 order;
> > -       u8 reserved;
> > +
> > +       /* Host (non-meta) state. Guarded by the host stage-2 lock. */
> > +       enum pkvm_page_state host_state : 8;
> >  };
> >
> >  extern u64 __hyp_vmemmap;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index caba3e4bd09e..1595081c4f6b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -201,8 +201,8 @@ static void *guest_s2_zalloc_page(void *mc)
> >
> >         memset(addr, 0, PAGE_SIZE);
> >         p = hyp_virt_to_page(addr);
> > -       memset(p, 0, sizeof(*p));
> >         p->refcount = 1;
> > +       p->order = 0;
> >
> >         return addr;
> >  }
> > @@ -268,6 +268,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
> >
> >  void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
> >  {
> > +       struct hyp_page *page;
> >         void *addr;
> >
> >         /* Dump all pgtable pages in the hyp_pool */
> > @@ -279,7 +280,9 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
> >         /* Drain the hyp_pool into the memcache */
> >         addr = hyp_alloc_pages(&vm->pool, 0);
> >         while (addr) {
> > -               memset(hyp_virt_to_page(addr), 0, sizeof(struct hyp_page));
> > +               page = hyp_virt_to_page(addr);
> > +               page->refcount = 0;
> > +               page->order = 0;
> >                 push_hyp_memcache(mc, addr, hyp_virt_to_phys);
> >                 WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
> >                 addr = hyp_alloc_pages(&vm->pool, 0);
> > @@ -382,19 +385,25 @@ bool addr_is_memory(phys_addr_t phys)
> >         return !!find_mem_range(phys, &range);
> >  }
> >
> > -static bool addr_is_allowed_memory(phys_addr_t phys)
> > +static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
> > +{
> > +       return range->start <= addr && addr < range->end;
> > +}
> > +
> > +static int range_is_allowed_memory(u64 start, u64 end)
> 
> The name of this function "range_*is*_..." implies that it returns a
> boolean, which other functions in this file (and patch) with similar
> names do, but it returns an error instead. Maybe
> check_range_allowed_memory)?

Ack, I'll rename in v3.

> >  {
> >         struct memblock_region *reg;
> >         struct kvm_mem_range range;
> >
> > -       reg = find_mem_range(phys, &range);
> > +       /* Can't check the state of both MMIO and memory regions at once */
> 
> I don't understand this comment in relation to the code. Could you
> explain it to me please?

find_mem_range() will iterate the list of memblocks to find the 'range'
in which @start falls. That might either be in a memblock (so @addr is
memory, and @reg != NULL) or outside of one (so @addr is mmio, and
@reg == NULL). The check right after ensures that @end is in the same
PA range as @start. IOW, this checks that [start, end[ doesn't overlap
memory and MMIO, because the following logic wouldn't work for a mixed
case like that.

> > +       reg = find_mem_range(start, &range);
> > +       if (!is_in_mem_range(end - 1, &range))
> > +               return -EINVAL;
> >
> > -       return reg && !(reg->flags & MEMBLOCK_NOMAP);
> > -}
> > +       if (!reg || reg->flags & MEMBLOCK_NOMAP)
> > +               return -EPERM;
> >
> > -static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
> > -{
> > -       return range->start <= addr && addr < range->end;
> > +       return 0;
> >  }
> >
> >  static bool range_is_memory(u64 start, u64 end)
> > @@ -454,8 +463,11 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
> >         if (kvm_pte_valid(pte))
> >                 return -EAGAIN;
> >
> > -       if (pte)
> > +       if (pte) {
> > +               WARN_ON(addr_is_memory(addr) &&
> > +                       !(hyp_phys_to_page(addr)->host_state & PKVM_NOPAGE));
> 
> nit: since the host state is now an enum, should this just be an
> equality check rather than an &? This makes it consistent with other
> checks of pkvm_page_state in this patch too.

We don't currently have a state that is additive to PKVM_NOPAGE, so no
objection from me.

> >                 return -EPERM;
> > +       }
> >
> >         do {
> >                 u64 granule = kvm_granule_size(level);
> > @@ -477,10 +489,29 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
> >         return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
> >  }
> >
> > +static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_state state)
> > +{
> > +       phys_addr_t end = addr + size;
> 
> nit: newline
> 
> > +       for (; addr < end; addr += PAGE_SIZE)
> > +               hyp_phys_to_page(addr)->host_state = state;
> > +}
> > +
> >  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> >  {
> > -       return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
> > -                              addr, size, &host_s2_pool, owner_id);
> > +       int ret;
> > +
> > +       ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
> > +                             addr, size, &host_s2_pool, owner_id);
> > +       if (ret || !addr_is_memory(addr))
> > +               return ret;
> 
> Can hyp set an owner for an address that isn't memory? Trying to
> understand why we need to update the host stage2 pagetable but not the
> hypervisor's vmemmap in that case.

I think the answer is not currently, but we will when we'll have to e.g.
donate IOMMU registers to EL2 and things of that nature. Note that this
does require an extension to __host_check_page_state_range() to go query
the page-table 'the old way' for MMIO addresses, though that isn't done
in this series. If you think strongly that this is confusing, I'm happy
to drop that check and we'll add it back with the IOMMU series or
something like that.

> > +
> > +       /* Don't forget to update the vmemmap tracking for the host */
> > +       if (owner_id == PKVM_ID_HOST)
> > +               __host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> > +       else
> > +               __host_update_page_state(addr, size, PKVM_NOPAGE);
> > +
> > +       return 0;
> >  }
> >
> >  static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
> > @@ -604,35 +635,38 @@ static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
> >         return kvm_pgtable_walk(pgt, addr, size, &walker);
> >  }
> >
> > -static enum pkvm_page_state host_get_page_state(kvm_pte_t pte, u64 addr)
> > -{
> > -       if (!addr_is_allowed_memory(addr))
> > -               return PKVM_NOPAGE;
> > -
> > -       if (!kvm_pte_valid(pte) && pte)
> > -               return PKVM_NOPAGE;
> > -
> > -       return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
> > -}
> > -
> >  static int __host_check_page_state_range(u64 addr, u64 size,
> >                                          enum pkvm_page_state state)
> >  {
> > -       struct check_walk_data d = {
> > -               .desired        = state,
> > -               .get_page_state = host_get_page_state,
> > -       };
> > +       u64 end = addr + size;
> > +       int ret;
> > +
> > +       ret = range_is_allowed_memory(addr, end);
> > +       if (ret)
> > +               return ret;
> >
> >         hyp_assert_lock_held(&host_mmu.lock);
> > -       return check_page_state_range(&host_mmu.pgt, addr, size, &d);
> > +       for (; addr < end; addr += PAGE_SIZE) {
> > +               if (hyp_phys_to_page(addr)->host_state != state)
> > +                       return -EPERM;
> > +       }
> > +
> > +       return 0;
> >  }
> >
> >  static int __host_set_page_state_range(u64 addr, u64 size,
> >                                        enum pkvm_page_state state)
> >  {
> > -       enum kvm_pgtable_prot prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, state);
> > +       if (hyp_phys_to_page(addr)->host_state & PKVM_NOPAGE) {
> 
> Same nit as above regarding checking for PKVM_NOPAGE
> 
> Cheers,
> /fuad
> 
> 
> > +               int ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
> >
> > -       return host_stage2_idmap_locked(addr, size, prot);
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
> > +       __host_update_page_state(addr, size, state);
> > +
> > +       return 0;
> >  }
> >
> >  static int host_request_owned_transition(u64 *completer_addr,
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index cbdd18cd3f98..7e04d1c2a03d 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -180,7 +180,6 @@ static void hpool_put_page(void *addr)
> >  static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >                                      enum kvm_pgtable_walk_flags visit)
> >  {
> > -       enum kvm_pgtable_prot prot;
> >         enum pkvm_page_state state;
> >         phys_addr_t phys;
> >
> > @@ -203,16 +202,16 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
> >         case PKVM_PAGE_OWNED:
> >                 return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
> >         case PKVM_PAGE_SHARED_OWNED:
> > -               prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_BORROWED);
> > +               hyp_phys_to_page(phys)->host_state = PKVM_PAGE_SHARED_BORROWED;
> >                 break;
> >         case PKVM_PAGE_SHARED_BORROWED:
> > -               prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_OWNED);
> > +               hyp_phys_to_page(phys)->host_state = PKVM_PAGE_SHARED_OWNED;
> >                 break;
> >         default:
> >                 return -EINVAL;
> >         }
> >
> > -       return host_stage2_idmap_locked(phys, PAGE_SIZE, prot);
> > +       return 0;
> >  }
> >
> >  static int fix_hyp_pgtable_refcnt_walker(const struct kvm_pgtable_visit_ctx *ctx,
> > --
> > 2.47.0.338.g60cca15819-goog
> >
