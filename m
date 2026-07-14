Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E8241B8D2
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 19:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784055705; cv=none; b=DhHVab+xFniKEEv3sM2+w0unIuGZK9VY6qismIAmu4PmXN0mgwTr4myJQgwCPuoCc9I8TpvPXDvy1PzQ1GvbDYzw0qwYDMhhJ59ENkhS6LR7NpYnJEsDC1iqrpbNQKky+dnt/FOGiLTZJozxA4A8bxJxgWk1A+LH7Xe+H+PdoyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784055705; c=relaxed/simple;
	bh=i7wDg/R/yTdwr4JMrgY97Nr2LSi2QHYr3zDhF0rsBys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d3jmOMFfppmVKIEbgieerSQo/cPdEXdYqHRjPpnMb9fX1YFgcKrd3qAs4Mn02AYcNWC8krjG562VIs2t9i8KvZFnmlYHOryiA5naJEX2VB4KxhoadMOE/KPepdG8eAEjtPn+Xj2hqvADOAld6yW6/QGFtoyoaStZ9olFVOn6x5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rv4qQ6sZ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rv4qQ6sZ"
X-Forwarded-Encrypted: i=1; AHgh+RohkpPV0qSg9mc4P2/4i+uff/BRss4xkAa2zkOBY8I/7Y5pw+84xJ2/k7/CAypc4wIyVKe5BLQ=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784055700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C7jEdnPHOZYySDOHtLiyemt7b8AC13rHzDaBDc2anI4=;
	b=Rv4qQ6sZYzl2+XiWeraz0xnWEcyy7hNCANdY9psOsmcHDLq/LrNlosEtFp8W0EnhpQuLp2
	RE6p+0nxp9PAt7uDQ7TDNDyBSQfacS86JFMM4hV8N8TaMAwMBYlMCIN2VAc9WbJfwGH459
	adjs55sxKZhIG3ST6G/uqy5+JskHWzI=
X-Gm-Message-State: AOJu0YzNaPUqqPfg5gRTvNuv/4TSdt/D4y50vzy8iSWkE62GspvyE02a
	X3pXKwE6eqwJjMyqxbMcwD2UNhdb/vt/z5IPKbcdMC2nycJnYiTnJGP8vPZtMlvvxZ9hQAJXlF3
	dokqAJD5Fju5PrjSifdEZgumKLn1hBKMJAdukRTWF
X-Received: by 2002:a05:622a:1803:b0:51b:fd21:c077 with SMTP id
 d75a77b69052e-51d7bd8c7aemr18055221cf.21.1784055687763; Tue, 14 Jul 2026
 12:01:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-6-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-6-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 20:00:50 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwzsZ7NjT3ojabPbe43U+Dev6gFzYM_x0rEA+teVqO0mA@mail.gmail.com>
X-Gm-Features: AUfX_mzct80YiNWPh-7YCP4I0LagY0Zs3bKOU46mwa5A199ZA6btE8cxlulEIMM
Message-ID: <CA+EHjTwzsZ7NjT3ojabPbe43U+Dev6gFzYM_x0rEA+teVqO0mA@mail.gmail.com>
Subject: Re: [PATCH v2 05/18] KVM: arm64: Allow kvm_hyp_memcache usage outside
 of stage-2
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Although currently limited to guest stage-2 page-table allocations,
> struct kvm_hyp_memcache is a useful primitive for passing a list of
> discontiguous pages between host and hypervisor.
>
> Introduce init_hyp_memcache() to initialise a generic hyp memcache, and
> init_hyp_stage2_memcache() for stage-2 specific memcaches. The generic
> initialiser will be used to top up the upcoming pKVM heap allocator.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bae2c4f92ef5..caea8e9986d1 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -91,9 +91,22 @@ struct kvm_hyp_memcache {
>         struct pkvm_mapping *mapping; /* only used from EL1 */
>
>  #define        HYP_MEMCACHE_ACCOUNT_STAGE2     BIT(1)
> +#define        HYP_MEMCACHE_ACCOUNT_KMEMCG     BIT(2)
>         unsigned long flags;
>  };
>
> +static inline void init_hyp_memcache(struct kvm_hyp_memcache *mc)
> +{
> +       memset(mc, 0, sizeof(*mc));
> +       mc->mapping = ZERO_SIZE_PTR; /* Prevent allocation, solely useful for stage2 memcache */
> +}
> +
> +static inline void init_hyp_stage2_memcache(struct kvm_hyp_memcache *mc)
> +{
> +       memset(mc, 0, sizeof(*mc));
> +       mc->flags = HYP_MEMCACHE_ACCOUNT_STAGE2 | HYP_MEMCACHE_ACCOUNT_KMEMCG;
> +}
> +
>  static inline void push_hyp_memcache(struct kvm_hyp_memcache *mc,
>                                      phys_addr_t *p,
>                                      phys_addr_t (*to_pa)(void *virt))
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c6..fb38821f2037 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1159,9 +1159,11 @@ static void hyp_mc_free_fn(void *addr, void *mc)
>  static void *hyp_mc_alloc_fn(void *mc)
>  {
>         struct kvm_hyp_memcache *memcache = mc;
> +       gfp_t gfp = (memcache->flags & HYP_MEMCACHE_ACCOUNT_KMEMCG) ?
> +                   GFP_KERNEL_ACCOUNT : GFP_KERNEL;
>         void *addr;
>
> -       addr = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +       addr = (void *)__get_free_page(gfp);

Generic memcaches are not accounted anymore. That looks intentional
and right since heap pages are hyp-global, not attributable to the
topup'ing task. Maybe worth a line in the commit message confirming
this is deliberate?

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

>         if (addr && memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
>                 kvm_account_pgtable_pages(addr, 1);
>
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 053e4f733e4b..8324a6a1bc48 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -111,7 +111,7 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
>         void *hyp_vcpu;
>         int ret;
>
> -       vcpu->arch.pkvm_memcache.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
> +       init_hyp_stage2_memcache(&vcpu->arch.pkvm_memcache);
>
>         hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
>         if (!hyp_vcpu)
> @@ -172,7 +172,7 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
>                 goto free_vm;
>
>         kvm->arch.pkvm.is_created = true;
> -       kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
> +       init_hyp_stage2_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
>         kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
>
>         return 0;
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
