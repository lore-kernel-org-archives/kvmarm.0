Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F1A21638D
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768825408; cv=none; b=bv0MeGpupFhuoynR8nFeNvB67tyRKR+w1GZ0T2FAysyV7NbCzmR9FzGtr3OpXE8D6dLX73e+vHetFgLINjmQqL1KKvpMTsy/qDuRnuN+rYVift9DoB3LSDgqdH5oSFa01OuWHvza2rDl6P+BsjxGZQK1ZJIzDXzwfkC5zUg8jgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768825408; c=relaxed/simple;
	bh=aOy6FI7GeudVcvAEG/d42TKDEg3rmbhIQ3RHpbHxLTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GJrRv/8iO6IDt+4yfVD4w0qnbxy0cI2v4yCZS1NmDxgwS12otp7rGAQyQvNuMrJgquwbJWMSMXjcWPs8+qrqqeHnAGJ3Gr5AVeS5WAcyQBBCTomzzdrhNBxMaFGVHBbeiZYtu9+qtrbwExq6bdEucYWGifMMtiL4n/gHw94j1XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 367A5339;
	Mon, 19 Jan 2026 04:23:13 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0635F3F632;
	Mon, 19 Jan 2026 04:23:14 -0800 (PST)
Message-ID: <f19cab15-0626-4d13-b25e-1c194294e62f@arm.com>
Date: Mon, 19 Jan 2026 12:23:13 +0000
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
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aWkqt37FJ5l6QD0E@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Catalin,

On 1/15/26 17:58, Catalin Marinas wrote:
> On Mon, Jan 12, 2026 at 04:58:33PM +0000, Ben Horgan wrote:
>>  menu "ARMv8.5 architectural features"
>> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
>> new file mode 100644
>> index 000000000000..14011e5970ce
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/mpam.h
>> @@ -0,0 +1,67 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright (C) 2025 Arm Ltd. */
>> +
>> +#ifndef __ASM__MPAM_H
>> +#define __ASM__MPAM_H
>> +
>> +#include <linux/jump_label.h>
>> +#include <linux/percpu.h>
>> +#include <linux/sched.h>
>> +
>> +#include <asm/sysreg.h>
>> +
>> +DECLARE_STATIC_KEY_FALSE(mpam_enabled);
>> +DECLARE_PER_CPU(u64, arm64_mpam_default);
>> +DECLARE_PER_CPU(u64, arm64_mpam_current);
>> +
>> +/*
>> + * The value of the MPAM0_EL1 sysreg when a task is in resctrl's default group.
>> + * This is used by the context switch code to use the resctrl CPU property
>> + * instead. The value is modified when CDP is enabled/disabled by mounting
>> + * the resctrl filesystem.
>> + */
>> +extern u64 arm64_mpam_global_default;
>> +
>> +/*
>> + * The resctrl filesystem writes to the partid/pmg values for threads and CPUs,
>> + * which may race with reads in mpam_thread_switch(). Ensure only one of the old
>> + * or new values are used. Particular care should be taken with the pmg field as
>> + * mpam_thread_switch() may read a partid and pmg that don't match, causing this
>> + * value to be stored with cache allocations, despite being considered 'free' by
>> + * resctrl.
>> + */
>> +#ifdef CONFIG_ARM64_MPAM
>> +static inline u64 mpam_get_regval(struct task_struct *tsk)
>> +{
>> +	return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);
>> +}
>> +
>> +static inline void mpam_thread_switch(struct task_struct *tsk)
>> +{
>> +	u64 oldregval;
>> +	int cpu = smp_processor_id();
>> +	u64 regval = mpam_get_regval(tsk);
>> +
>> +	if (!static_branch_likely(&mpam_enabled))
>> +		return;
>> +
>> +	if (regval == READ_ONCE(arm64_mpam_global_default))
>> +		regval = READ_ONCE(per_cpu(arm64_mpam_default, cpu));
>> +
>> +	oldregval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
>> +	if (oldregval == regval)
>> +		return;
>> +
>> +	write_sysreg_s(regval, SYS_MPAM1_EL1);
>> +	isb();
>> +
>> +	/* Synchronising the EL0 write is left until the ERET to EL0 */
>> +	write_sysreg_s(regval, SYS_MPAM0_EL1);
> 
> Since we have an isb() already, does it make any difference if we write
> MPAM0 before the barrier? Similar question for other places where we
> write these two registers.

The reason for the isb() placement is to document that it's not required
for the MPAM0_EL1. All instructions running at EL1take their MPAM
configuration from MPAM1_EL1. This includes LDTR and STTR as you asked
about in a different thread.

> 
> At some point, we should go through __switch_to() and coalesce the isbs
> into fewer as we keep accumulating them (e.g. all those switch function
> setting some sync variable if needed).
> 
>> +
>> +	WRITE_ONCE(per_cpu(arm64_mpam_current, cpu), regval);
> 
> Is it too expensive to read the MPAM sysregs and avoid carrying around
> another per-CPU state? You use it for pm restoring but we could just
> save it in cpu_do_suspend() like other sysregs. Not a big issue, it just
> feels like this function got unnecessarily complicated (it took me a bit
> to figure out what it all does).

It's done this way as it matches what's done in x86. I expect it would
be cheap enough to read the register to check whether a write is required.

> 
> A related question - is resctrl_arch_set_cdp_enabled() always called in
> non-preemptible contexts? We potentially have a race between setting
> current->mpam_partid_msg and arm64_mpam_global_default, so the check in
> mpam_thread_switch() can get confused.

The resctrl filesystem can only ever get mounted once and
resctrl_arch_set_cdp_enabled() is always called in mount. In
rdt_get_tree(), rdt_enable_ctx() calls resctrl_arch_set_cdp_enabled().
This is done while holding the rdtgroup_mutex and the user can't change
the mpam configuration from the default until the mutex is released and
it can claim it.

> 
> And I couldn't figure out where the MPAMx_EL1 registers are written. If
> any global/per-cpu/per-task value is changed, does the kernel wait until
> the next thread switch to write the sysreg? The only places I can found
> touching these sysregs are the thread switch, pm notifiers and KVM.
> 

If the task configuration is changed then the MPAM sysreg will only be
updated the next time it goes into the kernel. So, just eventually
consistent. For cpu configuration, update_closid_rmid() gets called
which ipis the cpus and ends up calling mpam_thread_switch() from
resctrl_arch_sched_in().

Thanks,

Ben

