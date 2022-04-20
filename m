Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC99C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 20 Apr 2022 10:56:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C75474B1E7;
	Wed, 20 Apr 2022 06:56:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ddaOtouUAS+E; Wed, 20 Apr 2022 06:56:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 408614B1C9;
	Wed, 20 Apr 2022 06:56:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90CA34B1C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 06:55:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P9BS-TJ-RNFK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Apr 2022 06:55:58 -0400 (EDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
 [209.85.128.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF36D4B1C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 06:55:57 -0400 (EDT)
Received: by mail-wm1-f50.google.com with SMTP id
 n40-20020a05600c3ba800b0038ff1939b16so973726wms.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Apr 2022 03:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=xFXSoDNZKB5JzmesuQFZyUZUSyoURgEytWmZjeW2Ois=;
 b=R5XQP+zqKvDZWUUp8VJx0ejWpT3rKsf3+AlLW0TyFHhVMNUCQG7NU9UFGy2R/ZlyPA
 xQpqsw3RjYXOAFrgzzqYRLMlwgQtMfy71Ad6FfWibmVamgHfJ1oRJsz6h26Bzo+sgsi4
 JKt7A7F3DrgcFV2qCLT+gDRwMks3S1kxzXcIVncvEBsCCGZYrct1/wj41tEuvCEi4COn
 EC3o0Lp967A0KM8AcIDzWKEPcA5hgBx7LedJBYEbtx8yiyOWHux/dK2Er2rjX+kDAtRv
 uqW+vJI0+KKMB1ZbeIdrgdLPwU7pNVgvyW9NSglWjW3bm+ROZb3tiQ3U/nRZSlRoSEhZ
 sAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=xFXSoDNZKB5JzmesuQFZyUZUSyoURgEytWmZjeW2Ois=;
 b=BtKbdbxT9KJa3GR2iMLwZSD+nrv5wzOWiQPiNHYp4YOUKSeDmeOMExHXqoGnwB55PY
 wSRy3/ZNFtRS8ZbF35zBQqDfFibZM+6naQANcpLXGobsnbr4WQsG4o6Lx1b/d+eBOWBF
 EjF56PICTMnXIRACSuJkg3Vxh0MHHu2JsV5gzMfokUHPT2Zr3SzdmIY8oN3oilMKSFi4
 VPrlcwoY4BpoXH4KnVkJpPh+51k0miZmHovAvkB2dH9CLVsEn9ILFitOFSnh5L+PMQoh
 D4Ky+PPd2qYzRH1kYANANzpo8OOIDXTQuU/hfCAhT70syhuoLXGYQSkjzmd6tdF/f0KH
 meVw==
X-Gm-Message-State: AOAM533wrCvx6GGbLA0kJR8XdDJ7GKZOd3/q+UcrkSwxU0lMqMLulv2W
 nYmlv+hMgSMdE3/BABXM3uw4OHsnZNsd+TqSxYxdAQ==
X-Google-Smtp-Source: ABdhPJyespdTciFCCPylGn+26pI3Plhlm1SBuoVhToWE8GBtCrEWPYQ1gRnsNkXDHEot/LjUIT+lr4uOa5CgxKTXL4A=
X-Received: by 2002:a05:600c:1d12:b0:391:3cf6:243e with SMTP id
 l18-20020a05600c1d1200b003913cf6243emr3054109wms.137.1650452156482; Wed, 20
 Apr 2022 03:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
 <20220401175554.1931568-21-dmatlack@google.com>
In-Reply-To: <20220401175554.1931568-21-dmatlack@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Wed, 20 Apr 2022 16:25:43 +0530
Message-ID: <CAAhSdy1JAHkPEoy7+bNNABrOzTw2gZZSCftuhimiXom3OrLFmw@mail.gmail.com>
Subject: Re: [PATCH v3 20/23] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To: David Matlack <dmatlack@google.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
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

On Fri, Apr 1, 2022 at 11:26 PM David Matlack <dmatlack@google.com> wrote:
>
> Allow the capacity of the kvm_mmu_memory_cache struct to be chosen at
> declaration time rather than being fixed for all declarations. This will
> be used in a follow-up commit to declare an cache in x86 with a capacity
> of 512+ objects without having to increase the capacity of all caches in
> KVM.
>
> This change requires each cache now specify its capacity at runtime,
> since the cache struct itself no longer has a fixed capacity known at
> compile time. To protect against someone accidentally defining a
> kvm_mmu_memory_cache struct directly (without the extra storage), this
> commit includes a WARN_ON() in kvm_mmu_topup_memory_cache().
>
> This change, unfortunately, adds some grottiness to
> kvm_phys_addr_ioremap() in arm64, which uses a function-local (i.e.
> stack-allocated) kvm_mmu_memory_cache struct. Since C does not allow
> anonymous structs in functions, the new wrapper struct that contains
> kvm_mmu_memory_cache and the objects pointer array, must be named, which
> means dealing with an outer and inner struct. The outer struct can't be
> dropped since then there would be no guarantee the kvm_mmu_memory_cache
> struct and objects array would be laid out consecutively on the stack.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Looks good to me.

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/mmu.c              | 13 +++++++++----
>  arch/mips/include/asm/kvm_host.h  |  2 +-
>  arch/mips/kvm/mips.c              |  2 ++
>  arch/riscv/include/asm/kvm_host.h |  2 +-
>  arch/riscv/kvm/mmu.c              | 17 ++++++++++-------
>  arch/riscv/kvm/vcpu.c             |  1 +
>  arch/x86/include/asm/kvm_host.h   |  8 ++++----
>  arch/x86/kvm/mmu/mmu.c            |  9 +++++++++
>  include/linux/kvm_types.h         | 19 +++++++++++++++++--
>  virt/kvm/kvm_main.c               | 10 +++++++++-
>  12 files changed, 65 insertions(+), 21 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0e96087885fe..4670491899de 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -362,7 +362,7 @@ struct kvm_vcpu_arch {
>         bool pause;
>
>         /* Cache some mmu pages needed inside spinlock regions */
> -       struct kvm_mmu_memory_cache mmu_page_cache;
> +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
>
>         /* Target CPU and feature flags */
>         int target;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ba9165e84396..af4d8a490af5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -320,6 +320,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         vcpu->arch.target = -1;
>         bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
>
> +       vcpu->arch.mmu_page_cache.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>
>         /* Set up the timer */
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0d19259454d8..01e15bcb7be2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -764,7 +764,12 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  {
>         phys_addr_t addr;
>         int ret = 0;
> -       struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +       DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {
> +               .cache = {
> +                       .gfp_zero = __GFP_ZERO,
> +                       .capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> +               },
> +       };
>         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
>                                      KVM_PGTABLE_PROT_R |
> @@ -777,14 +782,14 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>         guest_ipa &= PAGE_MASK;
>
>         for (addr = guest_ipa; addr < guest_ipa + size; addr += PAGE_SIZE) {
> -               ret = kvm_mmu_topup_memory_cache(&cache,
> +               ret = kvm_mmu_topup_memory_cache(&page_cache.cache,
>                                                  kvm_mmu_cache_min_pages(kvm));
>                 if (ret)
>                         break;
>
>                 write_lock(&kvm->mmu_lock);
>                 ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
> -                                            &cache);
> +                                            &page_cache.cache);
>                 write_unlock(&kvm->mmu_lock);
>                 if (ret)
>                         break;
> @@ -792,7 +797,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>                 pa += PAGE_SIZE;
>         }
>
> -       kvm_mmu_free_memory_cache(&cache);
> +       kvm_mmu_free_memory_cache(&page_cache.cache);
>         return ret;
>  }
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 717716cc51c5..935511d7fc3a 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -347,7 +347,7 @@ struct kvm_vcpu_arch {
>         unsigned long pending_exceptions_clr;
>
>         /* Cache some mmu pages needed inside spinlock regions */
> -       struct kvm_mmu_memory_cache mmu_page_cache;
> +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
>
>         /* vcpu's vzguestid is different on each host cpu in an smp system */
>         u32 vzguestid[NR_CPUS];
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..45c7179144dc 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -387,6 +387,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         if (err)
>                 goto out_free_gebase;
>
> +       vcpu->arch.mmu_page_cache.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> +
>         return 0;
>
>  out_free_gebase:
> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> index 78da839657e5..4ec0b7a3d515 100644
> --- a/arch/riscv/include/asm/kvm_host.h
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -186,7 +186,7 @@ struct kvm_vcpu_arch {
>         struct kvm_sbi_context sbi_context;
>
>         /* Cache pages needed to program page tables with spinlock held */
> -       struct kvm_mmu_memory_cache mmu_page_cache;
> +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_cache);
>
>         /* VCPU power-off state */
>         bool power_off;
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f80a34fbf102..5ffd164a5aeb 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -347,10 +347,12 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>         int ret = 0;
>         unsigned long pfn;
>         phys_addr_t addr, end;
> -       struct kvm_mmu_memory_cache pcache;
> -
> -       memset(&pcache, 0, sizeof(pcache));
> -       pcache.gfp_zero = __GFP_ZERO;
> +       DEFINE_KVM_MMU_MEMORY_CACHE(cache) page_cache = {
> +               .cache = {
> +                       .gfp_zero = __GFP_ZERO,
> +                       .capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> +               },
> +       };
>
>         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>         pfn = __phys_to_pfn(hpa);
> @@ -361,12 +363,13 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>                 if (!writable)
>                         pte = pte_wrprotect(pte);
>
> -               ret = kvm_mmu_topup_memory_cache(&pcache, stage2_pgd_levels);
> +               ret = kvm_mmu_topup_memory_cache(&page_cache.cache,
> +                                                stage2_pgd_levels);
>                 if (ret)
>                         goto out;
>
>                 spin_lock(&kvm->mmu_lock);
> -               ret = stage2_set_pte(kvm, 0, &pcache, addr, &pte);
> +               ret = stage2_set_pte(kvm, 0, &page_cache.cache, addr, &pte);
>                 spin_unlock(&kvm->mmu_lock);
>                 if (ret)
>                         goto out;
> @@ -375,7 +378,7 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>         }
>
>  out:
> -       kvm_mmu_free_memory_cache(&pcache);
> +       kvm_mmu_free_memory_cache(&page_cache.cache);
>         return ret;
>  }
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 624166004e36..6a5f5aa45bac 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -94,6 +94,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>
>         /* Mark this VCPU never ran */
>         vcpu->arch.ran_atleast_once = false;
> +       vcpu->arch.mmu_page_cache.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>
>         /* Setup ISA features available to VCPU */
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be4349c9ffea..ffb2b99f3a60 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -694,10 +694,10 @@ struct kvm_vcpu_arch {
>          */
>         struct kvm_mmu *walk_mmu;
>
> -       struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> -       struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> -       struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
> -       struct kvm_mmu_memory_cache mmu_page_header_cache;
> +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_pte_list_desc_cache);
> +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_shadow_page_cache);
> +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_shadowed_info_cache);
> +       DEFINE_KVM_MMU_MEMORY_CACHE(mmu_page_header_cache);
>
>         /*
>          * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f058f28909ea..a8200b3f8782 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5800,12 +5800,21 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  {
>         int ret;
>
> +       vcpu->arch.mmu_pte_list_desc_cache.capacity =
> +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
>         vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
>
> +       vcpu->arch.mmu_page_header_cache.capacity =
> +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>         vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>
> +       vcpu->arch.mmu_shadowed_info_cache.capacity =
> +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> +
> +       vcpu->arch.mmu_shadow_page_cache.capacity =
> +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>
>         vcpu->arch.mmu = &vcpu->arch.root_mmu;
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index ac1ebb37a0ff..579cf39986ec 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -83,14 +83,29 @@ struct gfn_to_pfn_cache {
>   * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
>   * holding MMU locks.  Note, these caches act more like prefetch buffers than
>   * classical caches, i.e. objects are not returned to the cache on being freed.
> + *
> + * The storage for the cache object pointers is laid out after the struct, to
> + * allow different declarations to choose different capacities. The capacity
> + * field defines the number of object pointers available after the struct.
>   */
>  struct kvm_mmu_memory_cache {
>         int nobjs;
> +       int capacity;
>         gfp_t gfp_zero;
>         struct kmem_cache *kmem_cache;
> -       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> +       void *objects[];
>  };
> -#endif
> +
> +#define __DEFINE_KVM_MMU_MEMORY_CACHE(_name, _capacity)                \
> +       struct {                                                \
> +               struct kvm_mmu_memory_cache _name;              \
> +               void *_name##_objects[_capacity];               \
> +       }
> +
> +#define DEFINE_KVM_MMU_MEMORY_CACHE(_name) \
> +       __DEFINE_KVM_MMU_MEMORY_CACHE(_name, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE)
> +
> +#endif /* KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE */
>
>  #define HALT_POLL_HIST_COUNT                   32
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70e05af5ebea..c4cac4195f4a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -373,9 +373,17 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  {
>         void *obj;
>
> +       /*
> +        * The capacity fieldmust be initialized since the storage for the
> +        * objects pointer array is laid out after the kvm_mmu_memory_cache
> +        * struct and not known at compile time.
> +        */
> +       if (WARN_ON(mc->capacity == 0))
> +               return -EINVAL;
> +
>         if (mc->nobjs >= min)
>                 return 0;
> -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> +       while (mc->nobjs < mc->capacity) {
>                 obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
> --
> 2.35.1.1094.g7c7d902a7c-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
