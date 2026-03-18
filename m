Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D3B3D902C
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773841411; cv=none; b=KY0eZtzyaf3neBj75Tpre680Ny1gc1YH4EOAIkZZWnEjxeLoBJyj3ZeJbYMqfttP7Io5TeinW/ALExHq/CDWu5AsSJVz7Mxg/ErKWiO0gDvmhreiSZVb+aGv8gViwmEOOnu8FkUFOkOjKecvM1oLWs8vZxPi2g23wwhtw7OLVXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773841411; c=relaxed/simple;
	bh=0CHweL7Qoq/6T3NeuOTeEVI0sVTLwvv7YbW2pvbrx7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhxCl16yY545+6waupcnsz1YqU/xfvgzF43d+F+gX718XRHwCDp6cHIQe7YQX0Jd3r014/CkwGS1QQ2DUEZJnRkWGrQA/0J+KM/ISnnW8Fb7FEN5Oy6LnN+BeBE0pUidSEGsEeGmF6M9SkDeZ0rNCuJpN0T6aNoChqrj4xZJ2y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5A1E1BF7;
	Wed, 18 Mar 2026 06:43:22 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BD9C3F73B;
	Wed, 18 Mar 2026 06:43:27 -0700 (PDT)
Date: Wed, 18 Mar 2026 13:43:22 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: Re: [PATCH 04/17] KVM: arm64: Replace fault_is_perm with a helper
Message-ID: <20260318134322.GA3915656@e124191.cambridge.arm.com>
References: <20260316175451.1866175-1-maz@kernel.org>
 <20260316175451.1866175-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316175451.1866175-5-maz@kernel.org>

On Mon, Mar 16, 2026 at 05:54:37PM +0000, Marc Zyngier wrote:
> Carrying a boolean to indicate that a given fault is slightly odd,

ESR_ELx_FSC_SLIGHTLY_ODD :D
(probably should be "that a given fault is a permission fault is..")

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> as this is a property of the fault itself, and we'd better avoid
> duplicating state.
> 
> For this purpose, introduce a kvm_s2_fault_is_perm() predicate that
> can take a fault descriptor as a parameter. fault_is_perm is therefore
> dropped from kvm_s2_fault.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 2a7128b8dd14f..1b32f2e6c3e61 100644
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
> -- 
> 2.47.3
> 
