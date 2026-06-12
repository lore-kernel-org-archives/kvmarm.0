Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BF53537EE;
	Fri, 12 Jun 2026 19:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293856; cv=none; b=LdX9DooX0eMxZFqEq2z04QBkhu2dnw5zpw2J4kbqe/67fMfhslb3OS4cFnWCuxXqwQJbX0/K8ITbyTPK5nGZhE1ddOnTW90Mx1NoKDcIzDTvkW9ZMnNpOTR4H/4IEfSCU3IyWGtQdmFyzQi0F94+6tb+QOGi1kt0YHmDqEIE6b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293856; c=relaxed/simple;
	bh=n1dO9w59qYqHXc4rEQT6iMuIOIG7l7Q+mN27dAEjEJA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=esvqH3Wxc8n6UxO9juyUWyiuVWN5609U9VfaH04cMgLKCAnCRU5WpX/uf1y68ahxlu9h5dfVJfA+M+iSSfyqDWNpNeDhjGodPfFTCsKp4q8cnii8Pca7yWIguAxUzYCBfAe+ogyGkTQ3Q3PkMzBj9SdXL3QxhmQP6P4AiZS1ffg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJkuxDiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJkuxDiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA2D1F000E9;
	Fri, 12 Jun 2026 19:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781293855;
	bh=rJgBMF4wsmR8LL6fgAM8Dbs15szZC7UFV/TJvwP/rW4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gJkuxDiCogo0h2P/AS8t1WS1nnXKwry3Jw/ZpBjr4bc7Hod0rRqlSNZU7GNAKys2x
	 1JMT/xsBjvPutCiWWl4+gFhQHCnm/MIOE1+aFustm0OUY+4cdBQddyFsT6JLoG5B60
	 pMlIVd8jHozat0RWLLVfpWete2WA+daq1LlR3bKvrSPuu3IqcmaTqFaD7bDsqdrEKY
	 icYxaTegZ1p+X9TBt7z2g5yKUKsWRPH634tOcOW7zPNoeZXRbus2XjS7ghPzKWiiIO
	 bYYHkEoBENWvMKp/galXV7ZBHPHwsm9SR2RY38w+oifC9MQIX0ah+Nppc2UVpojER3
	 AVk3lFt9sIDUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/21] KVM: arm64: Implement lazy PMU context swaps
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260612192909.1153907-16-coltonlewis@google.com>
References: <20260612192909.1153907-16-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 19:50:53 +0000
Message-Id: <20260612195054.3EA2D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Lazy PMU context swap fails to load the guest's PMU context into h=
ardware when transitioning to GUEST_OWNED.

Pre-existing issues:
- [High] Missing Context Synchronization Event (isb) after writing to the c=
ontrol-plane register mdcr_el2.
--

commit a83c8406b5c65fa431f7a278b4af5a7ef746c844
Author: Colton Lewis <coltonlewis@google.com>

KVM: arm64: Implement lazy PMU context swaps

Since many guests will never touch the PMU, they need not pay the cost
of context swapping those registers.

Use an enum to implement a simple state machine for PMU register
access. The PMU is either free or guest owned. We only need to context
swap if the PMU registers are guest owned. The PMU initially starts as
free and only transitions to guest owned if a guest has touched the
PMU registers.

> diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
> index 044f011c9c84b..bb1f3dca03869 100644
> --- a/arch/arm64/kvm/pmu-direct.c
> +++ b/arch/arm64/kvm/pmu-direct.c
[ ... ]
> @@ -388,3 +388,20 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
>  	kvm_pmu_set_guest_counters(pmu, 0);
>  	preempt_enable();
>  }
> +
> +/**
> + * kvm_pmu_set_guest_owned() - Give PMU ownership to guest
> + * @vcpu: Pointer to vcpu struct
> + *
> + * Reconfigure the guest for physical access of PMU hardware if
> + * allowed. This means reconfiguring mdcr_el2.
> + *
> + */
> +void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_pmu_is_partitioned(vcpu->kvm) &&
> +	    vcpu->arch.pmu.access =3D=3D VCPU_PMU_ACCESS_FREE) {
> +		vcpu->arch.pmu.access =3D VCPU_PMU_ACCESS_GUEST_OWNED;
> +		kvm_arm_setup_mdcr_el2(vcpu);

[Severity: High]
This is a pre-existing issue, but does kvm_arm_setup_mdcr_el2() need an isb=
()
after writing to mdcr_el2?

When has_vhe() is true, it writes directly to mdcr_el2 but does not issue an
isb() before returning. Now that kvm_pmu_set_guest_owned() is called from
the active trap handling path, won't the immediate subsequent PMU hardware
accesses run against an architecturally undefined pipeline state?

[Severity: High]
Does this transition the PMU ownership without loading the guest's PMU stat=
e?

If we don't call kvm_pmu_load(vcpu) here to synchronize the in-memory guest
PMU state to the hardware PMU registers, won't the trap handler immediately
access uninitialized physical hardware registers containing the host's stat=
e?

> +	}
> +}

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 94572bc52c32a..f0eebeeb5ed96 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
[ ... ]
> @@ -1192,15 +1193,17 @@ static u64 pmu_reg_read(struct kvm_vcpu *vcpu, en=
um vcpu_sysreg reg)
>  	u64 val =3D 0;
>  	int idx;
> =20
> +	kvm_pmu_set_guest_owned(vcpu);
> +
>  	switch (reg) {
>  	case PMCR_EL0:
> -		if (kvm_pmu_is_partitioned(vcpu->kvm))
> +		if (kvm_pmu_get_access(vcpu) =3D=3D VCPU_PMU_ACCESS_GUEST_OWNED)
>  			val =3D kvm_pmu_direct_pmcr_read(vcpu);

[Severity: High]
Could this leak host state to the guest and later corrupt the guest's state?

Because kvm_pmu_set_guest_owned() didn't load the guest's PMU state, this
read (and subsequent ones in this handler) will access the physical PMU
registers that still hold the host's state.

Later, when the guest exits, kvm_pmu_put() will read these physical hardware
registers and save them back into vcpu->arch, permanently corrupting the
guest's saved PMU context.

Doesn't this also silently break live migration if restored PMU state is
wiped out upon the guest's first trapped access?

>  		else
>  			val =3D kvm_vcpu_read_pmcr(vcpu);
>  		break;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612192909.1153=
907-1-coltonlewis@google.com?part=3D15
