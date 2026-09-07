Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 117C545A29F
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788799968; cv=none; b=Wqskt0a7GewftMi2M4o5mIGnUdjmCfLJqWyuhzeUBaEtK8z59YnA5OFxrkTPxEcLrpGDh0sDAcIxJZI3SUDGQPSIbP0u2m0z70NAg/SXi6xsxtKM74Ya7n7V6bL/o3Qdvr4Uv22OBRMbyvKsV55hnWd4ScCFMuHFvuEUHocI4ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788799968; c=relaxed/simple;
	bh=9KGiycjC0t79RPzsvjfZKtPbm8KkSJBkxzKIHrahiz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ew9oQpKKGpO4sSusCfdOiZBEoGeZAnQ5gc2U6+rbl4rOJnF2P9ZANJVp5m8sxKNDcLB/nKqIb/9VsPJGUDlcWtZvMflP8dO1fDeignpxgpd2YRx17sPnokJXT8wJP7eE5yMTUalHbFJ0Fk79BHdSiMGj210MxCR5jHDOoR+bvT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sDQVkBbA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sDQVkBbA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D47E1476;
	Mon,  7 Sep 2026 09:52:42 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C3F933F528;
	Mon,  7 Sep 2026 09:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788799965; bh=9KGiycjC0t79RPzsvjfZKtPbm8KkSJBkxzKIHrahiz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sDQVkBbAvoRk8ASr2K6Iz+RksnpaYHjgHHet/FkQGGN4vkix5fYGu7aYvNa8MHLi6
	 4lKTZb4ak4jryOZefEYZiYh7f6WtwgQl5dbEVw4K51hqJXB6KhyLINqtY2+MHsnYkW
	 wRLsfN3MT3QtNNJicsORgjvJOdazczlrcG3NDgc0=
Date: Mon, 7 Sep 2026 17:52:35 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, 
	oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 12/20] KVM: arm64: Handle huge mappings in
 __pkvm_host_force_reclaim_page_guest()
Message-ID: <yzeb47zjrxdsfztilng7n4e22fnsm4ncqjeqzmryc7sqncuqw6@pjtshmjxwelh>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-13-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803100904.3563942-13-vdonnefort@google.com>

On Mon, Aug 03, 2026 at 11:08:56AM +0100, Vincent Donnefort wrote:

[...]

> -static void hyp_poison_page(phys_addr_t phys)
> +static void __hyp_poison_page(void *addr, size_t size)
>  {
> -	void *addr = hyp_fixmap_map(phys);
> -
> -	memset(addr, 0, PAGE_SIZE);
> +	memset(addr, 0, size);
>  	/*
>  	 * Prefer kvm_flush_dcache_to_poc() over __clean_dcache_guest_page()
>  	 * here as the latter may elide the CMO under the assumption that FWB
> @@ -1304,19 +1302,15 @@ static void hyp_poison_page(phys_addr_t phys)
>  	 * host stage-2 and would otherwise lead to a malicious host potentially
>  	 * being able to read the contents of newly reclaimed guest pages.
>  	 */
> -	kvm_flush_dcache_to_poc(addr, PAGE_SIZE);
> -	hyp_fixmap_unmap();
> +	kvm_flush_dcache_to_poc(addr, size);
>  }
>  
>  static void hyp_poison_range(phys_addr_t phys, u64 size)
>  {
> -	u64 offset;
> -
> -	for (offset = 0; offset < size; offset += PAGE_SIZE)
> -		hyp_poison_page(phys + offset);
> +	__apply_guest_page(__hyp_va(phys), size, __hyp_poison_page);
>  }

Patch 8 introduces hyp_poison_range(), and it is reimplemented in
another way here. Maybe just do it this way in the first time?

>  
> -static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
> +static int host_stage2_get_guest_info(phys_addr_t phys, u64 *size, struct pkvm_hyp_vm **vm,
>  				      u64 *gfn)
>  {
>  	enum pkvm_page_state state;
> @@ -1344,34 +1338,43 @@ static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
>  	if (ret)
>  		return ret;
>  
> -	if (WARN_ON(level != KVM_PGTABLE_LAST_LEVEL))
> -		return -EINVAL;
> +	/* We only support either PAGE_SIZE or PMD_SIZE */
> +	if (level < KVM_PGTABLE_LAST_LEVEL - 1)
> +		return -E2BIG;
>  
> -	return host_stage2_decode_gfn_meta(pte, vm, gfn);
> +	ret = host_stage2_decode_gfn_meta(pte, vm, gfn);
> +	if (ret)
> +		return ret;
> +
> +	*size = kvm_granule_size(level);
> +
> +	return 0;

This can also be moved into its own patch with get_valid_guest_pte(),
hyp_poison_range() changes in my opinion.

Thanks,
Wei-Lin Chang

[...]
