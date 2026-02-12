Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC6F224D6
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770916958; cv=none; b=EH3W6IaODFGgzixAxk15LKypG+jvn4cKKsw3d771sDxX9ciIBfRctyaIhVGFtsYnsS1AKHZ77S75O4lohpdoITXNQOXlf77euW5WkgxlhGhTHLUhdfrCbRANMuR72wkproqSatoWhLbMI//nFGRnZSBDzyfjJ/eXhZLmEJqaJ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770916958; c=relaxed/simple;
	bh=axlsKnV4UN/7W0+tVxBsUxPWYY+rV5DrO7VNLOPHhus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqPOgp0xp/AduqC//lgx6MGwRi0zG1O4/dEtmj4W6dZclbFrzy95YYu3zUYh8C7kFMjLkrQhYVvhtG6T326Ken+aJI3xocX6dE1tJr70WVe8G52NS4J+KUuoHYXRwGJTQZHzTXxVFZDak9NuoAuklfPDf8BFTRplDcK9oWqInQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68F49339;
	Thu, 12 Feb 2026 09:22:29 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA21E3F632;
	Thu, 12 Feb 2026 09:22:32 -0800 (PST)
Date: Thu, 12 Feb 2026 17:22:28 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 25/35] KVM: arm64: Reclaim faulting page from pKVM in
 spurious fault handler
Message-ID: <aY4MVDoEnq-fqv_F@raptor>
References: <20260119124629.2563-1-will@kernel.org>
 <20260119124629.2563-26-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119124629.2563-26-will@kernel.org>

Hi Will,

Would be nice to merge this with the previous patch, that added the force
reclaim function, as it would make reviewing easier.

On Mon, Jan 19, 2026 at 12:46:18PM +0000, Will Deacon wrote:
> Host kernel accesses to pages that are inaccessible at stage-2 result in
> the injection of a translation fault, which is fatal unless an exception
> table fixup is registered for the faulting PC (e.g. for user access
> routines). This is undesirable, since a get_user_pages() call could be
> used to obtain a reference to a donated page and then a subsequent
> access via a kernel mapping would lead to a panic().
> 
> Rework the spurious fault handler so that stage-2 faults injected back
> into the host result in the target page being forcefully reclaimed when
> no exception table fixup handler is registered.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/include/asm/virt.h |  6 ++++++
>  arch/arm64/kvm/pkvm.c         |  7 +++++++
>  arch/arm64/mm/fault.c         | 15 +++++++++------
>  3 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
> index b51ab6840f9c..e80addc923a4 100644
> --- a/arch/arm64/include/asm/virt.h
> +++ b/arch/arm64/include/asm/virt.h
> @@ -94,6 +94,12 @@ static inline bool is_pkvm_initialized(void)
>  	       static_branch_likely(&kvm_protected_mode_initialized);
>  }
>  
> +#ifdef CONFIG_KVM
> +bool pkvm_reclaim_guest_page(phys_addr_t phys);
> +#else
> +static inline bool pkvm_reclaim_guest_page(phys_addr_t phys) { return false; }
> +#endif
> +
>  /* Reports the availability of HYP mode */
>  static inline bool is_hyp_mode_available(void)
>  {
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8be91051699e..d1926cb08c76 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -563,3 +563,10 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	WARN_ON_ONCE(1);
>  	return -EINVAL;
>  }
> +
> +bool pkvm_reclaim_guest_page(phys_addr_t phys)
> +{
> +	int ret = kvm_call_hyp_nvhe(__pkvm_force_reclaim_guest_page, phys);

Nitpicking here, we have the functions __pkvm_reclaim_page_guest() and this
function, pkvm_reclaim_guest_page(), which calls
__pkvm_force_reclaim_guest_page, which in turn calls
__pkvm_host_force_reclaim_page_guest(). I think having a bit of naming
consistency would be really useful when navigating the source code.

It might also be useful to document that callers of the hypercall
__pkvm_force_reclaim_guest_page are not expected to unpin the page in case of
success, but callers of __pkvm_reclaim_dying_guest_page are.

Thanks,
Alex

> +
> +	return !ret || ret == -EAGAIN;
> +}
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 2294f2061866..5d62abee5262 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -289,9 +289,6 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
>  	if (!is_el1_data_abort(esr) || !esr_fsc_is_translation_fault(esr))
>  		return false;
>  
> -	if (is_pkvm_stage2_abort(esr))
> -		return false;
> -
>  	local_irq_save(flags);
>  	asm volatile("at s1e1r, %0" :: "r" (addr));
>  	isb();
> @@ -302,8 +299,12 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
>  	 * If we now have a valid translation, treat the translation fault as
>  	 * spurious.
>  	 */
> -	if (!(par & SYS_PAR_EL1_F))
> +	if (!(par & SYS_PAR_EL1_F)) {
> +		if (is_pkvm_stage2_abort(esr))
> +			return pkvm_reclaim_guest_page(par & SYS_PAR_EL1_PA);
> +
>  		return true;
> +	}
>  
>  	/*
>  	 * If we got a different type of fault from the AT instruction,
> @@ -389,9 +390,11 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
>  	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
>  		return;
>  
> -	if (WARN_RATELIMIT(is_spurious_el1_translation_fault(addr, esr, regs),
> -	    "Ignoring spurious kernel translation fault at virtual address %016lx\n", addr))
> +	if (is_spurious_el1_translation_fault(addr, esr, regs)) {
> +		WARN_RATELIMIT(!is_pkvm_stage2_abort(esr),
> +			"Ignoring spurious kernel translation fault at virtual address %016lx\n", addr);
>  		return;
> +	}
>  
>  	if (is_el1_mte_sync_tag_check_fault(esr)) {
>  		do_tag_recovery(addr, esr, regs);
> -- 
> 2.52.0.457.g6b5491de43-goog
> 
> 
