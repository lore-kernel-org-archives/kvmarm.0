Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FAA3FFF94
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766166; cv=none; b=b9N5J8n1kc1q63b3TUIKID4XHMNAO7u/I7MOLnSzk+D/FDJW/l2A37g1jC506eosDEd6vv4UYIk2l6hgFsiI4HGYYzgbE73pAKw8ay7ep5tTQygQ2+G/YRiDUWDsnNIQ8KOJ8SlyMeIaLR9I31tqmL3oIokUXEUuFIvCQJeV+ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766166; c=relaxed/simple;
	bh=/8CA9AlJnsQ7cpdUJjO+yNUugw4zewjNizEhty/6aog=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BRDQTqEtHPZtG6PstpkBY9Bi9AASOmhdv3ymsH1V4aSFHk2nqZb8Evd3jjmQbWZSu9gAzPdiSQsBUrhbOmHUw0FlDekR+iUuo4VMD9y4KU7+EWEfasMHP+1spBIny8OnjJ62NCH3V5m2NI2AHcJ2+qNK/vQn3UnVE2+g8JO4TJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjCZ+N9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjCZ+N9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5AE1F00A3A;
	Mon,  7 Sep 2026 07:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788766165;
	bh=haYKcUnDYvbUfmuipTzuQ/QGydUqx96e0KuOKHtnOuo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VjCZ+N9jYvvjukjyI/SL+pZiTklAsgo2tjosxWCc+Jsj8/OmT3OkaXT/yNxiYjlJz
	 h4u4Fzv2Qu3Al7pgBkpWkklOFCPOnu6LmN2N/I97aV39G3PJw+6QiCM1OLqFRPf1Dk
	 7BKx+M8nCrJNIJMnyS1DFiG8UUJBQ3tnOI3AK7uHFrv2KXbfEUp4Q0nzovJecaaQea
	 5J174PIH0fg/4OrBlEdXm7OF0YF8IpltBUK1supDVaPBtIusDmUhRRwLHnRYIi82WN
	 mQoQ54Gj+udStM+oveEpHWTCOKEStaWtJxkuv3JnX2bUiUvvowz1tbGxaS90NFlgrj
	 IM3hiGhCh8NgQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/17] KVM: arm64: Reject host power-on of a vCPU
 that EL2 holds powered off
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260907070002.3333525-16-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-16-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 07:29:24 +0000
Message-Id: <20260907072924.EA5AE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Race condition between EL2 and Host PSCI handling leads to state d=
esynchronization and guest failure (INTERNAL_FAILURE)
--

commit 80fb3e3ea2b949c35be53322315a43ff86b0f3ea
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off

A protected vCPU's power state belongs to EL2, which changes it only
on the guest's own PSCI calls. KVM_SET_MP_STATE(RUNNABLE) on a vCPU
EL2 holds powered off changes the host's copy alone, and the guest's
next CPU_ON of that vCPU then fails: mp_state is no longer STOPPED, so
the host returns ALREADY_ON, which EL2 turns into INTERNAL_FAILURE.
SUSPENDED has the same effect.

[ ... ]

> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index e3db84400d1f8..208289a08099f 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -94,6 +94,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *=
source_vcpu)
>  	 */
>  	smp_wmb();
> =20

[Severity: High]
This is a pre-existing issue, but can a concurrent CPU_OFF and CPU_ON cause
state desynchronization between EL2 and the host?

In kvm_psci_vcpu_on(), there is an early return path before this hunk:

	spin_lock(&vcpu->arch.mp_state_lock);
	if (!kvm_arm_vcpu_stopped(vcpu)) {
		if (kvm_psci_version(source_vcpu) !=3D KVM_ARM_PSCI_0_1)
			ret =3D PSCI_RET_ALREADY_ON;
		else
			ret =3D PSCI_RET_INVALID_PARAMS;

		goto out_unlock;
	}

If vCPU 0 executes CPU_OFF, EL2 transitions it to OFF and exits to the host.
Concurrently, if vCPU 1 executes CPU_ON targeting vCPU 0, EL2 transitions it
to ON_PENDING and exits to the host.

If the host thread for vCPU 1 acquires mp_state_lock before the host thread
for vCPU 0, the host sees mp_state as RUNNABLE, rejects the CPU_ON, and
returns ALREADY_ON. EL2 then turns this into an INTERNAL_FAILURE, which lea=
ds
to the permanent loss of a vCPU.

Taking this early return path also skips the newly introduced
pkvm_powered_off =3D false update, compromising the accuracy of the trackin=
g.

Could this early return condition in kvm_psci_vcpu_on() be updated to prope=
rly
account for pending EL2 state transitions?

> +	/* EL2 has committed the protected vCPU to ON_PENDING to get here. */
> +	vcpu->arch.pkvm_powered_off =3D false;
> +
>  	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
>  	kvm_vcpu_wake_up(vcpu);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907070002.3333=
525-1-fuad.tabba@linux.dev?part=3D15
