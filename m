Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B15076022
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460933; cv=none; b=BunjtFTcju9JH0TBYrSfsAy+iv1puPt40wjGEPGl+LzSYWApVTJEe7f2PeFdjRyfkCeya+B4z+AW2OoZdZ5m9+NM5Iot0T7EkdR6nHn/v6J1VMTGrYb+DarfFhRy33x/Zg5wF3dRFtLxmaUO04JOmxSyHMkMCG/RCwoAqXWrkPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460933; c=relaxed/simple;
	bh=/reoyI/6hKkDFudg/aUgFGgBoyW1HH5oaMhs+HJaptg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZJmfoI4Mz94h+2MiyCxfe0Xq98+KjQ5naOuWd9s63tozaZMjkdLsUShbccpaUFTepj97JXt5HJnhTtuhCKhwCsU+f4bWKYaMqCJktg8XOumQ9/8FTiTRV8EGDUPPcjoR6ahAgQ6F/SQl9itDzE2KTCglB9sPJXeA3XQO03X0Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42F6C2F4;
	Tue, 26 Mar 2024 06:49:24 -0700 (PDT)
Received: from [10.1.29.179] (XHFQ2J9959.cambridge.arm.com [10.1.29.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E5303F64C;
	Tue, 26 Mar 2024 06:48:48 -0700 (PDT)
Message-ID: <b3177895-5ed0-4f1a-bede-4d0c87935bbc@arm.com>
Date: Tue, 26 Mar 2024 13:48:46 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: arm64: Use TLBI_TTL_UNKNOWN in
 __kvm_tlb_flush_vmid_range()
Content-Language: en-GB
To: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Gavin Shan <gshan@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Mostafa Saleh <smostafa@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Quentin Perret <qperret@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Shaoqin Huang <shahuang@redhat.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20240325185158.8565-1-will@kernel.org>
 <20240325185158.8565-4-will@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20240325185158.8565-4-will@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 25/03/2024 18:51, Will Deacon wrote:
> Commit c910f2b65518 ("arm64/mm: Update tlb invalidation routines for
> FEAT_LPA2") updated the __tlbi_level() macro to take the target level
> as an argument, with TLBI_TTL_UNKNOWN (rather than 0) indicating that
> the caller cannot provide level information. Unfortunately, the two
> implementations of __kvm_tlb_flush_vmid_range() were not updated and so
> now ask for an level 0 invalidation if FEAT_LPA2 is implemented.

Ouch, sorry about this! I remember rebasing my change onto the KVM tlbi range
changes and having a few conflicts. Obviously I didn't do a good enough job of
reviewing the result and missed this new user.

> 
> Fix the problem by passing TLBI_TTL_UNKNOWN instead of 0 as the level
> argument to __flush_s2_tlb_range_op() in __kvm_tlb_flush_vmid_range().
> 
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Marc Zyngier <maz@kernel.org>
> Fixes: c910f2b65518 ("arm64/mm: Update tlb invalidation routines for FEAT_LPA2")
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/tlb.c | 3 ++-
>  arch/arm64/kvm/hyp/vhe/tlb.c  | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index a60fb13e2192..2fc68da4036d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -154,7 +154,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>  	/* Switch to requested VMID */
>  	__tlb_switch_to_guest(mmu, &cxt, false);
>  
> -	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
> +	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride,
> +				TLBI_TTL_UNKNOWN);
>  
>  	dsb(ish);
>  	__tlbi(vmalle1is);
> diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
> index b32e2940df7d..1a60b95381e8 100644
> --- a/arch/arm64/kvm/hyp/vhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/vhe/tlb.c
> @@ -171,7 +171,8 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>  	/* Switch to requested VMID */
>  	__tlb_switch_to_guest(mmu, &cxt);
>  
> -	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
> +	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride,
> +				TLBI_TTL_UNKNOWN);
>  
>  	dsb(ish);
>  	__tlbi(vmalle1is);

