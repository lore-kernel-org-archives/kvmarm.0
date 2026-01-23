Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287B830EF9D
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769178592; cv=none; b=n+quy82JaAF5eZ21jpnY2dvMWYb5bgFymED5ZUcZY/fIHpZezfeucM3wdYReYVxFKE1RSxTZEQsM9o4/p/Ltu3fXOPO/iJ7bpG+wBJluS0h5Z04UUT2H8P/QmuzeJLRLknb8DfqddW+G/1w3TD1Foqm6613k5O1T0Bq31Pb5w+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769178592; c=relaxed/simple;
	bh=JJDLe7eGZExcD8LMBpiKoylkuVZWtIwWKnlEfY9Gwyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NaHxgB6DS8DE/5sYIeUDLl17lz08gRJ0mFNZH6iVn5IpC4s1SAuwME8+PLyGYrqbc9lt66DU/hbxYVAgI/yJay1PkFpkp81JRzL8xNYOrMIFqVPdxE7Nl+dgqzv879djPYBQNhljOupRHd4e7cYzlgotSQgvZE6yY6kXDSundFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CEE1B1476;
	Fri, 23 Jan 2026 06:29:43 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18F8F3F740;
	Fri, 23 Jan 2026 06:29:44 -0800 (PST)
Date: Fri, 23 Jan 2026 14:29:42 +0000
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
Message-ID: <aXOF1gYB_HEK8QPX@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-7-ben.horgan@arm.com>
 <aWkqt37FJ5l6QD0E@arm.com>
 <f19cab15-0626-4d13-b25e-1c194294e62f@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19cab15-0626-4d13-b25e-1c194294e62f@arm.com>

Hi Ben,

On Mon, Jan 19, 2026 at 12:23:13PM +0000, Ben Horgan wrote:
> On 1/15/26 17:58, Catalin Marinas wrote:
> > On Mon, Jan 12, 2026 at 04:58:33PM +0000, Ben Horgan wrote:
> >> +static inline void mpam_thread_switch(struct task_struct *tsk)
> >> +{
> >> +	u64 oldregval;
> >> +	int cpu = smp_processor_id();
> >> +	u64 regval = mpam_get_regval(tsk);
> >> +
> >> +	if (!static_branch_likely(&mpam_enabled))
> >> +		return;
> >> +
> >> +	if (regval == READ_ONCE(arm64_mpam_global_default))
> >> +		regval = READ_ONCE(per_cpu(arm64_mpam_default, cpu));
> >> +
> >> +	oldregval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
> >> +	if (oldregval == regval)
> >> +		return;
> >> +
> >> +	write_sysreg_s(regval, SYS_MPAM1_EL1);
> >> +	isb();
> >> +
> >> +	/* Synchronising the EL0 write is left until the ERET to EL0 */
> >> +	write_sysreg_s(regval, SYS_MPAM0_EL1);
> > 
> > Since we have an isb() already, does it make any difference if we write
> > MPAM0 before the barrier? Similar question for other places where we
> > write these two registers.
> 
> The reason for the isb() placement is to document that it's not required
> for the MPAM0_EL1. All instructions running at EL1take their MPAM
> configuration from MPAM1_EL1. This includes LDTR and STTR as you asked
> about in a different thread.

It's fine to keep it this way if LDTR/STTR are not affected by the MPAM0
register.

> >> +
> >> +	WRITE_ONCE(per_cpu(arm64_mpam_current, cpu), regval);
> > 
> > Is it too expensive to read the MPAM sysregs and avoid carrying around
> > another per-CPU state? You use it for pm restoring but we could just
> > save it in cpu_do_suspend() like other sysregs. Not a big issue, it just
> > feels like this function got unnecessarily complicated (it took me a bit
> > to figure out what it all does).
> 
> It's done this way as it matches what's done in x86. I expect it would
> be cheap enough to read the register to check whether a write is required.

Since you use it for CPU suspend/resume, I guess it's fine, it saves us
from having to preserve it in the low-level asm sleep code. I don't have
a strong preference either way.

> > A related question - is resctrl_arch_set_cdp_enabled() always called in
> > non-preemptible contexts? We potentially have a race between setting
> > current->mpam_partid_msg and arm64_mpam_global_default, so the check in
> > mpam_thread_switch() can get confused.
> 
> The resctrl filesystem can only ever get mounted once and
> resctrl_arch_set_cdp_enabled() is always called in mount. In
> rdt_get_tree(), rdt_enable_ctx() calls resctrl_arch_set_cdp_enabled().
> This is done while holding the rdtgroup_mutex and the user can't change
> the mpam configuration from the default until the mutex is released and
> it can claim it.

What if resctrl_arch_set_cdp_enabled() gets preempted between updating
current task partid and setting arm64_mpam_global_default? The mutex
doesn't help.

> > And I couldn't figure out where the MPAMx_EL1 registers are written. If
> > any global/per-cpu/per-task value is changed, does the kernel wait until
> > the next thread switch to write the sysreg? The only places I can found
> > touching these sysregs are the thread switch, pm notifiers and KVM.
> 
> If the task configuration is changed then the MPAM sysreg will only be
> updated the next time it goes into the kernel.

Is it updated when it goes into the kernel or when we have a context
switch? If you have a long-running user thread that is never scheduled
out, it may not notice the update even if it entered the kernel (but no
context switch).

> So, just eventually
> consistent. For cpu configuration, update_closid_rmid() gets called
> which ipis the cpus and ends up calling mpam_thread_switch() from
> resctrl_arch_sched_in().

I see, it should be fine.

-- 
Catalin
