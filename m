Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9041917CD
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 16:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769443213; cv=none; b=AuL8VxI3p2jS0i0afKU/Z0uzc1DNu3gj9eFSbT45LzmD72fylrPlsqyqQX4UfYAKlOmm+lZGNKT1eLTB+8dYzYRvg7emH+K1Fi8u+abP1/urJ3xZhdaZlOdWNRPOxatrjOiTXhg6w9LOvf52DJeCjZYTlQ7U5t4VrcA/DAmwFz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769443213; c=relaxed/simple;
	bh=pubbUNobILTWFODnOQQ56cn2oCTG/Go4cK129lbZkTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q7eAsr+M2Sirp+U9Krexp68zS/c1fMpfH4o7NRKNzwe9Grr6bu7uGlYYGrgC3rXPpxwAH1WcCL05qyAjg+/tfVaLCBHuaB7qq4RGjcuwoB7EtBwPjoSLxUuYG120yt+HQRCrvGWOWkXiRuwQJB5vOFdeBfMwYJ7rQwkSqBrfoZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F01E7339;
	Mon, 26 Jan 2026 08:00:03 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9936E3F5CA;
	Mon, 26 Jan 2026 08:00:05 -0800 (PST)
Message-ID: <2ce2b78e-9a79-489d-813c-3ed6ced34f12@arm.com>
Date: Mon, 26 Jan 2026 16:00:04 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 29/47] arm_mpam: resctrl: Pick classes for use as mbm
 counters
To: Peter Newman <peternewman@google.com>, James Morse <james.morse@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-30-ben.horgan@arm.com>
 <CALPaoCh+mRLJEfhKBve3hRf+vHHoObjvWRt74OfpopgtR9g9FQ@mail.gmail.com>
 <c157d2b6-7282-438f-b9e7-1a24be3fbf53@arm.com>
 <CALPaoCi0fR5sUVsjXi25XHBrhn3whFvKDpEvUGSM5Hjd2LZP6w@mail.gmail.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <CALPaoCi0fR5sUVsjXi25XHBrhn3whFvKDpEvUGSM5Hjd2LZP6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Peter, James,

On 1/19/26 12:47, Peter Newman wrote:
> Hi James,
> 
> On Mon, Jan 19, 2026 at 1:04 PM James Morse <james.morse@arm.com> wrote:
>>
>> Hi Peter,
>>
>> On 15/01/2026 15:49, Peter Newman wrote:
>>> On Mon, Jan 12, 2026 at 6:02 PM Ben Horgan <ben.horgan@arm.com> wrote:
>>>> From: James Morse <james.morse@arm.com>
>>>>
>>>> resctrl has two types of counters, NUMA-local and global. MPAM has only
>>>> bandwidth counters, but the position of the MSC may mean it counts
>>>> NUMA-local, or global traffic.
>>>>
>>>> But the topology information is not available.
>>>>
>>>> Apply a heuristic: the L2 or L3 supports bandwidth monitors, these are
>>>> probably NUMA-local. If the memory controller supports bandwidth monitors,
>>>> they are probably global.
>>
>>> Are remote memory accesses not cached? How do we know an MBWU monitor
>>> residing on a cache won't count remote traffic?
>>
>> It will, yes you get double counting. Is forbidding both mbm_total and mbm_local preferable?
>>
>> I think this comes from 'total' in mbm_total not really having the obvious meaning of the
>> word:
>> If I have CPUs in NUMA-A and no memory controllers, then NUMA-B has no CPUs, and all the
>> memory-controllers.
>> With MPAM: we've only got one bandwidth counter, it doesn't know where the traffic goes
>> after the MSC. mbm-local on the L3 would reflect all the bandwidth, and mbm-total on the
>> memory-controllers would have the  same number.
>> I think on x86 mbm_local on the CPUs would read zero as zero traffic went to the 'local'
>> memory controller, and mbm_total would reflect all the memory bandwidth. (so 'total'
>> really means 'other')
> 
> Our software is going off the definition from the Intel SDM:
> 
> "This event monitors the L3 external bandwidth satisfied by the local
> memory. In most platforms that support this event, L3 requests are
> likely serviced by a memory system with non-uniform memory
> architecture. This allows bandwidth to off-package memory resources to
> be tracked by subtracting local from total bandwidth (for instance,
> bandwidth over QPI to a memory controller on another physical
> processor could be tracked by subtraction).

Indeed we should base our discussion on the event definition in the
Intel SDM. For our reference, the description for the external bandwidth
monitoring event (mbm_total) is:

"This event monitors the L3 total external bandwidth to the next level
of the cache hierarchy, including all demand and prefetch misses from
the L3 to the next hierarchy of the memory system. In most platforms,
this represents memory bandwidth."

> 
> On NUMA-capable hardware that can support this event where all memory
> is local, mbm_local == mbm_total, but in practice you can't read them
> at the same time from userspace, so if you read mbm_total first,
> you'll probably get a small negative result for remote bandwidth.
> 
>>
>> I think what MPAM is doing here is still useful as a system normally has both CPUs and
>> memory controllers in the NUMA nodes, and you can use this to spot a control/monitor group
>> on a NUMA-node that is hammering all the memory (outlier mbm_local), or the same where a
>> NUMA-node's memory controller is getting hammered by all the NUMA nodes (outlier
>> mbm_total)
>>
>> I've not heard of a platform with both memory bandwidth monitors at L3 and the memory
>> controller, so this may be a theoretical issue.
>>
>> Shall we only expose one of mbm-local/total to prevent this being seen by user-space?
> 
> I believe in the current software design, MPAM is only able to support
> mbm_total, as an individual MSC (or class of MSCs with the same
> configuration) can't separate traffic by destination, so it must be
> the combined value. On a hardware design where MSCs were placed such
> that one only counts local traffic and another only counts remote, the
> resctrl MPAM driver would have to understand the hardware
> configuration well enough to be able to produce counts following
> Intel's definition of mbm_local and mbm_total.

On a system with MSC measuring memory bandwidth on the L3 caches these
MSC will measure all bandwidth to the next level of the memory hierarchy
which matches the definition of mbm_total. (We assume any MSC on an L3
is at the egress even though acpi/dt doesn't distinguish ingress and
egress.)

For MSC on memory controllers then they don't distinguish which L3 cache
the traffic came from and so unless there is a single L3 then we can't
use these memory bandwidth monitors as they count neither mbm_local nor
mbm_total. When there is a single L3 (and no higher level caches) then
it would match both mbm_total and mbm_local.

Hence, I agree we should just use mbm_total and update the heuristics
such that if the MSC are at the memory only consider them if there are
no higher caches and a single L3.

The introduction of ABMC muddies the waters as the "event_filter" file
defines the meaning of mbm_local and mbm_total. In order to handle this
file properly with MPAM, fs/resctrl changes are needed. We could either
make "event_filter" show the bits that correspond to the mbm counter and
unchangeable or decouple the "event_filter" part of ABMC from the
counter assignment part. As more work is needed to not break abi here
I'll drop the ABMC patches from the next respin of this series.

> 
> Thanks,
> -Peter

Thanks,

Ben

