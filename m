Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A0D17C77;
	Mon, 14 Oct 2024 14:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916877; cv=none; b=PO1gKUIDUjr267/h3wATi36PtRVEHecxLKM0+9bXClh3q6jpfYqV2DdxWXqnmsPISsvqdT+EqqOIyPaK3cHXPcm8pPSQLTH51nVkIkIP1M5+oLalGmDuZT7D2VQwQWP/AWgo7ZUbWgXxM5uqydQ7QYEqf/XQFr0fgr+N0DAZdGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916877; c=relaxed/simple;
	bh=DFO1aR4GLZZo4R8pIqMvQlWpP7eE9cLB5QesFzKUEqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zc6b/jg0OGYDqo80oymYsx28BZS4jiDZ7iKSd9Ij+om1Y9iS5EVuFOOBzB4VqY4JwvPvRcPxsUnaLnTLPhwqjlMl8dP4k+uhT1hDf2MAuEUSY4ods6SUZMkYCYHGZRPf8Vh0KAzNuKfxBei/pIqXM47IoZ4aQ7Ojial6CvcvSjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6198F1007;
	Mon, 14 Oct 2024 07:41:44 -0700 (PDT)
Received: from [10.57.21.126] (unknown [10.57.21.126])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD6853F51B;
	Mon, 14 Oct 2024 07:41:09 -0700 (PDT)
Message-ID: <f3ce0718-064d-48e4-a681-7058157127b0@arm.com>
Date: Mon, 14 Oct 2024 15:41:07 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, Dan Williams <dan.j.williams@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-11-steven.price@arm.com>
 <5a3432d1-6a79-434c-bc93-6317c8c6435c@redhat.com>
 <6c306817-fbd7-402c-8425-a4523ed43114@arm.com>
 <7a83461d-40fd-4e61-8833-5dae2abaf82b@arm.com>
 <5999b021-0ae3-4d90-ae29-f18f187fd115@redhat.com>
 <11cff100-3406-4608-9993-c29caf3d086d@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <11cff100-3406-4608-9993-c29caf3d086d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 14/10/2024 09:56, Suzuki K Poulose wrote:
> On 12/10/2024 07:06, Gavin Shan wrote:
>> On 10/12/24 2:22 AM, Suzuki K Poulose wrote:
>>> On 11/10/2024 15:14, Steven Price wrote:
>>>> On 08/10/2024 05:12, Gavin Shan wrote:
>>>>> On 10/5/24 12:43 AM, Steven Price wrote:
>>>>>> From: Sami Mujawar <sami.mujawar@arm.com>
>>>>>>
>>>>>> Introduce an arm-cca-guest driver that registers with
>>>>>> the configfs-tsm module to provide user interfaces for
>>>>>> retrieving an attestation token.
>>>>>>
>>>>>> When a new report is requested the arm-cca-guest driver
>>>>>> invokes the appropriate RSI interfaces to query an
>>>>>> attestation token.
>>>>>>
>>>>>> The steps to retrieve an attestation token are as follows:
>>>>>>     1. Mount the configfs filesystem if not already mounted
>>>>>>        mount -t configfs none /sys/kernel/config
>>>>>>     2. Generate an attestation token
>>>>>>        report=/sys/kernel/config/tsm/report/report0
>>>>>>        mkdir $report
>>>>>>        dd if=/dev/urandom bs=64 count=1 > $report/inblob
>>>>>>        hexdump -C $report/outblob
>>>>>>        rmdir $report
>>>>>>
>>>>>> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
>>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>>>> ---
>>>>>> v3: Minor improvements to comments and adapt to the renaming of
>>>>>> GRANULE_SIZE to RSI_GRANULE_SIZE.
>>>>>> ---
>>>>>>    drivers/virt/coco/Kconfig                     |   2 +
>>>>>>    drivers/virt/coco/Makefile                    |   1 +
>>>>>>    drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>>>>>>    drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>>>>>>    .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211
>>>>>> ++++++++++++ ++++++
>>>>>>    5 files changed, 227 insertions(+)
>>>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>>>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>>>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
>>
>> [...]
>>
>>>>>> +/**
>>>>>> + * arm_cca_report_new - Generate a new attestation token.
>>>>>> + *
>>>>>> + * @report: pointer to the TSM report context information.
>>>>>> + * @data:  pointer to the context specific data for this module.
>>>>>> + *
>>>>>> + * Initialise the attestation token generation using the
>>>>>> challenge data
>>>>>> + * passed in the TSM descriptor. Allocate memory for the attestation
>>>>>> token
>>>>>> + * and schedule calls to retrieve the attestation token on the
>>>>>> same CPU
>>>>>> + * on which the attestation token generation was initialised.
>>>>>> + *
>>>>>> + * The challenge data must be at least 32 bytes and no more than 64
>>>>>> bytes. If
>>>>>> + * less than 64 bytes are provided it will be zero padded to 64
>>>>>> bytes.
>>>>>> + *
>>>>>> + * Return:
>>>>>> + * * %0        - Attestation token generated successfully.
>>>>>> + * * %-EINVAL  - A parameter was not valid.
>>>>>> + * * %-ENOMEM  - Out of memory.
>>>>>> + * * %-EFAULT  - Failed to get IPA for memory page(s).
>>>>>> + * * A negative status code as returned by
>>>>>> smp_call_function_single().
>>>>>> + */
>>>>>> +static int arm_cca_report_new(struct tsm_report *report, void *data)
>>>>>> +{
>>>>>> +    int ret;
>>>>>> +    int cpu;
>>>>>> +    long max_size;
>>>>>> +    unsigned long token_size;
>>>>>> +    struct arm_cca_token_info info;
>>>>>> +    void *buf;
>>>>>> +    u8 *token __free(kvfree) = NULL;
>>>>>> +    struct tsm_desc *desc = &report->desc;
>>>>>> +
>>>>>> +    if (!report)
>>>>>> +        return -EINVAL;
>>>>>> +
>>>>>
>>>>> This check seems unnecessary and can be dropped.
>>>>
>>>> Ack
>>>>
>>>>>> +    if (desc->inblob_len < 32 || desc->inblob_len > 64)
>>>>>> +        return -EINVAL;
>>>>>> +
>>>>>> +    /*
>>>>>> +     * Get a CPU on which the attestation token generation will be
>>>>>> +     * scheduled and initialise the attestation token generation.
>>>>>> +     */
>>>>>> +    cpu = get_cpu();
>>>>>> +    max_size = rsi_attestation_token_init(desc->inblob,
>>>>>> desc->inblob_len);
>>>>>> +    put_cpu();
>>>>>> +
>>>>>
>>>>> It seems that put_cpu() is called early, meaning the CPU can go
>>>>> away before
>>>>> the subsequent call to arm_cca_attestation_continue() ?
>>>>
>>>> Indeed, good spot. I'll move it to the end of the function and update
>>>> the error paths below.
>>>
>>> Actually this was on purpose, not to block the CPU hotplug. The
>>> attestation must be completed on the same CPU.
>>>
>>> We can detect the failure from "smp_call" further down and make sure
>>> we can safely complete the operation or restart it.
>>>
>>
>> Yes, It's fine to call put_cpu() early since we're tolerant to error
>> introduced
>> by CPU unplug. It's a bit confused that rsi_attestation_token_init()
>> is called
>> on the local CPU while arm_cca_attestation_continue() is called on
>> same CPU
>> with help of smp_call_function_single(). Does it make sense to unify
>> so that
>> both will be invoked with the help of smp_call_function_single() ?
>>
>>      int cpu = smp_processor_id();
>>
>>      /*
>>       * The calling and target CPU can be different after the calling
>> process
>>       * is migrated to another different CPU. It's guaranteed the
>> attestatation
>>       * always happen on the target CPU with smp_call_function_single().
>>       */
>>      ret = smp_call_function_single(cpu,
>> rsi_attestation_token_init_wrapper,
>>                                     (void *)&info, true);
> 
> Well, we want to allocate sufficient size buffer (size returned from
> token_init())  outside an atomic context (thus not in smp_call_function()).
> 
> May be we could make this "allocation" restriction in a comment to
> make it clear, why we do it this way.

So if I've followed this correctly the get_cpu() route doesn't work
because of the need to allocate outblob. So using
smp_call_function_single() for all calls seems to be the best approach,
along with a comment explaining what's going on. So how about:

	/*
	 * The attestation token 'init' and 'continue' calls must be
	 * performed on the same CPU. smp_call_function_single() is used
	 * instead of simply calling get_cpu() because of the need to
	 * allocate outblob based on the returned value from the 'init'
	 * call and that cannot be done in an atomic context.
	 */
	cpu = smp_processor_id();

	info.challenge = desc->inblob;
	info.challenge_size = desc->inblob_len;

	ret = smp_call_function_single(cpu, arm_cca_attestation_init,
				       &info, true);
	if (ret)
		return ret;
	max_size = info.result;

(with appropriate updates to the 'info' struct and a new
arm_cca_attestation_init() wrapper for rsi_attestation_token_init()).

Steve

