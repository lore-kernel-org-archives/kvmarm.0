Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9DC642073
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 493231042;
	Wed, 22 Nov 2023 10:02:14 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 189433F73F;
	Wed, 22 Nov 2023 10:01:25 -0800 (PST)
Message-ID: <82117d83-95a8-47ae-96b3-9f44732489b1@arm.com>
Date: Wed, 22 Nov 2023 18:01:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/13] KVM: arm64: Expose ID_AA64MMFR4_EL1 to guests
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-13-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-13-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> We can now expose ID_AA64MMFR4_EL1 to guests, and let NV guests
> understand that they cannot really switch HCR_EL2.E2H to 0 on
> some platforms.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arch/arm64/kvm/nested.c   | 4 ++++
>   arch/arm64/kvm/sys_regs.c | 2 +-
>   2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 042695a210ce..3885f1c93979 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -137,6 +137,10 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>   		val |= FIELD_PREP(NV_FTR(MMFR2, TTL), 0b0001);
>   		break;
>   
> +	case SYS_ID_AA64MMFR4_EL1:
> +		val &= NV_FTR(MMFR4, E2H0);
> +		break;
> +
>   	case SYS_ID_AA64DFR0_EL1:
>   		/* Only limited support for PMU, Debug, BPs and WPs */
>   		val &= (NV_FTR(DFR0, PMUVer)	|
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9f76f24b96f8..ff2e66f0bda1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2197,7 +2197,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   					ID_AA64MMFR2_EL1_NV |
>   					ID_AA64MMFR2_EL1_CCIDX)),
>   	ID_SANITISED(ID_AA64MMFR3_EL1),
> -	ID_UNALLOCATED(7,4),
> +	ID_SANITISED(ID_AA64MMFR4_EL1),
>   	ID_UNALLOCATED(7,5),
>   	ID_UNALLOCATED(7,6),
>   	ID_UNALLOCATED(7,7),

