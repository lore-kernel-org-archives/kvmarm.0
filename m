Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBF84DD6F5
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 16:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784048387; cv=none; b=OOTxVRb2SzVz7ioj1AVLdy3H8vJKZ+DKgLVQzA01fx23MWEreY7aKV5arM81uHTKYOMiev8YZ/YQeCdO45KkkrsP8OvqLqJzdjjzYLDfsGyTTeVvVI1WN0rgj/DFNgakoKhdfLNNJvMLg5aWvABL44cxQcCP+Xpwk4MydoNwvJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784048387; c=relaxed/simple;
	bh=He2dYNLQzoCqMuJV/k2P4VDMKvdtAcGYhmCpZo1Qdjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tv6p0HcGtMtWyRq5jeMv3jpoi7rAQEIpf6UxenbnUsMvvqek1CeuHSStnIL6hlEx2AIZQsyegLN5JldtlhojFPa27AZPuAu1Jn8FlvOKy/DOatxGA2pTvucDsImr5ugnGNvqllZRhkjN+a8+Xsw/kdFGsOLL4Knw2hWStnPr8M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KCgZLPzp; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KCgZLPzp"
X-Forwarded-Encrypted: i=1; AHgh+RoJLiGMCRurmvATf2OHT3CC87+bU6OGJ6Pn0St8iyXHXa643iZs0K3VwlzqGfv8pRDoelqKb/M=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784048381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K+fcK+yW+QNwHqaWRgbstmh4tm3jTw4aWDAu42J6kL4=;
	b=KCgZLPzpndtX9jU7b+XDrqj7UAhn+LKZMpOrJCWdYm53xAdbkSOsepB0Aeq+KJ/zxtW68/
	BL3gCLgnl++a2bfDjTi0S05zIPy7TZsTFNAsiPMf30b/J81VP7BDQlSaonBxMv1ZzoCn1f
	M/G/WF55CkhvqmbQSQP7YscJ5RpRx3U=
X-Gm-Message-State: AOJu0YwrIfDxrpno2AReK56gOy76KC1VNeuqU6AvKa0Ow7XYZNFoQrHj
	0fY91jBqnhUTcllyJsoYWYcRuoHEs7i2AGnEfEnvy1LAsj4d5o1192qaEQnC+87MBG17kmuwsz4
	wEvhqBi05b/ciUkcqanjRQxQTtusZu+1c/rq/1PsR
X-Received: by 2002:ac8:7d03:0:b0:51c:104c:100c with SMTP id
 d75a77b69052e-51d71546a1cmr16511151cf.2.1784048378538; Tue, 14 Jul 2026
 09:59:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-2-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-2-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 17:59:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy-drTkKuSqJNT1HD2GBn4xNXM2UyvE1zd53uG49suq7w@mail.gmail.com>
X-Gm-Features: AUfX_my1WlQOlgsnQrNZQXkrHk8cUZgVcy2F7Kpqienn2dOS644hLsWwx9GRj_I
Message-ID: <CA+EHjTy-drTkKuSqJNT1HD2GBn4xNXM2UyvE1zd53uG49suq7w@mail.gmail.com>
Subject: Re: [PATCH v2 01/18] KVM: arm64: Add __pkvm_private_range_pa
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Mappings in the pKVM private range are not identity mapped, making the
> standard __hyp_pa() unsuitable for translating these addresses.
>
> Introduce __pkvm_private_range_pa() to resolve physical addresses for
> this range by walking the hypervisor page-table. This will be useful for
> the upcoming pKVM heap allocator.
>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index 6e83ce35c2f2..d3137c16b632 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -30,5 +30,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
>                                   unsigned long *haddr);
>  int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
>  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
> +phys_addr_t __pkvm_private_range_pa(void *va);
>
>  #endif /* __KVM_HYP_MM_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 3b0bee496bff..773426a68d2d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -502,3 +502,17 @@ int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
>
>         return ret;
>  }
> +
> +phys_addr_t __pkvm_private_range_pa(void *va)
> +{
> +       kvm_pte_t pte = 0;
> +       s8 level;
> +
> +       hyp_spin_lock(&pkvm_pgd_lock);
> +       WARN_ON(kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)va, &pte, &level));

nit: can you pass NULL instead of level?

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


> +       hyp_spin_unlock(&pkvm_pgd_lock);
> +
> +       WARN_ON(!kvm_pte_valid(pte));
> +
> +       return kvm_pte_to_phys(pte) + offset_in_page(va);
> +}
> --
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
