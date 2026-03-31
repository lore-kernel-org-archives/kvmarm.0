Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7162D0C7B
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 04:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774930143; cv=none; b=sU8cAaOEfpn4Y6N3IvxlwZK7SARncGQXcHGCtMF9rz1Nkdj2TPgkx570mC1teK6dU+oCG0H1RvMJHm0B1YsvtQjMM2TpXpQm/DAMrRay/V3Ad0ulZfYfrDN5iuGIAqxsWkMplaSkVeXktG1SpNiBMinEESwC/vej9y180MVM7D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774930143; c=relaxed/simple;
	bh=eeWhzDq/g9ogPWuXGXHJA1W4KEgQE+FQiwe859PXeeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aANSX5jhcweNSbheVwdZzLJ2F096bb+Rk/WEzg20+Y9FdOU8TSgxJevSmIaONLnirUQxxPChaJLdUsoyVhHYel2hC35TN2Z8mGlUlroqnHu3CP/LfQvprjkW+ih/R9C7RRCGZcXfPEgbLIg/iQlHi9UJ9HdQSmIvvlmWFhUZhwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dGlBHyFX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dGlBHyFX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DD1F1F91;
	Mon, 30 Mar 2026 21:08:53 -0700 (PDT)
Received: from [10.57.18.211] (unknown [10.57.18.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 535AD3F7D8;
	Mon, 30 Mar 2026 21:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774930139; bh=eeWhzDq/g9ogPWuXGXHJA1W4KEgQE+FQiwe859PXeeo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dGlBHyFX6rFFQON99FFtMC8b5JgeE53XaS2fqDrNs/yKosEGOuW25BUbV+Lsn74F6
	 Ef2mIF6MvvYKgttrOqX0gHAOOKIFcPqFk0XQxRZfronsbiojDatehk2kZhhS8cQtES
	 ACVb0hMqbJK4agzMSA37QHzB+7biNB6lFJqbXp3g=
Message-ID: <a9eeecfe-de90-4a0f-854f-0ee4e4d1c8bc@arm.com>
Date: Tue, 31 Mar 2026 09:38:51 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/30] KVM: arm64: Remove redundant state variables
 from struct kvm_s2_fault
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-9-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-9-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Remove redundant variables vma_shift and vfio_allow_any_uc from struct
> kvm_s2_fault as they are easily derived or checked when needed.
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5572b127f8663..1b991300735be 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1721,10 +1721,8 @@ struct kvm_s2_fault {
>  	bool mte_allowed;
>  	bool is_vma_cacheable;
>  	bool s2_force_noncacheable;
> -	bool vfio_allow_any_uc;
>  	unsigned long mmu_seq;
>  	phys_addr_t ipa;
> -	short vma_shift;
>  	gfn_t gfn;
>  	kvm_pfn_t pfn;
>  	bool logging_active;
> @@ -1749,9 +1747,9 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  		return -EFAULT;
>  	}
>  
> -	fault->vma_shift = kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot, fault->nested,
> -						   &fault->force_pte, &fault->ipa);
> -	fault->vma_pagesize = 1UL << fault->vma_shift;
> +	fault->vma_pagesize = 1UL << kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot,
> +							     fault->nested, &fault->force_pte,
> +							     &fault->ipa);
>  
>  	/*
>  	 * Both the canonical IPA and fault IPA must be aligned to the
> @@ -1764,8 +1762,6 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
>  	fault->gfn = fault->ipa >> PAGE_SHIFT;
>  	fault->mte_allowed = kvm_vma_mte_allowed(vma);
>  
> -	fault->vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
> -
>  	fault->vm_flags = vma->vm_flags;
>  
>  	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
> @@ -1796,7 +1792,7 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>  				       fault->write_fault ? FOLL_WRITE : 0,
>  				       &fault->writable, &fault->page);
>  	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> -		kvm_send_hwpoison_signal(fault->hva, fault->vma_shift);
> +		kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
>  		return 0;
>  	}
>  	if (is_error_noslot_pfn(fault->pfn))
> @@ -1874,7 +1870,7 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
>  		fault->prot |= KVM_PGTABLE_PROT_X;
>  
>  	if (fault->s2_force_noncacheable) {
> -		if (fault->vfio_allow_any_uc)
> +		if (fault->vm_flags & VM_ALLOW_ANY_UNCACHED)
>  			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
>  		else
>  			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
> @@ -1978,7 +1974,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		.logging_active = memslot_is_logging(memslot),
>  		.force_pte = memslot_is_logging(memslot),
>  		.s2_force_noncacheable = false,
> -		.vfio_allow_any_uc = false,
>  		.prot = KVM_PGTABLE_PROT_R,
>  	};
>  	struct kvm_s2_fault *fault = &fault_data;

