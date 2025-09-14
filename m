Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54002773CA
	for <kvmarm@lists.linux.dev>; Sun, 14 Sep 2025 20:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757882474; cv=none; b=tM23RAdnRBAF2pClMRn/hq+VyIGvv57kz3n5YhVDnodzpJuly1VosQQUGR6pUZlqBj5hQHiD/jhW49JZ3hCV5clkr/KH1P9RQ1ZUS8+CQlk21xRd/gzkagGCtGytsHLwx6HEptcpT4voYEs8bUjfelgPxwO+g64cTlY3Ox4bBcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757882474; c=relaxed/simple;
	bh=vFkIDmaFD2pw5A0W7OZBOCqG4/7Cw7pOHwZ/Ct06vqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfBJ5RA6Gi4T8C5oopQz+JMfMFoIfczJoBQzJOy6RVs8PgDzNdwjswVK8ojMniXcAPrMhkrX7yfRVlyb5UTEzqWM3LKSaP3wBmTfyn0ZatcfusTUzKx3dbrUqsV/UoG+7++nK8DjZTTHsBcOAKwNOclMNsv7UxagQ7znApzNyvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IYxQJ7+/; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IYxQJ7+/"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2637b6e9149so153145ad.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Sep 2025 13:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757882472; x=1758487272; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PNSjjL64mFdVCOUJRjIHIc/4Pp2YkjFAp7TrkUJbvbY=;
        b=IYxQJ7+/7bfqYL0rJA6IVpAdDbiKp2ynjOH9O/YJz5ahW8eg4IKNK+CnalKxit8uBn
         +RT+AcGSQqLU6efF24m9agk9SKdoZzCXbc9XCTpp+cbG8MGFXamOnYG6ZqSavHOJo0B0
         rS2uC2Zh3wXCAuXjHclWetMSnE+2MbTqmfwLTgFS3uOIBdb5s0uBnwoy+A1vOkiomeYy
         wtLP1OP8RSj305Y7R8Q7AbcH9EDJwCsfD9PWEtr1c4ZYgCTLmh8lPpxqyT86cuM4iWA3
         8e2jorI1CxQrnUKKnUugNdrn0JqOxClvs/qV7jbRv+dfeP6tu1lns7B/Hc2eZrRicXjB
         GZpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757882472; x=1758487272;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PNSjjL64mFdVCOUJRjIHIc/4Pp2YkjFAp7TrkUJbvbY=;
        b=Up90C7mcUHyrzy5kBL+KZSKCAzmI9SSfR9oodqmQ8Zn+zgVaxUYc+lt4qJmqfUaD9K
         foickWvlkrkjXegUcsdBYp3I7U2HFldLpeqzWCsict5PbSOeJh75KVB4QjvulDnKMEtL
         mOEV3BEceiSwyxFjAMjhyHtCi2rZuvXo47UwabCHiTwaa+59DcfGytPwp5TPXG4Y777P
         khJ0UwGGnWrN7e6BJBqay8JZyoVFNRF5uZTAOckzxg6CTMSvIp3S6H9LsA4qZxz3LfzS
         ZbUjG9LKdUbOuVMHM220QAizerDnVD1bBZwKSKJ9JQjka46Sb4PKuPnnnodJJ1fRrot8
         Gc1A==
X-Forwarded-Encrypted: i=1; AJvYcCWZvyQGJ6MBPWVq3a31Z/lsFfISQ3nI3oL61jhWH6tgBDjLyN1nUysBJLeKSEGhfkuNt+OgE6U=@lists.linux.dev
X-Gm-Message-State: AOJu0YyJshuIJPTzJ8iYxY2iNhCiIpCPMWQKyCUBRVfNORSgIbjnSTQT
	x1/8HvyzckJB0PPx+oUEDuIWPnKECkWOtPt9WIC4sF5sBKyFr86i9yFTBSSdO7OhjA==
X-Gm-Gg: ASbGncuF5SCGKNnpJNdYgDpZMBT8Il0G4wHCOeSB70lebDf5olbICXQ570lbJsjw3T3
	o6CAwszne3Gxb6bokbF1UQID4nXXRnjSV3TD9eIJntNKGLZgPZATbBaU6akk48rUGFuhCvLJEOH
	Y0+KYgM1Lri50i/10xsFz0Kv2tfY0ouj6NaylAiI947tkahWRymIKifp/GPUSeaGCHTuu51gLdk
	IyGPKRUVDUakVyzsrJv2rfNXkThESpUgZGF2klZ7VJgnavDdIOAup6Iw83eF3/VlF0TiEAPk8+r
	Qg3yXRn9ELqjgptswsexTf8z4NLFVXDbnefVLxlqp9wOPDhAVEz+tp8yPV5hhgsEdJ1o3WR8MX6
	eCdKi0V9S48iOmHgYtkPN7wcwhyMxNWAUlVOz7XmhuR296NBpLEQPGoov8uD63FrA68jVFrc94w
	==
X-Google-Smtp-Source: AGHT+IHvAZDBJIBrGn/Rxmed7TPoC1eE87FxlDAP8nIpAj01UwnK5cfZtdePiHpGJ6H0pHDgIaQEaQ==
X-Received: by 2002:a17:903:244b:b0:234:bfa1:da3e with SMTP id d9443c01a7336-260a3dd2bbamr3723445ad.5.1757882471428;
        Sun, 14 Sep 2025 13:41:11 -0700 (PDT)
Received: from google.com (23.178.142.34.bc.googleusercontent.com. [34.142.178.23])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-264ba05335dsm22707595ad.142.2025.09.14.13.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 13:41:10 -0700 (PDT)
Date: Sun, 14 Sep 2025 20:41:04 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	jgg@ziepe.ca, mark.rutland@arm.com
Subject: Re: [PATCH v4 02/28] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <aMcoYCcJXjN64cOE@google.com>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-3-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250819215156.2494305-3-smostafa@google.com>

On Tue, Aug 19, 2025 at 09:51:30PM +0000, Mostafa Saleh wrote:
> Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> drivers can use that to protect the MMIO of IOMMU.
> The initial attempt to implement this was to have a new flag to
> "___pkvm_host_donate_hyp" to accept MMIO. However that had many problems,
> it was quite intrusive for host/hyp to check/set page state to make it
> aware of MMIO and to encode the state in the page table in that case.
> Which is called in paths that can be sensitive to performance (FFA, VMs..)
> 
> As donating MMIO is very rare, and we don’t need to encode the full state,
> it’s reasonable to have a separate function to do this.
> It will init the host s2 page table with an invalid leaf with the owner ID
> to prevent the host from mapping the page on faults.
> 
> Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
> stage-2 PTEs, as this can be triggered from recycle logic under memory
> pressure. There is no code relying on this, as all ownership changes is
> done via kvm_pgtable_stage2_set_owner()
> 
> For error path in IOMMU drivers, add a function to donate MMIO back
> from hyp to host.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 64 +++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c                  |  9 +--
>  3 files changed, 68 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 52d7ee91e18c..98e173da0f9b 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -37,6 +37,8 @@ int __pkvm_host_share_hyp(u64 pfn);
>  int __pkvm_host_unshare_hyp(u64 pfn);
>  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
>  int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot);
> +int __pkvm_host_donate_hyp_mmio(u64 pfn);
> +int __pkvm_hyp_donate_host_mmio(u64 pfn);
>  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 861e448183fd..c9a15ef6b18d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -799,6 +799,70 @@ int ___pkvm_host_donate_hyp(u64 pfn, u64 nr_pages, enum kvm_pgtable_prot prot)
>  	return ret;
>  }
>  
> +int __pkvm_host_donate_hyp_mmio(u64 pfn)
> +{
> +	u64 phys = hyp_pfn_to_phys(pfn);
> +	void *virt = __hyp_va(phys);
> +	int ret;
> +	kvm_pte_t pte;
> +
> +	host_lock_component();
> +	hyp_lock_component();
> +
> +	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
> +	if (ret)
> +		goto unlock;
> +
> +	if (pte && !kvm_pte_valid(pte)) {
> +		ret = -EPERM;
> +		goto unlock;
> +	}
> +
> +	ret = kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL);
> +	if (ret)
> +		goto unlock;
> +	if (pte) {
> +		ret = -EBUSY;
> +		goto unlock;
> +	}

I'm thinking of a situation where both of these checks might be
necessary.. The first check seems to confirm if the page being donated
isn't set up to trap in the hyp (i.e. the donor/host doesn't own the
page anymore). 

However, the second check seems to check if the pfn is already mapped
in the hyp's space. Is this check only to catch errorneous donations of
a shared page or is there something else?

> +
> +	ret = pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, PAGE_HYP_DEVICE);
> +	if (ret)
> +		goto unlock;
> +	/*
> +	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> +	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
> +	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
> +	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
> +	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
> +	 */
> +	WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt, phys,
> +				PAGE_SIZE, &host_s2_pool, PKVM_ID_HYP));
> +unlock:
> +	hyp_unlock_component();
> +	host_unlock_component();
> +
> +	return ret;
> +}
> +
> +int __pkvm_hyp_donate_host_mmio(u64 pfn)
> +{
> +	u64 phys = hyp_pfn_to_phys(pfn);
> +	u64 virt = (u64)__hyp_va(phys);
> +	size_t size = PAGE_SIZE;
> +
> +	host_lock_component();
> +	hyp_lock_component();
> +
> +	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
> +	WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt, phys,
> +				PAGE_SIZE, &host_s2_pool, PKVM_ID_HOST));
> +	hyp_unlock_component();
> +	host_unlock_component();
> +
> +	return 0;
> +}
> +
>  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
>  {
>  	return ___pkvm_host_donate_hyp(pfn, nr_pages, PAGE_HYP);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index c351b4abd5db..ba06b0c21d5a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1095,13 +1095,8 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	kvm_pte_t *childp = NULL;
>  	bool need_flush = false;
>  
> -	if (!kvm_pte_valid(ctx->old)) {
> -		if (stage2_pte_is_counted(ctx->old)) {
> -			kvm_clear_pte(ctx->ptep);
> -			mm_ops->put_page(ctx->ptep);
> -		}
> -		return 0;
> -	}
> +	if (!kvm_pte_valid(ctx->old))
> +		return stage2_pte_is_counted(ctx->old) ? -EPERM : 0;
>  
>  	if (kvm_pte_table(ctx->old, ctx->level)) {
>  		childp = kvm_pte_follow(ctx->old, mm_ops);
> -- 

Thanks
Praan
