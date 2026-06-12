Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C133148DA;
	Fri, 12 Jun 2026 19:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781294266; cv=none; b=bmyPbF/kFeLCw22wV8ClUFljtaiSD68mAOWwYqPhSIP45FBohOYt15RBcS88dqA2iZEU6mEGDPQ6hDzpg5WTS3MA2PDLUwoiyAk1jb2kor+c+6GkipPdHJ0qwSY8zWUBkWZ6GDPJCp7K1yPiE7TYFbljQqAD1ZuQ2BwKZx1lzRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781294266; c=relaxed/simple;
	bh=0ogKh3eALOfhgqghvmX5NuAIa06w4c8xW64JjIqomnQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FFWPgaL3KUpoZBqqrsUkMLDp0cFFxTPFeZ1WQubn3ZM/RFBPTeIHXphhAklqciAM3VtTr1ba07I+fFSPdi3qr3tEbqRwHc+s28LteT7vOx0GO4ln6knTHKqZxqthZQ3zcuo9YtF/IAfO0Mikh3EdZBDnQrlkOUkaCRZwtshDwTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNgiWjiG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNgiWjiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C851F000E9;
	Fri, 12 Jun 2026 19:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781294264;
	bh=SXJIXy8qPBlfNd7leBlkKg99ORW7RPKwzy7ieYkwFSw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DNgiWjiGg0jz1AzmFY6oEkmbLcfCDtEvQwBzD6HLkHv6b2sIJFT75cBD0Iz3AG1Oc
	 VkQ08v/LZT1/xf7gYn6DNQaL294Wsm96TVe7QHXjUoIsPZFKlp+oxr+wKwXNdpNk+y
	 Obl7eEC/jaS6mhadKnklLhdGY+bkFSDbRAZUShSYzO+UKGei+mKFWnolMuLGUIWG0W
	 GLVji+ETMibTqGAzoeFjS86XNGbkc7I0EGCTlNH8Ru6dIOOFuTE0qvxmW2Gixnnmad
	 Wi1TIeSMOjoPqoTLQv1+dEA4pdFfDRutH4rnU3Tw1YhjGeLVXXX7feo07qAUZogVOX
	 5TgVM3ZYJbbIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/21] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
 guest counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20260612192909.1153907-17-coltonlewis@google.com>
References: <20260612192909.1153907-17-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:57:44 +0000
Message-Id: <20260612195744.80C851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Host perf event overflows corrupt the virtual PMU state of run=
ning vCPUs.
- [High] KVM traps PMOVSCLR_EL0 but fails to read live hardware state, brea=
king guest PMU polling.
--

commit 18a5ac7857cf364463b827796f49cf7c00c6ef08
Author: Colton Lewis <coltonlewis@google.com>

perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters

Because ARM hardware is not yet capable of direct PPI injection into
guests, guest counters will still trigger interrupts that need to be
handled by the host PMU interrupt handler. Clear the overflow flags in
hardware to handle the interrupt as normal, but update the virtual
overflow register for later injecting the interrupt into the guest.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index bb1f3dca03869..64f40cfb31012 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
> @@ -405,3 +405,25 @@ void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu)

[ ... ]

> +/**
> + * kvm_pmu_handle_guest_irq() - Record IRQs in guest counters
> + * @pmu: PMU to check for overflows
> + * @pmovsr: Overflow flags reported by driver
> + *
> + * Set overflow flags in guest-reserved counters in the VCPU register
> + * for the guest to clear later.
> + */
> +void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr)
> +{
> +	struct kvm_vcpu *vcpu =3D kvm_get_running_vcpu();
> +	u64 mask =3D kvm_pmu_guest_counter_mask(pmu);
> +	u64 govf =3D pmovsr & mask;
> +
> +	write_pmovsclr(govf);
> +
> +	if (!vcpu)
> +		return;
> +
> +	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=3D, govf);

[Severity: Critical]
Can host perf event overflows corrupt the virtual pmu state of running vCPU=
s?

When the host pmu is partitioned, the host perf subsystem is allowed to use
the guest partition counters (0..hpmn) whenever the currently running vCPU
does not own the pmu (e.g., vCPUs using the emulated pmu).

However, kvm_pmu_host_counter_mask() unconditionally excludes these
counters from the host's clear mask. When a host event on these counters
overflows, the host irq handler leaves the hardware flag set and passes the
overflow to kvm_pmu_handle_guest_irq().

This code blindly applies the host overflow to the currently running vCPU's
PMOVSSET_EL0 software state without verifying if the vCPU actually owns
the pmu partition:

    vcpu->arch.pmu.access =3D=3D VCPU_PMU_ACCESS_GUEST_OWNED

Could this corrupt the virtual pmu state and inject spurious overflows
into innocent VMs?

> +}
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index c187397134990..6ab15a5209608 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -774,16 +774,15 @@ static void armv8pmu_disable_event_irq(struct perf_=
event *event)
>  	armv8pmu_disable_intens(BIT(event->hw.idx));
>  }
> =20
> -static u64 armv8pmu_getreset_flags(void)
> +static u64 armv8pmu_getovf_flags(void)
>  {
>  	u64 value;
> =20
>  	/* Read */
>  	value =3D read_pmovsclr();
> =20
> -	/* Write to clear flags */
> -	value &=3D ARMV8_PMU_CNT_MASK_ALL;
> -	write_pmovsclr(value);
> +	/* Only report interrupt enabled counters. */
> +	value &=3D read_pmintenset();

[Severity: High]
Does masking out overflow flags for counters without interrupts enabled bre=
ak
guest pmu polling?

KVM unconditionally traps guest accesses to PMOVSCLR_EL0 and PMOVSSET_EL0
(via FGT HDFGRTR_EL2_PMOVS) to prevent the guest from seeing host counter
overflows. However, the trap handlers (pmu_reg_read and pmu_reg_write
in arch/arm64/kvm/sys_regs.c) only interact with KVM's software shadow
state and ignore the live hardware pmovsclr_el0 register for guest-owned
counters.

Since this masks hardware overflows with read_pmintenset(), counters with
interrupts disabled will never trigger the host irq handler to sync the
shadow state.

Consequently, will a guest polling for overflows with pmu interrupts disabl=
ed
loop infinitely reading stale zeros and miss the overflow events entirely?

> =20
>  	return value;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D16
