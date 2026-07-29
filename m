Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A88B44E055;
	Wed, 29 Jul 2026 11:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785324560; cv=none; b=Tm5pdnsomGPxwIOlncILNV703G5kMPJjv3RwO+TOHkqtsigabBXDbySPCYtr7jzZloruQqPw1e3cou0+1dbHdAJFYu2Z3Gbv221HX4opY3xNSUTtPmwLYt9nke0IgG9AG7QXvrJcHWh/DyOOWQKhw34c3VcvLQ17mQcvysxLvpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785324560; c=relaxed/simple;
	bh=3dujk0xlQiyne+wr/hrffNb4dhXtQPBlWXvQl12kDAM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=baNs/o1RKiqKSbtG0RNu5iwwL4rzN4o8PZB0ZH4aFR9BV+5iPGyqYAfqucGVZn7TY6zWczWrlaO+4KemKEonOUH600byFSyM/svTFSKHwMvhM2mITKXSRJz6loIwNL1+qmWsGGwAdckg1hHkV/muUqf5TtRD0zSQhwpurzraORU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODlyJVGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODlyJVGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51721F000E9;
	Wed, 29 Jul 2026 11:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785324559;
	bh=LUNijxIQVDOkuunoq/M54XsQjVyHyhj2tJ6oEkR1+X0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ODlyJVGWkn+dTyjN2rLLmLmS5zJu3Gq/gcYPtYQMGyEYp8HkPpdYr6dMMYbIJZN49
	 KhddmOIKMNYYb7DVTxPWJbLA0Ji0FvffKBw0KZVjctFjRybFWTKLkt5PIOsNJnP871
	 bzl7upnT13YDDbMik3LdpSK5ZiGaHG6J6+cONYyFNL4hyNmaTT3XERwHOt74Ch4LoW
	 KaENJS3zbJo8/4Lfxz2GE4b4P23gCuPizDlpcxAIOiSGmgW6mcBJXj6yDUbos1yxcx
	 2ibFVJkUwH2IlZ2UCwKpxY2ZJNka4XSSwQjUHu2k3lrVGq9hcFxpODZIbYdO5G9Lee
	 n8OUylr9/5MEw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/11] KVM: arm64: Enable KVM_HW_DIRTY_BIT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260729104548.3439958-12-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
 <20260729104548.3439958-12-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 11:29:18 +0000
Message-Id: <20260729112918.C51721F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Direct accesses to EL2 system registers from EL1 cause host pa=
nics on nVHE and pKVM configurations.
- [High] Writes to control-plane system registers are missing immediate `is=
b()` synchronization instructions.
- [High] Unbounded hardware polling loop with preemption disabled.
- [Medium] Preempt notifier is registered within an atomic section where pr=
eemption is inherently disabled.
--

--- Patch [11]: [PATCH v3 11/11] KVM: arm64: Enable KVM_HW_DIRTY_BIT ---
commit 9dec1efff0823ef68d8ee166e3fa545263373c0f
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Enable KVM_HW_DIRTY_BIT
   =20
Set the corresponding bit to enable hardware accelerated dirty-bitmap and
dirty-ring cleaning for arm64. Actually using acceleration depends on the
cpus enabling FEAT_HACDBS as well as the pre-requisite features for it,
such as FEAT_HDBSS and FEAT_HAFDBS.

> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 449154f9a4852..3264d8ca093e3 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -34,6 +34,7 @@ menuconfig KVM
>  	select HAVE_KVM_IRQ_BYPASS
>  	select HAVE_KVM_READONLY_MEM
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
> +	select HAVE_KVM_HW_DIRTY_BIT
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
>  	select KVM_GUEST_MEMFD
> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> new file mode 100644
> index 0000000000000..ca9cfefe0893b
> --- /dev/null
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -0,0 +1,438 @@
[ ... ]
> +static void hacdbs_start(u64 *hw_entries, int size)
> +{
> +	u64 br;
> +	/* Each entry is 8 bytes */
> +	int size_b =3D size * sizeof(hw_entries[0]);
> +	int size_p2 =3D max(roundup_pow_of_two(size_b), PAGE_SIZE);
> +
> +	/* If not using the full size of the array, put a stop entry at the end=
 */
> +	if (size_b < size_p2)
> +		hw_entries[size] =3D HDBSS_ENTRY_VALID | HDBSS_ENTRY_TTWL_RESV;
> +
> +	sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
> +			   HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);

[Severity: Critical]
Can this code cause a host panic on nVHE and pKVM configurations?

The code directly attempts to read and write EL2 registers, which triggers
a synchronous undefined exception at EL1. Since kvm_arch_dirty_clear_enable=
d()
only checks for system_supports_hacdbs() and does not enforce has_vhe(),
could an unprivileged userspace application reliably crash the host by
triggering this on non-VHE hardware?

[Severity: High]
Does this code allow the CPU pipeline to observe architecturally undefined
state?=20

The ARM64 subsystem rules require an isb() as the very next instruction
following a control-plane sysreg write. Here, SYS_HACDBSCONS_EL2 is modified
but several instructions and variable assignments occur before an isb() is
reached.

> +
> +	br =3D (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
> +	     FIELD_PREP(HACDBSBR_EL2_SZ, ilog2(size_p2) - 12) |
> +	     FIELD_PREP(HACDBSBR_EL2_EN, 1);
> +
> +	/* All writes to the array have to complete before starting */
> +	dsb(ishst);
> +
> +	write_sysreg_s(br, SYS_HACDBSBR_EL2);
> +	isb();
> +}
[ ... ]
> +static void hacdbs_sched_in(struct preempt_notifier *notifier, int cpu)
> +{
> +	struct hacdbs_sched_save *save =3D container_of(notifier,
> +						      struct hacdbs_sched_save,
> +						      notifier);
> +
> +	write_sysreg_s(save->save.vtcr_el2, SYS_VTCR_EL2);
> +	write_sysreg_s(save->save.vttbr_el2, SYS_VTTBR_EL2);
> +	isb();

[Severity: High]
Can this missing synchronization lead to unpredictable execution?

The ARM64 subsystem rules require an isb() as the very next instruction
following a control-plane sysreg write, but SYS_VTCR_EL2 is written followed
by SYS_VTTBR_EL2 before the isb() is issued.

> +
> +	if (save->save.hcr_vm_set) {
> +		sysreg_clear_set_hcr(0, HCR_EL2_VM);
> +		isb();
> +	}
> +
> +	write_sysreg_s(save->save.hacdbscons_el2, SYS_HACDBSCONS_EL2);
> +	write_sysreg_s(save->save.hacdbsbr_el2, SYS_HACDBSBR_EL2);
> +	isb();

[Severity: High]
Is another isb() required here?

SYS_HACDBSCONS_EL2 is written followed by SYS_HACDBSBR_EL2 without
an intervening isb(). Does this sequence allow the CPU pipeline to observe
stale configurations?

> +}
[ ... ]
> +static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
> +{
> +	int ret;
> +	u64 cons;
> +	struct hacdbs_sched_save save;
> +
> +	preempt_notifier_init(&save.notifier, &hacdbs_preempt_ops);
> +	preempt_disable();
> +	preempt_notifier_register(&save.notifier);
> +	preempt_enable();

[Severity: Medium]
Are these preempt notifiers effectively dead code on standard kernels?

The calling functions (__kvm_arch_dirty_log_clear and
__kvm_arch_dirty_ring_clear) acquire write_lock(&kvm->mmu_lock) before
this code runs.

Since the mmu_lock rwlock already disables preemption, this region cannot be
preempted. If the hardware cleaning takes a long time, won't the thread
stall rather than cleanly context switching?

> +
> +	__load_stage2(&kvm->arch.mmu);
> +	sysreg_clear_set_hcr(0, HCR_EL2_VM);
> +	isb();

[Severity: Critical]
Does this code also trigger a synchronous undefined exception at EL1?

Directly attempting to access EL2 registers from EL1 causes traps on non-VHE
hardware.

> +
> +	hacdbs_start(hw_entries, size);
> +
> +	do {
> +		cons =3D read_sysreg_s(SYS_HACDBSCONS_EL2);
> +		if (FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons))
> +			break;
> +
> +		if (FIELD_GET(HACDBSCONS_EL2_INDEX, cons) >=3D size)
> +			break;
> +
> +		udelay(1);
> +	} while (true);

[Severity: High]
Could this unbounded polling loop cause a hard lockup?

Since this runs under write_lock(&kvm->mmu_lock) with preemption disabled,
if the hardware accelerator hangs, takes unusually long, or fails to set an
error reason, the CPU will stall indefinitely. Should there be a timeout or
fallback mechanism here?

> +
> +	ret =3D hacdbs_stop(size);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729104548.3439=
958-1-leo.bras@arm.com?part=3D11
