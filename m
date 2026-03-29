Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798F02FD7D3
	for <kvmarm@lists.linux.dev>; Sun, 29 Mar 2026 13:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774791722; cv=pass; b=AFOZjElLNQHHUdr+o7RTotsxOOrxQLOWP2y+1rrvweyOY6F8TYgZhsm4In5yTY4+fIfz+uh9tRGUZSrpPVJzqGlVPyrBTENXcvyZX3gu4O3vuMBgRQ0HDtaFRuO/aNs/Xdtvn9cf/vFfMmZIhpjHeMPmqiBOO3I+kk3bKeNvcvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774791722; c=relaxed/simple;
	bh=yG0GY9Z7DdEjRqq/jjl/HZBwFW+WK1FwgjS1QWQk1HQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CeZ6DvSuzCkzSVTnxxFs3NNs0+ncmovgnzel6mJr62zxnL/QPDa/0QQrAHXx/LjZJN/7mcIaeGeJ7MYy31XYCkDUKXbP+PKqpXBYWWLgbZPK1r5UdF3GQBh4JOJRka9RWnGy083ZSG9WUdKGEbBarG9DLn9C11e9tPaW1/2w9v0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JKYIze2f; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JKYIze2f"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50b6c45781aso724681cf.0
        for <kvmarm@lists.linux.dev>; Sun, 29 Mar 2026 06:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774791720; cv=none;
        d=google.com; s=arc-20240605;
        b=lFzyihOEFpxLZ9WHNo0/gDAP1dgues5hxaWsvJzD6oVmPjqVqILEK9JKQEl2knqP5t
         5wFeUApK7IA4tkNd4i/wjkLkCenxtSZAVdTJumZiNInE0bXCQ5ijALe5faafFqz3+Q9S
         c4znPFSWlEyJb4ubbqhNtryMPFQz8w6EFXuyjb0Mzj5UDaPUFor3OQeto4871pV2qUm5
         s9fl5C6JooP7pErwsq9GpW3kxI7Yb0XhSigenRpniegFS+uaQRGC9HxeYo9c/sA2TW8F
         gnw3EoaMT8eTx+OP+VX3zgraLvWUhLxedpscxHKCOHuKODK8g3NxWHfXvlDjO9XlNLgk
         psWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aF4Epmx2n9nntDB8c7LNu8cL/wQsJEEhS1gBTnU+6mE=;
        fh=zoQ4tudxtQ1b5aaJflGt0BO8KdU0AxS3JiEVnUrvhYI=;
        b=GFRjaFNEpHzn8oQMPS0FrWsbaBfAwohpXVu46hgb8GZdO0RvX2Zwr9H3ps8jIX/gDo
         gp9HIuyAbZ/TWMadKtMD2RK1PjiXerzPSNvdVdUFVzZ/g86jcTPTAE36ycK5jy3dmobD
         IiLH8XjBCqqFMqJQEuQt4j4TVkMd+6N8qNqeCl+5rZBYsTpRT8cZHeBCEGMlEJcZt41I
         QzhLe+dtyEpedWDPNXOfJ1updVWEFz3pnlyaSAHykVZydqc0RbbsrT99t4zn6ETb+X2Y
         OAQ+TS8DsklBRonN2UYmih9+DFdZ02UXXcBzw39bZd5k1bp5Noj10zVH5XFuDEYda0FK
         jLpg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774791720; x=1775396520; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aF4Epmx2n9nntDB8c7LNu8cL/wQsJEEhS1gBTnU+6mE=;
        b=JKYIze2fFoeJIRPrYMDysBdhKraR5u18Vv8LOpSCkljIgyPbTj310LrG34E66AVvIL
         AEUZ9EoMz/gir7tlXOfblF/LpM8zTvsKEG4uu7j54cEJ/iQP3u/9v1z/WeVURtrTc6os
         hdnko4zGaVEPN6a9rJ5jQSDqQSE00xPSkwv4sEehFE4M1w8JCp3Gp+4lGerNnTlK2uNj
         vG2qOOzLbn3swGQD50SLw+DkeN8NCQcOK5XwJ83FJfVudZfhGgYh4CuZvkVTOPFi/XnH
         ZZlMfv+deaFYxSSv0o3Y8obklps0XFn7RzLsPdQDkUowt79N2rU2KcTvOSpnJ9Rysis8
         QJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774791720; x=1775396520;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF4Epmx2n9nntDB8c7LNu8cL/wQsJEEhS1gBTnU+6mE=;
        b=mHM1MAF+uV2LCAkGjvdJfkZmYf2udhZblwkmid+h6oH8OEZFKFETZ0OtZfFmSo1Sz2
         QpfQiiqmYOaR3O0BBX3yEf21kTqK7l4nAUL3myASvi9IQS5oL2Ja1NWsMf/o9fshzKRT
         Rn+8VLyokOY/oNUR0rYcdHAz92MiZh34bcM54PXdXFXEzVW8eZLoRZChdkhQtjCpgZO+
         uoRWmINbYbL8o7Moj152+ofOuiGv2s/DLNvstasFqGD8lmddM33wzIrpqIdhJv2+1mHJ
         62Ua4rtWrXIIB70mSzCKtSmZMwaiVdYdNXkOxaTJLwkfvZgZQ2bM/NzaMhefHU0HstO9
         6K3Q==
X-Gm-Message-State: AOJu0Yx4uvXVL0EehQa9LRel95CwZasQ79x7YsJG6S0k7gGVxXMMqrYb
	77EFQwXop0WZCQc2BamSCstCw7VKd7k9tuYVhux+DGD39Y7YsdAkxc6GpsM7FXJpiYcnuGI0BBD
	mL2jkaZAfJUmQ8rhl9GdDMgMtDl7ue4oiKyHxN1Fk
X-Gm-Gg: ATEYQzz0KgQPOy2Je0Vee+bStHTS9u2+SSnmJ51Uu0+kJY885HyVv3GW+MWA/nJgB8T
	bOQzXdm37XyAG6sjneBRLe/HUDDCKDUXK8X6BGcmi/Kbnr1rSnBEyrrOIdWtiJ5O41Ht8Uuq96L
	943z7LcGJzfG4PEoeDf/PMXeDma5Il6EoQ/y+HavHwvciIAW+N0f2arGGGB3qr9ScBKvykuuOTo
	gPaI43on3GyhnXLAkyEatqc07gfeuwYSlULVYMXIJL+kQmK23YAtnKB0DhS2PBaaNA2dHLj2LxM
	ld8fGy7x
X-Received: by 2002:a05:622a:3cd:b0:509:1d4b:f86f with SMTP id
 d75a77b69052e-50bb27f6ef2mr18579571cf.14.1774791719904; Sun, 29 Mar 2026
 06:41:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260327113618.4051534-1-maz@kernel.org> <20260327113618.4051534-22-maz@kernel.org>
 <86ecl549aw.wl-maz@kernel.org>
In-Reply-To: <86ecl549aw.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 29 Mar 2026 14:41:22 +0100
X-Gm-Features: AQROBzAIIIl4BXFhMlior6x1Oks2QHN0i-uK1SaLiMYW9yClQIV8jdg80mHlByo
Message-ID: <CA+EHjTz60sr7sVaizJT3Cxg+AHLBy09032VBvmqc-dRtEFeNeg@mail.gmail.com>
Subject: Re: [PATCH v2 21/30] KVM: arm64: Kill topup_memcache from kvm_s2_fault
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 27 Mar 2026 at 14:49, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 27 Mar 2026 11:36:09 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > The topup_memcache field can be easily replaced by the equivalent
> > conditions, and the resulting code is not much worse.

This is easier to reason about I think, so (not sure if it applies to
fold-ins, but fwiw):
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad

> >
> > Tested-by: Fuad Tabba <tabba@google.com>
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> > Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/kvm/mmu.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index e8bda71e862b2..5b05caecdbd92 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1712,7 +1712,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
> >
> >  struct kvm_s2_fault {
> >       bool writable;
> > -     bool topup_memcache;
> >       bool mte_allowed;
> >       bool is_vma_cacheable;
> >       bool s2_force_noncacheable;
> > @@ -1983,9 +1982,8 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> >               .logging_active = logging_active,
> >               .force_pte = logging_active,
> >               .prot = KVM_PGTABLE_PROT_R,
> > -             .topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
> >       };
> > -     void *memcache;
> > +     void *memcache = NULL;
> >       int ret;
> >
> >       /*
> > @@ -1994,9 +1992,11 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
> >        * only exception to this is when dirty logging is enabled at runtime
> >        * and a write fault needs to collapse a block entry into a table.
> >        */
> > -     ret = prepare_mmu_memcache(s2fd->vcpu, fault.topup_memcache, &memcache);
> > -     if (ret)
> > -             return ret;
> > +     if (!perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu))) {
> > +             ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
> > +             if (ret)
> > +                     return ret;
> > +     }
> >
> >       /*
> >        * Let's check if we will get back a huge page backed by hugetlbfs, or
>
> Sashiko has spotted [1] an interesting corner case here, which is that the
> original code always initialises memcache to its correct value, while
> we now only do it in a limited number of cases.
>
> I'm proposing to restore the original behaviour by folding the
> following change into this patch, splitting the retrieval of the
> memcache pointer from the top-up and avoiding the ugly pointer
> indirection:
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1fe7182be45ac..03e1f389339c7 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1513,25 +1513,22 @@ static bool kvm_vma_is_cacheable(struct vm_area_struct *vma)
>         }
>  }
>
> -static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
> -                               void **memcache)
> +static void *get_mmu_memcache(struct kvm_vcpu *vcpu)
>  {
> -       int min_pages;
> -
>         if (!is_protected_kvm_enabled())
> -               *memcache = &vcpu->arch.mmu_page_cache;
> +               return &vcpu->arch.mmu_page_cache;
>         else
> -               *memcache = &vcpu->arch.pkvm_memcache;
> -
> -       if (!topup_memcache)
> -               return 0;
> +               return &vcpu->arch.pkvm_memcache;
> +}
>
> -       min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
> +static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
> +{
> +       int min_pages = kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu);
>
>         if (!is_protected_kvm_enabled())
> -               return kvm_mmu_topup_memory_cache(*memcache, min_pages);
> +               return kvm_mmu_topup_memory_cache(memcache, min_pages);
>
> -       return topup_hyp_memcache(*memcache, min_pages);
> +       return topup_hyp_memcache(memcache, min_pages);
>  }
>
>  /*
> @@ -1589,7 +1586,8 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
>         gfn_t gfn;
>         int ret;
>
> -       ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
> +       memcache = get_mmu_memcache(s2fd->vcpu);
> +       ret = topup_mmu_memcache(s2fd->vcpu, memcache);
>         if (ret)
>                 return ret;
>
> @@ -1993,7 +1991,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>         bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
>         struct kvm_s2_fault_vma_info s2vi = {};
>         enum kvm_pgtable_prot prot;
> -       void *memcache = NULL;
> +       void *memcache;
>         int ret;
>
>         /*
> @@ -2002,9 +2000,10 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>          * only exception to this is when dirty logging is enabled at runtime
>          * and a write fault needs to collapse a block entry into a table.
>          */
> +       memcache = get_mmu_memcache(s2fd->vcpu);
>         if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
>                             kvm_is_write_fault(s2fd->vcpu))) {
> -               ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
> +               ret = topup_mmu_memcache(s2fd->vcpu, memcache);
>                 if (ret)
>                         return ret;
>         }
>
> The bot has also pointed out a couple of cases where memcache and
> permission faults interact badly. I'll look into them separately, as
> they predate this rework.
>
> Thanks,
>
>         M.
>
> [1] https://sashiko.dev/#/patchset/20260327113618.4051534-1-maz%40kernel.org?patch=12134
>
> --
> Without deviation from the norm, progress is not possible.
