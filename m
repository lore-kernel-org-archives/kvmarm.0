Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AAC1DE4E4
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 09:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734428122; cv=none; b=SOeke7DpGJfruW6HYOKfjEc7a983FmEiDPO2Ex0B1oz/DBHpSRxpf0KaTbcYtwVd9qYmGDqU6FIXaXCfZ1hr+cE6yPMqQFBsfAiBzZvqLQ1ltmewMjTIIf5KNxOcpx0Txarzc3KtiICjham/9PkI671sp7ZiT/DRlaRlfZGXtpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734428122; c=relaxed/simple;
	bh=qsLMCXWsQ+3fLSbhb0BNzpGZI309INPAu4lNQRTTc9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hVStOpUONm+I0gExwWuP/20y71Ev1bnMOYWIMrO3QVvJ2UehToiusQ9/dV1YkqFQlm8UUFIHEpOCC5LETe9rdUtLy53KjKKBgQBIqZ1HMHFSU0djWOMGB3aDbrORyh+7s2N6+mFVYIszC4BHB9W4t95yuJlz6L6lFQ2QVt+9WH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d8+Mlav4; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d8+Mlav4"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso41735e9.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 01:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734428118; x=1735032918; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0YxXse8TpUV8emF5PzngJGsZOaE5LozkgRZjppoi+Nc=;
        b=d8+Mlav45PST85+JmwNR2qtjMi59wtNRkfi1sKAr2YnsEMrOpuDvIJVIoCEtDebHgw
         IK6qQC2iCjOoxycKG941d5zJgVU/5w4L+L/ydsRHD/md0Rt2Ga5iOKoPoLYOzMLiWs36
         ggAneWjJ2aWd7hpen6D8h94gUYIHGXc78XihVLy++HovsSoVoHaTQBHTND8+Ry6tWNI2
         Sy69rKc5BwJdK39ShP1mDaQPAHxHU40BGyeDTbKvt7Ww4ZX6kMrdVEfcpGs3J0o2jqXG
         SISxL09flzEtYZTHd/unwIeVfny/dNNbW2bzgnkx3KGJbedLykBS1Kzm4E+nhpspfc8L
         9JmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734428118; x=1735032918;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0YxXse8TpUV8emF5PzngJGsZOaE5LozkgRZjppoi+Nc=;
        b=qJYTPD91rSpOKZC+eI6543MA2u6tSXg6O3aXv/XEq6wvW7MizqBoYP5wWu6YEbrZZ8
         bv6XAMA+DV3yMObUx3dckzSr2Hu+MnJpGPVBzz5cE0qVBVZpUWdUAI0emtaSHvp4SLcX
         0i5AECYU5bUBIV/qdYX7ZWlR2wjW75P0+y15Hu7Vyd5G7xSPXUzipobV7vSUJe6FKc+0
         YqjZMRKjeHzJy/SutABapPlWZm/B4A9vxJ+OdEFA6bPqbmviu4FDstkFT7/bI7o4sydd
         wn6C10/8aEzVV3lF3+vg2LGy7+iIHOnKl7QDlFnRvux1m+8CZdqqZwuEBhvLdDT9og3m
         L9eQ==
X-Forwarded-Encrypted: i=1; AJvYcCVm89EjseG3pD2ZjVQsaTeGT4Uyh2jo5OZU+ALPyktRRTJw4Ij+xy9YOtYq+rhbxGdXfsm9x58=@lists.linux.dev
X-Gm-Message-State: AOJu0YydYmToZIyWBSqECNH4njf+VWfNB9kx5rv6WA3Qy6yCaRk9R4EF
	RPgtoH6YnDfyPsgbDWGTa2iwoAW8xcqDq4oTTfbehojqaROPXlIP9bE3Jl8Mcb1SDqAUc//Pb7E
	MkgxLFVXVitXr+OVgimu6xxHZbt9gr80MoN6Q
X-Gm-Gg: ASbGncshe4JVfYLS8fVv6k7WD8scY0XLotMRa8oQgybLY8pnPWcv92eYF0uzwgUwq9+
	o882PJyG90OPSIOuUmlNIk53POZDfetny5LTlA6J+HSjp86YLRyKDme4wagVptfviS1w=
X-Google-Smtp-Source: AGHT+IEnzqsP/eLK/YJtavSV/8LgvuWxyG2alnUrf3g0IaGFXKbv3SE5teoKz7Sxa+UaVEJYeNMRb7kXYbpBdAc+TPI=
X-Received: by 2002:a7b:ce88:0:b0:436:186e:13a6 with SMTP id
 5b1f17b1804b1-436492cf51dmr1103805e9.6.1734428117971; Tue, 17 Dec 2024
 01:35:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-19-qperret@google.com>
In-Reply-To: <20241216175803.2716565-19-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 09:34:41 +0000
Message-ID: <CA+EHjTyu=CdAaPuNZScjASEKrm4zh1851isPqQfDej-Ms_vATA@mail.gmail.com>
Subject: Re: [PATCH v3 18/18] KVM: arm64: Plumb the pKVM MMU in KVM
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
> Introduce the KVM_PGT_S2() helper macro to allow switching from the
> traditional pgtable code to the pKVM version easily in mmu.c. The cost
> of this 'indirection' is expected to be very minimal due to
> is_protected_kvm_enabled() being backed by a static key.
>
> With this, everything is in place to allow the delegation of
> non-protected guest stage-2 page-tables to pKVM, so let's stop using the
> host's kvm_s2_mmu from EL2 and enjoy the ride.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_mmu.h   |  16 +++++
>  arch/arm64/kvm/arm.c               |   9 ++-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |   2 -
>  arch/arm64/kvm/mmu.c               | 107 +++++++++++++++++++++--------
>  4 files changed, 101 insertions(+), 33 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 66d93e320ec8..d116ab4230e8 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -353,6 +353,22 @@ static inline bool kvm_is_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>         return &kvm->arch.mmu != mmu;
>  }
>
> +static inline void kvm_fault_lock(struct kvm *kvm)
> +{
> +       if (is_protected_kvm_enabled())
> +               write_lock(&kvm->mmu_lock);
> +       else
> +               read_lock(&kvm->mmu_lock);
> +}
> +
> +static inline void kvm_fault_unlock(struct kvm *kvm)
> +{
> +       if (is_protected_kvm_enabled())
> +               write_unlock(&kvm->mmu_lock);
> +       else
> +               read_unlock(&kvm->mmu_lock);
> +}
> +
>  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>  void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
>  #else
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 55cc62b2f469..9bcbc7b8ed38 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -502,7 +502,10 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> +       if (!is_protected_kvm_enabled())
> +               kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> +       else
> +               free_hyp_memcache(&vcpu->arch.pkvm_memcache);
>         kvm_timer_vcpu_terminate(vcpu);
>         kvm_pmu_vcpu_destroy(vcpu);
>         kvm_vgic_vcpu_destroy(vcpu);
> @@ -574,6 +577,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>         struct kvm_s2_mmu *mmu;
>         int *last_ran;
>
> +       if (is_protected_kvm_enabled())
> +               goto nommu;
> +
>         if (vcpu_has_nv(vcpu))
>                 kvm_vcpu_load_hw_mmu(vcpu);
>
> @@ -594,6 +600,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>                 *last_ran = vcpu->vcpu_idx;
>         }
>
> +nommu:
>         vcpu->cpu = cpu;
>
>         kvm_vgic_load(vcpu);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 130f5f23bcb5..258d572eed62 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -103,8 +103,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>         /* Limit guest vector length to the maximum supported by the host.  */
>         hyp_vcpu->vcpu.arch.sve_max_vl  = min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
>
> -       hyp_vcpu->vcpu.arch.hw_mmu      = host_vcpu->arch.hw_mmu;
> -
>         hyp_vcpu->vcpu.arch.mdcr_el2    = host_vcpu->arch.mdcr_el2;
>         hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
>         hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 641e4fec1659..7c2995cb4577 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -15,6 +15,7 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_mmu.h>
>  #include <asm/kvm_pgtable.h>
> +#include <asm/kvm_pkvm.h>
>  #include <asm/kvm_ras.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
> @@ -31,6 +32,14 @@ static phys_addr_t __ro_after_init hyp_idmap_vector;
>
>  static unsigned long __ro_after_init io_map_base;
>
> +#define KVM_PGT_S2(fn, ...)                                                            \
> +       ({                                                                              \
> +               typeof(kvm_pgtable_stage2_ ## fn) *__fn = kvm_pgtable_stage2_ ## fn;    \
> +               if (is_protected_kvm_enabled())                                         \
> +                       __fn = pkvm_pgtable_ ## fn;                                     \
> +               __fn(__VA_ARGS__);                                                      \
> +       })
> +
>  static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
>                                            phys_addr_t size)
>  {
> @@ -147,7 +156,7 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
>                         return -EINVAL;
>
>                 next = __stage2_range_addr_end(addr, end, chunk_size);
> -               ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache);
> +               ret = KVM_PGT_S2(split, pgt, addr, next - addr, cache);
>                 if (ret)
>                         break;
>         } while (addr = next, addr != end);
> @@ -168,15 +177,23 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>   */
>  int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>  {
> -       kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> +       if (is_protected_kvm_enabled())
> +               kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
> +       else
> +               kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
>         return 0;
>  }
>
>  int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
>                                       gfn_t gfn, u64 nr_pages)
>  {
> -       kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
> -                               gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
> +       u64 size = nr_pages << PAGE_SHIFT;
> +       u64 addr = gfn << PAGE_SHIFT;
> +
> +       if (is_protected_kvm_enabled())
> +               kvm_call_hyp_nvhe(__pkvm_tlb_flush_vmid, kvm->arch.pkvm.handle);
> +       else
> +               kvm_tlb_flush_vmid_range(&kvm->arch.mmu, addr, size);
>         return 0;
>  }
>
> @@ -225,7 +242,7 @@ static void stage2_free_unlinked_table_rcu_cb(struct rcu_head *head)
>         void *pgtable = page_to_virt(page);
>         s8 level = page_private(page);
>
> -       kvm_pgtable_stage2_free_unlinked(&kvm_s2_mm_ops, pgtable, level);
> +       KVM_PGT_S2(free_unlinked, &kvm_s2_mm_ops, pgtable, level);
>  }
>
>  static void stage2_free_unlinked_table(void *addr, s8 level)
> @@ -280,6 +297,11 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>         __invalidate_icache_guest_page(va, size);
>  }
>
> +static int kvm_s2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +       return KVM_PGT_S2(unmap, pgt, addr, size);
> +}
> +
>  /*
>   * Unmapping vs dcache management:
>   *
> @@ -324,8 +346,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>
>         lockdep_assert_held_write(&kvm->mmu_lock);
>         WARN_ON(size & ~PAGE_MASK);
> -       WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
> -                                  may_block));
> +       WARN_ON(stage2_apply_range(mmu, start, end, kvm_s2_unmap, may_block));
>  }
>
>  void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
> @@ -334,9 +355,14 @@ void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>         __unmap_stage2_range(mmu, start, size, may_block);
>  }
>
> +static int kvm_s2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +       return KVM_PGT_S2(flush, pgt, addr, size);
> +}
> +
>  void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
>  {
> -       stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_flush);
> +       stage2_apply_range_resched(mmu, addr, end, kvm_s2_flush);
>  }
>
>  static void stage2_flush_memslot(struct kvm *kvm,
> @@ -942,10 +968,14 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>                 return -ENOMEM;
>
>         mmu->arch = &kvm->arch;
> -       err = kvm_pgtable_stage2_init(pgt, mmu, &kvm_s2_mm_ops);
> +       err = KVM_PGT_S2(init, pgt, mmu, &kvm_s2_mm_ops);
>         if (err)
>                 goto out_free_pgtable;
>
> +       mmu->pgt = pgt;
> +       if (is_protected_kvm_enabled())
> +               return 0;
> +
>         mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
>         if (!mmu->last_vcpu_ran) {
>                 err = -ENOMEM;
> @@ -959,7 +989,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>         mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
>         mmu->split_page_cache.gfp_zero = __GFP_ZERO;
>
> -       mmu->pgt = pgt;
>         mmu->pgd_phys = __pa(pgt->pgd);
>
>         if (kvm_is_nested_s2_mmu(kvm, mmu))
> @@ -968,7 +997,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>         return 0;
>
>  out_destroy_pgtable:
> -       kvm_pgtable_stage2_destroy(pgt);
> +       KVM_PGT_S2(destroy, pgt);
>  out_free_pgtable:
>         kfree(pgt);
>         return err;
> @@ -1065,7 +1094,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>         write_unlock(&kvm->mmu_lock);
>
>         if (pgt) {
> -               kvm_pgtable_stage2_destroy(pgt);
> +               KVM_PGT_S2(destroy, pgt);
>                 kfree(pgt);
>         }
>  }
> @@ -1082,9 +1111,11 @@ static void *hyp_mc_alloc_fn(void *unused)
>
>  void free_hyp_memcache(struct kvm_hyp_memcache *mc)
>  {
> -       if (is_protected_kvm_enabled())
> -               __free_hyp_memcache(mc, hyp_mc_free_fn,
> -                                   kvm_host_va, NULL);
> +       if (!is_protected_kvm_enabled())
> +               return;
> +
> +       kfree(mc->mapping);
> +       __free_hyp_memcache(mc, hyp_mc_free_fn, kvm_host_va, NULL);
>  }
>
>  int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
> @@ -1092,6 +1123,12 @@ int topup_hyp_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages)
>         if (!is_protected_kvm_enabled())
>                 return 0;
>
> +       if (!mc->mapping) {
> +               mc->mapping = kzalloc(sizeof(struct pkvm_mapping), GFP_KERNEL_ACCOUNT);
> +               if (!mc->mapping)
> +                       return -ENOMEM;
> +       }
> +
>         return __topup_hyp_memcache(mc, min_pages, hyp_mc_alloc_fn,
>                                     kvm_host_pa, NULL);
>  }
> @@ -1130,8 +1167,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>                         break;
>
>                 write_lock(&kvm->mmu_lock);
> -               ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
> -                                            &cache, 0);
> +               ret = KVM_PGT_S2(map, pgt, addr, PAGE_SIZE, pa, prot, &cache, 0);
>                 write_unlock(&kvm->mmu_lock);
>                 if (ret)
>                         break;
> @@ -1143,6 +1179,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>         return ret;
>  }
>
> +static int kvm_s2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +       return KVM_PGT_S2(wrprotect, pgt, addr, size);
> +}
>  /**
>   * kvm_stage2_wp_range() - write protect stage2 memory region range
>   * @mmu:        The KVM stage-2 MMU pointer
> @@ -1151,7 +1191,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   */
>  void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
>  {
> -       stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_wrprotect);
> +       stage2_apply_range_resched(mmu, addr, end, kvm_s2_wrprotect);
>  }
>
>  /**
> @@ -1442,9 +1482,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         unsigned long mmu_seq;
>         phys_addr_t ipa = fault_ipa;
>         struct kvm *kvm = vcpu->kvm;
> -       struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>         struct vm_area_struct *vma;
>         short vma_shift;
> +       void *memcache;
>         gfn_t gfn;
>         kvm_pfn_t pfn;
>         bool logging_active = memslot_is_logging(memslot);
> @@ -1472,8 +1512,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          * and a write fault needs to collapse a block entry into a table.
>          */
>         if (!fault_is_perm || (logging_active && write_fault)) {
> -               ret = kvm_mmu_topup_memory_cache(memcache,
> -                                                kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> +               int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> +
> +               if (!is_protected_kvm_enabled()) {
> +                       memcache = &vcpu->arch.mmu_page_cache;
> +                       ret = kvm_mmu_topup_memory_cache(memcache, min_pages);
> +               } else {
> +                       memcache = &vcpu->arch.pkvm_memcache;
> +                       ret = topup_hyp_memcache(memcache, min_pages);
> +               }
>                 if (ret)
>                         return ret;
>         }
> @@ -1494,7 +1541,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>          * logging_active is guaranteed to never be true for VM_PFNMAP
>          * memslots.
>          */
> -       if (logging_active) {
> +       if (logging_active || is_protected_kvm_enabled()) {
>                 force_pte = true;
>                 vma_shift = PAGE_SHIFT;
>         } else {
> @@ -1634,7 +1681,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 prot |= kvm_encode_nested_level(nested);
>         }
>
> -       read_lock(&kvm->mmu_lock);
> +       kvm_fault_lock(kvm);
>         pgt = vcpu->arch.hw_mmu->pgt;
>         if (mmu_invalidate_retry(kvm, mmu_seq)) {
>                 ret = -EAGAIN;
> @@ -1696,16 +1743,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                  * PTE, which will be preserved.
>                  */
>                 prot &= ~KVM_NV_GUEST_MAP_SZ;
> -               ret = kvm_pgtable_stage2_relax_perms(pgt, fault_ipa, prot, flags);
> +               ret = KVM_PGT_S2(relax_perms, pgt, fault_ipa, prot, flags);
>         } else {
> -               ret = kvm_pgtable_stage2_map(pgt, fault_ipa, vma_pagesize,
> +               ret = KVM_PGT_S2(map, pgt, fault_ipa, vma_pagesize,
>                                              __pfn_to_phys(pfn), prot,
>                                              memcache, flags);
>         }
>
>  out_unlock:
>         kvm_release_faultin_page(kvm, page, !!ret, writable);
> -       read_unlock(&kvm->mmu_lock);
> +       kvm_fault_unlock(kvm);
>
>         /* Mark the page dirty only if the fault is handled successfully */
>         if (writable && !ret)
> @@ -1724,7 +1771,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>
>         read_lock(&vcpu->kvm->mmu_lock);
>         mmu = vcpu->arch.hw_mmu;
> -       kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa, flags);
> +       KVM_PGT_S2(mkyoung, mmu->pgt, fault_ipa, flags);
>         read_unlock(&vcpu->kvm->mmu_lock);
>  }
>
> @@ -1764,7 +1811,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>                 }
>
>                 /* Falls between the IPA range and the PARange? */
> -               if (fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
> +               if (fault_ipa >= BIT_ULL(VTCR_EL2_IPA(vcpu->arch.hw_mmu->vtcr))) {
>                         fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
>
>                         if (is_iabt)
> @@ -1930,7 +1977,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>         if (!kvm->arch.mmu.pgt)
>                 return false;
>
> -       return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
> +       return KVM_PGT_S2(test_clear_young, kvm->arch.mmu.pgt,
>                                                    range->start << PAGE_SHIFT,
>                                                    size, true);
>         /*
> @@ -1946,7 +1993,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>         if (!kvm->arch.mmu.pgt)
>                 return false;
>
> -       return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
> +       return KVM_PGT_S2(test_clear_young, kvm->arch.mmu.pgt,
>                                                    range->start << PAGE_SHIFT,
>                                                    size, false);
>  }
> --
> 2.47.1.613.gc27f4b7a9f-goog
>
