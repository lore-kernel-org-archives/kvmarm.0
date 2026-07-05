Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16C83644A4
	for <kvmarm@lists.linux.dev>; Sun,  5 Jul 2026 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783260551; cv=none; b=rQ59HkzlxXDzIqmu5Tz3IV86TzCIo4C/VwXHUxZPSuT5MQQ/U7mBMpyuOgrpYNvoNFiYuNZT9GpBj2mD5PKcMYhIo15+IPbfUukXxgQYQ5FdRqGJWAwphxecXH3Pls19Fp5Sbo+nHvDgL+14tR+2rT7+UquD7UjyxPinW51vFFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783260551; c=relaxed/simple;
	bh=tton+mxcFxiJVWf32c1zvDyubZlrW/ZkabAOaNPXrwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I89Btx67VwObAtSuXxqjFHuDzzNYjtXTEY69sRAXePoNkvdWXkJLQGCG1DjhL5Zd3ygUTHdCFQ37IvbrChEmdrL6CLNYGhlGyinciBcL+OSNrBYUEkIwzg7eHU9Uo8YhICC+oFNJb1kERc1DfhGGTeNT+rpBcLno5YM4q94rHmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J8qSZd0S; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J8qSZd0S"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5F0F1D31;
	Sun,  5 Jul 2026 07:09:03 -0700 (PDT)
Received: from [10.57.73.233] (unknown [10.57.73.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDBC23F905;
	Sun,  5 Jul 2026 07:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783260548; bh=tton+mxcFxiJVWf32c1zvDyubZlrW/ZkabAOaNPXrwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J8qSZd0SBfShFknERJGrB1ZVz4rGkhg/AUDMTWxX1ycbLO792EFw8JwVkczZfWPCL
	 NYmP7NSnxtBRMjxfN+oMb0u+viwuxDaZNNlrgSNCgaETnsrQS1sXQY1AN7zd92Y4zt
	 IgHQnBWYv5cuEoLqzyYuWCFm49MY1Jd+eAPJTX70=
Message-ID: <a3b2423e-d8bc-4713-90ef-5bfac7079834@arm.com>
Date: Sun, 5 Jul 2026 19:38:58 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] KVM: arm64: Record whether pKVM stage 2 mapping is
 cacheable
To: Bradley Morgan <include@grrlz.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260701192428.17430-1-include@grrlz.net>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260701192428.17430-1-include@grrlz.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 02/07/26 12:54 am, Bradley Morgan wrote:
> pKVM keeps its own mapping list for stage 2 operations. Its flush path
> uses that list directly, so it lost the PTE attribute check done by the
> generic stage 2 walker.
> 
> Record whether a mapping is cacheable and skip cache maintenance for
> mappings that are not cacheable.
> 
> Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")

Is Fixes tag required? If I am reading correctly, Arm ARM says this:

"For VA-based cache maintenance instructions, the instruction operates on the
caches regardless of the memory type and cacheability attributes marked for
the memory address in the VMSA translation table entries. This means that
the effects of the cache maintenance instructions can apply regardless of:
  Whether the address accessed:
    Is Normal memory or Device memory.
    Has the Cacheable attribute or the Non-cacheable attribute."

So nothing goes wrong if we do dcache clean for non-cacheable memory.

> Signed-off-by: Bradley Morgan <include@grrlz.net>
> ---
> Changes since V3:
> - addressed some review :)
> 
>  arch/arm64/kvm/pkvm.c | 51 ++++++++++++++++++++++++++++++++++---------
>  1 file changed, 41 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 053e4f733e4b..6d1cad890c7e 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -302,9 +302,32 @@ static u64 __pkvm_mapping_start(struct pkvm_mapping *m)
>  	return m->gfn * PAGE_SIZE;
>  }
>  
> +#define PKVM_MAPPING_NR_PAGES_MASK     GENMASK_ULL(47, 0)
> +#define PKVM_MAPPING_NC                        BIT_ULL(48)
> +
> +static u64 pkvm_mapping_nr_pages(struct pkvm_mapping *m)
> +{
> +	return m->nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
> +}
> +
> +static bool pkvm_mapping_is_nc(struct pkvm_mapping *m)
> +{
> +	return m->nr_pages & PKVM_MAPPING_NC;
> +}
> +
> +static void pkvm_mapping_set_nr_pages(struct pkvm_mapping *m, u64 nr_pages,
> +				      bool nc)
> +{
> +	WARN_ON_ONCE(nr_pages & ~PKVM_MAPPING_NR_PAGES_MASK);
> +
> +	m->nr_pages = nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
> +	if (nc)
> +		m->nr_pages |= PKVM_MAPPING_NC;
> +}
> +
>  static u64 __pkvm_mapping_end(struct pkvm_mapping *m)
>  {
> -	return (m->gfn + m->nr_pages) * PAGE_SIZE - 1;
> +	return (m->gfn + pkvm_mapping_nr_pages(m)) * PAGE_SIZE - 1;
>  }
>  
>  INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
> @@ -350,7 +373,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
>  			continue;
>  
>  		page = pfn_to_page(mapping->pfn);
> -		WARN_ON_ONCE(mapping->nr_pages != 1);
> +	       WARN_ON_ONCE(pkvm_mapping_nr_pages(mapping) != 1);
>  		unpin_user_pages_dirty_lock(&page, 1, true);
>  		account_locked_vm(current->mm, 1, false);
>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> @@ -369,7 +392,7 @@ static int __pkvm_pgtable_stage2_unshare(struct kvm_pgtable *pgt, u64 start, u64
>  
>  	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
>  		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
> -					mapping->nr_pages);
> +				       pkvm_mapping_nr_pages(mapping));
>  		if (WARN_ON(ret))
>  			return ret;
>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> @@ -448,7 +471,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		 * permission faults are handled in the relax_perms() path.
>  		 */
>  		if (mapping) {
> -			if (size == (mapping->nr_pages * PAGE_SIZE))
> +			if (size == (pkvm_mapping_nr_pages(mapping) * PAGE_SIZE))
>  				return -EAGAIN;
>  
>  			/*
> @@ -472,7 +495,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	swap(mapping, cache->mapping);
>  	mapping->gfn = gfn;
>  	mapping->pfn = pfn;
> -	mapping->nr_pages = size / PAGE_SIZE;
> +	pkvm_mapping_set_nr_pages(mapping, size / PAGE_SIZE,
> +				  (prot & (KVM_PGTABLE_PROT_DEVICE |
> +					   KVM_PGTABLE_PROT_NORMAL_NC)));
>  	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
>  
>  	return ret;
> @@ -503,7 +528,7 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	lockdep_assert_held(&kvm->mmu_lock);
>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
>  		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
> -					mapping->nr_pages);
> +				       pkvm_mapping_nr_pages(mapping));
>  		if (WARN_ON(ret))
>  			break;
>  	}
> @@ -517,9 +542,13 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  	struct pkvm_mapping *mapping;
>  
>  	lockdep_assert_held(&kvm->mmu_lock);
> -	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> +		if (pkvm_mapping_is_nc(mapping))
> +			continue;
> +
>  		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
> -					  PAGE_SIZE * mapping->nr_pages);
> +					  PAGE_SIZE * pkvm_mapping_nr_pages(mapping));
> +	}
>  
>  	return 0;
>  }
> @@ -536,8 +565,10 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
>  
>  	lockdep_assert_held(&kvm->mmu_lock);
>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> -		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
> -					   mapping->nr_pages, mkold);
> +		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest,
> +					   handle, mapping->gfn,
> +					   pkvm_mapping_nr_pages(mapping),
> +					   mkold);
>  
>  	return young;
>  }

