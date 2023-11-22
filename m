Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BB72136A
	for <kvmarm@lists.linux.dev>; Wed, 22 Nov 2023 09:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F90F1595;
	Wed, 22 Nov 2023 01:17:33 -0800 (PST)
Received: from [10.57.42.32] (unknown [10.57.42.32])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E498B3F73F;
	Wed, 22 Nov 2023 01:16:44 -0800 (PST)
Message-ID: <8a173f26-9c88-4619-9d71-0c7625bc2129@arm.com>
Date: Wed, 22 Nov 2023 09:16:44 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/13] arm64: cpufeature: Correctly display signed
 override values
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20231120123721.851738-1-maz@kernel.org>
 <20231120123721.851738-4-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231120123721.851738-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/11/2023 12:37, Marc Zyngier wrote:
> When a field gets overriden, the kernel indicates the result of
> the override in dmesg. This works well with unsigned fields, but
> results in a pretty ugly output when the field is signed.
> 
> Truncate the field to its width before displaying it.
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arch/arm64/kernel/cpufeature.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index e52d2c2b757f..767a6f288755 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -950,7 +950,8 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
>   				pr_warn("%s[%d:%d]: %s to %llx\n",
>   					reg->name,
>   					ftrp->shift + ftrp->width - 1,
> -					ftrp->shift, str, tmp);
> +					ftrp->shift, str,
> +					tmp & (BIT(ftrp->width) - 1));
>   		} else if ((ftr_mask & reg->override->val) == ftr_mask) {
>   			reg->override->val &= ~ftr_mask;
>   			pr_warn("%s[%d:%d]: impossible override, ignored\n",

