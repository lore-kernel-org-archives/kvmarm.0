Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280541FAC55
	for <kvmarm@lists.linux.dev>; Fri,  3 Jan 2025 16:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735920065; cv=none; b=WQgwxZSOBJHmIqnSe4d0ouLMnzu6oXlMwoNJ3DBnB491yaahIa1ImaXorsmfImSGOg2H6o31c88AGXwniEuFT6/fQ/UUgBsdb57NnnOgU/cs8jMUFYbR/5byZOjRWJT71M0/uPQzvLxG2/huAubThLyaRhjY7UqvT3OecoFbk9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735920065; c=relaxed/simple;
	bh=su6wp7frDyYNNRKa9Oz3fSXkdYJBtcNuwT2iZDdT+3A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gSUdJoA+cergo5stKAieGUcQIg2zG7C4hYHQ0uxP3pD5jqA2odcYmIkCPLna1Iv4nuOdr/3cYARTLLg/BeHmL6rUVD/zAV73tOz46etBUxDgM7JkSmHcz3aH12Hx+N1/IuMVdKx4DTBdkte+Jr1wAGTVJw18dlXPiUf3k0XEiJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6572D1480;
	Fri,  3 Jan 2025 08:01:31 -0800 (PST)
Received: from [10.57.93.14] (unknown [10.57.93.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F4F83F673;
	Fri,  3 Jan 2025 08:01:00 -0800 (PST)
Message-ID: <2a6448f5-a48b-42fd-9589-acdb434f0a8a@arm.com>
Date: Fri, 3 Jan 2025 16:00:59 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND RFC PATCH v1 2/5] arm64: Add BBM Level 2 cpu feature
Content-Language: en-GB
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
 catalin.marinas@arm.com, corbet@lwn.net, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, yangyicong@huawei.com,
 guohanjun@huawei.com, wangkefeng.wang@huawei.com, liaochang1@huawei.com,
 sunnanyong@huawei.com, linuxarm@huawei.com
References: <20241211160218.41404-3-miko.lenczewski@arm.com>
 <87cyhxs3xq.wl-maz@kernel.org> <084c5ada-51af-4c1a-b50a-4401e62ddbd6@arm.com>
 <86ikrprn7w.wl-maz@kernel.org> <2b1cc228-a8d5-4383-ab25-abbbcccd2e2c@arm.com>
 <86h678sy00.wl-maz@kernel.org> <5c551e43-78e9-4336-ab16-b55c0d6c7f92@arm.com>
 <20241219164528.GH24724@willie-the-truck>
 <20250102120704.00002984@huawei.com> <86ed1lpfdh.wl-maz@kernel.org>
 <20250103153512.GD3816@willie-the-truck>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20250103153512.GD3816@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/01/2025 15:35, Will Deacon wrote:
> On Thu, Jan 02, 2025 at 12:30:34PM +0000, Marc Zyngier wrote:
>> On Thu, 02 Jan 2025 12:07:04 +0000,
>> Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
>>> On Thu, 19 Dec 2024 16:45:28 +0000
>>> Will Deacon <will@kernel.org> wrote:
>>>> On Thu, Dec 12, 2024 at 04:03:52PM +0000, Ryan Roberts wrote:
>>>>>>>> If anything, this should absolutely check for FAR_EL1 and assert that
>>>>>>>> this is indeed caused by such change.  
>>>>>>>
>>>>>>> I'm not really sure how we would check this reliably? Without patch 5, the
>>>>>>> problem is somewhat constrained; we could have as many changes in flight as
>>>>>>> there are CPUs so we could keep a list of all the {mm_struct, VA-range} that are
>>>>>>> being modified. But if patch 5 is confirmed to be architecturally sound, then
>>>>>>> there is no "terminating tlbi" so there is no bound on the set of {mm_struct,
>>>>>>> VA-range}'s that could legitimately cause a conflict abort.  
>>>>>>
>>>>>> I didn't mean to imply that we should identify the exact cause of the
>>>>>> abort. I was hoping to simply check that FAR_EL1 reports a userspace
>>>>>> VA. Why wouldn't that work?  
>>>>>
>>>>> Ahh gottya! Yes agreed, this sounds like the right approach.  
>>>>
>>>> Please, can we just not bother handling conflict aborts at all outside of
>>>> KVM? This is all dead code, it's complicated and it doesn't scale to the
>>>> in-kernel use-cases that others want. There's also not been any attempt
>>>> to add the pKVM support for handling host-side conflict aborts from what
>>>> I can tell.
>>>>
>>>> For now, I would suggest limiting this series just to the KVM support
>>>> for handling a broken/malicious guest. If the contpte performance
>>>> improvements are worthwhile (I've asked for data), then let's add support
>>>> for the CPUs that handle the conflict in hardware (I believe this is far
>>>> more common than reporting the abort) so that the in-kernel users can
>>>> benefit whilst keeping the code manageable at the same time.
>>>>
>>>
>>> Given direction the discussion is going in time to raise a hand.
>>>
>>> Huawei has implementations that support BBML2, and might report TLB conflict
>>> abort after changing block size directly until an appropriate TLB invalidation
>>> instruction completes and this Implementation Choice is architecturally compliant.
>>
>> Compliant, absolutely. That's the letter of the spec. The usefulness
>> aspect is, however, more debatable, and this is what Will is pointing
>> out.
>>
>> Dealing with TLB Conflict aborts is an absolute pain if you need
>> to handle it within the same Translation Regime and using the same
>> TTBR as the one that has generated the fault. So at least for the time
>> being, it might be preferable to only worry about the implementations
>> that will promise to never generate such an abort and quietly perform
>> an invalidation behind the kernel's back.
> 
> Agreed. We're not dropping support for CPUs that don't give us what we'd
> like here, we're just not bending over to port and maintain new
> optimisations for them. I think that's a reasonable compromise?
> 
> That said, thanks for raising this, Jonathan. It's a useful data point
> to know that TLB conflict aborts exist in the wild!

Indeed. Just to make it explicit; if we were to support all architecturally
compliant BBML2 implementations, we would need to drop the final patch in this
series. But since it sounds like we will be taking the approach of only allowing
these optimizations for implementations that never raise conflict abort and
handle it all in HW, it should be safe to keep the optimization in that final
patch. I'll work with Miko to get this bashed into shape and reposted.

Thanks,
Ryan

> 
> Will

