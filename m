Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2D537206A;
	Fri, 12 Jun 2026 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781294288; cv=none; b=frk6GTnTG/Z8u57rH2oRNZ63yXYzax5mvHDYfQjEV/xI29+vQOPZmBXpyIx16tr3GO2x/TUO0aXe4VeEniFj8qmGlsCzBwPoPeBjYmoG+LAW4zMaYiFucFI+jn++Rvbkug+DSDpO3C0jZyjpX5veGHrA8oMf+YlEEafxgSrvDeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781294288; c=relaxed/simple;
	bh=bJOLKZvTiWI9KOvDKgZWVmthgbVZoffi36ioc8ETaUw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fyXhpjH8R9EXI3QlR+QZqF9BvHRCBqg5ezjckeIOYOjNmHIB96gbTq4b1DKRgaB5l/SlfBfLXzFDMaBpXiesOXOEmlzzkH4CFP4T5PuIqd3j8o/OVfN3UPwc+a52+gZ7gVVhf9Zyl3otjHJiXRldUsNMUlBZM3xjyjZ2m96ESj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAjrDYIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAjrDYIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C5A1F000E9;
	Fri, 12 Jun 2026 19:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781294286;
	bh=iZ5H/kR1eTEeXA7ny9mMFOt69thTVQMgQELSd28aGNM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lAjrDYIeNdaxQgKOfODb7jxRaQb0ls8SzbjbkFMYIDTWIukSw4blY8rYep1kA5pSQ
	 jHhgO3vYrNKW0o2zwR8fwPAR5wIU7JDM7jiShjzQ2cjPm+NRlDgOpY3xthnis2MOJi
	 Kd6+RO5bF75polwLBzYHdeRRjDf8JBHnlj6H6AQ88yyTm5LI6CxQT+tg1beZu2uqie
	 6ndg+0IgItPM1Iw0l1RdYzKFlle+4R0ZWFjgk6lMy+tpetzt2rmYb4eyVfKt6mD3mG
	 H+2eisLJcsT9GwPKb7nYMJIcgIDPu/ncJbvEIRIPx/VJAQMTmkqAWSOxvpEmtGNHio
	 gunuT48/qoFRg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/21] KVM: arm64: Detect overflows for the Partitioned
 PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org
In-Reply-To: <20260612192909.1153907-18-coltonlewis@google.com>
References: <20260612192909.1153907-18-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:58:06 +0000
Message-Id: <20260612195806.82C5A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Missing return and failure to synchronize hardware registers when =
transitioning to VCPU_PMU_ACCESS_GUEST_OWNED drops interrupts and corrupts =
guest PMU state.
- [High] kvm_pmu_part_overflow_status() evaluates overflow using stale soft=
ware PMOVSSET_EL0 instead of the physical register when the PMU is guest-ow=
ned, missing hardware overflows.
- [Low] Unused prototype for `kvm_pmu_overflow_status` left in header.

Pre-existing issues:
- [High] Non-atomic read-modify-write of PMOVSSET_EL0 in hardirq context co=
rrupts concurrent process-context writes.
- [High] Missing required `isb()` synchronization immediately following a w=
rite to the `pmcr_el0` control-plane system register.
--

commit df42d2108e88f67258ce6c2dfa8340d8d1ee7a87
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Detect overflows for the Partitioned PMU
   =20
When we re-enter the VM after handling a PMU interrupt, calculate
whether it was any of the guest counters that overflowed and inject an
interrupt into the guest if so.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 64f40cfb31012..0062d1d8e1999 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c

[Severity: High]
This isn't a bug introduced by this patch, but looking at
kvm_pmu_direct_pmcr_write() in this file, is there a missing isb() after
writing the control register?

arch/arm64/kvm/pmu-direct.c:kvm_pmu_direct_pmcr_write() {
    write_sysreg(val, pmcr_el0);
    if (reset_p) {
...
}

Architectural rules require every write to a control-plane system register
to be followed by an isb() as the very next instruction. Since it is follow=
ed
immediately by a conditional branch, can the pipeline observe undefined sta=
te?

> @@ -426,4 +426,52 @@ void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u=
64 pmovsr)
>  		return;
> =20
>  	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=3D, govf);

[Severity: High]
This is a pre-existing issue, but does this non-atomic read-modify-write
in hardirq context corrupt concurrent process-context writes?

When the physical PMU interrupt handler calls kvm_pmu_handle_guest_irq(), it
executes this macro in hardirq context. Concurrently, the VM-exit path
(access_pmovs()) can execute the same macro in process context with
interrupts enabled.

If the hardware interrupt preempts the process context between the read and
write phases, could the process context overwrite the sysreg with its stale
read and silently drop the overflow bits?

> +
> +	if (kvm_pmu_part_overflow_status(vcpu)) {
> +		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> +
> +		if (!in_nmi())
> +			kvm_vcpu_kick(vcpu);
> +		else
> +			irq_work_queue(&vcpu->arch.pmu.overflow_work);
> +	}
> +}
> +
> +/**
> + * kvm_pmu_part_overflow_status() - Determine if any guest counters have=
 overflowed
[ ... ]
> +bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
> +{
> +	struct arm_pmu *pmu;
> +	u64 mask, pmovs, pmint, pmcr;
> +	bool overflow;
> +
> +	pmu =3D vcpu->kvm->arch.arm_pmu;
> +	mask =3D kvm_pmu_guest_counter_mask(pmu);
> +
> +	if (vcpu->arch.pmu.access =3D=3D VCPU_PMU_ACCESS_FREE) {
> +		pmovs =3D __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
> +		pmint =3D __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
> +		pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0);
> +
> +		if ((pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint))
> +			kvm_pmu_set_guest_owned(vcpu);
> +		else
> +			return false;
> +	}
> +

[Severity: High]
Does this fall through to read uninitialized hardware state?

When a virtual overflow is detected and kvm_pmu_set_guest_owned() is called,
it transitions the state but there is no return true; here. Execution falls
through to unconditionally read the physical hardware registers below.

Additionally, looking at kvm_pmu_set_guest_owned(), it grants direct
hardware access via MDCR_EL2 but fails to invoke kvm_pmu_load() to populate
the hardware PMU with the guest's context.

Since the hardware wasn't loaded, could these reads return host state,
causing the calculation to evaluate to false and drop the pending interrupt?

> +	pmovs =3D __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
> +	pmint =3D read_pmintenset();
> +	pmcr =3D read_pmcr();

[Severity: High]
Does this evaluate overflow using stale software state instead of the
physical register when the PMU is guest-owned?

When the PMU is guest-owned, physical hardware overflows update the physical
register. The software context is only synchronized during kvm_pmu_put().

Since this is called during guest exit via kvm_pmu_sync_hwstate() before
kvm_pmu_put() runs, could unconditionally reading the software context via
__vcpu_sys_reg() evaluate against stale state and miss physical hardware
overflows?

> +	overflow =3D (pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint);
> +
> +	return overflow;
>  }

[ ... ]

> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 25163a689ae80..f72d080ee7ba2 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -93,6 +93,8 @@ bool kvm_set_pmuserenr(u64 val);
>  void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_pmu_resync_el0(void);
> +bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu);
> +bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu);

[Severity: Low]
Since kvm_pmu_overflow_status() was renamed to kvm_pmu_emul_overflow_status=
()
in this patch, should the old prototype be removed from this header file?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D17
