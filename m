Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FE833374A
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 17:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278621; cv=none; b=cdnQ+v89DaNxmKRkE7FmAVHK/sXhvJ6PgwqbE59ceiNDus1sRxA7GItCtMZUkqiS1sLborrvhW2DqCctgJUaL09GGQ+WAIE4mZQ0Logrp5fI6HVmfAot7z9ES4PonoXjG5Tbxm1dxtCKmofg8y2OUGOOWEOOTS7XPyPgZrx7pqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278621; c=relaxed/simple;
	bh=uap4ZNNf4KCRh72JT+8YyzrSp1+Duu0+i2bQB0KuFO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bRIr3+R6tVvoPiY3ifPdisRVC4n5hqioJJKFrAlBbOuKK43a/vuPHUu3nwxLIeCJ2wFP2hgfieOw2iZhF59n/D+NPDYZe2np530I9I7pUXlh0efPtXLCpjCoMA9EqqF9+bopmP1V7j7OPJBPKdbUOQjm5PN6Op4xJupAPD9wGEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C99971CE0;
	Tue,  4 Nov 2025 09:50:09 -0800 (PST)
Received: from [10.57.71.89] (unknown [10.57.71.89])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB1F33F66E;
	Tue,  4 Nov 2025 09:50:15 -0800 (PST)
Message-ID: <a0b19558-dbcb-4231-b0c4-302cc10652db@arm.com>
Date: Tue, 4 Nov 2025 17:50:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/8] KVM: arm64: Fix Trace Buffer trap polarity for
 protected VMs
Content-Language: en-GB
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
 joey.gouly@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 vladimir.murzin@arm.com
References: <20251104125906.1919426-1-tabba@google.com>
 <20251104125906.1919426-6-tabba@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20251104125906.1919426-6-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/11/2025 12:59, Fuad Tabba wrote:
> The E2TB bits in MDCR_EL2 control trapping of Trace Buffer system
> register accesses. These accesses are trapped to EL2 when the bits are
> clear.
> 
> The trap initialization logic for protected VMs in pvm_init_traps_mdcr()
> had the polarity inverted. When a guest did not support the ExtTrcBuff
> feature, the code was setting E2TB. This incorrectly disabled the trap,
> potentially allowing a protected guest to access registers for a feature
> it was not given.
> 
> Fix this by inverting the operation.
> 
> Fixes: f50758260bff ("KVM: arm64: Group setting traps for protected VMs by control register")
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/arm64/kvm/hyp/nvhe/pkvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 43bde061b65d..df0c59a29b35 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -118,7 +118,7 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
>   		val |= MDCR_EL2_TTRF;
>   
>   	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))

Why are we checkin ExtTrcBuff ? Shouldn't that be TraceBuffer ?

> -		val |= MDCR_EL2_E2TB_MASK;
> +		val &= ~MDCR_EL2_E2TB_MASK;
This looks correct to me.

Suzuki

>   
>   	/* Trap Debug Communications Channel registers */
>   	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))


