Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D9C386566
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 06:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774940278; cv=none; b=nYxoKqVqpUlAdRrq47ShPHgbtbyMP4a/a1s6wA3PEJENCRo/iIo6P72GNQIGAzbGo4D4Xy01lVGA4f8zqEcvX6EpyvwMIOIuHgHMkg2xyxs5Pa+e7Xb2y20CPCqPJYuP8cjm3Yo6bMe85Pi3ACIpV76Zn9oJixTNBnQvFtRl5sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774940278; c=relaxed/simple;
	bh=2tOMaJp56iXUOV/xkh3Q08VCKzhADZC2/A1u7wVNqcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nvBhT/5ryA19QUOFIZgrxi61nkiIelTRH5CHalpq7VfHfCjSnpPX1nyB7AqKNQ/P1TAjqI6mCGWs3dE2c3WWDsQcg3FFZ76lgK5CSV2xoZOWUGrLhH7om5zcxF4YFjIRcrjx0vP1YhsrNYA8QQYZh3Uyp46glt+IplQ+N2VsP9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jUXTOiLI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jUXTOiLI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47AC4495B;
	Mon, 30 Mar 2026 23:57:49 -0700 (PDT)
Received: from [10.57.18.211] (unknown [10.57.18.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A77703F7D8;
	Mon, 30 Mar 2026 23:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774940275; bh=2tOMaJp56iXUOV/xkh3Q08VCKzhADZC2/A1u7wVNqcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jUXTOiLI9uc4O/BtVmCD3Pfg6t+oABR1hnVEsw1GT0cmK6m8Z8yv2axk3OU8o/8ns
	 E+sb+tkKwzB96Osa4oxz67fau7jGEOlCGveXKEBX4SYadsF6KoNdegLMx9hyzeKSKi
	 zmUnKQuO2UoHxyr3MRgMXyzl4mtuN2b8FKFr48No=
Message-ID: <8bd2b649-01b5-44f4-a034-c202e226e97c@arm.com>
Date: Tue, 31 Mar 2026 12:27:48 +0530
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

Is not the existing code block bit more cleaner though ?

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

