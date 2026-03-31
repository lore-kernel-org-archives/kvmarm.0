Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229C836F431
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 05:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774935791; cv=none; b=grKZ47KHU0Q/P0k1AeTBEzLkYUbM487XCCml/VXDFLd2b+wSXEh52E79euQZvHLygfPjgQV8Vq+3eBb9yq7AVjmAYtfOjC776xMdZeLN25Z/wiiIDZLeQ5qhAwF4a//n22JggkNS8aHTMEBzH6BYavIEARwFxg4ZbEVTw/Oy5Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774935791; c=relaxed/simple;
	bh=vSB+ljS0jlhp1cm4eU7MyoYZxLluHbOT/8kE0YlcoaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=co2y6d+yrxvcrqMdFLPzKIHYR19WIFb2+wt/5RambUpOa6YQD8ZSOLBejTWMfKKvVdhP3qUmx7rzFyZbdk9HsU1Wqkj+QmMyim7mkD+3MN2zCM2edPdwii0uFQ/bBkjbdOZeU9Ee2Ox4KM91Ju4oIZ0hkqSKTD585YST5OcBMKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=UcpTubK+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="UcpTubK+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F651493B;
	Mon, 30 Mar 2026 22:43:02 -0700 (PDT)
Received: from [10.57.18.211] (unknown [10.57.18.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03D1A3F641;
	Mon, 30 Mar 2026 22:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774935788; bh=vSB+ljS0jlhp1cm4eU7MyoYZxLluHbOT/8kE0YlcoaI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UcpTubK+EvW+7IXovLRXihaJceuFtVVv/2TbkFcvixMghUlnloG/D5wcq1cmQt/bU
	 0gc/qT4RsaXBg/GLVxWOnhkdSiZ/M7mCCQijhg378kx6Xj+56B1lPHXAx9hgUYtvk6
	 aZzLSM6CDWf+C0onhJJ46xM3pRi07C4BgmO5zA5o=
Message-ID: <8deec1ce-044e-484a-9f9c-82163f3ac801@arm.com>
Date: Tue, 31 Mar 2026 11:13:01 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/30] KVM: arm64: Initialize struct kvm_s2_fault
 completely at declaration
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-11-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-11-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Simplify the initialization of struct kvm_s2_fault in user_mem_abort().
> 
> Instead of partially initializing the struct via designated initializers
> and then sequentially assigning the remaining fields (like write_fault
> and topup_memcache) further down the function, evaluate those
> dependencies upfront.
> 
> This allows the entire struct to be fully initialized at declaration. It
> also eliminates the need for the intermediate fault_data variable and
> its associated fault pointer, reducing boilerplate.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 34 ++++++++++++++++------------------
>  1 file changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index e77b0b60697f6..2b85daaa4426b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1962,8 +1962,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  struct kvm_memory_slot *memslot, unsigned long hva,
>  			  bool fault_is_perm)
>  {
> -	int ret = 0;
> -	struct kvm_s2_fault fault_data = {
> +	bool write_fault = kvm_is_write_fault(vcpu);
> +	bool logging_active = memslot_is_logging(memslot);
> +	struct kvm_s2_fault fault = {
>  		.vcpu = vcpu,
>  		.fault_ipa = fault_ipa,
>  		.nested = nested,
> @@ -1971,19 +1972,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  		.hva = hva,
>  		.fault_is_perm = fault_is_perm,
>  		.ipa = fault_ipa,
> -		.logging_active = memslot_is_logging(memslot),
> -		.force_pte = memslot_is_logging(memslot),
> -		.s2_force_noncacheable = false,
> +		.logging_active = logging_active,
> +		.force_pte = logging_active,
>  		.prot = KVM_PGTABLE_PROT_R,
> +		.fault_granule = fault_is_perm ? kvm_vcpu_trap_get_perm_fault_granule(vcpu) : 0,
> +		.write_fault = write_fault,
> +		.exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu),
> +		.topup_memcache = !fault_is_perm || (logging_active && write_fault),
>  	};
> -	struct kvm_s2_fault *fault = &fault_data;
>  	void *memcache;
> +	int ret;
>  
> -	if (fault->fault_is_perm)
> -		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
> -	fault->write_fault = kvm_is_write_fault(fault->vcpu);
> -	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
> -	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
> +	VM_WARN_ON_ONCE(fault.write_fault && fault.exec_fault);
>  
>  	/*
>  	 * Permission faults just need to update the existing leaf entry,
> @@ -1991,9 +1991,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * only exception to this is when dirty logging is enabled at runtime
>  	 * and a write fault needs to collapse a block entry into a table.
>  	 */
> -	fault->topup_memcache = !fault->fault_is_perm ||
> -				(fault->logging_active && fault->write_fault);
> -	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
> +	ret = prepare_mmu_memcache(vcpu, fault.topup_memcache, &memcache);
>  	if (ret)
>  		return ret;
>  
> @@ -2001,17 +1999,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * Let's check if we will get back a huge page backed by hugetlbfs, or
>  	 * get block mapping for device MMIO region.
>  	 */
> -	ret = kvm_s2_fault_pin_pfn(fault);
> +	ret = kvm_s2_fault_pin_pfn(&fault);
>  	if (ret != 1)
>  		return ret;
>  
> -	ret = kvm_s2_fault_compute_prot(fault);
> +	ret = kvm_s2_fault_compute_prot(&fault);
>  	if (ret) {
> -		kvm_release_page_unused(fault->page);
> +		kvm_release_page_unused(fault.page);
>  		return ret;
>  	}
>  
> -	return kvm_s2_fault_map(fault, memcache);
> +	return kvm_s2_fault_map(&fault, memcache);
>  }
>  
>  /* Resolve the access fault by making the page young again. */
