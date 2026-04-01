Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3916437D116
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 03:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775013499; cv=none; b=j78kLOKQOx6f8mDDEEg5NzvdrsomjKr6lrw6NUx5AjNyKm+oy/BR4RUbr4WRCWk8RH9j+iNoncw2Nya8vKnXfBIsKhMt0FWPZ4VOMm5mBYF4fYIi26tX3Ol2fMUOVu2SmGTOe9rUoFHB790tfbXumOqISC04EqROu/OOVOW4NuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775013499; c=relaxed/simple;
	bh=ffCwt7tLZzRDrhNmFIilVOdNcywEiho2JhdBiZv7pXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NQ+MBvsBLwKJYnQGNNizEQl4pzdjK/ImTCvzqd1pTrhyv5CvmydbjJvepCjjukyoUpaR+jQKeFFfD/KgASHOJzPrcRBdCRmh/RkwJzoyBUbydNoekl4/aVz63Oz2yKv/GAnHzSN8/9hOa6lscwFPeJZO3sBLq8cBDhZgIeXLGiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GRP1Cq94; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GRP1Cq94"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC0712E99;
	Tue, 31 Mar 2026 20:18:11 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9313C3F915;
	Tue, 31 Mar 2026 20:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775013497; bh=ffCwt7tLZzRDrhNmFIilVOdNcywEiho2JhdBiZv7pXI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GRP1Cq94GtnROBZ9zfMNV5opZ7cwxhg70F8oVYaFLJq/c4KPnS/dnn7jRp2E1vjIH
	 a3FEnk4RPX2Yr2BsdLpUZm9hEx7JOTWCwJCTPM9VfrCrNH9Ay09Cb63q05hw3QUeba
	 1bxp6gCAzFJ7txvh8b+tpTY9E1pFqKQFSAgPRXoM=
Message-ID: <ee8eaa98-fe0d-4c13-b441-f6e8ba1aac5f@arm.com>
Date: Wed, 1 Apr 2026 08:48:11 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/30] KVM: arm64: Replace fault_is_perm with a helper
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-18-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-18-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:06 PM, Marc Zyngier wrote:
> Carrying a boolean to indicate that a given fault is a permission fault
> is slightly odd, as this is a property of the fault itself, and we'd
> better avoid duplicating state.
> 
> For this purpose, introduce a kvm_s2_fault_is_perm() predicate that
> can take a fault descriptor as a parameter. fault_is_perm is therefore
> dropped from kvm_s2_fault.
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

>  arch/arm64/kvm/mmu.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 09e32f08028e4..1e0d93d6d265a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1711,8 +1711,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
>  }
>  
>  struct kvm_s2_fault {
> -	bool fault_is_perm;
> -
>  	bool write_fault;
>  	bool exec_fault;
>  	bool writable;
> @@ -1732,6 +1730,11 @@ struct kvm_s2_fault {
>  	vm_flags_t vm_flags;
>  };
>  
> +static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
> +{
> +	return kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
> +}
> +
>  static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
>  				     struct kvm_s2_fault *fault)
>  {
> @@ -1888,7 +1891,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
>  	if (s2fd->nested)
>  		adjust_nested_exec_perms(kvm, s2fd->nested, &fault->prot);
>  
> -	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
> +	if (!kvm_s2_fault_is_perm(s2fd) && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
>  		/* Check the VMM hasn't introduced a new disallowed VMA */
>  		if (!fault->mte_allowed)
>  			return -EFAULT;
> @@ -1905,6 +1908,7 @@ static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
>  static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  			    struct kvm_s2_fault *fault, void *memcache)
>  {
> +	bool fault_is_perm = kvm_s2_fault_is_perm(s2fd);
>  	struct kvm *kvm = s2fd->vcpu->kvm;
>  	struct kvm_pgtable *pgt;
>  	int ret;
> @@ -1922,7 +1926,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  	 */
>  	if (fault->vma_pagesize == PAGE_SIZE &&
>  	    !(fault->force_pte || fault->s2_force_noncacheable)) {
> -		if (fault->fault_is_perm && fault->fault_granule > PAGE_SIZE) {
> +		if (fault_is_perm && fault->fault_granule > PAGE_SIZE) {
>  			fault->vma_pagesize = fault->fault_granule;
>  		} else {
>  			fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
> @@ -1936,7 +1940,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  		}
>  	}
>  
> -	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
> +	if (!fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
>  		sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
>  
>  	/*
> @@ -1944,7 +1948,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
>  	 * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
>  	 * kvm_pgtable_stage2_map() should be called to change block size.
>  	 */
> -	if (fault->fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
> +	if (fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
>  		/*
>  		 * Drop the SW bits in favour of those stored in the
>  		 * PTE, which will be preserved.
> @@ -1977,7 +1981,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
>  	bool write_fault = kvm_is_write_fault(s2fd->vcpu);
>  	bool logging_active = memslot_is_logging(s2fd->memslot);
>  	struct kvm_s2_fault fault = {
> -		.fault_is_perm = perm_fault,
>  		.logging_active = logging_active,
>  		.force_pte = logging_active,
>  		.prot = KVM_PGTABLE_PROT_R,

