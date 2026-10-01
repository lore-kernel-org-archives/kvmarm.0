Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4450192D8A
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864310; cv=none; b=WlcnS4IuyjW1XrkSfvbfNMe6v0ZNjhK+vcclAHeyxqBW2lW2RptAWLlo6wmOXNtW4OQMxF0mdmov7JDrSfoQ8kWu6kpp5m0EEF0oO7QLtwzCdufAAdVqh9JWsNDpUQquiMGd2fxmutvvXhTc9GGK61SBQ1QmkhbokG9Zg6ehs00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864310; c=relaxed/simple;
	bh=8p58d17GGNcviII3klkMwUjY4J5XBSmC4HXmivuITLg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RRrrC7CXGCINJpskpbmye0q+aHyNklAus8e3BbKqXSryx9yR1yTgmTjHbBMMRNgakRBtHWUlNEPpRhkIwvRh+cm0PQCM7ru0/T6BJPBKRRRLH/o87XdCRvmg6K8opfk6LPpRPbRggT1Mm68viNfL/RSMDmRgbwg4lhg5w4D+orQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VslM4tZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VslM4tZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97661F00899;
	Thu,  1 Oct 2026 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790864308;
	bh=V+jGmhE/o7C4pwee+6T89pLvv9OavUzQuLR8KTvtjLo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VslM4tZ4Vf9rbTBuT+CC8GwGePLiT5JhTqWytJMHydanjZEVItloY2qV2f3YhIvpk
	 8d10w0u3lCKwRQxVJuOBpvmRrccqBR0aCHQ3SOZXEfUxbgBgcMgqHB4nms4r9uSPK1
	 DvUUeVIoFsOrO806kS4NsaTdEU+oQcoHmI3qI2S9neESaaZP929dDWtoEcRkBfmyWJ
	 Y8sAFc0YMhgQEjCtaaVJtol5IceUsnsjzdGrQ/IRQomfVk0flq+N0disxbr2j9Bl5/
	 uZY5z+xQnpXFYl+5oBrBjSsdw4K5iOkfchFlPT8pwzIVBXgmt9QDDj/Wlxrlk4rgLv
	 iqzM3oDFPtXGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 16/18] KVM: arm64: Reject host power-on of a vCPU
 that EL2 holds powered off
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261001135711.1640520-17-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
 <20261001135711.1640520-17-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 14:18:27 +0000
Message-Id: <20261001141827.B97661F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] arm64: PSCI CPU_ON spuriously fails for protected secondary vCPUs
- [Medium] arm64: KVM_SET_MP_STATE rejects KVM_MP_STATE_UNINITIALIZED with =
-EINVAL
--

commit f4c00ca4b159d4b7954978f9de7770cc8b67b029
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off

This patch records a protected vCPU held powered off by EL2 as
KVM_MP_STATE_UNINITIALIZED. It restricts KVM_SET_MP_STATE from overwriting
this value with RUNNABLE or SUSPENDED, and updates the guest CPU_ON checks
to gate on this state rather than STOPPED.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 14fe4e7275796..a89087c83e27f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

[ ... ]

> @@ -818,12 +829,24 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu=
 *vcpu,
> =20
>  	switch (mp_state->mp_state) {
>  	case KVM_MP_STATE_RUNNABLE:
> +		if (kvm_pkvm_vcpu_is_powered_off(vcpu)) {
> +			ret =3D -EPERM;
> +			break;
> +		}
> +
>  		WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
>  		break;
>  	case KVM_MP_STATE_STOPPED:
> -		__kvm_arm_vcpu_power_off(vcpu);
> +		/* Keep EL2's off record: STOPPED over it would let RUNNABLE through. =
*/
> +		if (!kvm_pkvm_vcpu_is_powered_off(vcpu))
> +			__kvm_arm_vcpu_power_off(vcpu, KVM_MP_STATE_STOPPED);
>  		break;
>  	case KVM_MP_STATE_SUSPENDED:
> +		if (kvm_pkvm_vcpu_is_powered_off(vcpu)) {
> +			ret =3D -EPERM;
> +			break;
> +		}
> +
>  		kvm_arm_vcpu_suspend(vcpu);
>  		break;
>  	default:
>  		ret =3D -EINVAL;
>  	}

[Severity: Medium]
Does this break the userspace API for KVM_SET_MP_STATE?

The switch statement lacks a case for KVM_MP_STATE_UNINITIALIZED, defaulting
to -EINVAL for a state that KVM now actively exposes. If a userspace VMM
attempts to save and restore the state by reading via KVM_GET_MP_STATE and
later passing that exact state back via KVM_SET_MP_STATE, it will fail with
-EINVAL. Can we add a case to properly handle the uninitialized state?

[ ... ]

> @@ -1788,7 +1811,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm=
_vcpu *vcpu,
>  	spin_lock(&vcpu->arch.mp_state_lock);
> =20
>  	if (power_off)
> -		__kvm_arm_vcpu_power_off(vcpu);
> +		__kvm_arm_vcpu_power_off(vcpu, KVM_MP_STATE_STOPPED);

[Severity: High]
Can this cause a spurious PSCI_RET_ALREADY_ON failure when booting secondary
protected vCPUs?

When the VMM initializes a secondary protected vCPU with
KVM_ARM_VCPU_POWER_OFF, it explicitly hardcodes its mp_state to
KVM_MP_STATE_STOPPED here.

>  	else
>  		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
> =20

[ ... ]

> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index e3db84400d1f8..b01f8d44033f1 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -63,7 +63,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu =
*source_vcpu)
>  		return PSCI_RET_INVALID_PARAMS;
> =20
>  	spin_lock(&vcpu->arch.mp_state_lock);
> -	if (!kvm_arm_vcpu_stopped(vcpu)) {
> +	/*
> +	 * A protected vCPU is off once the host has acted on EL2's CPU_OFF.
> +	 * STOPPED before that is the VMM's pause.
> +	 */
> +	if (!kvm_arm_vcpu_stopped(vcpu) ||
> +	    (vcpu_is_protected(vcpu) && !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
>  		if (kvm_psci_version(source_vcpu) !=3D KVM_ARM_PSCI_0_1)
>  			ret =3D PSCI_RET_ALREADY_ON;
>  		else

[Severity: High]
Following up on the KVM_ARM_VCPU_POWER_OFF initialization above, does this
condition incorrectly reject guest CPU_ON requests?

If the primary vCPU executes a PSCI CPU_ON call before the secondary vCPU
thread has executed its first KVM_RUN, __pkvm_create_hyp_vcpu() hasn't yet
upgraded the state to KVM_MP_STATE_UNINITIALIZED.

Consequently, when kvm_psci_vcpu_on() evaluates the condition above, it
sees the vCPU as STOPPED but not UNINITIALIZED. The condition evaluates
to true, causing it to return PSCI_RET_ALREADY_ON to the guest. This
deterministically breaks SMP boot for protected VMs on VMMs that block
secondary vCPU threads prior to wakeup.=20

Should kvm_arch_vcpu_ioctl_vcpu_init() directly set the state to
KVM_MP_STATE_UNINITIALIZED for protected vCPUs to avoid this race?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001135711.1640=
520-1-fuad.tabba@linux.dev?part=3D16
