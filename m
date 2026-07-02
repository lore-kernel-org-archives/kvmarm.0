Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F2F32ED40;
	Thu,  2 Jul 2026 16:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009293; cv=none; b=TBsUf5u4Blzd5/B+fj1EyrCK+Sl5jc6NbDd7kxL8C30epQ1s+bolrSSfaQkMjxcQrJFqHOENVZawlBPC9ZV10jh8JiBIXNw8R5D6EnWinEuElRgcT/nMwenTg39UYTBMn765g7uC5kp9nx4OpWn/u5Z6HTCpokv8OPlXJU8mjzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009293; c=relaxed/simple;
	bh=zBCO1ZECYY6J5S1LKodQxCh5mRx6lyaB4SwBPWitulc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eWfXxKSkaQWA8k5evKg7L9BKxXN+g40d6+g9yt+qd9u9f9q4jdhX6SNdsdciHBZDend4HIpN8fznj5//lZ4LxuIOK6MrFvzcdTg27VwoZZ6wS7p3eCNRSovSy9xI83B+esYb0ejgNrE4K7QVzOlBsmcx9Bcl4Kpl96oig8a7D48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6rHEIuI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6rHEIuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091A51F000E9;
	Thu,  2 Jul 2026 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783009292;
	bh=TDTgJ5I9K6Abxl0mV3EVXP9gQTo62MA/0IHbbmHfY84=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c6rHEIuIGvKh+/j7uIHg3wALZw9u61O5DTCzjY12EKh2Lzik+h+5LAIf+g7OIc0wy
	 5Wt/tG3Edrq24gzYL2Fng7OwlovFigH4XKQIUgbAsvlgTBdHKalPeLXh3RPtgz6GL7
	 CnAvqntm76SXGgLlTBTye/AXFTsI/o2zERjOzXdvNuNQBmCFNILBayRK4XzVHZsESe
	 BtDmQfmFg1gynFihYP7I5ef5YxOyjSp9sgCLqc+j063jegEcVnmm+iD7N8/TT0b3Uy
	 MeBjpGUbG7HNJfF9OhreuK8zuqBoVSfN9xpZE/m+CLohSuv/fa9OTHkIp1TvHin2jQ
	 hbt8/gaXSn4Hg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/28] KVM: arm64: Relax CNTHCTL_EL2 handling when
 FEAT_NV2p1 is present
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260702160248.1377250-11-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-11-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:21:31 +0000
Message-Id: <20260702162132.091A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Unconditional use of the CNTKCTL_EL1 hardware alias under FEAT_NV2=
p1 clobbers the CNTHCTL_EL2.ECV bit for both the host and the guest.

Pre-existing issues:
- [High] Writes to the control-plane system registers CNTHCTL_EL2 and CNTKC=
TL_EL1 are missing a mandatory ISB instruction.
--

commit 71cc9698fb316a6dc28bed5d5465cd03b6074925
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Relax CNTHCTL_EL2 handling when FEAT_NV2p1 is present

This patch optimizes CNTHCTL_EL2 accesses when FEAT_NV2p1 is present by
treating the CNTKCTL_EL1 accessor as normal. It replaces the split approach
with direct use of the CNTKCTL_EL1 hardware alias.

> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 4155fe89b58a1..db60facad9f3c 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c

[ ... ]

> @@ -876,8 +876,14 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, s=
truct timer_map *map)
>  	assign_clear_set_bit(tvt02, CNTHCTL_EL1NVVCT, clr, set);
>  	assign_clear_set_bit(tpt02, CNTHCTL_EL1NVPCT, clr, set);
> =20
> -	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
> -	sysreg_clear_set(cnthctl_el2, clr, set);
> +	/*
> +	 * This only happens on VHE, so use the CNTHCTL_EL2 accessor, unless
> +	 * we are sure CNTKCTL_EL1 is completely stateful with FEAT_NV2p1.
> +	 */
> +	if (!cpus_have_final_cap(ARM64_HAS_NV2P1))
> +		sysreg_clear_set(cnthctl_el2, clr, set);
> +	else
> +		sysreg_clear_set(cntkctl_el1, clr, set);

[Severity: High]
Does this read-modify-write on the host's physical state using the
cntkctl_el1 alias inadvertently clear KVM's own physical CNTHCTL_EL2.ECV bi=
t?

Since the alias drops or mishandles the ECV bit, reading it might return ECV
as 0 and write it back as 0. This could silently disable the host's ECV
functionality, such as CNTPOFF initialization from kvm_timer_init_vhe().

[Severity: High]
This is a pre-existing issue, but shouldn't there be an isb() instruction
immediately following these control-plane system register writes?

Writing to CNTHCTL_EL2 or CNTKCTL_EL1 without an explicit context
synchronization event can cause the CPU to operate under a stale timer trap
configuration for several cycles before returning.

>  }
> =20
>  void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/=
sysreg-sr.c
> index 6f0f046e4ca4e..0c4ef1ce32ae7 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c

[ ... ]

> @@ -69,11 +69,18 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu =
*vcpu)
>  		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
>  		 * the interesting CNTHCTL_EL2 bits live. So preserve these
>  		 * bits when reading back the guest-visible value.
> +		 *
> +		 * While NV2p1 fixes some of that, it makes CNTHCTL_EL2.ECV
> +		 * even more broken than it already was with NV2.
>  		 */
>  		val =3D read_sysreg_el1(SYS_CNTKCTL);
> -		val &=3D CNTKCTL_VALID_BITS;
> -		__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, &=3D, ~CNTKCTL_VALID_BITS);
> -		__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, |=3D, val);
> +		if (!cpus_have_final_cap(ARM64_HAS_NV2P1)) {
> +			val &=3D CNTKCTL_VALID_BITS;
> +			__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, &=3D, ~CNTKCTL_VALID_BITS);
> +			__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, |=3D, val);
> +		} else {
> +			__vcpu_assign_sys_reg(vcpu, CNTHCTL_EL2, val);
> +		}

[Severity: High]
Will directly assigning the hardware value here clobber the saved in-memory
guest state for the broken ECV bit?

As noted in the comment above, NV2p1 makes CNTHCTL_EL2.ECV broken when
accessed via CNTKCTL_EL1. Bypassing the mask-and-merge step could permanent=
ly
destroy the guest's saved ECV configuration.

>  	}
> =20
>  	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));

[ ... ]

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1dfc1f88bec82..9439c5b2b1fe8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

[ ... ]

> @@ -322,8 +322,10 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, e=
num vcpu_sysreg reg)
>  		switch (reg) {
>  		case CNTHCTL_EL2:
>  			val =3D read_sysreg_el1(SYS_CNTKCTL);
> -			val &=3D CNTKCTL_VALID_BITS;
> -			val |=3D __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
> +			if (!cpus_have_final_cap(ARM64_HAS_NV2P1)) {
> +				val &=3D CNTKCTL_VALID_BITS;
> +				val |=3D __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
> +			}
>  			return val;

[Severity: High]
By skipping this mask-and-merge step for NV2p1, won't this directly return
the broken hardware value to userspace?

This appears to hide the ECV bit from userspace entirely, which might break
live migration.

>  		case CPTR_EL2:
>  			if (cpus_have_final_cap(ARM64_HAS_NV2P1))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D10
