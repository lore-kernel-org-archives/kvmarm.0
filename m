Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E896376BCF
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 12:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768565582; cv=none; b=nEgFRjx70ygToO0R2r8OltevyZej+xIOWry+LEXbj/+h81y0p3hBcDqiugtbkfNZsxnNmqXqeUvkse5dJAuVZlbdcf0tOT+nsFdwo1EytSuN03EUdIBD4mqG6SuahAYcc2ilO9e7VzimAzTB7KP68lg8j6XuC0I4Enxqq6M9fvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768565582; c=relaxed/simple;
	bh=H9aI2Q83iCkWc6TEmnuF/X6GTYeKiJdRfajHWB2Udu0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=iio3IJf1hwIaRGOwlV5FidgOebQGSe0yZwzm6mXC1lEmQHw498oHrik6vShCHwd6mH/fpifTGfRPnCdAqo9xXwij3bB9YwfSyWcRehahASbB/JD5DDU5IJRqeK+nGbJgFiIBdwezviLVjUwI1P65UJwWsKk8TXFAJVhVOrPUUU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20E041515;
	Fri, 16 Jan 2026 04:12:53 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 012263F694;
	Fri, 16 Jan 2026 04:12:54 -0800 (PST)
Message-ID: <c1dcc2a6-ca11-49e7-b7cd-d2ec70fed7f1@arm.com>
Date: Fri, 16 Jan 2026 12:12:53 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/47] arm_mpam: Use non-atomic bitops when modifying
 feature bitmap
From: Ben Horgan <ben.horgan@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, will@kernel.org,
 corbet@lwn.net, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-3-ben.horgan@arm.com> <aWonpc52-BMzcx8Q@arm.com>
 <b192241e-1b34-4d6c-bbb4-b53cdd98526f@arm.com>
Content-Language: en-US
In-Reply-To: <b192241e-1b34-4d6c-bbb4-b53cdd98526f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/16/26 12:02, Ben Horgan wrote:
> Hi Catalin,
> 
> On 1/16/26 11:57, Catalin Marinas wrote:
>> On Mon, Jan 12, 2026 at 04:58:29PM +0000, Ben Horgan wrote:
>>> In the test__props_mismatch() kunit test we rely on the struct mpam_props
>>> being packed to ensure memcmp doesn't consider packing. Making it packed
>>> reduces the alignment of the features bitmap and so breaks a requirement
>>> for the use of atomics. As we don't rely on the set/clear of these bits
>>> being atomic, just make them non-atomic.
>>>
>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>>> ---
>>> Changes since v2:
>>> Add comment (Jonathan)
>>> ---
>>>  drivers/resctrl/mpam_internal.h | 8 ++++++--
>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
>>> index 17cdc3080d58..e8971842b124 100644
>>> --- a/drivers/resctrl/mpam_internal.h
>>> +++ b/drivers/resctrl/mpam_internal.h
>>> @@ -200,8 +200,12 @@ struct mpam_props {
>>>  } PACKED_FOR_KUNIT;
>>>  
>>>  #define mpam_has_feature(_feat, x)	test_bit(_feat, (x)->features)
>>> -#define mpam_set_feature(_feat, x)	set_bit(_feat, (x)->features)
>>> -#define mpam_clear_feature(_feat, x)	clear_bit(_feat, (x)->features)
>>> +/*
>>> + * The non-atomic get/set operations are used because if struct mpam_props is
>>> + * packed, the alignment requirements for atomics aren't met.
>>> + */
>>> +#define mpam_set_feature(_feat, x)	__set_bit(_feat, (x)->features)
>>> +#define mpam_clear_feature(_feat, x)	__clear_bit(_feat, (x)->features)
>>
>> After discussing privately, I can see how test__props_mismatch() can
>> end up with unaligned atomics on the mmap_props::features array. Happy to
>> pick it up for 6.19 (probably the first patch as well, though that's
>> harmless).
> 
> Yes please.
> 
>>
>> Is there a Fixes tag here for future reference?
>>
> 
> Yes, the mpam_set/clear macros were introduced in

The mpam_set_clear() actually comes after in:
c10ca83a7783 arm_mpam: Merge supported features during mpam_enable() into mpam_class
but I think the fixes below is still the correct one as it is where we could 
first start seeing the problem.
> 
> Fixes: 8c90dc68a5de ("arm_mpam: Probe the hardware features resctrl supports")
> 
> Thanks,
> 
> Ben
> 
> 
 
Thanks,

Ben

