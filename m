Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8CD943E495;
	Wed,  3 Jun 2026 10:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484244; cv=none; b=cr4+prq1nIfNxttRPH63898glaqsEC7OVjBA4puLdq/6p9RY8R3eAW4WaPW02Gq46+jQqQj9ZxkDT5TIo8PY4lA6jmNFWUQ19oSYXA5pI5XRjim4pokcZwBou+33V4zZFWlGiJm1SZv61a2y+wkWBtnmPmVp55yQ1XBnIn99SHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484244; c=relaxed/simple;
	bh=SAgpyeJ2aeueZn4wrvVe1OZsJjrJkzgdYaZDrIyIPiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UG14X9piEBsnJbedIAh4g89YdtLCwJeB0EvCrkxfAgR6nCf5SbZOpD7yAVcSYckQLRxLENw8eKY85QBibgVWHyQh25KzYUTVBGCkpyy9SHM1bWmY8uk2AzZ7GT6NnEaj1bwMidZDqJZuC3ltjcSEixCH78zA2tmiOhOMEFF1PRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tqUpSENx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tqUpSENx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7B2032E4;
	Wed,  3 Jun 2026 03:57:14 -0700 (PDT)
Received: from [10.57.26.22] (unknown [10.57.26.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6CEB3F632;
	Wed,  3 Jun 2026 03:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780484239; bh=SAgpyeJ2aeueZn4wrvVe1OZsJjrJkzgdYaZDrIyIPiU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tqUpSENxeG0SKPwM2auSsdNR2MnbvVMsbBf17PLfnomuvP4sTFKKqtAj/CEsvGOgJ
	 RfzZMYa11Jh1JViWeQcUAS6TO/OdzQuGZzkwU020GsIj0LDzT+2r8LI/OERjrwrLXK
	 ySyuIUrwj2dYafSreRlXmz2QaMx+cMthgy/asKsY=
Message-ID: <f0eddd9f-dbaa-48e9-888d-2e3514395c91@arm.com>
Date: Wed, 3 Jun 2026 11:57:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/44] arm64: RMI: Check for RMI support at init
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-7-steven.price@arm.com>
 <ee494ecd-8979-40f2-896e-82137abbf440@redhat.com>
 <78425c0d-86c5-457f-b171-a4c8dd3acb7d@arm.com>
 <3a0f6277-2b68-45db-a07f-16a177b0586d@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <3a0f6277-2b68-45db-a07f-16a177b0586d@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 25/05/2026 07:58, Gavin Shan wrote:
> Hi Steve,
> 
> On 5/22/26 1:49 AM, Steven Price wrote:
>> On 21/05/2026 01:39, Gavin Shan wrote:
>>> On 5/13/26 11:17 PM, Steven Price wrote:
>>>> Query the RMI version number and check if it is a compatible version.
>>>> The first two feature registers are read and exposed for future code to
>>>> use.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>> v14:
>>>>    * This moves the basic RMI setup into the 'kernel' directory.
>>>> This is
>>>>      because RMI will be used for some features outside of KVM so
>>>> should
>>>>      be available even if KVM isn't compiled in.
>>>> ---
>>>>    arch/arm64/include/asm/rmi_cmds.h |  3 ++
>>>>    arch/arm64/kernel/Makefile        |  2 +-
>>>>    arch/arm64/kernel/cpufeature.c    |  1 +
>>>>    arch/arm64/kernel/rmi.c           | 65 ++++++++++++++++++++++++++
>>>> +++++
>>>>    4 files changed, 70 insertions(+), 1 deletion(-)
>>>>    create mode 100644 arch/arm64/kernel/rmi.c
>>>>
>>>
>>> [...]
>>>
>>>> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>>>> new file mode 100644
>>>> index 000000000000..99c1ccc35c11
>>>> --- /dev/null
>>>> +++ b/arch/arm64/kernel/rmi.c
>>>> @@ -0,0 +1,65 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/*
>>>> + * Copyright (C) 2023-2025 ARM Ltd.
>>>> + */
>>>> +
>>>> +#include <linux/memblock.h>
>>>> +
>>>> +#include <asm/rmi_cmds.h>
>>>> +
>>>> +unsigned long rmm_feat_reg0;
>>>> +unsigned long rmm_feat_reg1;
>>>> +
>>>> +static int rmi_check_version(void)
>>>> +{
>>>> +    struct arm_smccc_res res;
>>>> +    unsigned short version_major, version_minor;
>>>> +    unsigned long host_version =
>>>> RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>>>> +                             RMI_ABI_MINOR_VERSION);
>>>> +    unsigned long aa64pfr0 =
>>>> read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
>>>> +
>>>> +    /* If RME isn't supported, then RMI can't be */
>>>> +    if (cpuid_feature_extract_unsigned_field(aa64pfr0,
>>>> ID_AA64PFR0_EL1_RME_SHIFT) == 0)
>>>> +        return -ENXIO;
>>>> +
>>>> +    arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
>>>> +
>>>> +    if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>>>> +        return -ENXIO;
>>>> +
>>>> +    version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
>>>> +    version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
>>>> +
>>>> +    if (res.a0 != RMI_SUCCESS) {
>>>> +        unsigned short high_version_major, high_version_minor;
>>>> +
>>>> +        high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
>>>> +        high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
>>>> +
>>>> +        pr_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.
>>>> %d\n",
>>>> +               version_major, version_minor,
>>>> +               high_version_major, high_version_minor,
>>>> +               RMI_ABI_MAJOR_VERSION,
>>>> +               RMI_ABI_MINOR_VERSION);
>>>> +        return -ENXIO;
>>>> +    }
>>>> +
>>>> +    pr_info("RMI ABI version %d.%d\n", version_major, version_minor);
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int __init arm64_init_rmi(void)
>>>> +{
>>>> +    /* Continue without realm support if we can't agree on a
>>>> version */
>>>> +    if (rmi_check_version())
>>>> +        return 0;
>>>
>>> Is this still a valid point that we have to return zero on errors
>>> returned
>>> from rmi_check_version() or other other function calls like
>>> rmi_features()?
>>> arm64_init_rmi() is triggered by subsys_initcall() where the return
>>> value
>>> needs to indicate success or failure. It's fine to return error code
>>> from
>>> arm64_init_rmi() in the path.
>>
>> Hmm, I guess now this is moved to arm64 code this indeed doesn't need
>> to. Within a module I believe an error return can fail the module
>> loading.
>>
>> I'm not sure it really makes much difference though - if this
>> initialisation fails then it's not really an error - it just means the
>> feature is unavailable.
>>
> 
> I think the return value would be consistent to the value of
> 'arm64_rmi_is_available'.
> 'arm64_rmi_is_available' is true when zero is returned, otherwise,
> 'arm64_rmi_is_available'
> is false.
> 
> With the consistency between the return value and
> 'arm64_rmi_is_available', users are
> able to know the value of 'arm64_rmi_is_available' through kernel
> parameter 'initcall_debug'.
> With the kernel parameter, the initcalls including arm64_init_rmi() are
> traced and its
> return value is outputted in the traced messages, seeing
> do_trace_initcall_start().

Fair enough, and actually refactoring this function to pass error codes
up the call stack I think does improve the look.

Thanks,
Steve

>> Thanks,
>> Steve
>>
>>>> +
>>>> +    if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
>>>> +        return 0;
>>>> +    if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
>>>> +        return 0;
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +subsys_initcall(arm64_init_rmi);
>>>
> 
> Thanks,
> Gavin
> 

