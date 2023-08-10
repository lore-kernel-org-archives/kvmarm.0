Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2DF1E1C0
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 17:09:58 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-3fbea14700bso10490415e9.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 10:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691687397; x=1692292197;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5k2bgFIeP6rEvqhW+76MYexuUI5okzvmYLcGv7ImAA4=;
        b=348rKh2mB9+JZM1jeKzEc5ff04qfUKJElqfM7dcXuWR7WpqcsYyE0SR6pV+XKf3EXS
         EtRj6Pc2PahN400SFGd0Enu7oFvk/Y6fqGSqHRBevhWpSPC+eT3j/oza8H1lWhXds9bv
         ohZZ3YulUFTEuuWRPQjQe7hsBvCUvA42F3W65g10bk1Ey0D8p/7nmY8r+Bs/0pArjg/T
         ud1XhzVn+8MMJHmXAgHUxQc1oCGKFPmdEFRO0qRz4JfBMC4nDos7JeCDFomxzU1xCcsc
         13mfewUufnuDbOxu3rAUm/0c53ed3097YyoBTxgIXYrNWctWltSW563BrMdaSVwy0N0d
         qcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691687397; x=1692292197;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5k2bgFIeP6rEvqhW+76MYexuUI5okzvmYLcGv7ImAA4=;
        b=MDthIo7WfxezAv808I88cvkdFB6M3uJr4b16IBpLB2PH6LwVAQrduM34rMQ2w5kUJp
         /SnaOjv3rB3cI9MHDpfo5G7v0IUbUcug/7jOrZRv/SgnqktkjjERel37nG4tK7d50fxu
         qKoH7naj+k69yOcvDhv7QPXpYpiLvy/HP0qJi4ZjLroY/msO3VAAmLsunMFvTd38xPcp
         pmiPhnElPnvtTL08DrkXlul4Iy1wZxE1yPwB6Vg+tLOgfoJPtaBBa7or+oEemLxibRld
         HpzpioRX7haBOtrCNah9QTJIrkkxtjDs1oDbp5LVRrJiHr9fQqN/atg7MPCdKJhzpS+s
         /vFg==
X-Gm-Message-State: AOJu0YyniG9tyokMWeaNw0qAQ+U1dNufWTgv2EfZJzx9U4ry90prC/yd
	W2nX6tI7JgJIz3+5+ZSiEh8+7A==
X-Google-Smtp-Source: AGHT+IEWb/Xo7u8eP8qwVSZXPSJwXV2AwZhLO7gPmVS6pQLqyddlKtO7VqIGu2pqOFkudZuyrtfkwg==
X-Received: by 2002:a05:6000:c8:b0:313:f548:25b9 with SMTP id q8-20020a05600000c800b00313f54825b9mr2591405wrx.40.1691687396520;
        Thu, 10 Aug 2023 10:09:56 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id f17-20020adff451000000b00317efb41e44sm2763727wrp.18.2023.08.10.10.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 10:09:55 -0700 (PDT)
Date: Thu, 10 Aug 2023 18:09:51 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev,
	qperret@google.com, smostafa@google.com,
	linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
	will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Do not size-order align
 pkvm_alloc_private_va_range()
Message-ID: <ZNUZ3/nJkwUp4R3D@google.com>
References: <20230810133432.680392-1-vdonnefort@google.com>
 <CAC_TJvd_K=P4-sMRLu8cn8J8YvBwD0ZxEhocG+Q0Z7SpDvq-Fg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC_TJvd_K=P4-sMRLu8cn8J8YvBwD0ZxEhocG+Q0Z7SpDvq-Fg@mail.gmail.com>

On Thu, Aug 10, 2023 at 09:42:54AM -0700, Kalesh Singh wrote:
> On Thu, Aug 10, 2023 at 6:34 AM Vincent Donnefort <vdonnefort@google.com> wrote:
> >
> > commit f922c13e778d ("KVM: arm64: Introduce pkvm_alloc_private_va_range()")
> > added an alignment for the start address of any allocation into the nVHE
> > protected hypervisor private VA range.
> >
> > This alignment (order of the size of the allocation) intends to enable
> > efficient stack guard verification (if the PAGE_SHIFT bit is zero, the
> > stack pointer is on the stack guard page, a stack overflow occurred).
> >
> > But a such alignment only makes sense for stack allocation and can waste
> > a lot of VA space. So instead make a stack specific allocation function
> > (hyp_create_stack()) handling the stack guard page requirements, while
> > other users (e.g. fixmap) will only get page alignment.
> >
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > index d5ec972b5c1e..71d17ddb562f 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > @@ -18,6 +18,7 @@ void *hyp_fixmap_map(phys_addr_t phys);
> >  void hyp_fixmap_unmap(void);
> >
> >  int hyp_create_idmap(u32 hyp_va_bits);
> > +int hyp_create_stack(unsigned long stack_pa, unsigned long *stack_va);
> >  int hyp_map_vectors(void);
> >  int hyp_back_vmemmap(phys_addr_t back);
> >  int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > index 318298eb3d6b..275e33a8be9a 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > @@ -44,6 +44,28 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
> >         return err;
> >  }
> >
> > +static int __pkvm_alloc_private_va_range(unsigned long start, size_t size)
> > +{
> > +       unsigned long cur;
> > +       int ret = 0;
> > +
> > +       hyp_assert_lock_held(&pkvm_pgd_lock);
> > +
> > +       if (!start || start < __io_map_base)
> > +               return -EINVAL;
> > +
> > +       /* The allocated size is always a multiple of PAGE_SIZE */
> > +       cur = start + PAGE_ALIGN(size);
> > +
> > +       /* Are we overflowing on the vmemmap ? */
> > +       if (cur > __hyp_vmemmap)
> > +               ret = -ENOMEM;
> > +       else
> > +               __io_map_base = cur;
> > +
> > +       return ret;
> > +}
> > +
> >  /**
> >   * pkvm_alloc_private_va_range - Allocates a private VA range.
> >   * @size:      The size of the VA range to reserve.
> > @@ -56,27 +78,16 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
> >   */
> >  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
> >  {
> > -       unsigned long base, addr;
> > -       int ret = 0;
> > +       unsigned long addr;
> > +       int ret;
> >
> >         hyp_spin_lock(&pkvm_pgd_lock);
> > -
> > -       /* Align the allocation based on the order of its size */
> > -       addr = ALIGN(__io_map_base, PAGE_SIZE << get_order(size));
> > -
> > -       /* The allocated size is always a multiple of PAGE_SIZE */
> > -       base = addr + PAGE_ALIGN(size);
> > -
> > -       /* Are we overflowing on the vmemmap ? */
> > -       if (!addr || base > __hyp_vmemmap)
> > -               ret = -ENOMEM;
> > -       else {
> > -               __io_map_base = base;
> > -               *haddr = addr;
> > -       }
> > -
> > +       addr = __io_map_base;
> > +       ret = __pkvm_alloc_private_va_range(addr, size);
> >         hyp_spin_unlock(&pkvm_pgd_lock);
> >
> > +       *haddr = addr;
> > +
> >         return ret;
> >  }
> >
> > @@ -340,6 +351,39 @@ int hyp_create_idmap(u32 hyp_va_bits)
> >         return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
> >  }
> >
> > +int hyp_create_stack(unsigned long stack_pa, unsigned long *stack_va)
> > +{
> 
> Hi Vincent,
> 
> Can you rename this instead as pkvm_create_stack(), since it's for the
> protected case.

Not sure about the pkvm_create_stack(), I wanted to have something that looks
like hyp_create_idmap() that is also pkvm only. And as the latter, the stack
creation happens only during the setup, so I thought I'd better keep this
format.

Thoughts?

> 
> And I assume we want the same thing for the conventional nVHE mode:
> remove the alignment from hyp_alloc_private_va_range() into a
> hyp_create_stack().

Ah yes, good catch, even though it'll be less of a problem for non-protected
nVHE, it'd probably be a good thing of aligning both. Might do that in a
separated patch though.

> 
> Thanks,
> Kalesh

Thanks for having a look!

> 
> 
> > +       unsigned long addr;
> > +       size_t size;
> > +       int ret;
> > +
> > +       hyp_spin_lock(&pkvm_pgd_lock);
> > +
> > +       /* Make room for the guard page */
> > +       size = PAGE_SIZE * 2;
> > +       addr = ALIGN(__io_map_base, size);
> > +
> > +       ret = __pkvm_alloc_private_va_range(addr, size);
> > +       if (!ret) {
> > +               /*
> > +                * Since the stack grows downwards, map the stack to the page
> > +                * at the higher address and leave the lower guard page
> > +                * unbacked.
> > +                *
> > +                * Any valid stack address now has the PAGE_SHIFT bit as 1
> > +                * and addresses corresponding to the guard page have the
> > +                * PAGE_SHIFT bit as 0 - this is used for overflow detection.
> > +                */
> > +               ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr + PAGE_SIZE,
> > +                                         PAGE_SIZE, stack_pa, PAGE_HYP);
> > +       }
> > +       hyp_spin_unlock(&pkvm_pgd_lock);
> > +
> > +       *stack_va = addr + size;
> > +
> > +       return ret;
> > +}
> > +
> >  static void *admit_host_page(void *arg)
> >  {
> >         struct kvm_hyp_memcache *host_mc = arg;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> > index bb98630dfeaf..782c8d0fb905 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > @@ -121,33 +121,11 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> >                 if (ret)
> >                         return ret;
> >
> > -               /*
> > -                * Allocate a contiguous HYP private VA range for the stack
> > -                * and guard page. The allocation is also aligned based on
> > -                * the order of its size.
> > -                */
> > -               ret = pkvm_alloc_private_va_range(PAGE_SIZE * 2, &hyp_addr);
> > +               ret = hyp_create_stack(params->stack_pa, &hyp_addr);
> >                 if (ret)
> >                         return ret;
> >
> > -               /*
> > -                * Since the stack grows downwards, map the stack to the page
> > -                * at the higher address and leave the lower guard page
> > -                * unbacked.
> > -                *
> > -                * Any valid stack address now has the PAGE_SHIFT bit as 1
> > -                * and addresses corresponding to the guard page have the
> > -                * PAGE_SHIFT bit as 0 - this is used for overflow detection.
> > -                */
> > -               hyp_spin_lock(&pkvm_pgd_lock);
> > -               ret = kvm_pgtable_hyp_map(&pkvm_pgtable, hyp_addr + PAGE_SIZE,
> > -                                       PAGE_SIZE, params->stack_pa, PAGE_HYP);
> > -               hyp_spin_unlock(&pkvm_pgd_lock);
> > -               if (ret)
> > -                       return ret;
> > -
> > -               /* Update stack_hyp_va to end of the stack's private VA range */
> > -               params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
> > +               params->stack_hyp_va = hyp_addr;
> >         }
> >
> >         /*
> >
> > base-commit: 52a93d39b17dc7eb98b6aa3edb93943248e03b2f
> > --
> > 2.41.0.640.ga95def55d0-goog
> >
