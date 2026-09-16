Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CAC74F4758;
	Wed, 16 Sep 2026 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575166; cv=none; b=pgHs/ho6eXfofjJlz0vw22ZwShAyVoATpr5KnrDTzUVhwNDuBkfRICNl89k5yGIMOU01opcg/CrYJ9//vuv3spYGFzI/E47FD7CzHr0e15ldE5x9VNu0il/f8+M2SN+hZza3cWjV36lSP+JwYKQBvyQprUW3NAkuf+jX/Lo/1D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575166; c=relaxed/simple;
	bh=pjaVQE4akQZgPjv1LnRO5574aqN1CfXUHpF8mOqhjAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lN/FsLXcpsM0LVUORdN4Mo7XBtYz7yBYOioLBY3JPc3liLbv+chuxnbbUVzOhzYF0ZRUV2Pmb/6ITGdqpQ8fvusw2NAYj+7J6mJcRQq8vSGgbQdXKzK9sHPdaRvWdop8AIt9J4NjCLc+1Yw6FOHYfDnyrQn2JYSlxZCY20GMiFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xuc9obhN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xuc9obhN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42F181516;
	Wed, 16 Sep 2026 09:12:40 -0700 (PDT)
Received: from [10.57.8.14] (unknown [10.57.8.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E18BA3F7B4;
	Wed, 16 Sep 2026 09:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789575163; bh=pjaVQE4akQZgPjv1LnRO5574aqN1CfXUHpF8mOqhjAU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xuc9obhNrSIabA/7M5zQDGoh4O2ASYpT/smQ4VjKwml4m07SIHobscgQCxC2k6LpI
	 308ACacyVJyF8LdHu7EHtP25hHwUBTIfqlZnmHXp20MrWQBbU3S6er1INvrrjFJZIc
	 JyWW3qrOKmhE9ebSEg4lvhZVY/TJl2jndtzddHi8=
Message-ID: <73c921bb-9897-481d-bcb2-ef9b578a7c9f@arm.com>
Date: Wed, 16 Sep 2026 17:12:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 8/9] arm64: realm: Add RHI helper to query IPA state
 change alignment
Content-Language: en-GB
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Marc Zyngier <maz@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
 <20260904103452.1197239-9-aneesh.kumar@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260904103452.1197239-9-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/09/2026 11:34, Aneesh Kumar K.V (Arm) wrote:
> Arm CCA guests need to know the granularity at which the host expects IPA
> state changes to be performed. This can be larger than the guest page size
> and is needed when deciding the alignment for memory shared with the host.
> 
> Add the Realm Host Interface host configuration definitions and an
> get_ipa_state_change_alignment() helper. The helper uses RSI_HOST_CALL to
> query the supported HostConf version and features, reads the IPA change
> alignment when available, and falls back to PAGE_SIZE if the interface is
> unavailable or returns an invalid value.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

It may be worth mentioning the document number and may be the link
for RHI spec.

e.g., The Realm Host Interface specification Arm DEN00148 defines ...



> ---
>   drivers/firmware/arm_rmm/rsi.c | 46 ++++++++++++++++++++++++++++++++++
>   include/linux/arm-rsi-cmds.h   | 10 ++++++++
>   include/linux/arm-smccc-rhi.h  | 25 ++++++++++++++++++
>   include/linux/arm-smccc-rsi.h  |  7 ++++++
>   4 files changed, 88 insertions(+)
>   create mode 100644 include/linux/arm-smccc-rhi.h
> 
> diff --git a/drivers/firmware/arm_rmm/rsi.c b/drivers/firmware/arm_rmm/rsi.c
> index 52f40256bd78..2cd53f82432f 100644
> --- a/drivers/firmware/arm_rmm/rsi.c
> +++ b/drivers/firmware/arm_rmm/rsi.c
> @@ -9,6 +9,7 @@
>   #include <linux/swiotlb.h>
>   #include <linux/platform_device.h>
>   #include <linux/arm-rsi-cmds.h>
> +#include <linux/arm-smccc-rhi.h>
>   #include <linux/kobject.h>
>   #include <linux/sysfs.h>
>   
> @@ -164,6 +165,51 @@ static int realm_register_memory_enc_ops(void)
>   	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
>   }
>   
> +/* we need an aligned struct for rsi_host_call. slab is not yet ready */
> +static struct rsi_host_call hostconf_call __initdata;
> +static unsigned long __maybe_unused __init get_ipa_state_change_alignment(void)
> +{
> +	long ret;
> +	unsigned long shared_granule_size;
> +
> +	hostconf_call.imm = 0;
> +	hostconf_call.gprs[0] = RHI_HOSTCONF_VERSION;

Do we need to 0 out the other GPRs for RES0 arguments ?

> +	ret = rsi_host_call(lm_alias(&hostconf_call));
> +	if (ret != RSI_SUCCESS)
> +		goto err_out;
> +
> +	if (hostconf_call.gprs[0] != RHI_HOSTCONF_VER_1_0)
> +		goto err_out;
> +
> +	hostconf_call.imm = 0;
> +	hostconf_call.gprs[0] = RHI_HOSTCONF_FEATURES;

Same here, especially gprs[] could be overwritten by the results from
the Host for the previous call.


> +	ret = rsi_host_call(lm_alias(&hostconf_call));
> +	if (ret != RSI_SUCCESS)
> +		goto err_out;
> +
> +	if (!(hostconf_call.gprs[0] & __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT))
> +		goto err_out;
> +
> +	hostconf_call.imm = 0;
> +	hostconf_call.gprs[0] = RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT;
> +	ret = rsi_host_call(lm_alias(&hostconf_call));

minor nit: This patterns keep repeating. May be we could define a macro 
or something to make it cleaner ?

> +	if (ret != RSI_SUCCESS)
> +		goto err_out;
> +
> +	shared_granule_size = hostconf_call.gprs[0];
> +	if (shared_granule_size & (SZ_4K - 1) ||
> +	    !is_power_of_2(shared_granule_size))
> +		goto err_out;
> +
> +	return max(PAGE_SIZE, shared_granule_size);
> +err_out:
> +	/*
> +	 * For failure condition assume host is built with 4K page size
> +	 * and hence IPA state change alignment can be guest PAGE_SIZE.
> +	 */
> +	return PAGE_SIZE;
> +}
> +
>   void __init arm64_rsi_init(void)
>   {
>   	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
> diff --git a/include/linux/arm-rsi-cmds.h b/include/linux/arm-rsi-cmds.h
> index 3f7a6a833993..996f1621b996 100644
> --- a/include/linux/arm-rsi-cmds.h
> +++ b/include/linux/arm-rsi-cmds.h
> @@ -236,4 +236,14 @@ static inline unsigned long rsi_attestation_token_continue(phys_addr_t granule,
>   	return res.a0;
>   }
>   
> +static inline unsigned long rsi_host_call(struct rsi_host_call *rhi_call)
> +{
> +	phys_addr_t addr = virt_to_phys(rhi_call);
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RSI_HOST_CALL, addr, &res);
> +
> +	return res.a0;
> +}
> +
>   #endif /* __LINUX_ARM_RSI_CMDS_H_ */
> diff --git a/include/linux/arm-smccc-rhi.h b/include/linux/arm-smccc-rhi.h
> new file mode 100644
> index 000000000000..91a29996d72d
> --- /dev/null
> +++ b/include/linux/arm-smccc-rhi.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2026 ARM Ltd.
> + */
> +
> +#ifndef __LINUX_ARM_SMCCC_RHI_H_
> +#define __LINUX_ARM_SMCCC_RHI_H_
> +
> +#include <linux/arm-smccc.h>
> +
> +#define SMC_RHI_CALL(func)				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
> +			   ARM_SMCCC_SMC_64,		\
> +			   ARM_SMCCC_OWNER_STANDARD_HYP,\
> +			   (func))
> +
> +#define RHI_HOSTCONF_VER_1_0		0x10000
> +#define RHI_HOSTCONF_VERSION		SMC_RHI_CALL(0x004E)
> +
> +#define __RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT BIT(0)

minor nit: Could this be:

RHI_HOSTCONF_FEATURE_GET_IPA_CHANGE_ALIGNMENT	BIT(0)

to indicate this applies to the RHI_HOSTCONF_FEATURES output ?

> +#define RHI_HOSTCONF_FEATURES		SMC_RHI_CALL(0x004F)
> +
> +#define RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT	SMC_RHI_CALL(0x0050)

Cheers
Suzuki

> +
> +#endif /* __LINUX_ARM_SMCCC_RHI_H_ */
> diff --git a/include/linux/arm-smccc-rsi.h b/include/linux/arm-smccc-rsi.h
> index fddb77986f70..3532a3f08f4e 100644
> --- a/include/linux/arm-smccc-rsi.h
> +++ b/include/linux/arm-smccc-rsi.h
> @@ -182,6 +182,13 @@ struct realm_config {
>    */
>   #define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
>   
> +struct rsi_host_call {
> +	union {
> +		u16 imm;
> +		u64 padding0;
> +	};
> +	u64 gprs[31];
> +} __aligned(0x100);
>   /*
>    * Make a Host call.
>    *

