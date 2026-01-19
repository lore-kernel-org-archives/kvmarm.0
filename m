Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4AC637BE7E
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832542; cv=none; b=TuWkWYK6SxvX+582pG5yoeFGXt34t6SZCYVhZL+v0+MIC022g+efvlu0lKaMfffvA/xKpXB1Zyby/pzlWdA0J2PdH+5hCUNerMqlHuNQ/sx9A3DCT4j47adTzuuAtW0BfIKTXTSY9lCmSNXFIoIWp6RNw5dXG2wk94D95/gbl7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832542; c=relaxed/simple;
	bh=yzDwbVmmT2dMSt0hv6FrcnPy/Xr4vZwfxg9xduYUv0o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=TrsV6mvKH4z9TSF5zzXrVkPfaMbbt8kXbYZH4dB0s5wMrVxlLpXn5aJpmqLMcnQ4tjexPKPv09EdUhdkaCWtBEvUDkxe89ypQXGMy16VmT2RyAgNVun3WldQgbByrWByopKyv2M2NbHfpoyN4JLODY/ALCOnJHcty1dQh+0k8K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 751DD497;
	Mon, 19 Jan 2026 06:22:13 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44B383F632;
	Mon, 19 Jan 2026 06:22:15 -0800 (PST)
Message-ID: <4a5c4d68-989c-4657-9cdb-f48a7ff11655@arm.com>
Date: Mon, 19 Jan 2026 14:22:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/47] arm64: mpam: Re-initialise MPAM regs when CPU
 comes online
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
 <20260112165914.4086692-8-ben.horgan@arm.com> <aWkucXgE6g2lwvkj@arm.com>
 <d603ad9c-18a0-40fe-9d0b-2ff31eaf8f30@arm.com>
Content-Language: en-US
In-Reply-To: <d603ad9c-18a0-40fe-9d0b-2ff31eaf8f30@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Catalin,

On 1/19/26 13:38, Ben Horgan wrote:
> Hi Catalin,
> 
> On 1/15/26 18:14, Catalin Marinas wrote:
>> On Mon, Jan 12, 2026 at 04:58:34PM +0000, Ben Horgan wrote:
>>> From: James Morse <james.morse@arm.com>
>>>
>>> Now that the MPAM system registers are expected to have values that change,
>>> reprogram them based on the previous value when a CPU is brought online.
>>>
>>> Previously MPAM's 'default PARTID' of 0 was always used for MPAM in
>>> kernel-space as this is the PARTID that hardware guarantees to
>>> reset. Because there are a limited number of PARTID, this value is exposed
>>> to user-space, meaning resctrl changes to the resctrl default group would
>>> also affect kernel threads.  Instead, use the task's PARTID value for
>>> kernel work on behalf of user-space too. The default of 0 is kept for both
>>> user-space and kernel-space when MPAM is not enabled.
>>>
>>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>>> Signed-off-by: James Morse <james.morse@arm.com>
>>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>>> ---
>>> Changes since rfc:
>>> CONFIG_MPAM -> CONFIG_ARM64_MPAM
>>> Check mpam_enabled
>>> Comment about relying on ERET for synchronisation
>>> Update commit message
>>> ---
>>>  arch/arm64/kernel/cpufeature.c | 19 ++++++++++++-------
>>>  1 file changed, 12 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>> index c840a93b9ef9..0cdfb3728f43 100644
>>> --- a/arch/arm64/kernel/cpufeature.c
>>> +++ b/arch/arm64/kernel/cpufeature.c
>>> @@ -86,6 +86,7 @@
>>>  #include <asm/kvm_host.h>
>>>  #include <asm/mmu.h>
>>>  #include <asm/mmu_context.h>
>>> +#include <asm/mpam.h>
>>>  #include <asm/mte.h>
>>>  #include <asm/hypervisor.h>
>>>  #include <asm/processor.h>
>>> @@ -2483,13 +2484,17 @@ test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
>>>  static void
>>>  cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
>>>  {
>>> -	/*
>>> -	 * Access by the kernel (at EL1) should use the reserved PARTID
>>> -	 * which is configured unrestricted. This avoids priority-inversion
>>> -	 * where latency sensitive tasks have to wait for a task that has
>>> -	 * been throttled to release the lock.
>>> -	 */
>>> -	write_sysreg_s(0, SYS_MPAM1_EL1);
>>
>> Is this comment about priority inversion no longer valid?
> 
> Yes, will drop it.

Ah, that's done in the patch already. Also, we can't treat 0 as special
without taking it away from userspace and then we're down a partid and
there might be that many.

> 
>  I see thread
>> switching sets the same value for both MPAM0 and MPAM1 registers but I
>> couldn't find an explanation why this is now better when it wasn't
>> before.
> 
> I touch on it in the cover letter. It is the way it is done for x86 and
> so sensible to make it the default. All partids are usable from
> user-space and user-space can't bypass MPAM controls by doing the work
> in the kernel.
> 
> There is a proposal from Babu at AMD, PLZA, which he presented at LPC
> which would give a new interface to  have different configuration,
> closid, for userspace and kernel space. We should be able to use this
> with MPAM too.
> 
>>
>> MPAM1 will also be inherited by IRQ handlers AFAICT.
> 
> Yes, this is a disadvantage of having MPAM1 and MPAM0 change together.
> 
>>
>>> +	int cpu = smp_processor_id();
>>> +	u64 regval = 0;
>>> +
>>> +	if (IS_ENABLED(CONFIG_ARM64_MPAM) && static_branch_likely(&mpam_enabled))
>>> +		regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
>>> +
>>> +	write_sysreg_s(regval, SYS_MPAM1_EL1);
>>> +	isb();
>>> +
>>> +	/* Synchronising the EL0 write is left until the ERET to EL0 */
>>> +	write_sysreg_s(regval, SYS_MPAM0_EL1);
>>
>> I mentioned before, is it worth waiting until ERET?
> 
> Just for documentation. I can change it if you prefer.
> 
>>
>> Related to this, do LDTR/STTR use MPAM0 or MPAM1? I couldn't figure out
>> from the Arm ARM. If they use MPAM0, then we need the ISB early for the
>> uaccess routines, at least in the thread switching path (an earlier
>> patch).
>>
> 
> They use LDTR/STTR. MPAM doesn't care about which instruction is running.
> 
> Thanks,
> 
> Ben
> 
> 

Thanks,

Ben

