Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C3D2F619A
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 09:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111210; cv=none; b=qwxu4q577OSiQbSReVR+flf6WjH1QeSLLxS10tsm0z47tmdS/SH5KxxW3IVBK0aC8mqO8UH8LxgoFAVWKJlF44BZwZE4/M32x1JYn+vDAfwDJvflVL7eprOy2sZ6fi0FztdiC8XUn7yzeOmL4DpV6Wxa4jNdaAzy7IqorzsNZrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111210; c=relaxed/simple;
	bh=hrRYcsB8afw7E/aYVncf2Erojf9vJiWCY9oKpUehAW0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Dh7MRGDcmByu/VzJWCMDcVkoVN0RCEpuyedctk5DfaqV78IaU0aIPdOa2MtQX7+q+9kwXTIEHnJ69JcBb7IuLW0eqaQhdAFPBIDBAr+mJcTHKcqDXJHDRdThaYmY0pRCfv9mFkKfR2fcHHUh3jGTY4RDrjNWSK60+G9ltCtiLn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FB61339;
	Tue,  3 Feb 2026 01:33:21 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A24D3F632;
	Tue,  3 Feb 2026 01:33:22 -0800 (PST)
Message-ID: <fd130189-b9b8-437e-9240-308a5897c9b5@arm.com>
Date: Tue, 3 Feb 2026 09:33:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v3 41/47] arm_mpam: Generate a configuration for min
 controls
To: Shanker Donthineni <sdonthineni@nvidia.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "fenghuay@nvidia.com" <fenghuay@nvidia.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 gshan@redhat.com, james.morse@arm.com, kobak@nvidia.com,
 lcherian@marvell.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, peternewman@google.com,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, tan.shaopeng@fujitsu.com,
 xhao@linux.alibaba.com, catalin.marinas@arm.com, will@kernel.org,
 corbet@lwn.net, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 Zeng Heng <zengheng4@huawei.com>, jasjits@nvidia.com,
 Jason Sequeira <jsequeira@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-42-ben.horgan@arm.com>
 <20260113153938.00007d6e@huawei.com>
 <80db7035-07d3-4fb4-a228-f9c67d2df1f4@arm.com>
 <9e01328f-7f28-4b43-aaf4-59d3ce80c268@nvidia.com>
 <3ae02b5b-22ab-4778-a29d-709ca3163f58@arm.com>
 <ca45ea06-53fa-4010-86c6-66213243b636@nvidia.com>
Content-Language: en-US
In-Reply-To: <ca45ea06-53fa-4010-86c6-66213243b636@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Shanker, Fenghua,

On 2/2/26 16:34, Shanker Donthineni wrote:
> Hi Ben,
> 
> On 2/2/2026 4:21 AM, Ben Horgan wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> Hi Shanker,
>>
>> On 1/31/26 02:30, Shanker Donthineni wrote:
>>> Hi Ben,
>>>
>>> On 1/30/2026 8:17 AM, Ben Horgan wrote:
>>>> External email: Use caution opening links or attachments
>>>>
>>>>
>>>> Hi Fenghua, Jonathan,
>>>>
>>>> On 1/13/26 15:39, Jonathan Cameron wrote:
>>>>> On Mon, 12 Jan 2026 16:59:08 +0000
>>>>> Ben Horgan <ben.horgan@arm.com> wrote:
>>>>>
>>>>>> From: James Morse <james.morse@arm.com>
>>>>>>
>>>>>> MPAM supports a minimum and maximum control for memory bandwidth. The
>>>>>> purpose of the minimum control is to give priority to tasks that are
>>>>>> below
>>>>>> their minimum value. Resctrl only provides one value for the
>>>>>> bandwidth
>>>>>> configuration, which is used for the maximum.
>>>>>>
>>>>>>
>>>>>> Hence, I'll drop this patch, and update the mbw_min default to be
>>>>>> 0xFFFF
>>>>>> and for the value not to change even if mbw_max changes. I think this
>>>>>> leaves us in the best position going forward without any heuristics
>>>>>> that
>>>>>> may come back to bite us later when proper support for a schema
>>>>>> supporting mbw_min is added to resctrl.
>>> Background: I previouslyshared original fix(seecodesnippet below) with
>>> James Morse
>>> ~2 years ago to address the errata, which explicitly recommends usinga
>>> 5% gap for
>>> mitigation of the Hardware issue (the problem described in commit text
>>> of T241-MPAM-4)
>>>
>>> For some reason theoriginalimplementationwas splitinto two patches:
>>>    - Generic change applicable toall chips
>>>    - Specific fixfor Graceerrata T241-MPAM-4
>>> Issue: Dropping this patch impacts[PATCH v3 45/47] forthe errata fix. If
>>> removalis
>>> necessary, please mergethis changeinto the T241-MPAM-4-specific patch.
>>
>> What's the behaviour on T241 when MBW_MIN is always 0xFFFF?
> 
> Memory bandwidth throttling will not function correctly. The MPAM hardware
> monitors MIN and MAX values for each active partition to maintain memory
> bandwidth usage between MBW_MIN and MBW_MAX. Therefore, MBW_MIN must be
> less than MBW_MAX (IMO, setting MBW_MIN to always 0xFFFF is incorrect)

Ah, yes. 0xFFFF is indeed a bad default. Looking at Table 5-3 in Mpam
system component B.a I see that as all bandwidth will be below the
minimum and so high preference the MBW_MAX will have no effect. I'll
keep the default for MBW_MIN as 0 (or the minimum for grace).

> 
> Grace errata T241-MPAM-4 has two issues:
> - MBW_MIN must be greater than 0 (WAR set to one when when it's zero) -
> In the Grace implementation of memory-bandwidth partitioning (MPAM),
>    in the absence of contention for bandwidth, the minimum bandwidth
>    setting can affect the amount of achieved bandwidth. Specifically,
>    the achieved bandwidth in the absence of contention can settle to any
>    value between the values of MIN and MAX. This means if the gap between
>    MIN and MAX is large then the BW can settle closer to MIN. To achieve
>    BW closer to MAX in the absence of contention, software should configure
>    a relatively narrow gap between MPAMCFG_MBW_MIN and MPAMCFG_MBW_MAX.
>    The recommendation is to use a 5% gap, corresponding to an absolute
>    difference of (0xFFFF * 0.05) = 0xCCC between MPAMCFG_MBW_MIN and
>    MPAMCFG_MBW_MAX.

Ok, thanks. I understand the issue more now.

> 
>> I'm worried if we make a policy decision of how to set MBW_MIN based on
>> MBW_MAX for this platform then we won't be able to support a
>> configurable MBW_MIN in the future for this platform.
> 
> Yes, we can't support generic programmable MBW_MIN for Grace chip. The
> currentresctrl interface doesnot exposeMBW_MIN, preventingusers from
> configuring the recommended5% gap. Without this interfacesupport,
> theonly wayto applytheworkaround is through driver-level changes.
> 
>>   As when MBW_MIN
>> support is added in resctrl the user's configuration for this platform
>> would change meaning on kernel upgrade.
> 
> What is the timelineforaddingMBW_MIN support? We have two options.
>  Option-A: Keep the current WAR 5% gap and don't allow users to program
> MBW_MIN.
>  Option-B:Remove the5% gap workaround and relyon usersto program MBW_MIN
>             accordingto the Grace recommendations
> whentheinterfacebecomes available.
> 
> We'll prefer option-B.

The problem with option-B is that the transition introduces a change in
user visible
for any existing MBW_MAX configuration.

If option-A is preferable to disabling MBW_MAX on grace until we have
proper MBW_MIN support in resctrl then I think we should assume option-A.

The work to decide how new schema is underway but it's difficult to say
how long it will take.
See: https://lore.kernel.org/lkml/aPtfMFfLV1l%2FRB0L@e133380.arm.com/

Assuming that you're sure that the 5% gap is the best policy and that
there are no other objections I'll add that policy back into the
T241-MPAM-4 workaround and look into a way to ensure that we don't
accidentally enable MBW_MIN support for grace comes when the proper
support is added.

> 
> Thanks,
> Shanker
> 

Thanks,

Ben

