Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613287470
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 04:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718857337; cv=none; b=qTASlxFf94YeQswDV3NFO6R/NEfH9FIkawzMCAkFQREA7+ryCUUaJ7jioE41aMtQa9NrNdTTrv51nRYu4Zuspw6NvFdn9eczgtK3jtoTthS9v+7llFaJc72YSWswHQDXWwcel+u9/+tWSgyCg4FMWIz7xtE9GkqDmejya56NHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718857337; c=relaxed/simple;
	bh=QAdSu372sRUEYjNOdGuHPm3EQh6YcNhJYHxcXC6ObeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M1wHZx5O3VJO4GVH352TLce56bFOGWYVh/y5gw15bmVFZSIJV+0TBcNWlsxZp2hynIc//P4PJE+CYEImQGeePuRosCHLNzGYhiJOGb68T/vX/gCbMTcGltfbO3VfbmST/MEzvktil5Qf5UktFi9o0tCAbFvBUKIQ22IXAoevf2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AFB6DA7;
	Wed, 19 Jun 2024 21:22:39 -0700 (PDT)
Received: from [10.163.46.59] (unknown [10.163.46.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B3D13F64C;
	Wed, 19 Jun 2024 21:22:08 -0700 (PDT)
Message-ID: <ccfc2b96-acf3-4511-920a-2633305f940d@arm.com>
Date: Thu, 20 Jun 2024 09:52:05 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V18 6/9] KVM: arm64: nvhe: Disable branch generation in
 nVHE guests
Content-Language: en-US
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 will@kernel.org, catalin.marinas@arm.com, Mark Brown <broonie@kernel.org>,
 James Clark <james.clark@arm.com>, Rob Herring <robh@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Suzuki Poulose <suzuki.poulose@arm.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 linux-perf-users@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev
References: <20240613061731.3109448-1-anshuman.khandual@arm.com>
 <20240613061731.3109448-7-anshuman.khandual@arm.com>
 <ZmxgZqxXWnRqwbDC@J2N7QTR9R3.cambridge.arm.com>
 <774a63cb-21e6-4ef2-b2ab-0ff8937523b2@arm.com> <ZnAEVlVZFR3DLHHb@J2N7QTR9R3>
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ZnAEVlVZFR3DLHHb@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/17/24 15:09, Mark Rutland wrote:
> On Mon, Jun 17, 2024 at 12:15:15PM +0530, Anshuman Khandual wrote:
>>
>>
>> On 6/14/24 20:53, Mark Rutland wrote:
>>> On Thu, Jun 13, 2024 at 11:47:28AM +0530, Anshuman Khandual wrote:
>>>> Disable the BRBE before we enter the guest, saving the status and enable it
>>>> back once we get out of the guest. This avoids capturing branch records in
>>>> the guest kernel or userspace, which would be confusing the host samples.
>>>
>>> It'd be good to explain why we need to do this for nVHE, but not for
>>> VHE. I *think* that you're relying on BRBCR_EL2.EL0HBRE being ignored
>>> when HCR_EL2.TGE == 0, and BRBCR_EL1.E{1,0}BRE being initialized to 0
>>> out-of-reset.
>>
>> That's right, there is no possibility for the host and guest BRBE config
>> to overlap.
>>
>>> What should a user do if they *want* samples from a guest? Is that
>>
>> That is not supported currently. But in order to enable capturing guest
>> branch samples from inside the host - BRBCR_EL2 configs need to migrate
>> into BRBCR_EL1 when the guest runs on the cpu.
>>
>>> possible to do on other architectures, or do is that always prevented?
>>
>> I am not sure about other architectures, but for now this falls within
>> guest support which might be looked into later. But is not the proposed
>> patch complete in itself without any further guest support ?
> 
> My concern here is ABI rather than actual support.
I am trying to understand how this is an ABI problem. Because perf debug
tools could be described as - a best effort based sample collection. All
samples that could be collected for a given perf_event_attr request might
change if the underlying assumptions change later on. AFAICT semantics of
expectations for a given attribute request is not a hard ABI requirement.

> 
> It's not clear to me how this works across architectures, and we should
> have some idea of how this would work (e.g. if we're going to require
> new ABI or not), so that we don't have to break ABI later on.

BRBE HW does not have any guest filter in itself, unless BRBCR_EL2 gets
migrated across BRBCR_EL1 during guest transition, guest branch records
would not be captured.

event->attr.exclude_guest = 0 could have been denied during armpmu_add()
for preventing events with guest branch sample requests being scheduled
on the PMU. But it turns out to be not a very reliable parameter in that
sense as well.

event->attr.exclude_guest = 0 remains clear even for a standard session.

./perf record -e instructions:k -j any_call,save_type ls

perf tools will need some changes in order to avoid the above scenarios
as a default behaviour which would not be desirable as well.

These semantics could be worked out later on when BRBE guest support gets
included, and the current proposal would not prevent any potential future
changes in this regard.

> 
> Mark.
