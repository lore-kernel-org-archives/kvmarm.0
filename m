Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1200837CD39
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 07:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774941073; cv=none; b=fRKHKWmuaFwJMQy2IJ7jsQjnLfn2SBpfi1ENokoslvcZiy097vZHqmXgp60P8rrzuzQ5/cgFDI10DeUYwtBgGe2HlGoN1YnX44hrkOQBNajhiGJSCZgClXNoOiXLwGrniU3UMgPJT4R/LWQgYxy2vH8jZjE0v13H5vP7kdVMIpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774941073; c=relaxed/simple;
	bh=2SiH6CKgnh1H6NsZAZBece6LP/f2wHoqT/JSzoVa0D4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XvnPZF9bHwhQwZIig6O37kQdezZIcpYld7p+lVC3nIV53CNlbesUQz1bRE1nbtsIuIn1gEN5l22Q8mNP7ZetMedOhsRJRll9lvpfyDnHdbEOHSvTtDikvZy9OXMflqiIcm6OSWl7dzChXN4eQ3Y3WFzSP0FoZA70yKyBjsJH740=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZiaxDb2i; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZiaxDb2i"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A09491596;
	Tue, 31 Mar 2026 00:11:05 -0700 (PDT)
Received: from [10.57.18.211] (unknown [10.57.18.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDE0C3F641;
	Tue, 31 Mar 2026 00:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774941071; bh=2SiH6CKgnh1H6NsZAZBece6LP/f2wHoqT/JSzoVa0D4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZiaxDb2imkt5mju3NjuHU0SG6oqITQ2pfgBob/9neKocePc7CZ9665498i5NzgOoH
	 cFDfhUlmv8XEfYTvlgRM1tEuFqlHlof8sIk6WOaxvGWguO4dz5dmnnAWLyMPYAJ58J
	 3aOpP5e/m+FjP8rF7UeKulGErUVKby0isHTXxHQA=
Message-ID: <1c92ac00-80c3-4fb2-82ae-ab365cc0ffd8@arm.com>
Date: Tue, 31 Mar 2026 12:41:04 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/30] KVM: arm64: Clean up control flow in
 kvm_s2_fault_map()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-14-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-14-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/03/26 5:06 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Clean up the KVM MMU lock retry loop by pre-assigning the error code.
> Add clear braces to the THP adjustment integration for readability, and
> safely unnest the transparent hugepage logic branches.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ee2a548999b1b..c6cd6ce5254be 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1897,10 +1897,9 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  
>  	kvm_fault_lock(kvm);
>  	pgt = fault->vcpu->arch.hw_mmu->pgt;
> -	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
> -		ret = -EAGAIN;
> +	ret = -EAGAIN;
> +	if (mmu_invalidate_retry(kvm, fault->mmu_seq))
>  		goto out_unlock;
> -	}
>  
>  	/*
>  	 * If we are not forced to use page mapping, check if we are
> @@ -1908,16 +1907,17 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  	 */
>  	if (fault->vma_pagesize == PAGE_SIZE &&
>  	    !(fault->force_pte || fault->s2_force_noncacheable)) {
> -		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE)
> +		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE) {
>  			fault->vma_pagesize = fault->fault_granule;
> -		else
> +		} else {
>  			fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
>  									  fault->hva, &fault->pfn,
>  									  &fault->fault_ipa);
>  
> -		if (fault->vma_pagesize < 0) {
> -			ret = fault->vma_pagesize;
> -			goto out_unlock;
> +			if (fault->vma_pagesize < 0) {
> +				ret = fault->vma_pagesize;
> +				goto out_unlock;
> +			}
>  		}
>  	}
>  
> @@ -1951,7 +1951,9 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  	if (fault->writable && !ret)
>  		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
>  
> -	return ret != -EAGAIN ? ret : 0;
> +	if (ret != -EAGAIN)
> +		return ret;
> +	return 0;
>  }
>  
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,

