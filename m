Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ABA19B5B4
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425259; cv=none; b=oh3zpiekjci//4/oyNJeoyfmVF6q0EuCqLQ/+YSdVqVM4NNir6oM+4B7NdmzIjp5/4HjQ8PVk9LSJGLH3mkgmjpZzCQWihjqPddgRly1gxozUWnCaC+5wMDlHA2Lxycu3TJEglMFYulqnjjJCErzy2xnNWqpKv4dmlnXwJmUVz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425259; c=relaxed/simple;
	bh=HQBVM1bY6318JGK+RLisUREKBGbdSBEQCrai9x+uRLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sIIne5bgHRau9btZ7Tyj8dCAAq6wtw5DwKwsaFGVNJYJVFP5JUft13Kxf4qm0pk9DEZhPRudsxNT4S4MO1/S+06WOR7k5xwK1XnwzOWkDVIkmQhOEJJg3wlCdQK6jEaiXRQ9lSLTjr4q0rSMKTr0Jbx5UM9UH2K6wQeYjqgAqEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P7ekM1Je; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P7ekM1Je"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4361d5730caso27105e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425256; x=1735030056; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TDDJBYOHP75ThTGcuMvIwooq7g+u4EFaZTyJ2gC5szU=;
        b=P7ekM1Jej/tM9IufE/acbM09Zelxn3cWEIx2Cp7BQNLG2NxPewWa1xjYEQ/I2Qd4a3
         qL6Au+jxJgped9deg6PIKcHF6aOoaj1yTygCVNSEB7k8B68DTTxtfvERxxpSqcsrxvB+
         0hpLiLNQNouPVzYAATWNk23JfvD/wDE+3Pn4P1QKmOkH2k6XQCp5RiRLJbVQ7ZBZ6hpG
         QAVT2u/MgvYU77MmImssrMSHh7epPSqtKEzM7aSsBe3XG3XpjycDsK5Ybx6JLtqv5O6E
         NMJjBwxJ30A5aS6lEhwEhjWkX6c0M6BU0vSFjX2mC60RLXs4Gj+lynoK8iLWuhx8O/zA
         Y4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425256; x=1735030056;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TDDJBYOHP75ThTGcuMvIwooq7g+u4EFaZTyJ2gC5szU=;
        b=WTAsnSyEVoRxipxGpLRtJ9opffJ8yWCfAHGwFehVpe0jdbx4XisxPVYZZzFE7EEnPu
         TEHh8hpRh3MBOkVo82cGx4ArcBX1geX/ubS2fegoS0vel214wD+fd8k1KKYcxm8UGNC1
         8g3SghpI0FkrZjLMm7pK8aZlDv1xsh7jnGPIJOJpeT1nt+KSWrPqy9HDFTH4YsGhT1om
         7CYyv5UbL+1mvkGaxKIyE8ejdWrCjf22QJUlWPl8k4V9bmxb0ZHg5G+maxwkiBTo3txX
         v5wvgROck6XL3NZg2gRgIHDRqB3CuB4ynnqaOACZYh5kAw+N+efkwOaduUWGPmV4KZZV
         FxIA==
X-Forwarded-Encrypted: i=1; AJvYcCWUdfcXkjejJ2boKlbQO6Vd9f1KfNUsNkkicEkmzMwrKgMFk1hzPTlMlnGNlzu2tQfdbY2130Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTKbp2tMqfY3h1s0U4A6B3x51EfyPCIUBzdIfQtsutXT9+5lz8
	VSBIr6TnzL2JyIEmdKuKBJyQtKozjumnVMcMDoPYYfAzMYxbRpjJ5SFR3IdOqbiCqvW5oMgP1eX
	7oMSK07mjr7+smekeu9bZzcK47vyZnusgpj7T
X-Gm-Gg: ASbGncvJfZYhIrdQNj3fdT4lMix6I284d7edR4JIjSmfuP7kOSF0EdWmpXTB+WGyYKr
	ICoioHmAcWhEwyPtpoe4+DU1NJs5VleesoHNwsFZBlOWmfgX6tItz4/w9kNh7z28Jf+4=
X-Google-Smtp-Source: AGHT+IHt2ytzKMSYHdWFUZre8Ll5zz2KLXOBJJTQt0g6EdacRR7mrV/+5ef0UfOv3wQWC9wfn2CB/36gV3U1R7AeKKg=
X-Received: by 2002:a05:600c:258:b0:434:a0fd:95d9 with SMTP id
 5b1f17b1804b1-4364ad50a2bmr710775e9.5.1734425255510; Tue, 17 Dec 2024
 00:47:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-5-qperret@google.com>
In-Reply-To: <20241216175803.2716565-5-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:46:58 +0000
Message-ID: <CA+EHjTy9P4gt6z+NbxLLANUKJBe32g0HsyGvsobXSfGiFSZ5Lg@mail.gmail.com>
Subject: Re: [PATCH v3 04/18] KVM: arm64: Move host page ownership tracking to
 the hyp vmemmap
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
>
> We currently store part of the page-tracking state in PTE software bits
> for the host, guests and the hypervisor. This is sub-optimal when e.g.
> sharing pages as this forces to break block mappings purely to support
> this software tracking. This causes an unnecessarily fragmented stage-2
> page-table for the host in particular when it shares pages with Secure,
> which can lead to measurable regressions. Moreover, having this state
> stored in the page-table forces us to do multiple costly walks on the
> page transition path, hence causing overhead.
>
> In order to work around these problems, move the host-side page-tracking
> logic from SW bits in its stage-2 PTEs to the hypervisor's vmemmap.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/include/nvhe/memory.h |   6 +-
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 100 ++++++++++++++++-------
>  arch/arm64/kvm/hyp/nvhe/setup.c          |   7 +-
>  3 files changed, 77 insertions(+), 36 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index 45b8d1840aa4..8bd9a539f260 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -8,7 +8,7 @@
>  #include <linux/types.h>
>
>  /*
> - * SW bits 0-1 are reserved to track the memory ownership state of each page:
> + * Bits 0-1 are reserved to track the memory ownership state of each page:
>   *   00: The page is owned exclusively by the page-table owner.
>   *   01: The page is owned by the page-table owner, but is shared
>   *       with another entity.
> @@ -43,7 +43,9 @@ static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
>  struct hyp_page {
>         u16 refcount;
>         u8 order;
> -       u8 reserved;
> +
> +       /* Host (non-meta) state. Guarded by the host stage-2 lock. */
> +       enum pkvm_page_state host_state : 8;
>  };
>
>  extern u64 __hyp_vmemmap;
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index caba3e4bd09e..12bb5445fe47 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -201,8 +201,8 @@ static void *guest_s2_zalloc_page(void *mc)
>
>         memset(addr, 0, PAGE_SIZE);
>         p = hyp_virt_to_page(addr);
> -       memset(p, 0, sizeof(*p));
>         p->refcount = 1;
> +       p->order = 0;
>
>         return addr;
>  }
> @@ -268,6 +268,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
>
>  void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
>  {
> +       struct hyp_page *page;
>         void *addr;
>
>         /* Dump all pgtable pages in the hyp_pool */
> @@ -279,7 +280,9 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
>         /* Drain the hyp_pool into the memcache */
>         addr = hyp_alloc_pages(&vm->pool, 0);
>         while (addr) {
> -               memset(hyp_virt_to_page(addr), 0, sizeof(struct hyp_page));
> +               page = hyp_virt_to_page(addr);
> +               page->refcount = 0;
> +               page->order = 0;
>                 push_hyp_memcache(mc, addr, hyp_virt_to_phys);
>                 WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
>                 addr = hyp_alloc_pages(&vm->pool, 0);
> @@ -382,19 +385,28 @@ bool addr_is_memory(phys_addr_t phys)
>         return !!find_mem_range(phys, &range);
>  }
>
> -static bool addr_is_allowed_memory(phys_addr_t phys)
> +static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
> +{
> +       return range->start <= addr && addr < range->end;
> +}
> +
> +static int check_range_allowed_memory(u64 start, u64 end)
>  {
>         struct memblock_region *reg;
>         struct kvm_mem_range range;
>
> -       reg = find_mem_range(phys, &range);
> +       /*
> +        * Callers can't check the state of a range that overlaps memory and
> +        * MMIO regions, so ensure [start, end[ is in the same kvm_mem_range.
> +        */
> +       reg = find_mem_range(start, &range);
> +       if (!is_in_mem_range(end - 1, &range))
> +               return -EINVAL;
>
> -       return reg && !(reg->flags & MEMBLOCK_NOMAP);
> -}
> +       if (!reg || reg->flags & MEMBLOCK_NOMAP)
> +               return -EPERM;
>
> -static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
> -{
> -       return range->start <= addr && addr < range->end;
> +       return 0;
>  }
>
>  static bool range_is_memory(u64 start, u64 end)
> @@ -454,8 +466,10 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
>         if (kvm_pte_valid(pte))
>                 return -EAGAIN;
>
> -       if (pte)
> +       if (pte) {
> +               WARN_ON(addr_is_memory(addr) && hyp_phys_to_page(addr)->host_state != PKVM_NOPAGE);
>                 return -EPERM;
> +       }
>
>         do {
>                 u64 granule = kvm_granule_size(level);
> @@ -477,10 +491,33 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
>         return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
>  }
>
> +static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_state state)
> +{
> +       phys_addr_t end = addr + size;
> +
> +       for (; addr < end; addr += PAGE_SIZE)
> +               hyp_phys_to_page(addr)->host_state = state;
> +}
> +
>  int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
>  {
> -       return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
> -                              addr, size, &host_s2_pool, owner_id);
> +       int ret;
> +
> +       if (!addr_is_memory(addr))
> +               return -EPERM;
> +
> +       ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
> +                             addr, size, &host_s2_pool, owner_id);
> +       if (ret)
> +               return ret;
> +
> +       /* Don't forget to update the vmemmap tracking for the host */
> +       if (owner_id == PKVM_ID_HOST)
> +               __host_update_page_state(addr, size, PKVM_PAGE_OWNED);
> +       else
> +               __host_update_page_state(addr, size, PKVM_NOPAGE);
> +
> +       return 0;
>  }
>
>  static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
> @@ -604,35 +641,38 @@ static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
>         return kvm_pgtable_walk(pgt, addr, size, &walker);
>  }
>
> -static enum pkvm_page_state host_get_page_state(kvm_pte_t pte, u64 addr)
> -{
> -       if (!addr_is_allowed_memory(addr))
> -               return PKVM_NOPAGE;
> -
> -       if (!kvm_pte_valid(pte) && pte)
> -               return PKVM_NOPAGE;
> -
> -       return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
> -}
> -
>  static int __host_check_page_state_range(u64 addr, u64 size,
>                                          enum pkvm_page_state state)
>  {
> -       struct check_walk_data d = {
> -               .desired        = state,
> -               .get_page_state = host_get_page_state,
> -       };
> +       u64 end = addr + size;
> +       int ret;
> +
> +       ret = check_range_allowed_memory(addr, end);
> +       if (ret)
> +               return ret;
>
>         hyp_assert_lock_held(&host_mmu.lock);
> -       return check_page_state_range(&host_mmu.pgt, addr, size, &d);
> +       for (; addr < end; addr += PAGE_SIZE) {
> +               if (hyp_phys_to_page(addr)->host_state != state)
> +                       return -EPERM;
> +       }
> +
> +       return 0;
>  }
>
>  static int __host_set_page_state_range(u64 addr, u64 size,
>                                        enum pkvm_page_state state)
>  {
> -       enum kvm_pgtable_prot prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, state);
> +       if (hyp_phys_to_page(addr)->host_state == PKVM_NOPAGE) {
> +               int ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
>
> -       return host_stage2_idmap_locked(addr, size, prot);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       __host_update_page_state(addr, size, state);
> +
> +       return 0;
>  }
>
>  static int host_request_owned_transition(u64 *completer_addr,
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index cbdd18cd3f98..7e04d1c2a03d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -180,7 +180,6 @@ static void hpool_put_page(void *addr)
>  static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
>                                      enum kvm_pgtable_walk_flags visit)
>  {
> -       enum kvm_pgtable_prot prot;
>         enum pkvm_page_state state;
>         phys_addr_t phys;
>
> @@ -203,16 +202,16 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
>         case PKVM_PAGE_OWNED:
>                 return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
>         case PKVM_PAGE_SHARED_OWNED:
> -               prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_BORROWED);
> +               hyp_phys_to_page(phys)->host_state = PKVM_PAGE_SHARED_BORROWED;
>                 break;
>         case PKVM_PAGE_SHARED_BORROWED:
> -               prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_OWNED);
> +               hyp_phys_to_page(phys)->host_state = PKVM_PAGE_SHARED_OWNED;
>                 break;
>         default:
>                 return -EINVAL;
>         }
>
> -       return host_stage2_idmap_locked(phys, PAGE_SIZE, prot);
> +       return 0;
>  }
>
>  static int fix_hyp_pgtable_refcnt_walker(const struct kvm_pgtable_visit_ctx *ctx,
> --
> 2.47.1.613.gc27f4b7a9f-goog
>
