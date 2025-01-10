Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501F5224D7;
	Fri, 10 Jan 2025 18:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736533229; cv=none; b=XyNotRquvXYVeXtYlomfCFlB+fpfdTrwoyCOieppGgH4fLsDWUEkoBWGZ1kcypDen9xW/aqPbJuYVSEiNFNG345/79GPJWBtfuMCybp0mddPJqX2duNRswKu5fBX9HUhejt2OAltZE6l3ABWq25H+Gehxj6EHqOV9K9y3gbmYGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736533229; c=relaxed/simple;
	bh=5DI6pmLNL3uaHTAg0ZLwNi8HFQ0w/MGNSjp/AtdFWVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAQvGPIY5CS9s7IZdTla4OfW3t3zCotNXqfwTAFgg70BBiVLUoG/x2oGWqAKRYAJxIMtQMSdwf7yXzKcukZbfUZ2pBBUvmJU5MlonxhStR7UJGgz4ERPVjdvatDzVWLr3IzQy7l0k8OcZo3plt42U+BUd2qqMXpOIIKtWDg01Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC829C4CED6;
	Fri, 10 Jan 2025 18:20:25 +0000 (UTC)
Date: Fri, 10 Jan 2025 18:20:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: MTE: Use stage-2 NoTagAccess memory
 attribute if supported
Message-ID: <Z4Fk58k8YptDkVgm@arm.com>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
 <20250110110023.2963795-6-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110110023.2963795-6-aneesh.kumar@kernel.org>

On Fri, Jan 10, 2025 at 04:30:21PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Currently, the kernel won't start a guest if the MTE feature is enabled
> and the guest RAM is backed by memory which doesn't support access tags.
> Update this such that the kernel uses the NoTagAccess memory attribute
> while mapping pages from VMAs for which MTE is not allowed. The fault
> from accessing the access tags with such pages is forwarded to VMM so
> that VMM can decide to kill the guest or take any corrective actions
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

Mostly nitpicks below (apart from the slot registration). The decision
on whether that's the best approach lies with Oliver/Marc.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index cf811009a33c..609ed6a5ffce 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -378,6 +378,11 @@ static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
>  	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
>  }
>  
> +static inline bool kvm_vcpu_trap_is_tagaccess(const struct kvm_vcpu *vcpu)
> +{
> +	return !!(ESR_ELx_ISS2(kvm_vcpu_get_esr(vcpu)) & ESR_ELx_TagAccess);
> +}

The function type is already bool, no need for the "!!".

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index eb8220a409e1..3610bea7607d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1660,9 +1660,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
>  		/* Check the VMM hasn't introduced a new disallowed VMA */
> -		if (mte_allowed) {
> +		if (mte_allowed)
>  			sanitise_mte_tags(kvm, pfn, vma_pagesize);
> -		} else {
> +		else if (kvm_has_mte_perm(kvm))
> +			prot |= KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS;
> +		else {
>  			ret = -EFAULT;
>  			goto out_unlock;
>  		}

Don't remove the brackets at the end of "if (mte_allowed) {" etc. The
coding style does require them if at least one of the branches is
multi-line (the last "else").

> @@ -2152,7 +2162,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  		if (!vma)
>  			break;
>  
> -		if (kvm_has_mte(kvm) && !kvm_vma_mte_allowed(vma)) {
> +		if (kvm_has_mte(kvm) &&
> +		    !kvm_has_mte_perm(kvm) && !kvm_vma_mte_allowed(vma)) {
>  			ret = -EINVAL;
>  			break;
>  		}

I don't think we should change this, or at least not how it's done above
(Suzuki raised a related issue internally relaxing this for VM_PFNMAP).

For standard memory slots, we want to reject them upfront rather than
deferring to the fault handler. An example here is file mmap() passed as
standard RAM to the VM. It's an unnecessary change in behaviour IMHO.
I'd only relax this for VM_PFNMAP mappings further down in this
function (and move the VM_PFNMAP check above; see Suzuki's internal
patch, unless he posted it publicly already).

-- 
Catalin
