Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F26921DE3C1
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744714679; cv=none; b=hbpIIzWfdsjgo/W4wq0bRsa8cs1P1isDlRwxVgW3z86/nnG/MSZ40cGaJUrzpAacri+tE8PCbaKrr1WxRot4m9kV1ZMmiqWvD1fRLxDmw+itCnxaU8I46psG723J+e6BYdwmG/FAhD8Sd8o57azHHAfijiCe6m3w9GhgkmoV9b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744714679; c=relaxed/simple;
	bh=236BGQ5I/lIE3n6FcNEcKeltCUL+TkbcW8hfK85y1vU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=je6GQs4LPF1wQIi0YIWpVIbZM2pIgXaz+gcs6xgd5kOKEMwTWUQcfOu7G2dUVJFvhdf/EgU74APFExQWIS+sSgSlRLFM7N42yq00SvB0t7ToG7x8LoKjZ6qT49Jw3jZqp0+Mn1wjd7BKMGwIfwBuvPV2DKsUPN9ChKA6BsAWObI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA31415A1;
	Tue, 15 Apr 2025 03:57:53 -0700 (PDT)
Received: from [10.1.33.173] (e137867.arm.com [10.1.33.173])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 19D503F66E;
	Tue, 15 Apr 2025 03:57:51 -0700 (PDT)
Message-ID: <3d97e45a-23cf-419b-9b6f-140b4d88de7b@arm.com>
Date: Tue, 15 Apr 2025 11:57:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG][PATCH v8 4/6] arm64: Make _midr_in_range_list() an exported
 function
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvmarm@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 cohuck@redhat.com, eric.auger@redhat.com, sebott@redhat.com,
 yuzenghui@huawei.com, wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
 jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
 linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
References: <20250221140229.12588-1-shameerali.kolothum.thodi@huawei.com>
 <20250221140229.12588-5-shameerali.kolothum.thodi@huawei.com>
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Content-Language: en-US
Organization: Arm Ltd.
In-Reply-To: <20250221140229.12588-5-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I discovered that this patch breaks boot for some CPUs when building the 
default defconfig plus KASAN. This is still the case in v6.15-rc1 and rc2.

This patch marks `is_midr_in_range_list` as position independent but it 
isn't, breaking early boot when instrumented with KASAN and 
`CONFIG_RANDOMIZE_BASE` enabled.

The breaking usage seems to be in `kaslr_requires_kpti()` called in 
`early_map_kernel()`.
My testing on an AMD Seattle board does crash, but newer machines 
implementing E0PD do not crash as they do not need to check MIDRs in 
`kaslr_requires_kpti()`.
`is_mdr_in_range_list` did work in PI code previously because it was 
`inline`, which this patch changes.

Best regards,
Ada Couprie Diaz

On 21/02/2025 14:02, Shameer Kolothum wrote:
> Subsequent patch will add target implementation CPU support and that
> will require _midr_in_range_list() to access new data. To avoid
> exporting the data make _midr_in_range_list() a normal function and
> export it.
>
> No functional changes intended.
>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>   arch/arm64/include/asm/cputype.h | 15 +--------------
>   arch/arm64/kernel/cpu_errata.c   | 15 +++++++++++++++
>   arch/arm64/kernel/image-vars.h   |  1 +
>   3 files changed, 17 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index 2a76f0e30006..ccb4a155d118 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -276,20 +276,7 @@ static inline bool midr_is_cpu_model_range(u32 midr, u32 model, u32 rv_min,
>   	return _model == model && rv >= rv_min && rv <= rv_max;
>   }
>   
> -static inline bool is_midr_in_range(struct midr_range const *range)
> -{
> -	return midr_is_cpu_model_range(read_cpuid_id(), range->model,
> -				       range->rv_min, range->rv_max);
> -}
> -
> -static inline bool
> -is_midr_in_range_list(struct midr_range const *ranges)
> -{
> -	while (ranges->model)
> -		if (is_midr_in_range(ranges++))
> -			return true;
> -	return false;
> -}
> +bool is_midr_in_range_list(struct midr_range const *ranges);
>   
>   static inline u64 __attribute_const__ read_cpuid_mpidr(void)
>   {
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 99b55893fc4e..1f51cf6378c5 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -14,6 +14,21 @@
>   #include <asm/kvm_asm.h>
>   #include <asm/smp_plat.h>
>   
> +static inline bool is_midr_in_range(struct midr_range const *range)
> +{
> +	return midr_is_cpu_model_range(read_cpuid_id(), range->model,
> +				       range->rv_min, range->rv_max);
> +}
> +
> +bool is_midr_in_range_list(struct midr_range const *ranges)
> +{
> +	while (ranges->model)
> +		if (is_midr_in_range(ranges++))
> +			return true;
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(is_midr_in_range_list);
> +
>   static bool __maybe_unused
>   __is_affected_midr_range(const struct arm64_cpu_capabilities *entry,
>   			 u32 midr, u32 revidr)
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index ef3a69cc398e..de3d081e5a57 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -49,6 +49,7 @@ PROVIDE(__pi_arm64_sw_feature_override	= arm64_sw_feature_override);
>   PROVIDE(__pi_arm64_use_ng_mappings	= arm64_use_ng_mappings);
>   #ifdef CONFIG_CAVIUM_ERRATUM_27456
>   PROVIDE(__pi_cavium_erratum_27456_cpus	= cavium_erratum_27456_cpus);
> +PROVIDE(__pi_is_midr_in_range_list	= is_midr_in_range_list);
>   #endif
>   PROVIDE(__pi__ctype			= _ctype);
>   PROVIDE(__pi_memstart_offset_seed	= memstart_offset_seed);
