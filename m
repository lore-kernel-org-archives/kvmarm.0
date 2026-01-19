Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4E71C5D5E
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768824260; cv=none; b=sR9tggQKfQ3Oeo53+UQ6uwE+mldjTMpethY45z9t8X3bwy8W6Q15YR5RhAMMc5gGfhpLmUeR9eiFADSU1tp6pPs9B1H/ZW1NvMJK7MXWTiuWV71henVzoF0NtreU8dGOuiqH4FA/oIeQDXrKs6qZD7TYWslnGEG5pfC/FBkYUeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768824260; c=relaxed/simple;
	bh=Nye4XAyezarovYDKtXcgw44rTLO1Qv08plyCYIYQwbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GfT9bSmSaE2B3WrD7+nZRM9ndRXQm4LMj5Jzf1lTQkZOA4l2/mvjt2kxxIao4KGEXyCSNFD7H9iCvksWrdqt1qSu7GlfbKMGEVD7WERMyTro/R7HMqxQ+lvOkq4/HQeBChfB63PdzQSQb54xQU4LpVg45bSpAS9XPlXzHbf7zG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17DC01517;
	Mon, 19 Jan 2026 04:04:12 -0800 (PST)
Received: from [10.1.197.58] (eglon.cambridge.arm.com [10.1.197.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A802D3F632;
	Mon, 19 Jan 2026 04:04:12 -0800 (PST)
Message-ID: <c157d2b6-7282-438f-b9e7-1a24be3fbf53@arm.com>
Date: Mon, 19 Jan 2026 12:04:10 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 29/47] arm_mpam: resctrl: Pick classes for use as mbm
 counters
To: Peter Newman <peternewman@google.com>, Ben Horgan <ben.horgan@arm.com>
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
Content-Language: en-GB
From: James Morse <james.morse@arm.com>
In-Reply-To: <CALPaoCh+mRLJEfhKBve3hRf+vHHoObjvWRt74OfpopgtR9g9FQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Peter,

On 15/01/2026 15:49, Peter Newman wrote:
> On Mon, Jan 12, 2026 at 6:02 PM Ben Horgan <ben.horgan@arm.com> wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl has two types of counters, NUMA-local and global. MPAM has only
>> bandwidth counters, but the position of the MSC may mean it counts
>> NUMA-local, or global traffic.
>>
>> But the topology information is not available.
>>
>> Apply a heuristic: the L2 or L3 supports bandwidth monitors, these are
>> probably NUMA-local. If the memory controller supports bandwidth monitors,
>> they are probably global.

> Are remote memory accesses not cached? How do we know an MBWU monitor
> residing on a cache won't count remote traffic?

It will, yes you get double counting. Is forbidding both mbm_total and mbm_local preferable?

I think this comes from 'total' in mbm_total not really having the obvious meaning of the
word:
If I have CPUs in NUMA-A and no memory controllers, then NUMA-B has no CPUs, and all the
memory-controllers.
With MPAM: we've only got one bandwidth counter, it doesn't know where the traffic goes
after the MSC. mbm-local on the L3 would reflect all the bandwidth, and mbm-total on the
memory-controllers would have the  same number.
I think on x86 mbm_local on the CPUs would read zero as zero traffic went to the 'local'
memory controller, and mbm_total would reflect all the memory bandwidth. (so 'total'
really means 'other')

I think what MPAM is doing here is still useful as a system normally has both CPUs and
memory controllers in the NUMA nodes, and you can use this to spot a control/monitor group
on a NUMA-node that is hammering all the memory (outlier mbm_local), or the same where a
NUMA-node's memory controller is getting hammered by all the NUMA nodes (outlier
mbm_total)

I've not heard of a platform with both memory bandwidth monitors at L3 and the memory
controller, so this may be a theoretical issue.

Shall we only expose one of mbm-local/total to prevent this being seen by user-space?



Thanks,

James
