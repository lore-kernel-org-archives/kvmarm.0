Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FC038399C;
	Mon,  3 Aug 2026 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785775126; cv=none; b=M8fB3i5VPdaX0DPitk92plTL9XgKVEwWExK7ot8rJaAe3xsZ8paFNkeZIHxUq8+y5ySE7va34kbu07PkjfmNA3lmvlRSURYR48kWO1jKKpo6mE1EU1HjAKjgZCHGJjRMw3DbRlwrye94dmAyIhAsthjhIxz8foMtfZYP9ks69gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785775126; c=relaxed/simple;
	bh=AmCcD4dR0zVYogWPFJ/bGl+yWYPUBbEZ63FxXrJpkQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=QmDghXUQkGB81YV0PzdOKIcx1nzrUdnBbRjXLJyYxO9N11+bMbnKx2uL/M+tKld7j/85AZQV+/5GzTwKi44M6lKmlkzq3hfl+yHbgheGbUEftZu3RmxwMr5JyFuU/UoakdpzvWGhiq7CSqlzNO6UVF0Qipj7waGZQk8duW1c32U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hdUXt1yU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hdUXt1yU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 93779143D;
	Mon,  3 Aug 2026 09:38:39 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A01023F86F;
	Mon,  3 Aug 2026 09:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785775123; bh=AmCcD4dR0zVYogWPFJ/bGl+yWYPUBbEZ63FxXrJpkQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdUXt1yUWJXklQWVEiMjiWwV8+587ycQsTv4tA3oKPQs1rG13U/n6gUIEoYRYNaxN
	 Zi8Nf4Wek3M3hJ2fUGU9f4NPTwLz1260dEc/rkw9WgF0JuiJXF1lmTlm4ocKGGJKEE
	 WOfEVkCVFyLlM+WeKvEi+v+sKENifLXNpl9YO+YY=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 11/11] KVM: arm64: Enable KVM_HW_DIRTY_BIT
Date: Mon,  3 Aug 2026 17:38:40 +0100
Message-ID: <anDEEJIfwbHmMi1X@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729112918.C51721F000E9@smtp.kernel.org>
References: <20260729104548.3439958-1-leo.bras@arm.com> <20260729104548.3439958-12-leo.bras@arm.com> <20260729112918.C51721F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 11:29:18AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [Critical] Direct accesses to EL2 system registers from EL1 cause host panics on nVHE and pKVM configurations.
> - [High] Writes to control-plane system registers are missing immediate `isb()` synchronization instructions.
> - [High] Unbounded hardware polling loop with preemption disabled.
> - [Medium] Preempt notifier is registered within an atomic section where preemption is inherently disabled.
> --
> 
> --- Patch [11]: [PATCH v3 11/11] KVM: arm64: Enable KVM_HW_DIRTY_BIT ---
> commit 9dec1efff0823ef68d8ee166e3fa545263373c0f
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Enable KVM_HW_DIRTY_BIT
>     
> Set the corresponding bit to enable hardware accelerated dirty-bitmap and
> dirty-ring cleaning for arm64. Actually using acceleration depends on the
> cpus enabling FEAT_HACDBS as well as the pre-requisite features for it,
> such as FEAT_HDBSS and FEAT_HAFDBS.
> 
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 449154f9a4852..3264d8ca093e3 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -34,6 +34,7 @@ menuconfig KVM
> >  	select HAVE_KVM_IRQ_BYPASS
> >  	select HAVE_KVM_READONLY_MEM
> >  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
> > +	select HAVE_KVM_HW_DIRTY_BIT
> >  	select SCHED_INFO
> >  	select GUEST_PERF_EVENTS if PERF_EVENTS
> >  	select KVM_GUEST_MEMFD
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > new file mode 100644
> > index 0000000000000..ca9cfefe0893b
> > --- /dev/null
> > +++ b/arch/arm64/kvm/dirty_bit.c
> > @@ -0,0 +1,438 @@
> [ ... ]
> > +static void hacdbs_start(u64 *hw_entries, int size)
> > +{
> > +	u64 br;
> > +	/* Each entry is 8 bytes */
> > +	int size_b = size * sizeof(hw_entries[0]);
> > +	int size_p2 = max(roundup_pow_of_two(size_b), PAGE_SIZE);
> > +
> > +	/* If not using the full size of the array, put a stop entry at the end */
> > +	if (size_b < size_p2)
> > +		hw_entries[size] = HDBSS_ENTRY_VALID | HDBSS_ENTRY_TTWL_RESV;
> > +
> > +	sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
> > +			   HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);
> 
> [Severity: Critical]
> Can this code cause a host panic on nVHE and pKVM configurations?

It's VHE only

> 
> The code directly attempts to read and write EL2 registers, which triggers
> a synchronous undefined exception at EL1. Since kvm_arch_dirty_clear_enabled()
> only checks for system_supports_hacdbs() and does not enforce has_vhe(),
> could an unprivileged userspace application reliably crash the host by
> triggering this on non-VHE hardware?
> 
> [Severity: High]
> Does this code allow the CPU pipeline to observe architecturally undefined
> state? 
> 
> The ARM64 subsystem rules require an isb() as the very next instruction
> following a control-plane sysreg write. Here, SYS_HACDBSCONS_EL2 is modified
> but several instructions and variable assignments occur before an isb() is
> reached.

Already commented on a early patch.

> 
> > +
> > +	br = (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
> > +	     FIELD_PREP(HACDBSBR_EL2_SZ, ilog2(size_p2) - 12) |
> > +	     FIELD_PREP(HACDBSBR_EL2_EN, 1);
> > +
> > +	/* All writes to the array have to complete before starting */
> > +	dsb(ishst);
> > +
> > +	write_sysreg_s(br, SYS_HACDBSBR_EL2);
> > +	isb();
> > +}
> [ ... ]
> > +static void hacdbs_sched_in(struct preempt_notifier *notifier, int cpu)
> > +{
> > +	struct hacdbs_sched_save *save = container_of(notifier,
> > +						      struct hacdbs_sched_save,
> > +						      notifier);
> > +
> > +	write_sysreg_s(save->save.vtcr_el2, SYS_VTCR_EL2);
> > +	write_sysreg_s(save->save.vttbr_el2, SYS_VTTBR_EL2);
> > +	isb();
> 
> [Severity: High]
> Can this missing synchronization lead to unpredictable execution?
> 
> The ARM64 subsystem rules require an isb() as the very next instruction
> following a control-plane sysreg write, but SYS_VTCR_EL2 is written followed
> by SYS_VTTBR_EL2 before the isb() is issued.
> 

iden

> > +
> > +	if (save->save.hcr_vm_set) {
> > +		sysreg_clear_set_hcr(0, HCR_EL2_VM);
> > +		isb();
> > +	}
> > +
> > +	write_sysreg_s(save->save.hacdbscons_el2, SYS_HACDBSCONS_EL2);
> > +	write_sysreg_s(save->save.hacdbsbr_el2, SYS_HACDBSBR_EL2);
> > +	isb();
> 
> [Severity: High]
> Is another isb() required here?
> 
> SYS_HACDBSCONS_EL2 is written followed by SYS_HACDBSBR_EL2 without
> an intervening isb(). Does this sequence allow the CPU pipeline to observe
> stale configurations?
> 

iden

> > +}
> [ ... ]
> > +static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
> > +{
> > +	int ret;
> > +	u64 cons;
> > +	struct hacdbs_sched_save save;
> > +
> > +	preempt_notifier_init(&save.notifier, &hacdbs_preempt_ops);
> > +	preempt_disable();
> > +	preempt_notifier_register(&save.notifier);
> > +	preempt_enable();
> 
> [Severity: Medium]
> Are these preempt notifiers effectively dead code on standard kernels?
> 
> The calling functions (__kvm_arch_dirty_log_clear and
> __kvm_arch_dirty_ring_clear) acquire write_lock(&kvm->mmu_lock) before
> this code runs.
> 
> Since the mmu_lock rwlock already disables preemption, this region cannot be
> preempted. If the hardware cleaning takes a long time, won't the thread
> stall rather than cleanly context switching?
> 

iden

> > +
> > +	__load_stage2(&kvm->arch.mmu);
> > +	sysreg_clear_set_hcr(0, HCR_EL2_VM);
> > +	isb();
> 
> [Severity: Critical]
> Does this code also trigger a synchronous undefined exception at EL1?
> 
> Directly attempting to access EL2 registers from EL1 causes traps on non-VHE
> hardware.
> 

iden

> > +
> > +	hacdbs_start(hw_entries, size);
> > +
> > +	do {
> > +		cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
> > +		if (FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons))
> > +			break;
> > +
> > +		if (FIELD_GET(HACDBSCONS_EL2_INDEX, cons) >= size)
> > +			break;
> > +
> > +		udelay(1);
> > +	} while (true);
> 
> [Severity: High]
> Could this unbounded polling loop cause a hard lockup?
> 
> Since this runs under write_lock(&kvm->mmu_lock) with preemption disabled,
> if the hardware accelerator hangs, takes unusually long, or fails to set an
> error reason, the CPU will stall indefinitely. Should there be a timeout or
> fallback mechanism here?

iden

Leo
