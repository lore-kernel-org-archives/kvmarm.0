Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6CFE31714C
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 02:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775010243; cv=none; b=l7swXbnaDt7vlU7Sy75wLo+2Dlsx+IHe7jBOwvv0PJI2NCahvxgv5I0j8IyMI8NIa/i7sVy4MkonwBGtByFIVaQ1UNKzCgp9ogpOEvDpvzII6D104z1gqf1mFwcmfPVMGYVu2zL+M/OW5HM5aL/MolEEQ3l4n8kqfIBCaPGKr8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775010243; c=relaxed/simple;
	bh=HLoh86vohO7b+KpMGVA+Fn4nF+utzpab4GyEmA9Mmds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRh/La39YiOlD4W+p900qo7iNGYvbibaGcnmftCMwlCFV97Zb7DMGO/DACOw+GR/ugO3O7yljq+LoUtA5DNe0lH5phiPRKtOBBENA+VdGRPNqmTkpZZwze1PXswt4T7q4KktI5ltZ60TzJg2xvieHKtT73m93N6fmng6v89cBx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q8F8ZxCr; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q8F8ZxCr"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C2033161;
	Tue, 31 Mar 2026 19:23:54 -0700 (PDT)
Received: from [10.164.18.48] (unknown [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C08583F7D8;
	Tue, 31 Mar 2026 19:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775010239; bh=HLoh86vohO7b+KpMGVA+Fn4nF+utzpab4GyEmA9Mmds=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q8F8ZxCr6LZ/IpozivO+rH0nqoEn0hdZQZ19RD6aSibySieRfPtpjhCY+nLqIBOjc
	 7545JvSbZgJa5mNDrWj/olggUf13ofWNP6sf7Ie7eQ0mEiruktxat4mtgNnKZsW+eD
	 6qoJsAP0iU4rU3Y+e9aWUkMGxV2aDVe0UrXeK0z0=
Message-ID: <418441bc-d0b3-42c6-a7b1-aa4e2b17f536@arm.com>
Date: Wed, 1 Apr 2026 07:53:53 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/30] KVM: arm64: Hoist MTE validation check out of
 MMU lock path
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-13-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-13-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:06 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Simplify the non-cacheable attributes assignment by using a ternary
> operator. Additionally, hoist the MTE validation check (mte_allowed) out
> of kvm_s2_fault_map() and into kvm_s2_fault_compute_prot(). This allows
> us to fail faster and avoid acquiring the KVM MMU lock unnecessarily
> when the VMM introduces a disallowed VMA for an MTE-enabled guest.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0c71e3a9af8b0..ee2a548999b1b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1870,18 +1870,21 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
>  	if (fault->exec_fault)
>  		fault->prot |= KVM_PGTABLE_PROT_X;
>  
> -	if (fault->s2_force_noncacheable) {
> -		if (fault->vm_flags & VM_ALLOW_ANY_UNCACHED)
> -			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
> -		else
> -			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
> -	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
> +	if (fault->s2_force_noncacheable)
> +		fault->prot |= (fault->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
> +			       KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
> +	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
>  		fault->prot |= KVM_PGTABLE_PROT_X;
> -	}
>  
>  	if (fault->nested)
>  		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
>  
> +	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
> +		/* Check the VMM hasn't introduced a new disallowed VMA */
> +		if (!fault->mte_allowed)
> +			return -EFAULT;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1918,15 +1921,8 @@ static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
>  		}
>  	}
>  
> -	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm)) {
> -		/* Check the VMM hasn't introduced a new disallowed VMA */
> -		if (fault->mte_allowed) {
> -			sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
> -		} else {
> -			ret = -EFAULT;
> -			goto out_unlock;
> -		}
> -	}
> +	if (!fault->fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
> +		sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
>  
>  	/*
>  	 * Under the premise of getting a FSC_PERM fault, we just need to relax

