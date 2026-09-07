Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF1C35A39D
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788765407; cv=none; b=azY1X4eWHLmRiNJI+nOxyA6rhBpuGVoIFZCvg8sG7jwd3c2wIwdoxIPQ61YVkIJ/eBbd1haKVsUiyQJhnvkZ0i9AgxqShYwZXWTAADWDt6lCehxxi1P7uVm4nN5eCmBfnTOXGfX/ZuVYTy3mEeWk1Z03GuzjwOmKvOArDGaJbuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788765407; c=relaxed/simple;
	bh=/l4RUx1Fk08ehbGeI6tnCdZPHHk2EPGbB9fpkUbR42I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GhQtcEx9tQVbA62GqQqlJ5nXCYzLUcDWdkiKbmbkdAdph6lITuPi+d0eQw0cbHwjwiXXXJ5oT015nkTPY/DJT1mPk048B7o5uD7IF9GI1bXYFQY+OPGo+Xr66BSlO0a5f4AfoOk68IgqZx4M+VPzBz92le2xzsVyARozgilC9TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+5a9YJo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+5a9YJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6FF1F00A3A;
	Mon,  7 Sep 2026 07:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788765403;
	bh=mX4AZ2fhMPEFvf522BAoi+l5jGtfUom+xPK9cHY8V/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X+5a9YJoNjIi8u9mREaFDfsDtrC2R9RP+fLhm2QTuBjYB2oFK5caJeUDE+vSBvQy7
	 8Mwt3ay6LNfumX9O7tY7i3t5eMuJ0r4/huBjefbNWAzyYGTIVTolF8yV99NJ/5T/aH
	 b1Vh1W1k3AypM5M91Pt53gF4AqLsJeg5qGDY8AYi59eBEf/3RZFhJruDukSmBqHIw1
	 qFy6z8RrD+7wbM4B95JOoBhc55ognfgMpkkLbUukVv4VV2x39PyQTA5ct7Tz6pU0fJ
	 tMAluCDJHqP/4URraiPBng+ZdSPR0+rNP1OwEbCIPhAPCKW1jBlhcBzGpFDkYZzAzu
	 KzBmbi1p8itwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/17] KVM: arm64: Handle PSCI calls for protected
 VMs at EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260907070002.3333525-9-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-9-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 07:16:42 +0000
Message-Id: <20260907071643.0B6FF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The error path in `pkvm_reset_vcpu()` leaves `reset_state->reset =
=3D true`, breaking the synchronization barrier for subsequent `CPU_ON` cal=
ls.

Pre-existing issues:
- [High] Memory leak of SVE state pages when VM-wide initialization fails, =
due to clearing `KVM_ARM_VCPU_SVE`.
--

commit c2e0971411fd802ad76348d4eef69923169c10e5
Author: Fuad Tabba <fuad.tabba@linux.dev>

    KVM: arm64: Handle PSCI calls for protected VMs at EL2

This commit implements PSCI 1.1 handling at EL2 for protected VMs. It manag=
es
the vCPU power state transitions between OFF, ON_PENDING, and ON, and
intercepts PSCI calls like CPU_ON, CPU_OFF, and AFFINITY_INFO. Calls that
require host intervention, such as scheduling, are safely forwarded.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index 69f13362b7ab0..4ce79e191ff45 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c

[ ... ]

> @@ -407,6 +442,9 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu=
 *hyp_vcpu)
>  		return;
> =20
>  	sve_state =3D hyp_vcpu->vcpu.arch.sve_state;
> +	if (!sve_state)
> +		return;
> +

[Severity: High]
This isn't a bug introduced by this patch, but does the early return in
unpin_host_sve_state() cause a memory leak of SVE state pages when VM-wide
initialization fails?

If pkvm_vcpu_init_sve() fails on a secondary vCPU (for example, due to an
invalid configuration from host userspace), the error path in
pkvm_vcpu_init_sve() clears the KVM_ARM_VCPU_SVE bit in the VM-wide
vcpu_features bitmap.

During the subsequent teardown of the VM, unpin_host_vcpus() calls
unpin_host_sve_state() for all vCPUs. Because the feature bit was cleared,
unpin_host_sve_state() returns early and fails to unpin the SVE state
memory that was successfully pinned for previously initialized vCPUs. This
allows for a denial of service via resource exhaustion from host userspace.

>  	hyp_unpin_shared_mem(sve_state,
>  			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
>  }

[ ... ]

> +int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct vcpu_reset_state *reset_state =3D &hyp_vcpu->vcpu.arch.reset_sta=
te;
> +	int prev;
> +
> +	/*
> +	 * Pairs with smp_store_release(&reset_state->reset, true) in
> +	 * pvm_psci_vcpu_on(). The acquire must precede the cmpxchg: reversed, a
> +	 * winning cmpxchg with a false acquire would leave power_state =3D=3D =
ON
> +	 * with the reset skipped.
> +	 */
> +	if (!smp_load_acquire(&reset_state->reset))
> +		return -ECANCELED;
> +
> +	prev =3D cmpxchg_relaxed(&hyp_vcpu->power_state,
> +			       PSCI_0_2_AFFINITY_LEVEL_ON_PENDING,
> +			       PSCI_0_2_AFFINITY_LEVEL_ON);
> +	if (prev !=3D PSCI_0_2_AFFINITY_LEVEL_ON_PENDING) {
> +		/* The only other writer of ON_PENDING is the rollback. */
> +		WARN_ON(prev !=3D PSCI_0_2_AFFINITY_LEVEL_OFF);
> +		return -ECANCELED;

[Severity: High]
Does the -ECANCELED error path in pkvm_reset_vcpu() leave
reset_state->reset set to true, breaking the synchronization barrier for
subsequent CPU_ON calls?

If a CPU_ON hypercall is followed by a host rollback (which sets power_state
back to OFF but intentionally leaves reset_state.reset =3D true), a
subsequent CPU_ON from the guest sets power_state to ON_PENDING, writes
the new pc/r0, and sets reset_state->reset =3D true.

However, because reset_state->reset was already left as true, if the target
vCPU executes pkvm_reset_vcpu() concurrently, its
smp_load_acquire(&reset_state->reset) will immediately succeed. The target
vCPU then reads pc and r0 before the CPU_ON call has finished writing them,
resulting in a data race and the guest booting with corrupted state.

> +	}
> +
> +	kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
> +	kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
> +
> +	/* Must be done after resetting sys registers. */
> +	kvm_reset_vcpu_psci(&hyp_vcpu->vcpu, reset_state);
> +
> +	hyp_vcpu->exit_code =3D 0;
> +	/*
> +	 * power_state =3D=3D ON rules out the other two writers, the source
> +	 * cmpxchg(OFF, ON_PENDING) and the rollback cmpxchg(ON_PENDING, OFF).
> +	 */
> +	reset_state->reset =3D false;
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907070002.3333=
525-1-fuad.tabba@linux.dev?part=3D8
