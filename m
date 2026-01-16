Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FABB35F8DA
	for <kvmarm@lists.linux.dev>; Fri, 16 Jan 2026 10:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768559350; cv=none; b=nXL5b98YA/K64MaUXdnsbpWLAhcMJPP4ayMelJxdqNZR/ZxVc/TbQUmF2A0NZdg5+uCGGu22LGQoBqXMR0lZwPmTK4HemvAT2ivE+1+Q1BmQo/ZD8QjDCi9mTFjFAF8ozZi4b9ZRJbPSZeSnl8FHnF/cNlUez4Cp/SwgSNLMvlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768559350; c=relaxed/simple;
	bh=leY+HiXTWIOz98kOnqG/sfRjYfWeT3Pvss9rCvp/tY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LTDmQhQxKkJ5KZqde8Vm8B7Gt2AfcaHWaEH/bxINI/AEgcUTIjC6+LLOGFNMbbmPUm2g4KGLdi/aRRiv2mohUGlG1f0cqXSoEPIGk7q8xxklioAPZw9VJTqehXyn5e1ExZmKVQAorbYb19CVRTCJSvy1JLSCwLjetM7NxdiQYrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2172E1515;
	Fri, 16 Jan 2026 02:29:01 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDC733F694;
	Fri, 16 Jan 2026 02:29:02 -0800 (PST)
Message-ID: <0eb7fc76-179e-4e55-b13e-78cea775c2ba@arm.com>
Date: Fri, 16 Jan 2026 10:29:01 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 28/47] arm_mpam: resctrl: Add support for csu counters
To: Reinette Chatre <reinette.chatre@intel.com>,
 "peternewman@google.com" <peternewman@google.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, rohit.mathew@arm.com, scott@os.amperecomputing.com,
 sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com,
 catalin.marinas@arm.com, will@kernel.org, corbet@lwn.net, maz@kernel.org,
 oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
 kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-29-ben.horgan@arm.com>
 <e65d2b54-e14c-4b1d-a9ea-04b6e0eb051f@intel.com>
 <90561371-96f0-4bdb-8316-1b657f26da54@arm.com>
 <f2e9d7e2-1f99-45e4-9cf9-49e1ce2f08e9@intel.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <f2e9d7e2-1f99-45e4-9cf9-49e1ce2f08e9@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Reinette, Peter,

On 1/15/26 18:54, Reinette Chatre wrote:
> Hi Ben,
> 
> On 1/15/26 7:43 AM, Ben Horgan wrote:
>> On 1/13/26 23:14, Reinette Chatre wrote:
>>> On 1/12/26 8:58 AM, Ben Horgan wrote:
> ...
>>>> +
>>>> +		/*
>>>> +		 * Unfortunately, num_rmid doesn't mean anything for
>>>> +		 * mpam, and its exposed to user-space!
>>>> +		 *
>>>
>>> The idea of adding a per MON group "num_mon_groups" file has been floated a couple of
>>> times now. I have not heard any objections against doing something like this.
>>> https://lore.kernel.org/all/cbe665c2-fe83-e446-1696-7115c0f9fd76@arm.com/
>>> https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/
>>
>> Hmm, I see now that 'num_rmid' is documented as an upper bound and so
>> neither 1 or mpam_pmg_max + 1 agree with the documentation.
>>
>> "
>> "num_rmids":
>> 		The number of RMIDs available. This is the
>> 		upper bound for how many "CTRL_MON" + "MON"
>> 		groups can be created.
>> "
> 
> Please note that this documentation has been refactored (without changing its
> meaning). The above quoted text is specific to L3 monitoring and with the
> addition of telemetry monitoring the relevant text now reads:
> 	The upper bound for how many "CTRL_MON" + "MON" can be created                  
> 	is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.  
> 
>>
>> So, if I understand correctly you're proposing setting
>> num_rmids = num_pmg * num_partids on arm platforms and that in the
>> interim this can then be used to calculate the num_pmg by calculating
>> num_closid/num_rmid but that a per CTRL_MON num_mon_groups should be
>> added to make this consistent across architectures?
> 
> Yes for num_rmids = num_pmg * num_partids. 

Ok, I don't really see another option.

The motivation for this is that to me
> this looks like the value that best matches the num_rmids documentation. I understand
> the RMID vs PMG is difficult so my proposal is certainly not set in stone and I would like to
> hear motivation for different interpretations. "calculating num_pmg" is not obvious
> though. I interpret "num_pmg" here as number of monitor groups per control group and on
> an Arm system this is indeed num_closid/num_rmids (if num_rmids = num_pmg * num_partids)
> but on x86 it is just num_rmids. Having user space depend on such computation to determine how
> many monitor groups per control group would thus require that user space knows whether the
> underlying system is Arm or x86 and would go against goal of having resctrl as a generic interface.
> 
> The way forward may be to deprecate (somehow) num_rmids and transition to something
> like "num_mon_groups" but it is currently vague how "num_mon_groups" may look like. That thread 
> (https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/) fizzled
> out after raising a few options how it may look.
> 
> Another proposal was to add a "mon_id_includes_control_id" to use as another "guide" to
> determine how many monitoring groups can be created but at the time it seemed an intermediary
> step for user to determine the number of monitor groups that resctrl can also provide.
> https://lore.kernel.org/lkml/CALPaoChad6=xqz+BQQd=dB915xhj1gusmcrS9ya+T2GyhTQc5Q@mail.gmail.com/

Just thinking about it now but the "mon_id_includes_control_id" option
seems the best to me as it is a single bit option that along with
"num_rmids" let's you know which monitor groups you can create and if
it's sensible to move monitor groups between CTRL MON groups.

The "num_mon_groups" per CTRL MON group would also need to be
interpreted together with "num_rmid" to know if it is a global or per
CTRL MON upper bound. This option also uses multiple files to give the
same bit of information.

> 
> Making this consistent across architectures is the goal since resctrl aims to be
> a generic interface. Users should not need to do things like infer which system they
> are running on by looking at output of resctrl files as mentioned.
> 
> fwiw ...  there seems to be a usage by Google to compare num_rmids to num_closids to determine
> how to interact with resctrl:
> https://lore.kernel.org/lkml/CALPaoCgSO7HzK9BjyM8yL50oPyq9kBj64Nkgyo1WEJrWy5uHUg@mail.gmail.com/

Unfortunately, it looks like we're about to break this heuristic :( At
least, until a way to get this information generically in resctrl is
decided upon.

> 
> Reinette

Thanks,

Ben

