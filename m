Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134D41F4634;
	Thu, 21 May 2026 15:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779378304; cv=none; b=hKNySolSlIoCj17rJWniKt47QCPAttAZ6mBZUAri7jZLSWouIsJQHkODxToQpbT5aGSkW2XHRoDH4XFhnFlgdn1wETY7CPQQuQZn+PU32lsAe71GrD7ogIktKONOF+QZE4NFUOty3YLRSu+NWq+wWqn5gYigpaXW/bb4Pj/4m3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779378304; c=relaxed/simple;
	bh=QF68rTb5Q+J5M5tadzuOVbWRc8TvXFXjwcG27utu4As=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bqx/yZy2ZtPinw5qYskbjBweoQlgjFigZoY65No6wMa/UoX+PmskYQB3LP/M0dl2VC6n0/L6TOJdyYE8cYeZPJacVCBPIZIpLK3PdqJfgrApY+a6MeYpB1aY/pUJ5b+Vtbvo+RIRW6HL4BcT8fo3p4ga7Kccf5fVW/uSm3WUaIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nwnfIIi3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nwnfIIi3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 297A43D42;
	Thu, 21 May 2026 08:44:57 -0700 (PDT)
Received: from [10.1.32.22] (e122027.cambridge.arm.com [10.1.32.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A2D93F632;
	Thu, 21 May 2026 08:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779378302; bh=QF68rTb5Q+J5M5tadzuOVbWRc8TvXFXjwcG27utu4As=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nwnfIIi38PHTdUkuOtqwyuB2KBFbfOgzNq+J/ZusfxI3GaJBwHsQZTOJE/kyJGXd4
	 1WEsuJlB2bfkTFkAJpCRoLj0yhZO0jEDfzYgMHNHfjduUzsCHS5qQXJzWKA4ouj5y1
	 SxI+y2k8OSePhhuZ5ZCDMeMccIfDdesc3sOzjZhE=
Message-ID: <1b577c26-5a59-4786-9c3a-d72847cc0c86@arm.com>
Date: Thu, 21 May 2026 16:44:44 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 05/44] arm64: RMI: Add wrappers for RMI calls
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-6-steven.price@arm.com> <86cxypvsfy.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86cxypvsfy.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/05/2026 13:49, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:13 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The wrappers make the call sites easier to read and deal with the
>> boiler plate of handling the error codes from the RMM.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes from v13:
>>  * Update to RMM v2.0-bet1 spec including some SRO support (there still
>>    some FIXMEs where SRO support is incomplete).
>> Changes from v12:
>>  * Update to RMM v2.0 specification
>> Changes from v8:
>>  * Switch from arm_smccc_1_2_smc() to arm_smccc_1_2_invoke() in
>>    rmi_rtt_read_entry() for consistency.
>> Changes from v7:
>>  * Minor renaming of parameters and updated comments
>> Changes from v5:
>>  * Further improve comments
>> Changes from v4:
>>  * Improve comments
>> Changes from v2:
>>  * Make output arguments optional.
>>  * Mask RIPAS value rmi_rtt_read_entry()
>>  * Drop unused rmi_rtt_get_phys()
>> ---
>>  arch/arm64/include/asm/rmi_cmds.h | 661 ++++++++++++++++++++++++++++++
>>  1 file changed, 661 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>>
>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
>> new file mode 100644
>> index 000000000000..04f7066894e9
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rmi_cmds.h
>> @@ -0,0 +1,661 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#ifndef __ASM_RMI_CMDS_H
>> +#define __ASM_RMI_CMDS_H
>> +
>> +#include <linux/arm-smccc.h>
>> +
>> +#include <asm/rmi_smc.h>
>> +
>> +struct rtt_entry {
>> +	unsigned long walk_level;
>> +	unsigned long desc;
>> +	int state;
>> +	int ripas;
>> +};
>> +
>> +#define RMI_MAX_ADDR_LIST	256
>> +
>> +struct rmi_sro_state {
>> +	struct arm_smccc_1_2_regs regs;
>> +	unsigned long addr_count;
>> +	unsigned long addr_list[RMI_MAX_ADDR_LIST];
>> +};
>> +
>> +#define rmi_smccc(...) do {						\
>> +	arm_smccc_1_1_invoke(__VA_ARGS__);				\
>> +} while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||			\
>> +	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
>> +
>> +unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp);
>> +void rmi_sro_free(struct rmi_sro_state *sro);
>> +
>> +/**
>> + * rmi_rmm_config_set() - Configure the RMM
>> + * @cfg_ptr: PA of a struct rmm_config
>> + *
>> + * Sets configuration options on the RMM.
>> + *
>> + * Return: RMI return code
>> + */
>> +static inline int rmi_rmm_config_set(unsigned long cfg_ptr)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_RMM_CONFIG_SET, cfg_ptr, &res);
>> +
>> +	return res.a0;
>> +}
>> +
>> +/**
>> + * rmi_rmm_activate() - Activate the RMM
>> + *
>> + * Return: RMI return code
>> + */
>> +static inline int rmi_rmm_activate(void)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_RMM_ACTIVATE, &res);
>> +
>> +	return res.a0;
>> +}
>> +
>> +/**
>> + * rmi_granule_tracking_get() - Get configuration of a Granule tracking region
>> + * @start: Base PA of the tracking region
>> + * @end: End of the PA region
>> + * @out_category: Memory category
>> + * @out_state: Tracking region state
>> + * @out_top: Top of the memory region
>> + *
>> + * Return: RMI return code
>> + */
>> +static inline int rmi_granule_tracking_get(unsigned long start,
>> +					   unsigned long end,
>> +					   unsigned long *out_category,
>> +					   unsigned long *out_state,
>> +					   unsigned long *out_top)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_TRACKING_GET, start, end, &res);
>> +
>> +	if (out_category)
>> +		*out_category = res.a1;
>> +	if (out_state)
>> +		*out_state = res.a2;
>> +	if (out_top)
>> +		*out_top = res.a3;
>> +
>> +	return res.a0;
>> +}
>> +
>> +/**
>> + * rmi_gpt_l1_create() - Create a Level 1 GPT
>> + * @addr: Base of physical address region described by the L1GPT
>> + *
>> + * Return: RMI return code
>> + */
>> +static inline int rmi_gpt_l1_create(unsigned long addr)
>> +{
>> +	struct arm_smccc_res res;
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_GPT_L1_CREATE, addr, &res);
>> +
>> +	if (RMI_RETURN_STATUS(res.a0) == RMI_INCOMPLETE) {
>> +		/* FIXME */
> 
> Is that part of the SRO stuff you're talking about in the notes?
> What is the ETA for fixing all these FIXMEs?

Yes, RMI_INCOMPLETE is the return for SRO. Fixing all this up is on the
plan for my next posting which I expect to be after 7.2-rc1 (so July).
There were some changes in the beta 2 spec and the RMM doesn't implement
most of this yet so I didn't want to rush out completely untested code
which might change.

Thanks,
Steve

> Thanks,
> 
> 	M.
> 

