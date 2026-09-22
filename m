Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8DF417BE5;
	Tue, 22 Sep 2026 08:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065019; cv=none; b=AhA5GX2hHJYkLcawUnDepwhAmHXSQccSMuT6K2UX3zVv553l11pkyv7x8dCvk2y5jpqlYFne7KwBQGtfKo+96AcbIuUX1yC7r1PAUtcg+SyTlOol6BX3HMGShbAqdV0NWFWpW+1x3T/TqOpSiiWPEHOQHdxMhkEKUSmyHcTQ2/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065019; c=relaxed/simple;
	bh=4HbwZEfa+cRQWF9f/+A2Lw6siv1Umc8ka3GRgBT5ZFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kSRbv8Pzh1t2ucFlt6Iov9T5tKQvb/0ZjzKPhnTbZ715YqxG9QJOHAtyzBR/RlQ3kVQHCAuPpBWEBcYwjr/968KyYtcWUUwJwZJTM4tEpR/QOBwBEBUO2K1F8MWG6/XZKDrLFcp9D7ASv9nBzQZGIQsAcMObdEWn3NrjEbVyFxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gsyPGIOz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gsyPGIOz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD6ED1576;
	Tue, 22 Sep 2026 01:16:52 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0DD83F632;
	Tue, 22 Sep 2026 01:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790065016; bh=4HbwZEfa+cRQWF9f/+A2Lw6siv1Umc8ka3GRgBT5ZFY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gsyPGIOzdWO+7ye4dvf4hgM8YlaXqCY8aW4qTmiRM4liCZm/4j7epoLXFMjUuyYgq
	 22WHSurfxTtl16xdShGOI671c4pDflaXqa3NWYCEcvA9GEWQUsd9G7fGYZt/KyixOz
	 Au29k3hFlPbdtvH21rGaxqyuBdOyF7JuWcqA4Fnk=
Message-ID: <beee950f-0659-43dd-9c5e-0a51722ea54a@arm.com>
Date: Tue, 22 Sep 2026 09:16:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <aqrGPK0lFBFXL2qY@arm.com> <985520fa-99b0-4620-bfee-8e6321b36104@arm.com>
 <aqvCwM_73qMpqzvV@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aqvCwM_73qMpqzvV@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17/09/2026 11:36, Catalin Marinas wrote:
> Hi Suzuki,
> 
> On Thu, Sep 17, 2026 at 10:03:14AM +0100, Suzuki K Poulose wrote:
>> On 16/09/2026 17:39, Catalin Marinas wrote:
>>> On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
>>>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>>>> index 75c3e463df2ef..dc3a87902a60c 100644
>>>> --- a/arch/arm64/mm/fault.c
>>>> +++ b/arch/arm64/mm/fault.c
>>>> @@ -914,6 +914,24 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>>>>    	return 0;
>>>>    }
>>>> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
>>>> +{
>>>> +	const struct fault_info *inf = esr_to_fault_info(esr);
>>>> +	unsigned long addr = untagged_addr(far);
>>>> +
>>>> +	die_kernel_fault(inf->name, addr, esr, regs);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
>>>> +{
>>>> +	if (!user_mode(regs) && !is_el1_instruction_abort(esr) &&
>>>> +	    fixup_exception(regs, esr))
>>>> +		return 0;
>>>> +
>>>> +	return 1;
>>>> +}
>>>
>>> We discussed briefly offline. With the latest patches around, would we
>>> ever end up with private memory mapped in the VMM and hence the GPF? If
>>> not, I would still keep this handling but add a
>>> WARN_ON_ONCE(user_mode(regs)).
>>>
>>> However, can we end up delegating a non-guest_memfd memslot page as
>>> protected?
>>>
>>> I played a bit with codex and it reckons it's possible if a guest_memfd
>>> memslot is deleted after its IPA range has been initialised with
>>> RIPAS=RAM. Removing the memslot unmaps and undelegates any data pages
>>> but leaves the RMM state as RAM. The VMM can then install an ordinary
>>> memslot over the same GPA range.
>>
>> This should be prevented by the following predicates:
>>
>> 1) Realms only support guest_memfd backed memslots for mappable memory.
>> 2) Memslots cannot be created after the Realm is created, as is with the
>> protected VMs. (This check seems to have been lost over the iterations,
>>   but should be reinstated).
> 
> If that's the intended model, I think it should work. But v18 doesn't
> enforce either of them. I noticed the second predicate for pKVM only -
> your 'Widen the scope of "protected" VMs' patch makes this restriction
> explicit to pKVM.

Yes, like I said, that seems to have lost. I will put that back in. This
is not in the v18/v19, but will add it for the next iteration.

> 
> For the first one, if !kvm_slot_has_gmem(), it simply continues with the
> registration.
> 
>>> A subsequent private-IPA S2 fault sees the non-guest_memfd slot, takes
>>> user_mem_abort(), GUPs the user page and passes it to
>>> realm_map_protected(). The userspace mapping remains present, so a later
>>> EL0 access can generate a GPF.
>>
>> The Realm mem abort code should prevent this by ensuring that the
>> memslot is backed by gmem for private_faults. With the mandate of
>> in-place conversion, even the shared pages must come from the
>> gmem backed memslots.
> 
> IIUC this only works if the memslot is gmem but I can't see what
> prevents ordinary slots from being assigned to realms. I think we can
> enter the user_mem_abort() -> realm_map_ipa() for ordinary slots unless
> we prevent the deletion of the original slots and enforce gmem only
> slots early.

Correct. For CCA, we can mandate that the private faults are only
faulted in from gmem memslots or the "trusted device private" memslots
when we eventually get the DA support.

I will address this for v20 of the integration series

Cheers
Suzuki



> 

