Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E836B20F88
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 16:43:09 +0000 (UTC)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so161a12.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 09:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691685788; x=1692290588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pCRQDPUjfEEwAJEkHAr1294jQlqc05D8+1i3oYps4U=;
        b=iAIYky6G2/jp5l3/s+cjWoVkl5A0eP7Yk/8zuWdnxN415xvyN4+a9zp7kbIwOXKLVE
         XSx3Fj+rVt+oLjiGCbvWCMCcVDGNLjNuVIWivGW+M5duW+4/BwGF7KJRGl3gjIWOIKxg
         u6vYlXTtBnXCsWHryurAbBPTf2SbDa1DZA+yrdMedw9QsJjGfncC4kQ7MLrk22x7yzhD
         TtqcI9invS9pawqT5SNJiSnmx/2YPcYKYjxSsMmhf7LoCOYLCPeLEwL5no/C7gohAUD5
         JomjYzP0RFPYBK7MoKMyxSqbdfY7GBLo6UX6JRN5E638SU9zakm30uihFtJlUUgsZvAS
         oo6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691685788; x=1692290588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pCRQDPUjfEEwAJEkHAr1294jQlqc05D8+1i3oYps4U=;
        b=lUvKwye+keUSSYJc8OouyopTSz0aqVLvUCyja7p1rpTuwa7xWsu5YTTfnlOCf9zmYr
         7WoZ9osSmJUZaQBgAhoUHIftk5A+9V33t2hAWEHSEMgWcBuFtd79dlNJ8lsesbmghI+x
         xsXJbpXxIxeKGOTk8ZECiOjPG5SO1uMwQahz7u7Iov6ke1fSF0Nm37239rmg4HpjACK0
         dXme+L0nzORcVmT7smaJdevBGm5mwwPwPZPdgPiKBPyPedavPJMQ/bVEkY9JT56MfN2o
         GjlCyuiO99ecp0XLktGx7XOgqL/FhLkVYayO8lc5/UJjMMqujeL/wX6osWgl8SNY44oP
         5Exw==
X-Gm-Message-State: AOJu0Yypq/vyzPpMdRXAhNg+b1h6ObUq4ofcHy79NhFEs67bLwebzmW8
	3Vg860gN7gw1GhWu+SZr4UMtgv4cMdKtloqkj6ikfg==
X-Google-Smtp-Source: AGHT+IE8VU94WHYMQhQxKzpudSn9Hbco4CVz04xQP9f+hGuFa3GbrufDKxAWIRSLlzCJGecKtouWnKT9T4rAEHegt7c=
X-Received: by 2002:a50:f60d:0:b0:522:41c9:9b9 with SMTP id
 c13-20020a50f60d000000b0052241c909b9mr238914edn.5.1691685786236; Thu, 10 Aug
 2023 09:43:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230810133432.680392-1-vdonnefort@google.com>
In-Reply-To: <20230810133432.680392-1-vdonnefort@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 10 Aug 2023 09:42:54 -0700
Message-ID: <CAC_TJvd_K=P4-sMRLu8cn8J8YvBwD0ZxEhocG+Q0Z7SpDvq-Fg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Do not size-order align pkvm_alloc_private_va_range()
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	qperret@google.com, smostafa@google.com, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 10, 2023 at 6:34=E2=80=AFAM Vincent Donnefort <vdonnefort@googl=
e.com> wrote:
>
> commit f922c13e778d ("KVM: arm64: Introduce pkvm_alloc_private_va_range()=
")
> added an alignment for the start address of any allocation into the nVHE
> protected hypervisor private VA range.
>
> This alignment (order of the size of the allocation) intends to enable
> efficient stack guard verification (if the PAGE_SHIFT bit is zero, the
> stack pointer is on the stack guard page, a stack overflow occurred).
>
> But a such alignment only makes sense for stack allocation and can waste
> a lot of VA space. So instead make a stack specific allocation function
> (hyp_create_stack()) handling the stack guard page requirements, while
> other users (e.g. fixmap) will only get page alignment.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/in=
clude/nvhe/mm.h
> index d5ec972b5c1e..71d17ddb562f 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -18,6 +18,7 @@ void *hyp_fixmap_map(phys_addr_t phys);
>  void hyp_fixmap_unmap(void);
>
>  int hyp_create_idmap(u32 hyp_va_bits);
> +int hyp_create_stack(unsigned long stack_pa, unsigned long *stack_va);
>  int hyp_map_vectors(void);
>  int hyp_back_vmemmap(phys_addr_t back);
>  int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 318298eb3d6b..275e33a8be9a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -44,6 +44,28 @@ static int __pkvm_create_mappings(unsigned long start,=
 unsigned long size,
>         return err;
>  }
>
> +static int __pkvm_alloc_private_va_range(unsigned long start, size_t siz=
e)
> +{
> +       unsigned long cur;
> +       int ret =3D 0;
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
> +               ret =3D -ENOMEM;
> +       else
> +               __io_map_base =3D cur;
> +
> +       return ret;
> +}
> +
>  /**
>   * pkvm_alloc_private_va_range - Allocates a private VA range.
>   * @size:      The size of the VA range to reserve.
> @@ -56,27 +78,16 @@ static int __pkvm_create_mappings(unsigned long start=
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
> @@ -340,6 +351,39 @@ int hyp_create_idmap(u32 hyp_va_bits)
>         return __pkvm_create_mappings(start, end - start, start, PAGE_HYP=
_EXEC);
>  }
>
> +int hyp_create_stack(unsigned long stack_pa, unsigned long *stack_va)
> +{

Hi Vincent,

Can you rename this instead as pkvm_create_stack(), since it's for the
protected case.

And I assume we want the same thing for the conventional nVHE mode:
remove the alignment from hyp_alloc_private_va_range() into a
hyp_create_stack().

Thanks,
Kalesh


> +       unsigned long addr;
> +       size_t size;
> +       int ret;
> +
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +
> +       /* Make room for the guard page */
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
> +                                         PAGE_SIZE, stack_pa, PAGE_HYP);
> +       }
> +       hyp_spin_unlock(&pkvm_pgd_lock);
> +
> +       *stack_va =3D addr + size;
> +
> +       return ret;
> +}
> +
>  static void *admit_host_page(void *arg)
>  {
>         struct kvm_hyp_memcache *host_mc =3D arg;
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/se=
tup.c
> index bb98630dfeaf..782c8d0fb905 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -121,33 +121,11 @@ static int recreate_hyp_mappings(phys_addr_t phys, =
unsigned long size,
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
> +               ret =3D hyp_create_stack(params->stack_pa, &hyp_addr);
>                 if (ret)
>                         return ret;
>
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
> +               params->stack_hyp_va =3D hyp_addr;
>         }
>
>         /*
>
> base-commit: 52a93d39b17dc7eb98b6aa3edb93943248e03b2f
> --
> 2.41.0.640.ga95def55d0-goog
>
