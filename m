Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C1532AABA
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 02:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775011464; cv=none; b=DCT47nNTsxDx+XJPDwG1RycVFjLDbSRTXuSHnmSq/V9kdgEbe2F6Q+R0SS8Uz9woTrFaHHtBzXOTuUM/Nrzi5S+jdrqAV6bN8qWgIGOx3lbkM+qGzKB1viRyokeHNmEEiOsL31OMc1BmUjLLXJoX3rZ25vm2J3rmo3zv7nR5g4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775011464; c=relaxed/simple;
	bh=OZ9GWFPOx6d9+f9Pyu8AMsXa/guTZJZFoyAk6GfCE3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kb5f4BpO5O18wu9KXu4AS5Jj3URAfVafakIRMmAf04fqOL+RPh+cwH7NXfgCjDTOCZ5/mEit8bXmWY9kVqX1TKmAEC/HmD7Dz7ZkKCLdk2p9CQFf/9+67WMhuEMNT49nYsj4wij/pUNH/h7js1ekRtp//DYs07aislYsnkQBIGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I4J46Lax; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I4J46Lax"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 845452381;
	Tue, 31 Mar 2026 19:44:05 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32DFA3F7D8;
	Tue, 31 Mar 2026 19:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775011451; bh=OZ9GWFPOx6d9+f9Pyu8AMsXa/guTZJZFoyAk6GfCE3A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I4J46Laxvl7qB8oETrFxRVxqRrWyY4ZlCeiB4qF3HKlxjhiUwPIaj/XPCCrwLAKbQ
	 bgwCSuRS5dOHTTmzknCQulet6FkWzTYpNiw5oDAlHkT+d0t7KurTIoSXKQVdhIgZEs
	 C6pPdTfEn67tbyZX+1KhYduw3AjKYD8F/zk/yTRU=
Message-ID: <09757aa7-7016-43e5-88c5-b3ff34fed732@arm.com>
Date: Wed, 1 Apr 2026 08:14:05 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/30] KVM: arm64: Make fault_ipa immutable
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-16-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-16-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/03/26 5:06 PM, Marc Zyngier wrote:
> Updating fault_ipa is conceptually annoying, as it changes something
> that is a property of the fault itself.
> 
> Stop doing so and instead use fault->gfn as the sole piece of state
> that can be used to represent the faulting IPA.
> 
> At the same time, introduce get_canonical_gfn() for the couple of case
> we're we are concerned with the memslot-related IPA and not the faulting
> one.
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

>  arch/arm64/kvm/mmu.c | 38 ++++++++++++++++++++++++++------------
>  1 file changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 67e5e867e01dc..496bf5903ed3d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1400,10 +1400,10 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>   */
>  static long
>  transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
> -			    unsigned long hva, kvm_pfn_t *pfnp,
> -			    phys_addr_t *ipap)
> +			    unsigned long hva, kvm_pfn_t *pfnp, gfn_t *gfnp)
>  {
>  	kvm_pfn_t pfn = *pfnp;
> +	gfn_t gfn = *gfnp;
>  
>  	/*
>  	 * Make sure the adjustment is done only for THP pages. Also make
> @@ -1419,7 +1419,8 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  		if (sz < PMD_SIZE)
>  			return PAGE_SIZE;
>  
> -		*ipap &= PMD_MASK;
> +		gfn &= ~(PTRS_PER_PMD - 1);
> +		*gfnp = gfn;
>  		pfn &= ~(PTRS_PER_PMD - 1);
>  		*pfnp = pfn;
>  
> @@ -1735,7 +1736,6 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  {
>  	struct vm_area_struct *vma;
>  	struct kvm *kvm = fault->vcpu->kvm;
> -	phys_addr_t ipa;
>  
>  	mmap_read_lock(current->mm);
>  	vma = vma_lookup(current->mm, fault->hva);
> @@ -1753,9 +1753,7 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  	 * mapping size to ensure we find the right PFN and lay down the
>  	 * mapping in the right place.
>  	 */
> -	fault->fault_ipa = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize);
> -	ipa = fault->nested ? kvm_s2_trans_output(fault->nested) : fault->fault_ipa;
> -	fault->gfn = ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
> +	fault->gfn = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize) >> PAGE_SHIFT;
>  
>  	fault->mte_allowed = kvm_vma_mte_allowed(vma);
>  
> @@ -1777,6 +1775,17 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  	return 0;
>  }
>  
> +static gfn_t get_canonical_gfn(struct kvm_s2_fault *fault)
> +{
> +	phys_addr_t ipa;
> +
> +	if (!fault->nested)
> +		return fault->gfn;
> +
> +	ipa = kvm_s2_trans_output(fault->nested);
> +	return ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
> +}
> +
>  static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>  {
>  	int ret;
> @@ -1785,7 +1794,7 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>  	if (ret)
>  		return ret;
>  
> -	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
> +	fault->pfn = __kvm_faultin_pfn(fault->memslot, get_canonical_gfn(fault),
>  				       fault->write_fault ? FOLL_WRITE : 0,
>  				       &fault->writable, &fault->page);
>  	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
> @@ -1885,6 +1894,11 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
>  	return 0;
>  }
>  
> +static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
> +{
> +	return gfn_to_gpa(fault->gfn);
> +}
> +
>  static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  {
>  	struct kvm *kvm = fault->vcpu->kvm;
> @@ -1909,7 +1923,7 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  		} else {
>  			fault->vma_pagesize = transparent_hugepage_adjust(kvm, fault->memslot,
>  									  fault->hva, &fault->pfn,
> -									  &fault->fault_ipa);
> +									  &fault->gfn);
>  
>  			if (fault->vma_pagesize < 0) {
>  				ret = fault->vma_pagesize;
> @@ -1932,10 +1946,10 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  		 * PTE, which will be preserved.
>  		 */
>  		fault->prot &= ~KVM_NV_GUEST_MAP_SZ;
> -		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault->fault_ipa,
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, get_ipa(fault),
>  								 fault->prot, flags);
>  	} else {
> -		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault->fault_ipa, fault->vma_pagesize,
> +		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, get_ipa(fault), fault->vma_pagesize,
>  							 __pfn_to_phys(fault->pfn), fault->prot,
>  							 memcache, flags);
>  	}
> @@ -1946,7 +1960,7 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  
>  	/* Mark the page dirty only if the fault is handled successfully */
>  	if (fault->writable && !ret)
> -		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
> +		mark_page_dirty_in_slot(kvm, fault->memslot, get_canonical_gfn(fault));
>  
>  	if (ret != -EAGAIN)
>  		return ret;

