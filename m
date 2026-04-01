Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECED32A3DA
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 03:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775013988; cv=none; b=HEn6lZuVYeu5KudmZSRlwZxDutHOmpCgY9YgOlsqqhPVA85opEUYNvptPiobWtQ2DD7kxG440+rDurBDdgEjCzuHcAHHOdrfyvryi24U5tPoMgmqWZY3HVOP7AEzvi6kyvNmxR6MVnAalqI8o91jcJ85O1lkO2NVLYZ1V2X866E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775013988; c=relaxed/simple;
	bh=UzsoticdyH/0uzKlAtuoDnpldxKmYMWxES2cT2U7dOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QkPVxeUH60Fo8zLHDcmlO7XTgGjsPAF2lupey9U6bn7Dd+XaP/ZFxOOoHLvE36mxa8jch0NqZ5f2tLEngAMvqsFkuHpojWYLsn7v2eqSA2bsIbYB65Q9OD7pG2aw9qaebCSai2nfvSlk3Y8rnW5l3Qu58QGK14G07xJWB2eU0iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nI4G83G9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nI4G83G9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DDE61713;
	Tue, 31 Mar 2026 20:26:20 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 364EE3F915;
	Tue, 31 Mar 2026 20:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775013986; bh=UzsoticdyH/0uzKlAtuoDnpldxKmYMWxES2cT2U7dOI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nI4G83G9mlaa0vku4CRuCmhtI7cQ3DW36IaKxZaVcm4XTpQF8Vv1rh9iQ0JFYei1S
	 hOUVjhtjCaQclU8INr2sxVq5O9QvpDgZEaOyrcxzbSU3nKJ9QDTB8MdoVGFPfnEEAw
	 lh4tXtRgdJUOzEwAB00OIC7ZQ4vfzxbnOtEP77+o=
Message-ID: <c6d17e42-d782-43de-94be-2507acdaf217@arm.com>
Date: Wed, 1 Apr 2026 08:56:20 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/30] KVM: arm64: Constrain fault_granule to
 kvm_s2_fault_map()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-19-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-19-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:06 PM, Marc Zyngier wrote:
> The notion of fault_granule is specific to kvm_s2_fault_map(), and
> is unused anywhere else.
> 
> Move this variable locally, removing it from kvm_s2_fault.
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1e0d93d6d265a..981c04a74ab7a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1724,7 +1724,6 @@ struct kvm_s2_fault {
>  	bool logging_active;
>  	bool force_pte;
>  	long vma_pagesize;
> -	long fault_granule;
>  	enum kvm_pgtable_prot prot;
>  	struct page *page;
>  	vm_flags_t vm_flags;
> @@ -1908,9 +1907,9 @@ static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
>  static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  			    struct kvm_s2_fault *fault, void *memcache)
>  {
> -	bool fault_is_perm = kvm_s2_fault_is_perm(s2fd);
>  	struct kvm *kvm = s2fd->vcpu->kvm;
>  	struct kvm_pgtable *pgt;
> +	long perm_fault_granule;
>  	int ret;
>  	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
>  
> @@ -1920,14 +1919,17 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  	if (mmu_invalidate_retry(kvm, fault->mmu_seq))
>  		goto out_unlock;
>  
> +	perm_fault_granule = (kvm_s2_fault_is_perm(s2fd) ?
> +			      kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0);
> +
>  	/*
>  	 * If we are not forced to use page mapping, check if we are
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
>  	if (fault->vma_pagesize == PAGE_SIZE &&
>  	    !(fault->force_pte || fault->s2_force_noncacheable)) {
> -		if (fault_is_perm && fault->fault_granule > PAGE_SIZE) {
> -			fault->vma_pagesize = fault->fault_granule;
> +		if (perm_fault_granule > PAGE_SIZE) {
> +			fault->vma_pagesize = perm_fault_granule;
>  		} else {
>  			fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
>  									  s2fd->hva, &fault->pfn,
> @@ -1940,15 +1942,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  		}
>  	}
>  
> -	if (!fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
> +	if (!perm_fault_granule && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
>  		sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
>  
>  	/*
>  	 * Under the premise of getting a FSC_PERM fault, we just need to relax
> -	 * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
> +	 * permissions only if vma_pagesize equals perm_fault_granule. Otherwise,
>  	 * kvm_pgtable_stage2_map() should be called to change block size.
>  	 */
> -	if (fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
> +	if (fault->vma_pagesize == perm_fault_granule) {
>  		/*
>  		 * Drop the SW bits in favour of those stored in the
>  		 * PTE, which will be preserved.
> @@ -1984,7 +1986,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  		.logging_active = logging_active,
>  		.force_pte = logging_active,
>  		.prot = KVM_PGTABLE_PROT_R,
> -		.fault_granule = perm_fault ? kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0,
>  		.write_fault = write_fault,
>  		.exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
>  		.topup_memcache = !perm_fault || (logging_active && write_fault),

