Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B10F445AF0;
	Tue, 14 Jul 2026 09:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022834; cv=none; b=JekW8dYw7+FOYiQqnZDi/XTlhgS0MCzuUqnFm8acbkN1DUxr/C511A5VHhbWEszGMrG7GS+sVhjVz8vu8N3cNEgWwv/BM+Woj5bpCSh17J7w9M5SY1EP/IJjCVsb2Qqictkeyoc2rnecFx6Mz2bRbXmt5e2vLiQQuf1LgelCVOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022834; c=relaxed/simple;
	bh=SiQS2ofy545Ef/1csN4mdMNYMReSLrIaFJs+Im3AfC0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WxPCsFFPnI6V03tmRfsRyZ7CdiwvB3CAfkoZLPUyiyIZjv3+sZYZ+jwEbj8x3O2y1MlGQBzuPsJIVIuiE+Sg9CJGr25mWwbsi6oTlFRnHF4/OQdoJaMFN1cZ1jGZe5xcsmPyRg150FHodcSpk9kuZ80Eq2KMFTE33BZmV0L1aYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dC8vgNbJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dC8vgNbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AE91F00A3A;
	Tue, 14 Jul 2026 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784022830;
	bh=6v83Y87/3RwGwExS0ySlu3zXIQKUxt+pLt0Vbi+jyZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dC8vgNbJDsV8wpPb5IXTHhLnjNzwrNynW63dQM9kmWnPSXh00Napx1KLuq+504qc3
	 +zxLC8pJysibJuKGL/E4kHfGfQuEPYaaAG1cO6CFsTcpUa2dE4B+SJdibTPflab+Zz
	 BgZrHgc4fvW2YBnNCMccSd8dIwesw2mJWcxgJoBm7r8kQOhcPYWDClMTJxGyID2fCA
	 +Ta8+n5HG2ztPoNAfKbhSBscjKB3mfQVsC8EVBsZThZH4Bk5nix85cTVtQFQdZIcXU
	 Ff8fEc9549PAvH8P5heTkV8zzR4oPS9aj3LDJg5ppbSris1WqQNSNyWZokH9uSocjp
	 6beQBz5BIju9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/28] KVM: arm64: Relax CNTHCTL_EL2 handling when
 FEAT_NV2p1 is present
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260714091641.1970822-11-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-11-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 09:53:49 +0000
Message-Id: <20260714095350.20AE91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Removing the split-state preservation for `CNTHCTL_EL2` on FEAT_NV=
2p1 systems permanently corrupts the guest's in-memory ECV bit and leaks ho=
st-specific trap overrides to userspace.
--

--- Patch [10]: [PATCH v2 10/28] KVM: arm64: Relax CNTHCTL_EL2 handling whe=
n FEAT_NV2p1 is present ---
commit e272e43dc6ce85d3337902d78430aad6bf5b83fc
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Relax CNTHCTL_EL2 handling when FEAT_NV2p1 is present
   =20
With NV2p1, it is no longer necessary to use the split approach
where bits of CNTHCTL_EL2 cannot be accessed via CNTKCTL_EL1,
and we can treat the CNTKCTL_EL1 accessor as if it was "normal".

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
>  }

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
Does removing the split-state preservation for CNTHCTL_EL2 unconditionally
overwrite the guest's in-memory register state?

Since timer_set_traps() applies host-specific overrides to CNTKCTL_EL1 on t=
he
host side, calling __vcpu_assign_sys_reg() here appears to blindly copy tho=
se
host-specific traps directly into the guest's architectural state on exit.

Furthermore, as the comment above notes that NV2p1 makes the ECV bit even m=
ore
broken, won't this assignment corrupt the guest's ECV state as well?

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
Does this directly return the host-polluted physical register to userspace
during KVM_GET_ONE_REG?

Because the host-specific overrides from timer_set_traps() are present in
CNTKCTL_EL1, skipping the bitmasking on ARM64_HAS_NV2P1 systems seems to le=
ak
these hypervisor-specific configurations to userspace. This could break live
migration by restoring an altered execution environment.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714091641.1970=
822-1-maz@kernel.org?part=3D10
