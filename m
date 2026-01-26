Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE7C4225413
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769437823; cv=none; b=F9D5vbej6Pf3kMODaxcrL5qO7lUPA7Dh9S2fsEuyCITFniGcgmXu9H0OiQnAvu+70bSwm6y8RQeqAJRYwBuXhhGjHMK7BWEZEAcoDaVVR/NKpIRz5RaVWnGq/KJghU7X1VD91yBSREuWam+jECAvxF36uC9rPK7T3od2UOnTNcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769437823; c=relaxed/simple;
	bh=B7zB+MjQb7SRZ/5XrJXJrOxLelKo2UBqGdK18/DaHz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z5MsUt+FekhD3W8SBujutVCwPUfbC3p4kUlybvamUrv5Icc0ng6dbMSipGpiCAAqLQ2C0GJKauba+Jr9/VItyf00uHhRQshU7J6OjXKiiTreilkhEYoINPSQCQkQqY7xDMtouoPhff3sTKgeJp3nw42Fb1sj6Wy67fTVDlOIinA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE9D9339;
	Mon, 26 Jan 2026 06:30:14 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C6BA3F632;
	Mon, 26 Jan 2026 06:30:16 -0800 (PST)
Message-ID: <b79b74ed-8d52-45a9-80fd-47ed030f362f@arm.com>
Date: Mon, 26 Jan 2026 14:30:14 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/47] arm64: mpam: Context switch the MPAM registers
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
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aXOF1gYB_HEK8QPX@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Catalin,

On 1/23/26 14:29, Catalin Marinas wrote:
> Hi Ben,
> 
> On Mon, Jan 19, 2026 at 12:23:13PM +0000, Ben Horgan wrote:
>> On 1/15/26 17:58, Catalin Marinas wrote:
>>> On Mon, Jan 12, 2026 at 04:58:33PM +0000, Ben Horgan wrote:
>>>> +static inline void mpam_thread_switch(struct task_struct *tsk)
>>>> +{
>>>> +	u64 oldregval;
>>>> +	int cpu = smp_processor_id();
>>>> +	u64 regval = mpam_get_regval(tsk);
>>>> +
>>>> +	if (!static_branch_likely(&mpam_enabled))
>>>> +		return;
>>>> +
>>>> +	if (regval == READ_ONCE(arm64_mpam_global_default))
>>>> +		regval = READ_ONCE(per_cpu(arm64_mpam_default, cpu));
>>>> +
>>>> +	oldregval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
>>>> +	if (oldregval == regval)
>>>> +		return;
>>>> +
>>>> +	write_sysreg_s(regval, SYS_MPAM1_EL1);
>>>> +	isb();
>>>> +
>>>> +	/* Synchronising the EL0 write is left until the ERET to EL0 */
>>>> +	write_sysreg_s(regval, SYS_MPAM0_EL1);
>>>
>>> Since we have an isb() already, does it make any difference if we write
>>> MPAM0 before the barrier? Similar question for other places where we
>>> write these two registers.
>>
>> The reason for the isb() placement is to document that it's not required
>> for the MPAM0_EL1. All instructions running at EL1take their MPAM
>> configuration from MPAM1_EL1. This includes LDTR and STTR as you asked
>> about in a different thread.
> 
> It's fine to keep it this way if LDTR/STTR are not affected by the MPAM0
> register.
> 
>>>> +
>>>> +	WRITE_ONCE(per_cpu(arm64_mpam_current, cpu), regval);
>>>
>>> Is it too expensive to read the MPAM sysregs and avoid carrying around
>>> another per-CPU state? You use it for pm restoring but we could just
>>> save it in cpu_do_suspend() like other sysregs. Not a big issue, it just
>>> feels like this function got unnecessarily complicated (it took me a bit
>>> to figure out what it all does).
>>
>> It's done this way as it matches what's done in x86. I expect it would
>> be cheap enough to read the register to check whether a write is required.
> 
> Since you use it for CPU suspend/resume, I guess it's fine, it saves us
> from having to preserve it in the low-level asm sleep code. I don't have
> a strong preference either way.
> 
>>> A related question - is resctrl_arch_set_cdp_enabled() always called in
>>> non-preemptible contexts? We potentially have a race between setting
>>> current->mpam_partid_msg and arm64_mpam_global_default, so the check in
>>> mpam_thread_switch() can get confused.
>>
>> The resctrl filesystem can only ever get mounted once and
>> resctrl_arch_set_cdp_enabled() is always called in mount. In
>> rdt_get_tree(), rdt_enable_ctx() calls resctrl_arch_set_cdp_enabled().
>> This is done while holding the rdtgroup_mutex and the user can't change
>> the mpam configuration from the default until the mutex is released and
>> it can claim it.
> 
> What if resctrl_arch_set_cdp_enabled() gets preempted between updating
> current task partid and setting arm64_mpam_global_default? The mutex
> doesn't help.

I see, I had misinterpreted your question.

When looking into this I spotted that the per-cpu default,
arm64_mpam_default, is not updated on the cdp enable and so the default
tasks carry on running with the non-cdp default pmg/partid configuration.

On the race itself, if current->mpam_partid_pmg is set but not
arm64_mpam_global_default then if the current task is preempted at that
point there is a discrepancy. When the task gets context switched back
in then the comparison in mpam_thread_switch() will be false when true
would be expected.

In order to update arm64_mpam_default and make sure the mpam variables
and registers for the online cpus are in the right state by the end of
resctrl_arch_set_cdp_enabled() I'll add a per cpu call to
resctrl_arch_sync_cpu_closid_rmid(). I'll also add something in the
resume path so that arm64_mpam_default gets set correctly for the cpus
that were offline.

> 
>>> And I couldn't figure out where the MPAMx_EL1 registers are written. If
>>> any global/per-cpu/per-task value is changed, does the kernel wait until
>>> the next thread switch to write the sysreg? The only places I can found
>>> touching these sysregs are the thread switch, pm notifiers and KVM.
>>
>> If the task configuration is changed then the MPAM sysreg will only be
>> updated the next time it goes into the kernel.
> 
> Is it updated when it goes into the kernel or when we have a context
> switch? If you have a long-running user thread that is never scheduled
> out, it may not notice the update even if it entered the kernel (but no
> context switch).

Yes, only on context switch.

> 
>> So, just eventually
>> consistent. For cpu configuration, update_closid_rmid() gets called
>> which ipis the cpus and ends up calling mpam_thread_switch() from
>> resctrl_arch_sched_in().
> 
> I see, it should be fine.
> 

Thanks,

Ben

