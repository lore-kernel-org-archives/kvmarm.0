Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5B237BE93
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 10:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774348758; cv=none; b=SgwCCT40K+jQFa2y+6Pk+lMkVTl+krwQlwOisXGvHi2tqS5w+3PMhEUupNVuBOVhrz3ykle/lMW/4VZHqbtocxFr5kLI/6K+XybY4xNqSGQ4FJ4aJKTNOLrHhoxN8QD3ebXMmgil4531n+p5922bdl2ekMTCxLpbr/t+xYvs028=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774348758; c=relaxed/simple;
	bh=6Y+6bIcl+617xMVnk10JoTKwXYII2yK4F/IQxgKrtgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tg5cyU+w+TcbyV3KVwkmc8tsf1Xs28kgIOcuHDdRQWk5WaE9ahXXTHNB2MHq//iMwdHk9Htl6zKYE2+G+pIluuFMRboh0qslpDzab9tZAJXvwRiRapWoWIBP2z+ziBD66JmXPkPrFAo9CP+0VAQEQ5xo+DCrmFXbrkm7ZmypdtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eMpS2+tR; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eMpS2+tR"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439c6fc2910so876680f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 03:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774348753; x=1774953553; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yZ2jUllXMrSnGG0Eo+HND4zIczab9TgMkKrI+S1FtAQ=;
        b=eMpS2+tRwzuwLALYXNHz11KsEAkthgVE8vnYO7WwfheLlwBlubnSfLV5qOUYvHWElN
         LBf6k+AWFpAb29r4kSoznpP3gAF2LAcC0O2AvDOlEjFnN5MPOBk5ZG6jSnWA1p+b4jR5
         CEvL9BfNDWj8CZfEHHRafUVXDwuCjXtpQxu5WHLfRNGwajoU0X0/L6oG082gKmsAODtw
         PuV/pRDlcz64jCJBhlqgFEdsKIQ8bRc4qwV6CSQ1ah4Ydb/uQynUDvCiylrEgk2bcp8g
         ogd+5DUXXsf0FyYkNbYYEVeg2IrdGEGgHSrdN4Z2eenJr00bYYvIfNso8w8bvFX0WyO3
         R/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774348753; x=1774953553;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ2jUllXMrSnGG0Eo+HND4zIczab9TgMkKrI+S1FtAQ=;
        b=N1SVtaMxk7iqnYeFCQp1bcvwmzOz3seUAtOXaQDDljhaC4YdcwWOFbuJiXt0MQukQy
         nwgXVElqZ4/xMLwkaEA7bUdbmgIDBBH8MthQuwD7k0MXT3i6r4ytq9fyUOXmh9oBFFwo
         4DVcTiOtakXDDfSh+IPNGgahvsvcuiTuqB4Mh5DEZnVjYSFlezURkl+/zu6leR3GcuZ/
         kMPirXd0SjSH2HNKZu68T8o6BiSbxVTqA2Od2guFH/91LyQ6UfLw+XGjgUdg7zueZt83
         aX1ls+LrNouSS2/8SE/HcBWUMOmAsQlgK9tDtNZAJd1o7gCfKPtD9CUmFJFPSI0rIgPU
         oxsA==
X-Forwarded-Encrypted: i=1; AJvYcCVZ8d5ucwGZHgs7+aW1Uvtaf1UgRIZumKq43bqJ+S8tPVYE5k2lydOoBpisez0hTjt4wLtxWmA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9NrKKs20VZgEEJAG11KpQHRdb/LvZbNCf6YPs85S6AEoEUiTs
	jQha6b2RmHpM0XS37oYj+zVqqmgPdXGQZLtSzqsyBC3HwocpUe/pOfTspV1dLnTzvA==
X-Gm-Gg: ATEYQzxQjnE+yE8afByUcFR9qq5X1q3K4zaE/fylqrQhmGMhq38mQErHbgYrEHadRpA
	wFEA5R1VNBSE/sRXHfA8+KRSJLYCZfyfNAYLX8tN2A/48YKGxc0jAHtNoFf0+9iT7vDtdXF0SZB
	w9UHaob56CQQTQ/RNA3rzuzIkggpwlsIbkPKXBBPN0wGXV2UGLW3iI0xeip4mQSJIfrtsT1x8kD
	8bOGCUD4xHty33u1Ed+Q6u78hVo02Ec3HgR1xvd0w5N1R5+Y/Nd66buWrj1sh25pPmzP/F17XPj
	fZWBreckeAUPQxo2xgqwwv+FE1MZSd8VAZx054liZ8TexHNijPnDxttjt6ZcRPvNwl/UXnPlVUq
	SXuTIePKuiHZOuKyHlK1S6axV7aYebd7AA8m4pb64tkejy18/gI9y0WrixE8N2FpYwoSIXHhWgE
	nq8ISF7tvfZlm4UZAC8iSpW5YTUP2UTQZQCwa6xJNfM8IZ7ikaQlLkliE764EyCl+XxBA=
X-Received: by 2002:a05:6000:2c07:b0:43b:4582:e90d with SMTP id ffacd0b85a97d-43b64287104mr22929928f8f.42.1774348751978;
        Tue, 24 Mar 2026 03:39:11 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bd0dcsm36469256f8f.11.2026.03.24.03.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 03:39:11 -0700 (PDT)
Date: Tue, 24 Mar 2026 10:39:07 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: alexandru.elisei@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, catalin.marinas@arm.com,
	dbrazdil@google.com, joey.gouly@arm.com, kees@kernel.org,
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org,
	perlarsen@google.com, qperret@google.com, rananta@google.com,
	smostafa@google.com, suzuki.poulose@arm.com, tabba@google.com,
	tglx@kernel.org, bgrzesik@google.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH 01/14] KVM: arm64: Donate MMIO to the hypervisor
Message-ID: <acJpy7unwLbRahPL@google.com>
References: <20260310124933.830025-1-sebastianene@google.com>
 <20260310124933.830025-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260310124933.830025-2-sebastianene@google.com>

On Tue, Mar 10, 2026 at 12:49:20PM +0000, Sebastian Ene wrote:
> From: Mostafa Saleh <smostafa@google.com>
> 
> Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
> drivers can use that to protect the MMIO of IOMMU.
> The initial attempt to implement this was to have a new flag to
> "___pkvm_host_donate_hyp" to accept MMIO. However that had many problems,
> it was quite intrusive for host/hyp to check/set page state to make it
> aware of MMIO and to encode the state in the page table in that case.
> Which is called in paths that can be sensitive to performance (FFA, VMs..)
> 
> As donating MMIO is very rare, and we don’t need to encode the full
> state, it’s reasonable to have a separate function to do this.
> It will init the host s2 page table with an invalid leaf with the owner ID
> to prevent the host from mapping the page on faults.

I am not sure I agree here:

* Differentiating between MMIO and Memory is just a fast binary search into the
  memory regions.

* host_donate_hyp isn't a fast path even for memory regions anyway.

* Having common functions for changing ownership is more and more helpful (see the
  SME dvmsync workaround).

* There's nothing preventing from having a range here which is safely handled
  already by host_donate_hyp()

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
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 90 +++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c                  |  9 +-
>  3 files changed, 94 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 5f9d56754e39..8b617e6fc0e0 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -31,6 +31,8 @@ enum pkvm_component_id {
>  };
>  
>  extern unsigned long hyp_nr_cpus;
> +int __pkvm_host_donate_hyp_mmio(u64 pfn);
> +int __pkvm_hyp_donate_host_mmio(u64 pfn);
>  
>  int __pkvm_prot_finalize(void);
>  int __pkvm_host_share_hyp(u64 pfn);
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 38f66a56a766..0808367c52e5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -784,6 +784,96 @@ int __pkvm_host_unshare_hyp(u64 pfn)
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
> +	if (addr_is_memory(phys))
> +		return -EINVAL;
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
> +
gg> +	ret = pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, PAGE_HYP_DEVICE);
> gg+	if (ret)
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
> +	int ret;
> +	kvm_pte_t pte;
> +
> +	if (addr_is_memory(phys))
> +		return -EINVAL;
> +
> +	host_lock_component();
> +	hyp_lock_component();
> +
> +	ret = kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL);
> +	if (ret)
> +		goto unlock;
> +	if (!kvm_pte_valid(pte)) {
> +		ret = -ENOENT;
> +		goto unlock;
> +	}
> +
> +	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, NULL);
> +	if (ret)
> +		goto unlock;
> +
> +	if (FIELD_GET(KVM_INVALID_PTE_OWNER_MASK, pte) != PKVM_ID_HYP) {
> +		ret = -EPERM;
> +		goto unlock;
> +	}
> +
> +	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, virt, size) != size);
> +	WARN_ON(host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt, phys,
> +				PAGE_SIZE, &host_s2_pool, PKVM_ID_HOST));
> +unlock:
> +	hyp_unlock_component();
> +	host_unlock_component();
> +
> +	return ret;
> +}
> +
>  int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
>  {
>  	u64 phys = hyp_pfn_to_phys(pfn);
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 9b480f947da2..d954058e63ff 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1152,13 +1152,8 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
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
> 2.53.0.473.g4a7958ca14-goog
> 
