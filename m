Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3850959220E
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 18:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789066364; cv=none; b=jCNZY41L3akuqILJhVK2PZ9BbKTI1SmUojwTLomH4KzR8zE/MI2NC016aaQtGfi5eyQQzty4Zg0igaQm9b2cmJOIdb50ZiK0yPkoRohzvJMIzLTwtcd21wNYlhOtVddXZSyFHlGwMvJsKDnKkUFG/h6Uh3IGr4anCDEiGCzFMdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789066364; c=relaxed/simple;
	bh=PUqmytCxMyQ0ym4c50gS+GVSG7otnsiTkLudKZJwZFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c+V06F3fI7BAmj0CS3jWJ9sLACThxePpWTh/9zroBz3R6Du0Wbfs0zI5o+3ShU1smkZqfZXF4KUe5dMOPzuaHUpkiCZmY8oBCMlF8UM+YaiYkAdCr/ZpHm+jix1jWi0qKw+41jRndUzWQ/831+mgQ80HwmbH7M1zCRmPi7kuvHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bz0soMG0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bz0soMG0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC7D5237B;
	Thu, 10 Sep 2026 11:52:36 -0700 (PDT)
Received: from [10.57.7.48] (unknown [10.57.7.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 86D6D3F7B4;
	Thu, 10 Sep 2026 11:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789066360; bh=PUqmytCxMyQ0ym4c50gS+GVSG7otnsiTkLudKZJwZFI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Bz0soMG09HJvtLkmBobf5omEFtr8QN+tgX3HtQTv2tYksKKDU+zaetH0QWoNBUjpg
	 6nmUJBAqQY+V1TISan/OWs2czXHaQxyTL4wBwjziWxdNUBlcp8VyC5HOk9NYrEQSob
	 JAToEZ5TagPEj0oZmxgT6hDFosK7Uj4jO7WPOjrk=
Message-ID: <f75e72f7-c508-4153-8e83-74af275a7d8f@arm.com>
Date: Thu, 10 Sep 2026 19:52:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 1/1] arm64: mm: Handle Granule Protection Faults
 (GPFs)
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, will@kernel.org,
 linux-kernel@vger.kernel.org, maz@kernel.org,
 pavan.kondeti@oss.qualcomm.com, tabba@google.com, aneesh.kumar@kernel.org,
 mark.rutland@arm.com, sdonthineni@nvidia.com, steven.price@arm.com,
 gshan@redhat.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev
References: <20260907162204.1479401-1-suzuki.poulose@arm.com>
 <20260907162204.1479401-2-suzuki.poulose@arm.com> <aqLsnngKRbMRu211@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <aqLsnngKRbMRu211@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/09/2026 18:45, Catalin Marinas wrote:
> On Mon, Sep 07, 2026 at 05:22:04PM +0100, Suzuki K Poulose wrote:
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 0b52557652be6..ad00997b1a873 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -910,6 +910,22 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>>   	return 0;
>>   }
>>   
>> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
>> +{
>> +	const struct fault_info *inf = esr_to_fault_info(esr);
>> +
>> +	die_kernel_fault(inf->name, far, esr, regs);
>> +	return 0;
>> +}
>> +
>> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
>> +{
>> +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
>> +		return 0;
>> +
>> +	return 1;
>> +}
> 
> If we end up with a user PC here, we correctly return 1 but only because
> fixup_exception() won't find the PC. I'd rather have this explicit with
> a user_mode() check.

Sure, I have made the condtion to:

+       if (!user_mode(regs) && !is_el1_instruction_abort(esr) &&
+           fixup_exception(regs, esr))
+               return 0;

> 
>> +
>>   static const struct fault_info fault_info[] = {
>>   	{ do_bad,		SIGKILL, SI_KERNEL,	"ttbr address size fault"	},
>>   	{ do_bad,		SIGKILL, SI_KERNEL,	"level 1 address size fault"	},
>> @@ -946,12 +962,12 @@ static const struct fault_info fault_info[] = {
>>   	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 32"			},
>>   	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
>>   	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 34"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 35"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 36"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 37"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 38"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 39"			},
>> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 40"			},
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level -1 granule protection fault (translation table walk)" },
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 0 granule protection fault (translation table walk)" },
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 1 granule protection fault (translation table walk)" },
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 2 granule protection fault (translation table walk)" },
>> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"level 3 granule protection fault (translation table walk)" },
>> +	{ do_gpf,		SIGBUS,  SI_KERNEL,	"granule protection fault" },
> 
> For SIGBUS, we should use BUS_OBJERR like we do for do_sea().

Good point, I have added that.
> 
> Otherwise it looks fine to me.

Thanks, I have already added the untagged_addr() as reported by Sashiko.


> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>


Cheers
Suzuki
