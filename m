Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321D28833
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 21:55:24 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5223910acf2so3632a12.0
        for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 14:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691790923; x=1692395723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhCiC7mbWj5/D2V8sRIbRMcoDdeK0tvxeKDY85P43qA=;
        b=koeMk9lUXlXHX/byS6eEPwnw3qs54xYEchBhEDssqH82r8kkLlaCAwecUOVEzsgINi
         QDEDvjuSZlPIZkO+cg+dlSp2L3c37OuVQTg42gpiLBk2H5wbbp7MIcPPHUbhoRBLvcBf
         4cSP1zBADT5RPt4UZSw/IJAZPNNcmwy0W5N4ickJUFNqJtWPE4hDQC+XceCqKBNcmBIp
         RgmpXlntH582PfX0VvMW2mbM33OATH2TfTAokG6/GfwCMO8dRU57lggBrQ/PP4IShphP
         R5ZYE+Aw58oDKd5jyfKzgI9CHwMBfaVHzKeKqwosFteE43cKBG7etIhcyVkxI5guPTzu
         o6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691790923; x=1692395723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhCiC7mbWj5/D2V8sRIbRMcoDdeK0tvxeKDY85P43qA=;
        b=YaY84EWsNF9mDlFNtNkR6NuyjiUEgZ+3GSC4fXRD0p+cJnWnHsM+mdvQ0QMqq29kV+
         5kziklYA4CwqA7Pj65vnRO5Z1dyBhjCofVpOunJyyQxITfMbZpRxxuAwsRHkK4T22ohF
         EPVdMFMollcK/KHkTTH9D3la7OTBeHVEIoRK/c2tALmQUs2z8UH4LALsWoX93shUD27Q
         DXNLEdZMcAe0eX2GlpaMXfR3WW+B+fL9iC5n40mHyeKqBsT5m02IM4WUmyeSJxlW+P7m
         s5OSczwahxIvnJlZMKc1voIovxLp9XUVh69keDi3o81xjIZ3uVDL3kvbzBCwPqKRID4o
         txZg==
X-Gm-Message-State: AOJu0Yzr7TGc1exTsZrYCO6VopP3IT3tQPdVNk6ia7sZmgmkMGftfSPd
	PfRztz5c3h3dYxquK4LTx7dsrOt+vZDl8UE5Cc2z8w==
X-Google-Smtp-Source: AGHT+IEaQcTy9BePtpLW5nGk55KnTwvonzp9k+eOeHcPv03ACMfsViuBHKJTSZSrq7IHn+cdoYnJRXIe2I96PQFxi+E=
X-Received: by 2002:a50:d486:0:b0:522:4741:d992 with SMTP id
 s6-20020a50d486000000b005224741d992mr152402edi.4.1691790922815; Fri, 11 Aug
 2023 14:55:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230811112037.1147863-1-vdonnefort@google.com>
In-Reply-To: <20230811112037.1147863-1-vdonnefort@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Fri, 11 Aug 2023 14:55:11 -0700
Message-ID: <CAC_TJvcwWRSs-YcP-_awLn2VU9m-AT8HzSq+aKHvSPkpRw5=OA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Remove size-order align in the nVHE hyp
 private VA range
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	qperret@google.com, smostafa@google.com, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 11, 2023 at 4:20=E2=80=AFAM Vincent Donnefort <vdonnefort@googl=
e.com> wrote:
>
> commit f922c13e778d ("KVM: arm64: Introduce
> pkvm_alloc_private_va_range()") and commit 92abe0f81e13 ("KVM: arm64:
> Introduce hyp_alloc_private_va_range()") added an alignment for the
> start address of any allocation into the nVHE hypervisor private VA
> range.
>
> This alignment (order of the size of the allocation) intends to enable
> efficient stack verification (if the PAGE_SHIFT bit is zero, the stack
> pointer is on the guard page and a stack overflow occurred).
>
> But this is only necessary for stack allocation and can waste a lot of
> VA space. So instead make stack-specific functions, handling the guard
> page requirements, while other users (e.g.  fixmap) will only get page
> alignment.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> ---
>
> v1 -> v2:
>   * hyp_create_stack() -> pkvm_create_stack() (Kalesh)
>   * Add !protected version as well (Kalesh)
>   * phys_addr_t as type for PAs
>
> ---
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kv=
m_mmu.h
> index 0e1e1ab17b4d..96a80e8f6226 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -168,6 +168,7 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, siz=
e_t size,
>                            void __iomem **haddr);
>  int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>                              void **haddr);
> +int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr);
>  void __init free_hyp_pgds(void);
>
>  void stage2_unmap_vm(struct kvm *kvm);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 72dc53a75d1c..9acce45df2b5 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2283,30 +2283,8 @@ static int __init init_hyp_mode(void)
>         for_each_possible_cpu(cpu) {
>                 struct kvm_nvhe_init_params *params =3D per_cpu_ptr_nvhe_=
sym(kvm_init_params, cpu);
>                 char *stack_page =3D (char *)per_cpu(kvm_arm_hyp_stack_pa=
ge, cpu);
> -               unsigned long hyp_addr;
>
> -               /*
> -                * Allocate a contiguous HYP private VA range for the sta=
ck
> -                * and guard page. The allocation is also aligned based o=
n
> -                * the order of its size.
> -                */
> -               err =3D hyp_alloc_private_va_range(PAGE_SIZE * 2, &hyp_ad=
dr);
> -               if (err) {
> -                       kvm_err("Cannot allocate hyp stack guard page\n")=
;
> -                       goto out_err;
> -               }
> -
> -               /*
> -                * Since the stack grows downwards, map the stack to the =
page
> -                * at the higher address and leave the lower guard page
> -                * unbacked.
> -                *
> -                * Any valid stack address now has the PAGE_SHIFT bit as =
1
> -                * and addresses corresponding to the guard page have the
> -                * PAGE_SHIFT bit as 0 - this is used for overflow detect=
ion.
> -                */
> -               err =3D __create_hyp_mappings(hyp_addr + PAGE_SIZE, PAGE_=
SIZE,
> -                                           __pa(stack_page), PAGE_HYP);
> +               err =3D create_hyp_stack(__pa(stack_page), &params->stack=
_hyp_va);
>                 if (err) {
>                         kvm_err("Cannot map hyp stack\n");
>                         goto out_err;
> @@ -2319,8 +2297,6 @@ static int __init init_hyp_mode(void)
>                  * has been mapped in the flexible private VA space.
>                  */
>                 params->stack_pa =3D __pa(stack_page);
> -
> -               params->stack_hyp_va =3D hyp_addr + (2 * PAGE_SIZE);
>         }
>
>         for_each_possible_cpu(cpu) {
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/in=
clude/nvhe/mm.h
> index d5ec972b5c1e..230e4f2527de 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -26,6 +26,7 @@ int pkvm_create_mappings_locked(void *from, void *to, e=
num kvm_pgtable_prot prot
>  int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
>                                   enum kvm_pgtable_prot prot,
>                                   unsigned long *haddr);
> +int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
>  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
>
>  #endif /* __KVM_HYP_MM_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 318298eb3d6b..65a7a186d7b2 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -44,6 +44,27 @@ static int __pkvm_create_mappings(unsigned long start,=
 unsigned long size,
>         return err;
>  }
>
> +static int __pkvm_alloc_private_va_range(unsigned long start, size_t siz=
e)
> +{
> +       unsigned long cur;
> +
> +       hyp_assert_lock_held(&pkvm_pgd_lock);
> +
> +       if (!start || start < __io_map_base)
> +               return -EINVAL;
> +
> +       /* The allocated size is always a multiple of PAGE_SIZE */
> +       cur =3D start + PAGE_ALIGN(size);
> +
> +       /* Are we overflowing on the vmemmap ? */
> +       if (cur > __hyp_vmemmap)
> +               return -ENOMEM;
> +
> +       __io_map_base =3D cur;
> +
> +       return 0;
> +}
> +
>  /**
>   * pkvm_alloc_private_va_range - Allocates a private VA range.
>   * @size:      The size of the VA range to reserve.
> @@ -56,27 +77,16 @@ static int __pkvm_create_mappings(unsigned long start=
, unsigned long size,
>   */
>  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
>  {
> -       unsigned long base, addr;
> -       int ret =3D 0;
> +       unsigned long addr;
> +       int ret;
>
>         hyp_spin_lock(&pkvm_pgd_lock);
> -
> -       /* Align the allocation based on the order of its size */
> -       addr =3D ALIGN(__io_map_base, PAGE_SIZE << get_order(size));
> -
> -       /* The allocated size is always a multiple of PAGE_SIZE */
> -       base =3D addr + PAGE_ALIGN(size);
> -
> -       /* Are we overflowing on the vmemmap ? */
> -       if (!addr || base > __hyp_vmemmap)
> -               ret =3D -ENOMEM;
> -       else {
> -               __io_map_base =3D base;
> -               *haddr =3D addr;
> -       }
> -
> +       addr =3D __io_map_base;
> +       ret =3D __pkvm_alloc_private_va_range(addr, size);
>         hyp_spin_unlock(&pkvm_pgd_lock);
>
> +       *haddr =3D addr;
> +
>         return ret;
>  }
>
> @@ -340,6 +350,45 @@ int hyp_create_idmap(u32 hyp_va_bits)
>         return __pkvm_create_mappings(start, end - start, start, PAGE_HYP=
_EXEC);
>  }
>
> +int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr)
> +{
> +       unsigned long addr, prev_base;
> +       size_t size;
> +       int ret;
> +
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +
> +       prev_base =3D __io_map_base;
> +       /*
> +        * Efficient stack verification using the PAGE_SHIFT bit implies
> +        * an alignment of our allocation on the order of the size.
> +        */
> +       size =3D PAGE_SIZE * 2;
> +       addr =3D ALIGN(__io_map_base, size);
> +
> +       ret =3D __pkvm_alloc_private_va_range(addr, size);
> +       if (!ret) {
> +               /*
> +                * Since the stack grows downwards, map the stack to the =
page
> +                * at the higher address and leave the lower guard page
> +                * unbacked.
> +                *
> +                * Any valid stack address now has the PAGE_SHIFT bit as =
1
> +                * and addresses corresponding to the guard page have the
> +                * PAGE_SHIFT bit as 0 - this is used for overflow detect=
ion.
> +                */
> +               ret =3D kvm_pgtable_hyp_map(&pkvm_pgtable, addr + PAGE_SI=
ZE,
> +                                         PAGE_SIZE, phys, PAGE_HYP);
> +               if (ret)
> +                       __io_map_base =3D prev_base;
> +       }
> +       hyp_spin_unlock(&pkvm_pgd_lock);
> +
> +       *haddr =3D addr + size;
> +
> +       return ret;
> +}
> +
>  static void *admit_host_page(void *arg)
>  {
>         struct kvm_hyp_memcache *host_mc =3D arg;
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/se=
tup.c
> index bb98630dfeaf..0d5e0a89ddce 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -113,7 +113,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, un=
signed long size,
>
>         for (i =3D 0; i < hyp_nr_cpus; i++) {
>                 struct kvm_nvhe_init_params *params =3D per_cpu_ptr(&kvm_=
init_params, i);
> -               unsigned long hyp_addr;
>
>                 start =3D (void *)kern_hyp_va(per_cpu_base[i]);
>                 end =3D start + PAGE_ALIGN(hyp_percpu_size);
> @@ -121,33 +120,9 @@ static int recreate_hyp_mappings(phys_addr_t phys, u=
nsigned long size,
>                 if (ret)
>                         return ret;
>
> -               /*
> -                * Allocate a contiguous HYP private VA range for the sta=
ck
> -                * and guard page. The allocation is also aligned based o=
n
> -                * the order of its size.
> -                */
> -               ret =3D pkvm_alloc_private_va_range(PAGE_SIZE * 2, &hyp_a=
ddr);
> +               ret =3D pkvm_create_stack(params->stack_pa, &params->stac=
k_hyp_va);
>                 if (ret)
>                         return ret;
> -
> -               /*
> -                * Since the stack grows downwards, map the stack to the =
page
> -                * at the higher address and leave the lower guard page
> -                * unbacked.
> -                *
> -                * Any valid stack address now has the PAGE_SHIFT bit as =
1
> -                * and addresses corresponding to the guard page have the
> -                * PAGE_SHIFT bit as 0 - this is used for overflow detect=
ion.
> -                */
> -               hyp_spin_lock(&pkvm_pgd_lock);
> -               ret =3D kvm_pgtable_hyp_map(&pkvm_pgtable, hyp_addr + PAG=
E_SIZE,
> -                                       PAGE_SIZE, params->stack_pa, PAGE=
_HYP);
> -               hyp_spin_unlock(&pkvm_pgd_lock);
> -               if (ret)
> -                       return ret;
> -
> -               /* Update stack_hyp_va to end of the stack's private VA r=
ange */
> -               params->stack_hyp_va =3D hyp_addr + (2 * PAGE_SIZE);
>         }
>
>         /*
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d3b4feed460c..32c2f1665c6e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -592,6 +592,25 @@ int create_hyp_mappings(void *from, void *to, enum k=
vm_pgtable_prot prot)
>         return 0;
>  }
>
> +static int __hyp_alloc_private_va_range(unsigned long base)
> +{
> +       lockdep_assert_held(&kvm_hyp_pgd_mutex);
> +
> +       if (!PAGE_ALIGNED(base))
> +               return -EINVAL;
> +
> +       /*
> +        * Verify that BIT(VA_BITS - 1) hasn't been flipped by
> +        * allocating the new area, as it would indicate we've
> +        * overflowed the idmap/IO address range.
> +        */
> +       if ((base ^ io_map_base) & BIT(VA_BITS - 1))
> +               return -ENOMEM;
> +
> +       io_map_base =3D base;
> +
> +       return 0;
> +}
>
>  /**
>   * hyp_alloc_private_va_range - Allocates a private VA range.
> @@ -612,26 +631,16 @@ int hyp_alloc_private_va_range(size_t size, unsigne=
d long *haddr)
>
>         /*
>          * This assumes that we have enough space below the idmap
> -        * page to allocate our VAs. If not, the check below will
> -        * kick. A potential alternative would be to detect that
> -        * overflow and switch to an allocation above the idmap.
> +        * page to allocate our VAs. If not, the check in
> +        * __hyp_alloc_private_va_range() will kick. A potential
> +        * alternative would be to detect that overflow and switch
> +        * to an allocation above the idmap.
>          *
>          * The allocated size is always a multiple of PAGE_SIZE.
>          */
> -       base =3D io_map_base - PAGE_ALIGN(size);
> -
> -       /* Align the allocation based on the order of its size */
> -       base =3D ALIGN_DOWN(base, PAGE_SIZE << get_order(size));
> -
> -       /*
> -        * Verify that BIT(VA_BITS - 1) hasn't been flipped by
> -        * allocating the new area, as it would indicate we've
> -        * overflowed the idmap/IO address range.
> -        */
> -       if ((base ^ io_map_base) & BIT(VA_BITS - 1))
> -               ret =3D -ENOMEM;
> -       else
> -               *haddr =3D io_map_base =3D base;
> +       size =3D PAGE_ALIGN(size);
> +       base =3D io_map_base - size;
> +       ret =3D __hyp_alloc_private_va_range(base);
>
>         mutex_unlock(&kvm_hyp_pgd_mutex);
>
> @@ -668,6 +677,48 @@ static int __create_hyp_private_mapping(phys_addr_t =
phys_addr, size_t size,
>         return ret;
>  }
>
> +int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr)
> +{
> +       unsigned long base;
> +       size_t size;
> +       int ret;
> +
> +       mutex_lock(&kvm_hyp_pgd_mutex);
> +       /*
> +        * Efficient stack verification using the PAGE_SHIFT bit implies
> +        * an alignment of our allocation on the order of the size.
> +        */
> +       size =3D PAGE_SIZE * 2;
> +       base =3D ALIGN_DOWN(io_map_base - size, size);
> +
> +       ret =3D __hyp_alloc_private_va_range(base);
> +
> +       mutex_unlock(&kvm_hyp_pgd_mutex);
> +
> +       if (ret) {
> +               kvm_err("Cannot allocate hyp stack guard page\n");
> +               return ret;
> +       }
> +
> +       /*
> +        * Since the stack grows downwards, map the stack to the page
> +        * at the higher address and leave the lower guard page
> +        * unbacked.
> +        *
> +        * Any valid stack address now has the PAGE_SHIFT bit as 1
> +        * and addresses corresponding to the guard page have the
> +        * PAGE_SHIFT bit as 0 - this is used for overflow detection.
> +        */
> +       ret =3D __create_hyp_mappings(base + PAGE_SIZE, PAGE_SIZE, phys_a=
ddr,
> +                                   PAGE_HYP);
> +       if (ret)
> +               kvm_err("Cannot map hyp stack\n");

Should we reset the io_map_base if the mapping failed here as well?

Otherwise lgtm, Reviewed-by: Kalesh Singh <kaleshsingh@google.com>

Thanks,
Kalesh

> +
> +       *haddr =3D base + size;
> +
> +       return ret;
> +}
> +
>  /**
>   * create_hyp_io_mappings - Map IO into both kernel and HYP
>   * @phys_addr: The physical start address which gets mapped
>
> base-commit: 52a93d39b17dc7eb98b6aa3edb93943248e03b2f
> --
> 2.41.0.640.ga95def55d0-goog
>
