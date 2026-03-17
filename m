Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0162B3AB273
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773760130; cv=pass; b=V/NCVlDATmozEddjGnnOgBu035luP/RLHli5Z+i+mPZA+jgSwTbXmqg82PavYhHR5FKyARFaTqYheftpGa9fcnSdiDthYdvc7uLNVdhkMBHzLc9UYFWVKzpf7eNUDlDYd6RFZgvUslcee3MZtmyGhoc1A0UkC4rvm7Br1H0/wE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773760130; c=relaxed/simple;
	bh=bA2Gb8KUzY1Bo6RtAzLBJGOC2LNpnDGKkrLy8/mU/aU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iqTrLdAbzKSd9oP27UG3VQEw8Na6ug3jYSvLn2NBiTrmjBubY6Ki+d04xIcAe6Gwdkmdh7IL2Aza9BGki+iOsALCf0jFFzAOO0ExnKm6fgvLLxgdtQi3n2PfEMM0GFC2+oZ8bIeCyCmXtkfkbuLtg7+Pm0Z4hj5M7YBwuGGVEmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G90njydf; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G90njydf"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50906a98ffeso703601cf.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 08:08:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773760128; cv=none;
        d=google.com; s=arc-20240605;
        b=UUl3VBHpG0z0TNEgxox80qmG9y3HV3bnV2uO4XS5CyWDWm04EYl0kB+JjjqY4ssrv6
         +iMMa0mAegNGNM40ls3UL42H5WmBFS3vbqzj/cSJCrO9wq+O2HkmZyNjGc/rk+ha0RmK
         8ULLtcUQjRxe7FCGhACiaZe3W4ELCXsTu0G4CryyHY4CB6Z60e620eSququ0c32xH83H
         eMMCd8NdNWhTvpMXasE3CbChAPhc9gtLJqA4A6qie7A/Wbw7NPTNUJMzmB0HRr1t194R
         dPnV4qbjouKZP7bqDaQJtIyKzULocRkzyCGv9+aIV9lIjgqtfOKlhAmNA/JApjKv7+Yz
         dGMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7jWTREPyzCDkGQNDSEs9bLoKmaSEJu/Woq4lGsLjr8c=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=ZY6NtPsarglBlzK5Q3oH5cGh8tKWo8Ff1eHm/LYoqQ1mLFW1qu3m0Vd6Ipvcfgm5Gf
         aBPvG6rUNyskgKuGHsuwKlxn5iPIvUD4nRrLSOTH1TXFcOVVWJzmuTI+W37sSko7ikaz
         5vxuHbNLZPs0NEC3UONd3s7yJa5qiPvxzJy1AX67L/qww/w7Zpo6Bokw5ajmj306dm4Z
         5dvxXoe9hmdXkoI/FIXk8vRYlqBe3Euz8V2wrslP9bNlK35PhBIFBWimkpwwXGLx5jBP
         ZoPZ81j38uzH8fugvPIDu9ptpMYxlM7laWZETpQZgLJXkdw/q9GH892IFmd0xEOFvode
         vNOg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773760128; x=1774364928; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7jWTREPyzCDkGQNDSEs9bLoKmaSEJu/Woq4lGsLjr8c=;
        b=G90njydfk3horHYfoGBHGO5+8qf2FZEsYlGxe67GRgAnTezZY3co02LMyA0mQCfxIB
         KOAdsIZxX42ihW6HQYRIqogGRVATagTGMyF+z0S8/ouJd+RwkmB4h2AHe5K9XneeNXoC
         EO0cZ/A6p6kw2aA2nl8s2IfrWxMjKa6QazcpVnWXtb/Tw3ZzOUmutMn1Q0raCFS5F36P
         lsg54aHJA3N+SnGLBNeSt5+Yy4/SsJ01qmSBwTigme43YsaLdYI84Ah29Eh3xMchI0Ou
         PhjCDa0abjsVmcm9F9TVn24b6TkyY1L2BRigmSw8+XC8JNkHI4+eNC6xjARZsVDGRREP
         5Cgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773760128; x=1774364928;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7jWTREPyzCDkGQNDSEs9bLoKmaSEJu/Woq4lGsLjr8c=;
        b=Tky2x9Laf1s8CvUjUwWBohIsnJyafeyoLQgPFr2J42raA54ZQjDOKyaqPXleRzPhk1
         DHknmxpFEotwbdrBl/4/oTLrJPhcqJbfz2SBFa6fptl3rOKz136qE9cYVbWsCwmYjZat
         lWKLlCuQ32JKp7au5GYctILNhBt4z2tIuGnBhzssTOjoBnPJEpj352SdikXpkbTdBY5h
         vNPF61SlxrlDT4tVmNIbZ+Rai7oLgYkJDRf+W+HVekk/V6tM+UvCG4Y6lGbhUzwStuU2
         KI3NdZG9wKWwQlNhnkGcFuMK34lAJdcn7YmhZvYm/7sXsF5qNxnQdpFhfmB2uvrUP1OY
         gt2w==
X-Gm-Message-State: AOJu0YwXlThfMUtG6v3hGxbLXZ2XS07SeIzP2eY54y0IpYK5C0CoiYuE
	4Kw+lqzw6PxpIq97wX28pZpLvSSJ+kJBOEgHOsUA4AVT80eTe0+og6ov6gS9reFuOiP25lpLue+
	TniEs4ra5mCnVH8+yNSOnUaoanXjr766pggHqM6rL
X-Gm-Gg: ATEYQzy/aBBgvtdbpIVku1Q86LukX+HQE0rWoOdzl8vNsl5gbux2QRTitk+S66jzAOS
	tJy6OCoXWKeZNL31tWLpANtkcwhFoFZ0Ip+s0xZVAbzxbMeTgpW8bWW+bfJcKdPYidXlpfIpUVf
	bYCZdSr8zn1zAohOSZUdo3itA6D2y5GV5A0IsPajSugPlvO5xbN3GmI412N17PF5HNFgfAT0p/G
	1Q7zFnJhf8NgzNtOK5Gj+3PuXHK+gZjYo+M/VvOiq5Px6gSyarlDxoaUMKLaPq5uYJ5+tR78leL
	T2/bZOfe09CtCu3UKbQ0hbZDjXUilItDRI6w
X-Received: by 2002:ac8:5e12:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5099ac78738mr14418391cf.1.1773760127098; Tue, 17 Mar 2026
 08:08:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-14-maz@kernel.org>
In-Reply-To: <20260316175451.1866175-14-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 15:08:10 +0000
X-Gm-Features: AaiRm50tQZvylKlDpbQUpvWQUJ1v8L_ILPY_XeQv1DUqi7KBL0ZloUbelEHsyIo
Message-ID: <CA+EHjTxozYXqAwdmwnFX5DTPr80+xv9kA6_SYP-OMndNu1UcVQ@mail.gmail.com>
Subject: Re: [PATCH 13/17] KVM: arm64: Replace force_pte with a max_map_size attribute
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Mar 2026 at 17:55, Marc Zyngier <maz@kernel.org> wrote:
>
> force_pte is annoyingly limited in what it expresses, and we'd
> be better off with a more generic primitive. Introduce max_map_size
> instead, which does the trick and can be moved into the vma_info
> structure. This firther allows it to reduce the scopes in which

nit: firther -> further

> it is mutable.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>


Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/kvm/mmu.c | 47 +++++++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 22 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ccdc9398e4ce2..ac4bfcc33aeb1 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1648,15 +1648,32 @@ struct kvm_s2_fault_desc {
>         unsigned long           hva;
>  };
>
> +struct kvm_s2_fault_vma_info {
> +       unsigned long   mmu_seq;
> +       long            vma_pagesize;
> +       vm_flags_t      vm_flags;
> +       unsigned long   max_map_size;
> +       struct page     *page;
> +       kvm_pfn_t       pfn;
> +       gfn_t           gfn;
> +       bool            mte_allowed;
> +       bool            is_vma_cacheable;
> +       bool            map_writable;
> +};
> +
>  static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
> -                                    struct vm_area_struct *vma, bool *force_pte)
> +                                    struct kvm_s2_fault_vma_info *s2vi,
> +                                    struct vm_area_struct *vma)
>  {
>         short vma_shift;
>
> -       if (*force_pte)
> +       if (memslot_is_logging(s2fd->memslot)) {
> +               s2vi->max_map_size = PAGE_SIZE;
>                 vma_shift = PAGE_SHIFT;
> -       else
> +       } else {
> +               s2vi->max_map_size = PUD_SIZE;
>                 vma_shift = get_vma_page_shift(vma, s2fd->hva);
> +       }
>
>         switch (vma_shift) {
>  #ifndef __PAGETABLE_PMD_FOLDED
> @@ -1674,7 +1691,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>                 fallthrough;
>         case CONT_PTE_SHIFT:
>                 vma_shift = PAGE_SHIFT;
> -               *force_pte = true;
> +               s2vi->max_map_size = PAGE_SIZE;
>                 fallthrough;
>         case PAGE_SHIFT:
>                 break;
> @@ -1685,7 +1702,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>         if (s2fd->nested) {
>                 unsigned long max_map_size;
>
> -               max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
> +               max_map_size = min(s2vi->max_map_size, PUD_SIZE);
>
>                 /*
>                  * If we're about to create a shadow stage 2 entry, then we
> @@ -1703,28 +1720,15 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>                 else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
>                         max_map_size = PAGE_SIZE;
>
> -               *force_pte = (max_map_size == PAGE_SIZE);
> +               s2vi->max_map_size = max_map_size;
>                 vma_shift = min_t(short, vma_shift, __ffs(max_map_size));
>         }
>
>         return vma_shift;
>  }
>
> -struct kvm_s2_fault_vma_info {
> -       unsigned long   mmu_seq;
> -       long            vma_pagesize;
> -       vm_flags_t      vm_flags;
> -       struct page     *page;
> -       kvm_pfn_t       pfn;
> -       gfn_t           gfn;
> -       bool            mte_allowed;
> -       bool            is_vma_cacheable;
> -       bool            map_writable;
> -};
> -
>  struct kvm_s2_fault {
>         bool s2_force_noncacheable;
> -       bool force_pte;
>         enum kvm_pgtable_prot prot;
>  };
>
> @@ -1748,7 +1752,7 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
>                 return -EFAULT;
>         }
>
> -       s2vi->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, vma, &fault->force_pte));
> +       s2vi->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, s2vi, vma));
>
>         /*
>          * Both the canonical IPA and fault IPA must be aligned to the
> @@ -1933,7 +1937,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>          * backed by a THP and thus use block mapping if possible.
>          */
>         if (mapping_size == PAGE_SIZE &&
> -           !(fault->force_pte || fault->s2_force_noncacheable)) {
> +           !(s2vi->max_map_size == PAGE_SIZE || fault->s2_force_noncacheable)) {
>                 if (perm_fault_granule > PAGE_SIZE) {
>                         mapping_size = perm_fault_granule;
>                 } else {
> @@ -1990,7 +1994,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>         bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
>         struct kvm_s2_fault_vma_info s2vi = {};
>         struct kvm_s2_fault fault = {
> -               .force_pte = memslot_is_logging(s2fd->memslot),
>                 .prot = KVM_PGTABLE_PROT_R,
>         };
>         void *memcache;
> --
> 2.47.3
>
