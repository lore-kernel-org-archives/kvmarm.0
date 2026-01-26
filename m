Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BDF72FF151
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 14:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769439021; cv=none; b=FTpW5mig1FKh/YI25qSknIsXb1TkCkrtuiIpken7/+cXbw3jrlxsZb2YNayUCFvUwI8WlM/oVXj2K8HxBC0spWztntj7wAWZpB/LeEYGEaCNOuoT0pQNpDHaGWj3C1n0m7CR/FV/++kJqyqW0lerXG1wuPylJqNq8JyNtdwIT9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769439021; c=relaxed/simple;
	bh=cqtZXyZa8imQHxnsUX+fBLFsrMQYKmTLZDAUtPIK4TA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=IoNNqHdUlK2KYeQagFHiuRRfRCWSjg3gmm0fF0gYI3qTAX61CVEf0ElY6GipAy2Z6AHcjLdjL968H3+TeQleOPMEjfiqoSF5G41ujwg0aM7fM8ExOytnBFM3r8PjqhVhdkbjgBQcQNyUzmhEALM+7axirln5kswQC0dWOAZpjkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F283339;
	Mon, 26 Jan 2026 06:50:12 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2ACA33F632;
	Mon, 26 Jan 2026 06:50:14 -0800 (PST)
Message-ID: <555723b6-b4b1-436b-830a-464b9710fd8f@arm.com>
Date: Mon, 26 Jan 2026 14:50:12 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/47] arm64: mpam: Context switch the MPAM registers
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
 <20260112165914.4086692-7-ben.horgan@arm.com> <aWkqt37FJ5l6QD0E@arm.com>
 <f19cab15-0626-4d13-b25e-1c194294e62f@arm.com> <aXOF1gYB_HEK8QPX@arm.com>
 <b79b74ed-8d52-45a9-80fd-47ed030f362f@arm.com>
Content-Language: en-US
In-Reply-To: <b79b74ed-8d52-45a9-80fd-47ed030f362f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/26/26 14:30, Ben Horgan wrote:
> Hi Catalin,
> 
> On 1/23/26 14:29, Catalin Marinas wrote:
>> Hi Ben,
>>
>> On Mon, Jan 19, 2026 at 12:23:13PM +0000, Ben Horgan wrote:
>>> On 1/15/26 17:58, Catalin Marinas wrote:
>>>> On Mon, Jan 12, 2026 at 04:58:33PM +0000, Ben Horgan wrote:
>>>>> +static inline void mpam_thread_switch(struct task_struct *tsk)
>>>>> +{
>>>>> +	u64 oldregval;
>>>>> +	int cpu = smp_processor_id();
>>>>> +	u64 regval = mpam_get_regval(tsk);
>>>>> +
>>>>> +	if (!static_branch_likely(&mpam_enabled))
>>>>> +		return;
>>>>> +
>>>>> +	if (regval == READ_ONCE(arm64_mpam_global_default))
>>>>> +		regval = READ_ONCE(per_cpu(arm64_mpam_default, cpu));
>>>>> +
>>>>> +	oldregval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
>>>>> +	if (oldregval == regval)
>>>>> +		return;
>>>>> +
>>>>> +	write_sysreg_s(regval, SYS_MPAM1_EL1);
>>>>> +	isb();
>>>>> +
>>>>> +	/* Synchronising the EL0 write is left until the ERET to EL0 */
>>>>> +	write_sysreg_s(regval, SYS_MPAM0_EL1);
>>>>
>>>> Since we have an isb() already, does it make any difference if we write
>>>> MPAM0 before the barrier? Similar question for other places where we
>>>> write these two registers.
>>>
>>> The reason for the isb() placement is to document that it's not required
>>> for the MPAM0_EL1. All instructions running at EL1take their MPAM
>>> configuration from MPAM1_EL1. This includes LDTR and STTR as you asked
>>> about in a different thread.
>>
>> It's fine to keep it this way if LDTR/STTR are not affected by the MPAM0
>> register.
>>
>>>>> +
>>>>> +	WRITE_ONCE(per_cpu(arm64_mpam_current, cpu), regval);
>>>>
>>>> Is it too expensive to read the MPAM sysregs and avoid carrying around
>>>> another per-CPU state? You use it for pm restoring but we could just
>>>> save it in cpu_do_suspend() like other sysregs. Not a big issue, it just
>>>> feels like this function got unnecessarily complicated (it took me a bit
>>>> to figure out what it all does).
>>>
>>> It's done this way as it matches what's done in x86. I expect it would
>>> be cheap enough to read the register to check whether a write is required.
>>
>> Since you use it for CPU suspend/resume, I guess it's fine, it saves us
>> from having to preserve it in the low-level asm sleep code. I don't have
>> a strong preference either way.
>>
>>>> A related question - is resctrl_arch_set_cdp_enabled() always called in
>>>> non-preemptible contexts? We potentially have a race between setting
>>>> current->mpam_partid_msg and arm64_mpam_global_default, so the check in
>>>> mpam_thread_switch() can get confused.
>>>
>>> The resctrl filesystem can only ever get mounted once and
>>> resctrl_arch_set_cdp_enabled() is always called in mount. In
>>> rdt_get_tree(), rdt_enable_ctx() calls resctrl_arch_set_cdp_enabled().
>>> This is done while holding the rdtgroup_mutex and the user can't change
>>> the mpam configuration from the default until the mutex is released and
>>> it can claim it.
>>
>> What if resctrl_arch_set_cdp_enabled() gets preempted between updating
>> current task partid and setting arm64_mpam_global_default? The mutex
>> doesn't help.
> 
> I see, I had misinterpreted your question.
> 
> When looking into this I spotted that the per-cpu default,
> arm64_mpam_default, is not updated on the cdp enable and so the default
> tasks carry on running with the non-cdp default pmg/partid configuration.
> 
> On the race itself, if current->mpam_partid_pmg is set but not
> arm64_mpam_global_default then if the current task is preempted at that
> point there is a discrepancy. When the task gets context switched back
> in then the comparison in mpam_thread_switch() will be false when true
> would be expected.
> 
> In order to update arm64_mpam_default and make sure the mpam variables
> and registers for the online cpus are in the right state by the end of
> resctrl_arch_set_cdp_enabled() I'll add a per cpu call to
> resctrl_arch_sync_cpu_closid_rmid(). I'll also add something in the
> resume path so that arm64_mpam_default gets set correctly for the cpus
> that were offline.

Rather than the resume path I'll just set all the arm64_mpam_default in
resctrl_arch_set_cdp_enabled(). In code:

--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -193,6 +193,7 @@ static void resctrl_reset_task_closids(void)
 int resctrl_arch_set_cdp_enabled(enum resctrl_res_level ignored, bool
enable)
 {
        u32 partid_i = RESCTRL_RESERVED_CLOSID, partid_d =
RESCTRL_RESERVED_CLOSID;
+       int cpu;

        cdp_enabled = enable;

@@ -209,6 +210,10 @@ int resctrl_arch_set_cdp_enabled(enum
resctrl_res_level ignored, bool enable)

        resctrl_reset_task_closids();

+       for_each_possible_cpu(cpu)
+               mpam_set_cpu_defaults(cpu, partid_d, partid_i, 0, 0);
+       on_each_cpu(resctrl_arch_sync_cpu_closid_rmid, NULL, 1);
+
        return 0;
 }

> 
>>
>>>> And I couldn't figure out where the MPAMx_EL1 registers are written. If
>>>> any global/per-cpu/per-task value is changed, does the kernel wait until
>>>> the next thread switch to write the sysreg? The only places I can found
>>>> touching these sysregs are the thread switch, pm notifiers and KVM.
>>>
>>> If the task configuration is changed then the MPAM sysreg will only be
>>> updated the next time it goes into the kernel.
>>
>> Is it updated when it goes into the kernel or when we have a context
>> switch? If you have a long-running user thread that is never scheduled
>> out, it may not notice the update even if it entered the kernel (but no
>> context switch).
> 
> Yes, only on context switch.
> 
>>
>>> So, just eventually
>>> consistent. For cpu configuration, update_closid_rmid() gets called
>>> which ipis the cpus and ends up calling mpam_thread_switch() from
>>> resctrl_arch_sched_in().
>>
>> I see, it should be fine.
>>
> 
> Thanks,
> 
> Ben
> 
> 

Thanks,

Ben

