Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDD82D593E
	for <kvmarm@lists.linux.dev>; Thu,  4 Dec 2025 10:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764844619; cv=none; b=NCgJ1QfWzvsOtMWoqNaQxx55Sd0IXJo3oe5kFLtbO6cptdjCrfU0PgGTZjAHqnM8tFJyRWE8haOnde3nkEY6cCQAXJg8TnGE0wNaqETz9Augc8r/aWnjdg8Hjvz4KyH2ZzIzBy94Pi81S0/y5zAceT8GvXcphMeSJKjTyN5ath0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764844619; c=relaxed/simple;
	bh=DoPKg8tSViO58dPPfy5Wr80wyWPR/M9Tyd2yDddJPdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZVm1hpxZTXs1LATIj7ID45Iu45UD8PcRhDZXxF4j+dhzc+aAka2Yrp4UTdrDixNR37ERmpWCL7XBGH1UaFi1/59D75yTcr5nURxh+iV8Q2qAL5NUhappns2oNvU2ixxtDcQGa9nF5vEWvF4pH+GhTb4hk+9RnqUYuYQm/SPRBj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E498339;
	Thu,  4 Dec 2025 02:36:50 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 751C03F73B;
	Thu,  4 Dec 2025 02:36:56 -0800 (PST)
Message-ID: <b98c154a-1658-4501-bfa5-a93303aa5b3f@arm.com>
Date: Thu, 4 Dec 2025 10:36:54 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] arm64: Repaint ID_AA64MMFR2_EL1.IDS description
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>,
 Zenghui Yu <yuzenghui@huawei.com>, Yao Yuan <yaoyuan@linux.alibaba.com>
References: <20251204094806.3846619-1-maz@kernel.org>
 <20251204094806.3846619-2-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20251204094806.3846619-2-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 12/4/25 09:47, Marc Zyngier wrote:
> ID_AA64MMFR2_EL1.IDS, as described in the sysreg file, is pretty horrible
> as it diesctly give the ESR value. Repaint it using the usual NI/IMP
> identifiers to describe the absence/presence of FEAT_IDST.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
>  arch/arm64/tools/sysreg            | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 82da9b03692d4..107d62921b168 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -134,7 +134,7 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr2[] = {
>  	MAX_FEAT(ID_AA64MMFR2_EL1, UAO, IMP),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, IESB, IMP),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, AT, IMP),
> -	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, 0x18),
> +	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, IMP),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, TTL, IMP),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, BBM, 2),
>  	MAX_FEAT(ID_AA64MMFR2_EL1, E0PD, IMP),
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 1c6cdf9d54bba..3261e8791ac03 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2257,8 +2257,8 @@ UnsignedEnum	43:40	FWB
>  	0b0001	IMP
>  EndEnum
>  Enum	39:36	IDS

Should this also be changed to an UnsignedEnum?

> -	0b0000	0x0
> -	0b0001	0x18
> +	0b0000	NI
> +	0b0001	IMP
>  EndEnum
>  UnsignedEnum	35:32	AT
>  	0b0000	NI


Thanks,

Ben

