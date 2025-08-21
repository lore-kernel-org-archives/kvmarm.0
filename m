Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18B81322DDD
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 13:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755782037; cv=none; b=ZZl22OPMad3ar5cOVAsYFmA849QLqvC3hBZBftxhrbIKZoxwArKux7ZhXPjG6ApP11dSG676Fpzk1I8PmlrMUuibGuXPg91TDJLKtzkCvODnnIxWkUOVCLJjYOm/bmm26ONPkQikM47qXFIrdlGVJ4RCigGYaPpY8owurAeGE2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755782037; c=relaxed/simple;
	bh=6h4PscvxNqafL2iDhMLLEtrYUEmzx7ivJsKaxJKuD3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzIB3dEz9vj2VHUd/rHWLGLyOgZz0tOTpoLBu+pTbGZUv4xwVJ8AmO6UuCZqO7q+lXslYkD884LwUxvA7hDIc46ZITi8UE9vqd/Ay/Px9ggTRBUlkez/MEuq2m6OSg/o7RrVU8+vRZJQTJfuJ2uaRELSiysddihgDljA/fQlC+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E3F8152B;
	Thu, 21 Aug 2025 06:13:47 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D9EFC3F58B;
	Thu, 21 Aug 2025 06:13:53 -0700 (PDT)
Message-ID: <95819606-ef3b-46e1-8201-1abf0219659f@arm.com>
Date: Thu, 21 Aug 2025 14:13:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] KVM: arm64: Handle RASv1p1 registers
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>
References: <20250817202158.395078-1-maz@kernel.org>
 <20250817202158.395078-3-maz@kernel.org>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <20250817202158.395078-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 8/17/25 21:21, Marc Zyngier wrote:
> FEAT_RASv1p1 system registeres are not handled at all so far.
> KVM will give an embarassed warning on the console and inject
s/embarassed/embarrassed/

> an UNDEF, despite RASv1p1 being exposed to the guest on suitable HW.
> 
> Handle these registers similarly to FEAT_RAS, with the added fun
> that there are *two* way to indicate the presence of FEAT_RASv1p1.
> 
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 82ffb3b3b3cf7..feb1a7a708e25 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2697,6 +2697,18 @@ static bool access_ras(struct kvm_vcpu *vcpu,
>   	struct kvm *kvm = vcpu->kvm;
>   
>   	switch(reg_to_encoding(r)) {
> +	case SYS_ERXPFGCDN_EL1:
> +	case SYS_ERXPFGCTL_EL1:
> +	case SYS_ERXPFGF_EL1:
> +	case SYS_ERXMISC2_EL1:
> +	case SYS_ERXMISC3_EL1:
> +		if (!(kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1) ||
> +		      (kvm_has_feat_enum(kvm, ID_AA64PFR0_EL1, RAS, IMP) &&
> +		       kvm_has_feat(kvm, ID_AA64PFR1_EL1, RAS_frac, RASv1p1)))) {
> +			kvm_inject_undefined(vcpu);
> +			return false;
> +		}
> +		break;
>   	default:
>   		if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
>   			kvm_inject_undefined(vcpu);
The default condition needs updating for the case when 
ID_AA64PFR0_EL1.RAS = b10 otherwise access to the non-v1 specific RAS 
registers will result in an UNDEF being injected.

> @@ -3063,8 +3075,13 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	{ SYS_DESC(SYS_ERXCTLR_EL1), access_ras },
>   	{ SYS_DESC(SYS_ERXSTATUS_EL1), access_ras },
>   	{ SYS_DESC(SYS_ERXADDR_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXPFGF_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXPFGCTL_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXPFGCDN_EL1), access_ras },
>   	{ SYS_DESC(SYS_ERXMISC0_EL1), access_ras },
>   	{ SYS_DESC(SYS_ERXMISC1_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXMISC2_EL1), access_ras },
> +	{ SYS_DESC(SYS_ERXMISC3_EL1), access_ras },
>   
>   	MTE_REG(TFSR_EL1),
>   	MTE_REG(TFSRE0_EL1),

-- 
Thanks,

Ben

