Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2BE3B2FDF;
	Mon, 21 Sep 2026 10:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789985669; cv=none; b=HogbSpxBvkMeTShiT3iyjQ/gizh5KtO5qym1VpP6/2dpf73kQn9KTHayb+/Xr0+1i4o8thtDCe0QbAfYdwah4zJ/qU33EYq0GY1mS3C57irplut/AsW8qP/S9rqzSJdFKQLBEOh6OIBptTtiysP9p/56jMY9xFlGNM0y1JTSrBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789985669; c=relaxed/simple;
	bh=X21Q+N08xUOyF31kxvte0qv2v56innxWRBgC11u9YPg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UsQFLCdzhD1iLmxlMacZM+xCcVYrUyrgfTyqfON+xw0acEFj17uqKFFEF31l2OACnLX20xPe/DzObE/AtPeEcZRC4YYpFPv5SGEpD1ppVpwml32C9rsYfd7TDExOu00rwDf6clcO8R+97cZ/vP7TzKME8WifrV1t8BOehjQHPrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bi8wj6lS; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bi8wj6lS"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7ED0A1CE0;
	Mon, 21 Sep 2026 03:14:23 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 173203F86C;
	Mon, 21 Sep 2026 03:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789985667; bh=X21Q+N08xUOyF31kxvte0qv2v56innxWRBgC11u9YPg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=bi8wj6lSXbc+slgPhtQo8H+KMor5M5yzY0r8RQQqFvDPPtgRm0RMutnIRxaToRdTG
	 YWI+Jnobq16nw+PjJSrqSjkJr7INZTwpehy3S8gXoDGcYoHz2kHClYB+y772yLyN7Z
	 EPCugkdEQQwCspBynGN7LkS+G00+KuamtoSo/uq0=
Message-ID: <eb4a30a0-abd2-4334-b5f3-62621ec5a19e@arm.com>
Date: Mon, 21 Sep 2026 11:14:22 +0100
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
From: Suzuki K Poulose <suzuki.poulose@arm.com>
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
In-Reply-To: <d7ccaf22-5bde-4344-8bf0-a5a17dcac0f3@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/09/2026 10:27, Suzuki K Poulose wrote:
> On 19/09/2026 02:27, Jonathan Cameron wrote:
>>> The RMM (Realm Management Monitor) provides functionality that can be
>>> accessed by SMC calls from the host.
>>>
>>> The SMC definitions are based on DEN0137[1] version 2.0-bet3
>>>
>>> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> With Gavin's nitpicks and the GENMASK_ULL() from sashiko, just a few
>> comments inline.  Mostly on subtle inconsistencies that really don't
>> matter that much.
>>
>>>   include/linux/arm-smccc-rmi.h | 497 ++++++++++++++++++++++++++++++++++
>>>   1 file changed, 497 insertions(+)
>>>   create mode 100644 include/linux/arm-smccc-rmi.h
>>>
>>> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc- 
>>> rmi.h
>>> new file mode 100644
>>> index 000000000000..214d6228dfc2
>>> --- /dev/null
>>> +++ b/include/linux/arm-smccc-rmi.h

..

>>> +
>>> +struct rec_exit {
>>> +    union { /* 0x000 */
>>> +        u8 exit_reason;
>>> +        u8 padding0[0x100];

...

>>
>>> +    };
>>> +    union { /* 0x400 */
>>> +        struct {
>>> +            u64 cntp_ctl;
>>> +            u64 cntp_cval;
>>> +            u64 cntv_ctl;
>>> +            u64 cntv_cval;
>>> +        };
>>> +        u8 padding4[0x100];
>>> +    };
>>> +    union { /* 0x500 */
>>> +        struct {
>>> +            u64 ripas_base;
>>> +            u64 ripas_top;
>>> +            u8 ripas_value;
>>> +            u8 padding5[0xf];
>>
>> In various other places you just use a u64 for a u8
>> + padding. Why is this one special? And for that matter
>> various other fields later in this particular structure?
> 
> Please feel free to point out, if you spot any. I am happy
> to fix them.

I took a look and the padding is for extra "u64" bits in there.
e.g, ripas_value offset = 0x510 and the s2ap_base is really at 0x520
not 0x518. Same applies for the pmu_ovf_status and vsmmu.

So, I would leave them as they are. The rest are consistent.
e.g, num_bps and num_wps. in realm_parameter

Cheers
Suzuki


>
