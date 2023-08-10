Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420611E1C0
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 17:25:13 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-51e24210395so830a12.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 10:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691688312; x=1692293112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nzf5hJ7BzpZYH6Y8Uq33xq63oRcQgq/k6tP4wlcWygk=;
        b=P2jiIsbQPer0Zs36BqszCkZw4a0UXkdpLcafhw3JtSYiUWHmd/gDTXO5utZ+/BHQaJ
         +svos2vr4NRzwf5dto/VA8kb6Bx66XMnY+jISd+rKGYgVwk40HpLvIyYyD8maNgA269x
         OesMlGv8mQCpAIRJpL2GCV/8B3iIPif9wlNzlt/dmzDEixI01Ygl7SQF+lQJITfZN6Kh
         lgWLs0qp+g2nxH7toCUhajZBiZvs8zoWjIkts89u1ObUW+Oa7mkQ59/3ZSqkps2WdVZr
         wV11b5+WghG0o//FdvpbEGgoxAnmSX5ymdtABSQkj8+ggsjWElEzqFo+GhvncYpZwYt/
         S+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691688312; x=1692293112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nzf5hJ7BzpZYH6Y8Uq33xq63oRcQgq/k6tP4wlcWygk=;
        b=h9Q9HHrRBvdMH6iidz1TytbENlNBrxjjOBQ7UiEUzeMwvFqbn8OLOumH49dKfWwRdT
         Y43tEYQMpPCzZZGc/XMszvecpstbvlhuhwWmby3IdV3LGZME67YGfC2wZrX/+H/8HOaY
         qyUtsqOX7SZmC2F8/xLqcosk7dWdpQeA3Nk7/e9qMGw3qT8IHRoeJo6HNmBhBfseaTeL
         LTehtPhoyFIcMsVx6M2Y72G0EkH6eEZ3ihEE0cto5sxJFErWVN16Uk0NzfyIUeKZ5Su8
         KWWMQ8Lp3d7rs4ou3Lzq0t54rD2g0Ut/ziRfHbzcKfcSz2qDpIXwAPTkknhTUshSk3jC
         ANvA==
X-Gm-Message-State: AOJu0YylHU3fyRn0U6rKDxUD3r9ZRldxnAT0pJnH4PJMfF6N3nXkVN0P
	NWuwGbT6YvYCtgG4qAmsXEU/vIR+xWKplyR05QdCnw==
X-Google-Smtp-Source: AGHT+IFzZydg0dbv1utC/fNmDoU/v9X6/7XdcjX0TSCs/loL4+EwGUyupOCwC5Y5zCj70iwVH4+H/BZGN+Vx+FTmeo4=
X-Received: by 2002:a50:d549:0:b0:51a:1ffd:10e with SMTP id
 f9-20020a50d549000000b0051a1ffd010emr4213edj.3.1691688311991; Thu, 10 Aug
 2023 10:25:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230810133432.680392-1-vdonnefort@google.com>
 <CAC_TJvd_K=P4-sMRLu8cn8J8YvBwD0ZxEhocG+Q0Z7SpDvq-Fg@mail.gmail.com> <ZNUZ3/nJkwUp4R3D@google.com>
In-Reply-To: <ZNUZ3/nJkwUp4R3D@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 10 Aug 2023 10:25:00 -0700
Message-ID: <CAC_TJvcru7kRDr_DeUQ3Hhe8pCqhhgBf4egYPXERpA+0Rp8uUQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Do not size-order align pkvm_alloc_private_va_range()
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	qperret@google.com, smostafa@google.com, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 10, 2023 at 10:09=E2=80=AFAM Vincent Donnefort
<vdonnefort@google.com> wrote:
>
> On Thu, Aug 10, 2023 at 09:42:54AM -0700, Kalesh Singh wrote:
> > On Thu, Aug 10, 2023 at 6:34=E2=80=AFAM Vincent Donnefort <vdonnefort@g=
oogle.com> wrote:
> > >
> > > commit f922c13e778d ("KVM: arm64: Introduce pkvm_alloc_private_va_ran=
ge()")
> > > added an alignment for the start address of any allocation into the n=
VHE
> > > protected hypervisor private VA range.
> > >
> > > This alignment (order of the size of the allocation) intends to enabl=
e
> > > efficient stack guard verification (if the PAGE_SHIFT bit is zero, th=
e
> > > stack pointer is on the stack guard page, a stack overflow occurred).
> > >
> > > But a such alignment only makes sense for stack allocation and can wa=
ste
> > > a lot of VA space. So instead make a stack specific allocation functi=
on
> > > (hyp_create_stack()) handling the stack guard page requirements, whil=
e
> > > other users (e.g. fixmap) will only get page alignment.
> > >
> > > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > >
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hy=
p/include/nvhe/mm.h
> > > index d5ec972b5c1e..71d17ddb562f 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> > > @@ -18,6 +18,7 @@ void *hyp_fixmap_map(phys_addr_t phys);
> > >  void hyp_fixmap_unmap(void);
> > >
> > >  int hyp_create_idmap(u32 hyp_va_bits);
> > > +int hyp_create_stack(unsigned long stack_pa, unsigned long *stack_va=
);
> > >  int hyp_map_vectors(void);
> > >  int hyp_back_vmemmap(phys_addr_t back);
> > >  int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/m=
m.c
> > > index 318298eb3d6b..275e33a8be9a 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > > @@ -44,6 +44,28 @@ static int __pkvm_create_mappings(unsigned long st=
art, unsigned long size,
> > >         return err;
> > >  }
> > >
> > > +static int __pkvm_alloc_private_va_range(unsigned long start, size_t=
 size)
> > > +{
> > > +       unsigned long cur;
> > > +       int ret =3D 0;
> > > +
> > > +       hyp_assert_lock_held(&pkvm_pgd_lock);
> > > +
> > > +       if (!start || start < __io_map_base)
> > > +               return -EINVAL;
> > > +
> > > +       /* The allocated size is always a multiple of PAGE_SIZE */
> > > +       cur =3D start + PAGE_ALIGN(size);
> > > +
> > > +       /* Are we overflowing on the vmemmap ? */
> > > +       if (cur > __hyp_vmemmap)
> > > +               ret =3D -ENOMEM;
> > > +       else
> > > +               __io_map_base =3D cur;
> > > +
> > > +       return ret;
> > > +}
> > > +
> > >  /**
> > >   * pkvm_alloc_private_va_range - Allocates a private VA range.
> > >   * @size:      The size of the VA range to reserve.
> > > @@ -56,27 +78,16 @@ static int __pkvm_create_mappings(unsigned long s=
tart, unsigned long size,
> > >   */
> > >  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
> > >  {
> > > -       unsigned long base, addr;
> > > -       int ret =3D 0;
> > > +       unsigned long addr;
> > > +       int ret;
> > >
> > >         hyp_spin_lock(&pkvm_pgd_lock);
> > > -
> > > -       /* Align the allocation based on the order of its size */
> > > -       addr =3D ALIGN(__io_map_base, PAGE_SIZE << get_order(size));
> > > -
> > > -       /* The allocated size is always a multiple of PAGE_SIZE */
> > > -       base =3D addr + PAGE_ALIGN(size);
> > > -
> > > -       /* Are we overflowing on the vmemmap ? */
> > > -       if (!addr || base > __hyp_vmemmap)
> > > -               ret =3D -ENOMEM;
> > > -       else {
> > > -               __io_map_base =3D base;
> > > -               *haddr =3D addr;
> > > -       }
> > > -
> > > +       addr =3D __io_map_base;
> > > +       ret =3D __pkvm_alloc_private_va_range(addr, size);
> > >         hyp_spin_unlock(&pkvm_pgd_lock);
> > >
> > > +       *haddr =3D addr;
> > > +
> > >         return ret;
> > >  }
> > >
> > > @@ -340,6 +351,39 @@ int hyp_create_idmap(u32 hyp_va_bits)
> > >         return __pkvm_create_mappings(start, end - start, start, PAGE=
_HYP_EXEC);
> > >  }
> > >
> > > +int hyp_create_stack(unsigned long stack_pa, unsigned long *stack_va=
)
> > > +{
> >
> > Hi Vincent,
> >
> > Can you rename this instead as pkvm_create_stack(), since it's for the
> > protected case.
>
> Not sure about the pkvm_create_stack(), I wanted to have something that l=
ooks
> like hyp_create_idmap() that is also pkvm only. And as the latter, the st=
ack
> creation happens only during the setup, so I thought I'd better keep this
> format.
>
> Thoughts?

What I meant is (following the existing naming convention):

    pKVM:     pkvm_create_stack()  ->  pkvm_alloc_private_va_range()
    nVHE:      hyp_create_stack()    ->  hyp_alloc_private_va_range()

>
> >
> > And I assume we want the same thing for the conventional nVHE mode:
> > remove the alignment from hyp_alloc_private_va_range() into a
> > hyp_create_stack().
>
> Ah yes, good catch, even though it'll be less of a problem for non-protec=
ted
> nVHE, it'd probably be a good thing of aligning both. Might do that in a
> separated patch though.

Yeah fine with a follow up patch.

Thanks,
Kalesh

>
> >
> > Thanks,
> > Kalesh
>
> Thanks for having a look!
>
> >
> >
> > > +       unsigned long addr;
> > > +       size_t size;
> > > +       int ret;
> > > +
> > > +       hyp_spin_lock(&pkvm_pgd_lock);
> > > +
> > > +       /* Make room for the guard page */
> > > +       size =3D PAGE_SIZE * 2;
> > > +       addr =3D ALIGN(__io_map_base, size);
> > > +
> > > +       ret =3D __pkvm_alloc_private_va_range(addr, size);
> > > +       if (!ret) {
> > > +               /*
> > > +                * Since the stack grows downwards, map the stack to =
the page
> > > +                * at the higher address and leave the lower guard pa=
ge
> > > +                * unbacked.
> > > +                *
> > > +                * Any valid stack address now has the PAGE_SHIFT bit=
 as 1
> > > +                * and addresses corresponding to the guard page have=
 the
> > > +                * PAGE_SHIFT bit as 0 - this is used for overflow de=
tection.
> > > +                */
> > > +               ret =3D kvm_pgtable_hyp_map(&pkvm_pgtable, addr + PAG=
E_SIZE,
> > > +                                         PAGE_SIZE, stack_pa, PAGE_H=
YP);
> > > +       }
> > > +       hyp_spin_unlock(&pkvm_pgd_lock);
> > > +
> > > +       *stack_va =3D addr + size;
> > > +
> > > +       return ret;
> > > +}
> > > +
> > >  static void *admit_host_page(void *arg)
> > >  {
> > >         struct kvm_hyp_memcache *host_mc =3D arg;
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvh=
e/setup.c
> > > index bb98630dfeaf..782c8d0fb905 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> > > @@ -121,33 +121,11 @@ static int recreate_hyp_mappings(phys_addr_t ph=
ys, unsigned long size,
> > >                 if (ret)
> > >                         return ret;
> > >
> > > -               /*
> > > -                * Allocate a contiguous HYP private VA range for the=
 stack
> > > -                * and guard page. The allocation is also aligned bas=
ed on
> > > -                * the order of its size.
> > > -                */
> > > -               ret =3D pkvm_alloc_private_va_range(PAGE_SIZE * 2, &h=
yp_addr);
> > > +               ret =3D hyp_create_stack(params->stack_pa, &hyp_addr)=
;
> > >                 if (ret)
> > >                         return ret;
> > >
> > > -               /*
> > > -                * Since the stack grows downwards, map the stack to =
the page
> > > -                * at the higher address and leave the lower guard pa=
ge
> > > -                * unbacked.
> > > -                *
> > > -                * Any valid stack address now has the PAGE_SHIFT bit=
 as 1
> > > -                * and addresses corresponding to the guard page have=
 the
> > > -                * PAGE_SHIFT bit as 0 - this is used for overflow de=
tection.
> > > -                */
> > > -               hyp_spin_lock(&pkvm_pgd_lock);
> > > -               ret =3D kvm_pgtable_hyp_map(&pkvm_pgtable, hyp_addr +=
 PAGE_SIZE,
> > > -                                       PAGE_SIZE, params->stack_pa, =
PAGE_HYP);
> > > -               hyp_spin_unlock(&pkvm_pgd_lock);
> > > -               if (ret)
> > > -                       return ret;
> > > -
> > > -               /* Update stack_hyp_va to end of the stack's private =
VA range */
> > > -               params->stack_hyp_va =3D hyp_addr + (2 * PAGE_SIZE);
> > > +               params->stack_hyp_va =3D hyp_addr;
> > >         }
> > >
> > >         /*
> > >
> > > base-commit: 52a93d39b17dc7eb98b6aa3edb93943248e03b2f
> > > --
> > > 2.41.0.640.ga95def55d0-goog
> > >
