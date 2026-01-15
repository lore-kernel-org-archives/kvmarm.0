Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536053D7D19
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499906; cv=none; b=Mo7i5x2Kby+4yEeEhOlt5m7BFcLP9d6K2VTJZPMa+nmE7Eruzt4XAbNZ3lC1E2LF+5Tx0z7atbqZU97Xq3saj9JosIMlOwpAEx5Y5jNEAWlD0f1VPz/O0Ll4pUwuhAITSaSrXTdJqfxt2Z+lflUUljNd1HlAERyIRSBsb/Vd434=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499906; c=relaxed/simple;
	bh=1wN3PPHtPVqGIWnYZebrBVaw2Ke0fEyBoqFnxD+ZMzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fezVnBXDk/e53zAeN+BXL5+AU09dCKoePEj0w0EwBpQX9IiivINcx42GRb67dGD2JFi5rudZWyVnOWaB1DgFnKXKjY3exXXv6qgQyy7HwXAQBhcVotgdq6M7+HdVrFOoDinA5ru5ItLQI6zyV42g4o6tiH66fEFYxRIrc/4qeQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC2261515;
	Thu, 15 Jan 2026 09:58:16 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3ADC73F632;
	Thu, 15 Jan 2026 09:58:18 -0800 (PST)
Date: Thu, 15 Jan 2026 17:58:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	peternewman@google.com, punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com, reinette.chatre@intel.com,
	rohit.mathew@arm.com, scott@os.amperecomputing.com,
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com, will@kernel.org, corbet@lwn.net,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 06/47] arm64: mpam: Context switch the MPAM registers
Message-ID: <aWkqt37FJ5l6QD0E@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-7-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112165914.4086692-7-ben.horgan@arm.com>

On Mon, Jan 12, 2026 at 04:58:33PM +0000, Ben Horgan wrote:
>  menu "ARMv8.5 architectural features"
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> new file mode 100644
> index 000000000000..14011e5970ce
> --- /dev/null
> +++ b/arch/arm64/include/asm/mpam.h
> @@ -0,0 +1,67 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2025 Arm Ltd. */
> +
> +#ifndef __ASM__MPAM_H
> +#define __ASM__MPAM_H
> +
> +#include <linux/jump_label.h>
> +#include <linux/percpu.h>
> +#include <linux/sched.h>
> +
> +#include <asm/sysreg.h>
> +
> +DECLARE_STATIC_KEY_FALSE(mpam_enabled);
> +DECLARE_PER_CPU(u64, arm64_mpam_default);
> +DECLARE_PER_CPU(u64, arm64_mpam_current);
> +
> +/*
> + * The value of the MPAM0_EL1 sysreg when a task is in resctrl's default group.
> + * This is used by the context switch code to use the resctrl CPU property
> + * instead. The value is modified when CDP is enabled/disabled by mounting
> + * the resctrl filesystem.
> + */
> +extern u64 arm64_mpam_global_default;
> +
> +/*
> + * The resctrl filesystem writes to the partid/pmg values for threads and CPUs,
> + * which may race with reads in mpam_thread_switch(). Ensure only one of the old
> + * or new values are used. Particular care should be taken with the pmg field as
> + * mpam_thread_switch() may read a partid and pmg that don't match, causing this
> + * value to be stored with cache allocations, despite being considered 'free' by
> + * resctrl.
> + */
> +#ifdef CONFIG_ARM64_MPAM
> +static inline u64 mpam_get_regval(struct task_struct *tsk)
> +{
> +	return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);
> +}
> +
> +static inline void mpam_thread_switch(struct task_struct *tsk)
> +{
> +	u64 oldregval;
> +	int cpu = smp_processor_id();
> +	u64 regval = mpam_get_regval(tsk);
> +
> +	if (!static_branch_likely(&mpam_enabled))
> +		return;
> +
> +	if (regval == READ_ONCE(arm64_mpam_global_default))
> +		regval = READ_ONCE(per_cpu(arm64_mpam_default, cpu));
> +
> +	oldregval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
> +	if (oldregval == regval)
> +		return;
> +
> +	write_sysreg_s(regval, SYS_MPAM1_EL1);
> +	isb();
> +
> +	/* Synchronising the EL0 write is left until the ERET to EL0 */
> +	write_sysreg_s(regval, SYS_MPAM0_EL1);

Since we have an isb() already, does it make any difference if we write
MPAM0 before the barrier? Similar question for other places where we
write these two registers.

At some point, we should go through __switch_to() and coalesce the isbs
into fewer as we keep accumulating them (e.g. all those switch function
setting some sync variable if needed).

> +
> +	WRITE_ONCE(per_cpu(arm64_mpam_current, cpu), regval);

Is it too expensive to read the MPAM sysregs and avoid carrying around
another per-CPU state? You use it for pm restoring but we could just
save it in cpu_do_suspend() like other sysregs. Not a big issue, it just
feels like this function got unnecessarily complicated (it took me a bit
to figure out what it all does).

A related question - is resctrl_arch_set_cdp_enabled() always called in
non-preemptible contexts? We potentially have a race between setting
current->mpam_partid_msg and arm64_mpam_global_default, so the check in
mpam_thread_switch() can get confused.

And I couldn't figure out where the MPAMx_EL1 registers are written. If
any global/per-cpu/per-task value is changed, does the kernel wait until
the next thread switch to write the sysreg? The only places I can found
touching these sysregs are the thread switch, pm notifiers and KVM.

-- 
Catalin
