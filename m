Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD8E1A3154
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 03:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774929378; cv=none; b=ERBd+K0wHjd60Laa8zrV0PiVdiPiVxyniM1uQv19Efr+yZ2Vd59DNJaThWaQitPnRWmGS+iJ9btNRH0zTdL+LtlSwvbjHtW8CtC/z/WHTl9x4/9FgwDZ/bKGhY66T9/BejJdksFL0X5Tt28dD13AdLM7VhCWyMyZrUh2txZwGRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774929378; c=relaxed/simple;
	bh=80O4NMmB3gBu9FMGBVti7X/3T9K3gvasVuFL3fYGb24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iz3cEg0NJgcL+su3bSj8IrnVbApju5Cc2gQJvENfv5dgDonMlh9CJAralhhWAfX9TR06rkS5qrXfdvchcCsMuNMHMy0I59oBHdxLbceMw1jjYByvor5/u5dMdSWiyVXEgEQpLmr4FKHIIkOrUyF4waxwZC1bWaSlOZpDVVjfPW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=q134Con3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="q134Con3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C165814BF;
	Mon, 30 Mar 2026 20:56:10 -0700 (PDT)
Received: from [10.57.18.211] (unknown [10.57.18.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 27E793F641;
	Mon, 30 Mar 2026 20:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774929376; bh=80O4NMmB3gBu9FMGBVti7X/3T9K3gvasVuFL3fYGb24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q134Con3DS6ptSSm/vMlMBnGJSdar55NAeFdN+buDQB+PsDZJCwKdyZXSt37066kt
	 QezDfsjAADDdUOo/oZuiAZODm0XNIhTau/L2hOOX75zRmw9Ee681lV3CfC0dWNogq+
	 L9jJOoq+D7tEzYvhFKPiRjV4sEd+vqa+888fwbow=
Message-ID: <0a164ac6-fe82-4ac1-ba57-557755ee342d@arm.com>
Date: Tue, 31 Mar 2026 09:26:08 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/30] KVM: arm64: Simplify nested VMA shift
 calculation
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-8-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-8-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> In the kvm_s2_resolve_vma_size() helper, the local variable vma_pagesize
> is calculated from vma_shift, only to be used to bound the vma_pagesize
> by max_map_size and subsequently convert it back to a shift via __ffs().
> 
> Because vma_pagesize and max_map_size are both powers of two, we can
> simplify the logic by omitting vma_pagesize entirely and bounding the
> vma_shift directly using the shift of max_map_size. This achieves the
> same result while keeping the size-to-shift conversion out of the helper
> logic.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 164f1160ea33d..5572b127f8663 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1646,7 +1646,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>  				     bool *force_pte, phys_addr_t *ipa)
>  {
>  	short vma_shift;
> -	long vma_pagesize;
>  
>  	if (*force_pte)
>  		vma_shift = PAGE_SHIFT;
> @@ -1677,8 +1676,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>  		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
>  	}
>  
> -	vma_pagesize = 1UL << vma_shift;
> -
>  	if (nested) {
>  		unsigned long max_map_size;
>  
> @@ -1703,8 +1700,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
>  			max_map_size = PAGE_SIZE;
>  
>  		*force_pte = (max_map_size == PAGE_SIZE);
> -		vma_pagesize = min_t(long, vma_pagesize, max_map_size);
> -		vma_shift = __ffs(vma_pagesize);
> +		vma_shift = min_t(short, vma_shift, __ffs(max_map_size));
>  	}
>  
>  	return vma_shift;

