Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224A434A3A5;
	Fri, 12 Jun 2026 19:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293955; cv=none; b=VKmyJjeeZUpeIni2SbtOJhjpFZxiTHft0SprTEpcz0y+3HtwCVDEDkzlhnRlGoC5ZRtWQudXOA0KL9uQspq3/M58j65B+GlceMJCidNJ0RmRUx7QTjjtcjAnMtNC83GP9fpg+/COKiG3RxQFAAyfmO8ZL15+P5kf0mAjF3WaV/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293955; c=relaxed/simple;
	bh=y5IGlluuSVjpl4D7/SfzqTuMfUT7DDi82TH/jWvgmWA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gJdChKFq5Hw3r+8iVTt5UmwdHSQKIk+xuwhkJ8b51OEXjM9MkPVl3HQuvLIqdRQ5eyvpha+iGZZcSu3N0wEuduTPoyMBWvFekDSx0PIkk13amjt3ks9xLQD+hQtrNrLR+5xfmmANlJLnPYN9yskaJ4UE5K7uPijg7UvqYxfffS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTDKDSJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTDKDSJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1201F00A3A;
	Fri, 12 Jun 2026 19:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781293953;
	bh=LQxA4KkmIJ1xqsjw0+j8jdFHElQuXhSSEVDQJCET3Lg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HTDKDSJCagOcV+cUmB5BusFpDTD5VKxKJHhQLsSXcOkxaPMrZR/VjdiU/ZWeY7996
	 sAT7YUQQZEQqH+HtefVRPGYNe/mR/EWnX5OkjQSKbhXC/c9nGawQeNCNiTSd1B7aNY
	 9ZwWHc+tElVObp3JvEnNWgUTCWli/YihvZM/gXwotKZen+vlDMZTrI/PGKpP4KuIKn
	 o9T8nVuJ0CQ7LMn1YdlopY7B9nCcZ+tDvQnGBwTmKF3vyMIBcvymaW7lTN9+8HhHUs
	 0S74dZV7rxPmBETuZiPuZwPjNokpmKBFOgzEOvQD/7gV+8drNM3BuRIkixBb768Lwq
	 G5NPMvxSa/TUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/21] KVM: arm64: Set up MDCR_EL2 to handle a
 Partitioned PMU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260612192909.1153907-11-coltonlewis@google.com>
References: <20260612192909.1153907-11-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:52:33 +0000
Message-Id: <20260612195233.6D1201F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Critical] MDCR_EL2_HPMN update is incorrectly gated by FEAT_FGT, breakin=
g hardware PMU isolation and allowing guest escapes on non-FGT CPUs.
- [High] Unconditional restriction of PMU counters for non-partitioned VMs =
based on host capabilities.
- [High] Evaluating a per-CPU variable via `this_cpu_ptr()` from a preempti=
ble context in `kvm_arm_pmu_get_max_counters()`.
- [Medium] MDCR_EL2_HPME is set unconditionally for all VMs.

Pre-existing issues:
- [High] Missing Context Synchronization Event (isb) after writing to the M=
DCR_EL2 control-plane system register.
--

commit 414972a4abdb129c1ad96b121fefd7a789901b90
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Set up MDCR_EL2 to handle a Partitioned PMU

Set up MDCR_EL2 to handle a Partitioned PMU. If partitioned, set the
HPME, HPMD, and HCCD bits. If we have the ability to use Fine Grain
Traps (FEAT_FGT) also, unset the TPM and TPMCR bits that trap all PMU
accesses and set HPMN to the correct number of guest counters so
hardware enforces the right values.

> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index f4d7b12045e8f..c84321277d893 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c

[ ... ]

> @@ -43,14 +43,35 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *v=
cpu)
>  	vcpu->arch.mdcr_el2 =3D FIELD_PREP(MDCR_EL2_HPMN, *host_data_ptr(nr_eve=
nt_counters));
>  	vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_TPM |
>  				MDCR_EL2_TPMS |
>  				MDCR_EL2_TTRF |
>  				MDCR_EL2_TPMCR |
>  				MDCR_EL2_TDRA |
> -				MDCR_EL2_TDOSA);
> +				MDCR_EL2_TDOSA |
> +				MDCR_EL2_HPME);

[Severity: Medium]
The commit message states "If partitioned, set the HPME, HPMD, and HCCD bit=
s",
but MDCR_EL2_HPME is added to the unconditional bitmask here. Does this lea=
ve
an inactive state bit that could cause unpredictable interactions in nested
virtualization environments for non-partitioned VMs?

> +
> +	if (kvm_pmu_is_partitioned(vcpu->kvm)) {
> +		u8 nr_guest_cntr =3D vcpu->kvm->arch.nr_pmu_counters;
> +
> +		vcpu->arch.mdcr_el2 |=3D (MDCR_EL2_HPMD | MDCR_EL2_HCCD);
> +
> +		/*
> +		 * Take out the coarse grain traps if we are using
> +		 * fine grain traps and enforce counter access with
> +		 * HPMN.
> +		 */
> +		if (!vcpu_on_unsupported_cpu(vcpu) &&
> +		    cpus_have_final_cap(ARM64_HAS_FGT) &&
> +		    (cpus_have_final_cap(ARM64_HAS_HPMN0) || nr_guest_cntr > 0)) {
> +			vcpu->arch.mdcr_el2 &=3D ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR | MDCR_EL2_H=
PMN);
> +			vcpu->arch.mdcr_el2 |=3D FIELD_PREP(MDCR_EL2_HPMN, nr_guest_cntr);
> +		}

[Severity: Critical]
Is it safe to gate the MDCR_EL2_HPMN update behind the ARM64_HAS_FGT
capability check?

If FEAT_FGT is absent, HPMN remains equal to the total number of event
counters. While KVM falls back to trapping PMU accesses via TPM=3D1 on non-=
FGT
CPUs, when the PMU is guest-owned, the trap handlers can write unmasked
guest values directly to the hardware register:

arch/arm64/kvm/sys_regs.c:pmu_reg_write() {
    if (kvm_pmu_get_access(vcpu) =3D=3D VCPU_PMU_ACCESS_GUEST_OWNED) {
        if (set)
            write_sysreg(val, pmcntenset_el0);
    ...
}

Since KVM executes at EL2 and HPMN equals the total number of event counter=
s,
could this bypass hardware protections and allow a guest to overwrite host
performance counters on non-FGT CPUs?

[Severity: High]
This is a pre-existing issue, but I noticed that after MDCR_EL2 is updated
directly when has_vhe() is true in kvm_arm_setup_mdcr_el2():

arch/arm64/kvm/debug.c:kvm_arm_setup_mdcr_el2() {
    ...
    if (has_vhe())
        write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);

    preempt_enable();
}

There is no isb() immediately following the write to this control-plane
register. Because KVM immediately accesses PMU registers that depend on
MDCR_EL2 state (like writing to PMCNTENSET_EL0 after returning to
pmu_reg_write), could it observe architecturally undefined pipeline state?

> +
> +
> +	}
> =20
>  	/* Is the VM being debugged by userspace? */
>  	if (vcpu->guest_debug)

[ ... ]

> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 9ad3520417413..55cda8021400a 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c

[ ... ]

> @@ -552,6 +552,13 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
>  		return 1;
> =20
> +	/*
> +	 * If partitioned then we are limited by the max counters in
> +	 * the guest partition.
> +	 */
> +	if (pmu_is_partitioned(arm_pmu))
> +		return arm_pmu->max_guest_counters;

[Severity: High]
Does this incorrectly restrict the returned counters for all VMs on a
partitioned host?

By using pmu_is_partitioned(arm_pmu) which checks the host capability, rath=
er
than kvm_pmu_is_partitioned(kvm) which checks if the specific VM has opted
into the feature, this limits the counters to arm_pmu->max_guest_counters
even for non-partitioned VMs that safely use perf_event multiplexing.

Could this degrade PMU capabilities for non-partitioned VMs and break live
migration?

[Severity: High]
Can evaluating pmu_is_partitioned() here trigger a BUG splat?

kvm_arm_pmu_get_max_counters() is called from preemptible contexts during VM
configuration, and pmu_is_partitioned() evaluates a per-CPU variable:

arch/arm64/kvm/pmu-direct.c:pmu_is_partitioned() {
    ...
    return pmu->max_guest_counters >=3D 0 &&
        pmu->max_guest_counters <=3D *host_data_ptr(nr_event_counters);
}

Since host_data_ptr() uses this_cpu_ptr(), could accessing this CPU-local
variable with preemption enabled result in a BUG splat for using
smp_processor_id() in preemptible contexts?

> +
>  	/*
>  	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
>  	 * Ignore those and return only the general-purpose counters.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D10
