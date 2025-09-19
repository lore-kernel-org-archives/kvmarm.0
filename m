Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EB619755B
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 10:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758279239; cv=none; b=Jm//+lp5lwDFFZqOGW504tElszoag9bWmwzaeP+A4gpr7lCD8I0vKI3nYztpnnL1kKVTRzH7kG1yCBoCiVRNUwzzJ9yrEY0N2ShtUsT/7Wv+4Q1Mh19194nZsPpmqYLPaAO5ziHQPh3WWo0TsNND/FMMObzI0YBTcWU/k2TuPLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758279239; c=relaxed/simple;
	bh=gwyxNPbFQrPXNxTdH/PUvK+8/8BLW6ZHEVM2j2+Z1TA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H15t7lQNGyzZzTbAWz2p+5pC326bWhwykgt6OsR9/+a8xKZIKsMT0ie5EopqGHcxswl8NzPB4g1DohxPdH6ymElJpVph2lRZk3kxkkWmY9yO6HJtNptWmkunpmdRI+zR49LUTYPTE4bxpHKVQOxELyd+RurQG+H9RYys1F+LSvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE971169E;
	Fri, 19 Sep 2025 03:53:48 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD2403F66E;
	Fri, 19 Sep 2025 03:53:55 -0700 (PDT)
Message-ID: <64c0b9fc-c970-4f17-8c3b-6a5078257f83@arm.com>
Date: Fri, 19 Sep 2025 11:53:54 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/10] KVM: arm64: Convert MDCR_EL2 RES0 handling to
 compute_reg_res0_bits()
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Jinqian Yang <yangjinqian1@huawei.com>
References: <20250918151402.1665315-1-maz@kernel.org>
 <20250918151402.1665315-11-maz@kernel.org>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20250918151402.1665315-11-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 9/18/25 16:14, Marc Zyngier wrote:
> While MDCR_EL2 cannot be RES0, convert it to the same infrastructure
> anyway, as it make things cleaner.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 7b5c5044d4f64..109d1edcd83d4 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
[...]
> @@ -1417,8 +1419,7 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *r
>  		*res1 = SCTLR_EL1_RES1;
>  		break;
>  	case MDCR_EL2:
> -		*res0 = compute_res0_bits(kvm, mdcr_el2_feat_map,
> -					  ARRAY_SIZE(mdcr_el2_feat_map), 0, 0);
> +		*res0 = compute_reg_res0_bits(kvm, &mdcr_el2_desc, 0, 0);
>  		*res0 |= MDCR_EL2_RES0;
>  		*res1 = MDCR_EL2_RES1;
>  		break;

The patch itself looks fine to me but I am confused as to why MDCR_EL2
is the only switch case where we have:

*res0 |= <reg>_RES0;

Should this not be present in the other cases?

Thanks,

Ben

