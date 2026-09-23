Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAA8581241;
	Wed, 23 Sep 2026 22:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202896; cv=none; b=uFJTK4Cymbj3w5aq9uk7+k6WfIn6i9PUA+3Y0XPe9ERlBA3k7EauGEI//45alz731aBJgwraQIK/H8f0OT9EDfeeTEpbqpIvS66RG57/zVv0SJXuKtMPHr2ES3mmdakT8xDWPDc2TJzqOoauh0San0GsTFp/p1xVIrT5rmnmmXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202896; c=relaxed/simple;
	bh=e+cOxOOR7KeNTZdDG5EoT2YT7Z8uj3tv81dEWnLqxQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M1oy0DWnqPGU4Tab/2CMxb7OZXgolyObN9/2mru6v/35y9mqJRb55apXiFKMuw4O5gtoOdYsTWKeCfD00SkwgDBGdJDDepzi+y66em0BsVCwWbOkWKJOm0eB2PPzGy1r127H+QKG2K+h8oMzhfzmZJSluHt8AGA6pi4RR2ay3eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KvsswqJT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KvsswqJT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4783C152B;
	Wed, 23 Sep 2026 15:34:48 -0700 (PDT)
Received: from [10.57.8.94] (unknown [10.57.8.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCDA23F632;
	Wed, 23 Sep 2026 15:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790202891; bh=e+cOxOOR7KeNTZdDG5EoT2YT7Z8uj3tv81dEWnLqxQY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KvsswqJTKoAouUyBTgte07ttJiGhLx7UEhKgBCQUl8AKuWIqgaS50y5r+1wZsvLfL
	 PXiIgVDcVatXU14yZqH0uMrkLNul/b3Q0PXLMFXeb+rp99Enz2WFzuun0j2T37BLpI
	 QoIRq58cDg5rRujzsuaS+8eMLq1WWgth4j4SEfEI=
Message-ID: <eabbb060-9e99-432d-ac51-7470a7e8e7e9@arm.com>
Date: Wed, 23 Sep 2026 23:34:43 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
Content-Language: en-GB
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-2-suzuki.poulose@arm.com>
 <178978126540.2352296.16845657485139032765.b4-review@b4>
 <d7ccaf22-5bde-4344-8bf0-a5a17dcac0f3@arm.com>
 <45fb9520-7003-412f-9ab1-14e2a762c816@arm.com>
 <20260921142716.000073f8@oss.qualcomm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260921142716.000073f8@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/09/2026 22:27, Jonathan Cameron wrote:
> On Mon, 21 Sep 2026 11:02:56 +0100
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
>> On 21/09/2026 10:27, Suzuki K Poulose wrote:
>>> On 19/09/2026 02:27, Jonathan Cameron wrote:
>>>>> The RMM (Realm Management Monitor) provides functionality that can be
>>>>> accessed by SMC calls from the host.
>>>>>
>>>>> The SMC definitions are based on DEN0137[1] version 2.0-bet3
>>>>>
>>>>> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
>>>>>
>>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>
>>>> With Gavin's nitpicks and the GENMASK_ULL() from sashiko, just a few
>>>> comments inline.  Mostly on subtle inconsistencies that really don't
>>>> matter that much.
>>>>   
>>>>>    include/linux/arm-smccc-rmi.h | 497 ++++++++++++++++++++++++++++++++++
>>>>>    1 file changed, 497 insertions(+)
>>>>>    create mode 100644 include/linux/arm-smccc-rmi.h
>>>>>
>>>>> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-
>>>>> rmi.h
>>>>> new file mode 100644
>>>>> index 000000000000..214d6228dfc2
>>>>> --- /dev/null
>>>>> +++ b/include/linux/arm-smccc-rmi.h
>>>>> @@ -0,0 +1,497 @@
>>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>>> +/*
>>>>> + * Copyright (C) 2023-2026 ARM Ltd.
>>>>> + *
>>>>> + * The values and structures in this file are from the Realm
>>>>> Management Monitor
>>>>> + * specification (DEN0137) version 2.0-bet3:
>>>>> + * https://developer.arm.com/documentation/den0137/2-0bet3/
>>>>> + */
>>>>> +
>>>>> +#ifndef __LINUX_ARM_SMCCC_RMI_H_
>>>>> +#define __LINUX_ARM_SMCCC_RMI_H_
>>>>> +
>>>>> +#include <linux/arm-smccc.h>
>>>>> +#include <linux/bitfield.h>
>>>>> +#include <linux/bits.h>
>>>>> +#include <linux/build_bug.h>
>>>>> +#include <linux/sizes.h>
>>>>> +
>>>>> +#include <asm/page.h>
>>>>> +
>>>>> +#define SMC_RMI_CALL(func)                \
>>>>> +    ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,        \
>>>>> +               ARM_SMCCC_SMC_64,        \
>>>>> +               ARM_SMCCC_OWNER_STANDARD,    \
>>>>> +               (func))
>>>>
>>>> Obviously it is v18 so probably a future thing but nothing about this
>>>> is RMI specific.  Could be used for ARM_SMCCC_TRNG_RND64 for instance.
>>>> I'm not entirely sure what we'd call such a macro
>>>>
>>>> ARM_SMCCC_CALL_VAL64_STD() maybe?
>>>
>>> ARM_SMCCC_STD_CALL64_VAL() ?
>>>
>>> But, I would leave it as a wider cleanup in the tree as a separate
>>> series.
>>>    
>>>>
>>>> I'm not just not keen on macros whose names to me hint at something
>>>> special. FWIW this also matches SMC_RSI_FID() and FFA_SMC64().
>>>> Isn't it nice when we have a predictable naming scheme :)
>>>>
>>>> FID (for Function IDentifier) is in the spec, so maybe?
>>>>
>>>> Anyhow, I don't really care that much.
>>>>   
>>>>> +
>>>>> +#define SMC_RMI_VERSION                SMC_RMI_CALL(0x0150)
>>>>> +
>>>>
>>>>   
>>>>> +#define RMI_ABI_MAJOR_VERSION    2
>>>>> +#define RMI_ABI_MINOR_VERSION    0
>>>>> +
>>>>> +#define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)
>>>>
>>>> I'd mask it.  Mostly because that would shout that it is only 15 bits.
>>>>   
>>>
>>> Ack
>>>    
>>>>> +#define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
>>>>> +#define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))
>>>>
>>>> I'd go all in on FIELD_PREP() / FIELD_GET() + GENMASK just for the
>>>> sake of consistency + not having to be careful that everything is
>>>> checked for fit to keep the LLM bots happy.
>>>>   
>>>>> +
>>>>> +#define RMI_RETURN_STATUS_MASK        GENMASK(7, 0)
>>>>> +#define RMI_RETURN_INDEX_MASK        GENMASK(15, 8)
>>>>> +#define RMI_RETURN_MEMREQ_MASK        GENMASK(9, 8)
>>>>> +#define RMI_RETURN_CAN_CANCEL_MASK    BIT(10)
>>>>> +
>>>>> +#define RMI_RETURN_STATUS(ret)
>>>>> FIELD_GET(RMI_RETURN_STATUS_MASK, ret)
>>>>> +#define RMI_RETURN_INDEX(ret)
>>>>> FIELD_GET(RMI_RETURN_INDEX_MASK, ret)
>>>>
>>>> What's this one?  I can't find anything in the spec that matches it
>>>> and as far as I can tell you don't use it in this series.
>>>
>>> This is coming from RmiResultDataLevel. See RmiResult type.
>>> This was renamed after we introduce the RmiResultDataIncomplete.
>>> It is used in the KVM code to find the "level" where a command
>>> failed/walked.
>>>
>>> I could rename it to RMI_RESULT_DATA_LEVEL() ?
>>> Similarly RMI_RESULT_STATUS instead of RMI_RETURN_*
>>>    
>>>>   
>>>>> +#define RMI_RETURN_MEMREQ(ret)
>>>>> FIELD_GET(RMI_RETURN_MEMREQ_MASK, ret)
>>>>> +#define RMI_RETURN_CAN_CANCEL(ret)
>>>>> FIELD_GET(RMI_RETURN_CAN_CANCEL_MASK, ret)
>>>    
>>>> These are obscure enough to find in the spec I'd give a comment just
>>>> to save the sanity of anyone looking for them.
>>>
>>> As above, they are really RMI_RESULT_DATA_INCOMPLETE_*
>>>    
>>>>   
>>>>> +/*
>>>>> + * Note many of these fields are smaller than u64 but all fields
>>>>> have u64
>>>>> + * alignment, so use u64 to ensure correct alignment.
>>>>
>>>> Obviously this is only going to run on arm64 so it's not critical, but
>>>> more generally u64s aren't always 64 bit aligned.  So if you 'really'
>>>> care aligned_u64 is there to ensure it.  Meh, arm64 so fine.
>>>
>>> Agreed, I am worried about the churn in the consumer code. Also, like
>>> you said, this is only for ARM64. So, I would pass it.
>>>    
>>>>   
>>>>> + */
>>>>> +struct rmm_config {
>>>>> +    union { /* 0x0 */
>>>>> +        struct {
>>>>> +            u64 tracking_region_size;
>>>>> +            u64 rmi_granule_size;
>>>>> +        };
>>>>> +        u8 sizer[SZ_4K];
>>>>> +    };
>>>>> +};
>>>>> +
>>>>> +static_assert(sizeof(struct rmm_config) == SZ_4K);
>>>>> +
>>>>> +#define RMI_REALM_PARAM_FLAG_SVE        BIT(1)
>>>>> +#define RMI_REALM_PARAM_FLAG_PMU        BIT(2)
>>>>> +#define RMI_REALM_PARAM_FLAG_DA            BIT(3)
>>>>> +#define RMI_REALM_PARAM_FLAG_LFA_POLICY        GENMASK(6, 5)
>>>>> +#define RMI_REALM_PARAM_FLAG_MEC_POLICY        GENMASK(8, 7)
>>>>
>>>> Tiny bit inconsistent. When do you decide _MASK is needed and when
>>>> not?  Seems a little too random for multibit fields.
>>>
>>> I will try to clean this up.
>>
>> Actually, this is used when we don't consume them from RMM. i.e.,
>> we never call FIELD_GET() on them. But thats not a reason for
>> not being consistent in naming. I can fix it
> 
> Too obscure for me!  So if not too painful cleaner to just fix it.

Sorry, forgot to add that, I fixed them to _MASK

Cheers
Suzuki

> 
> Jonathan
> 
>>
>> Cheers
>> Suzuki
>>
>>
> 

