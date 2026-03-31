Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9202C387570
	for <kvmarm@lists.linux.dev>; Tue, 31 Mar 2026 06:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774938917; cv=none; b=gKOdW2HyeSH4wAZQzs6kB2ciOknZqtiAYUr7jYyhbpRYNDjQ3uxSTd2dIkluXxUxS6zjluuWVML8hkvLOAzrglVym1V4YxO8BxUdAG3Dbl6nFbJ/1A2unTtlDBmHmK1gFZmKNbmf6n55BKNAba75pZ56xz99dZ7PoRVZsAVzPFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774938917; c=relaxed/simple;
	bh=hJ/peryzDyZXWHGuHVyca0EHV/+QHTpwsvOABi0KKkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lA4yY213RHb4z0NVQ1mMGgY0yErSkKeYOi50iQaXPn/BOd0m7AtfHIoyLCkPIphwHEbktUKZivfq/EJIyBdDefq9QygTAHL6gQbSQm/dMroPWW85RFTgbSuPMrioQGkDjEvnZaxBVrnqW8yh88wk2t1UHmoFvDq+B96HQg9okAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iCCd9igQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iCCd9igQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0AFA5495B;
	Mon, 30 Mar 2026 23:35:09 -0700 (PDT)
Received: from [10.57.18.211] (unknown [10.57.18.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CC303F7D8;
	Mon, 30 Mar 2026 23:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774938914; bh=hJ/peryzDyZXWHGuHVyca0EHV/+QHTpwsvOABi0KKkk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iCCd9igQkNYtcksU7nNahSiWtqNQghsVB3OVx2YC1LmA4pdcD1Wo4kstqSaW16KqR
	 ZQm/I0QvNn/DR1r99Xv36tVA2U/RRPfeGYvCQDKFlFKs5rKIipKSq0E5mTi7ce3BLW
	 A17d7CCSRFfDv4RsVbr5f8ZKCASkreqRTuwN+K5U=
Message-ID: <3870cd5d-3128-4f59-9e20-413f3651da58@arm.com>
Date: Tue, 31 Mar 2026 12:05:08 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/30] KVM: arm64: Optimize early exit checks in
 kvm_s2_fault_pin_pfn()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>
References: <20260327113618.4051534-1-maz@kernel.org>
 <20260327113618.4051534-12-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260327113618.4051534-12-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/03/26 5:05 PM, Marc Zyngier wrote:
> From: Fuad Tabba <tabba@google.com>
> 
> Optimize the early exit checks in kvm_s2_fault_pin_pfn by grouping all
> error responses under the generic is_error_noslot_pfn check first,
> avoiding unnecessary branches in the hot path.
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  arch/arm64/kvm/mmu.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 2b85daaa4426b..0c71e3a9af8b0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1791,12 +1791,13 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
>  	fault->pfn = __kvm_faultin_pfn(fault->memslot, fault->gfn,
>  				       fault->write_fault ? FOLL_WRITE : 0,
>  				       &fault->writable, &fault->page);
> -	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> -		kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
> -		return 0;
> -	}
> -	if (is_error_noslot_pfn(fault->pfn))
> +	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
> +		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
> +			kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
> +			return 0;
> +		}
>  		return -EFAULT;
> +	}
>  
>  	return 1;
>  }

