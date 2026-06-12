Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88163546EF
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781248633; cv=none; b=Gmo9vvCm5YzZ3y8IzIilwkLDPGR9+wSqJ1OwIbBTfirRS4p04PoFFAqewlT7PzF63hZ85SVPmTGh1+Dvm90eBtbV0zD6LCDiGabfYi6XrNHvi0qWwc+LqUnYZ7pMpsu5XP1k5YzkFsZvjNrWQUeXt0ccUXTxJSY2PgGRa4aW2iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781248633; c=relaxed/simple;
	bh=XuHuEPN1DT3M1LiDjuo8/JwAWfGMpWYR+6bUXYxoW24=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H7gy2hsWloqE/lvRA35PpgUSUf0kJ9hM6VC0LkI7UexQ5CtwyqCr1jL+/+y+Ml35PRJmZKPeZxuVPaNyfvWOgR11rtqavU9wIXZrINmiTeDSEv+Y7d4FaoS6PQJ/LIPXZW5YDeMOkkBHQ86nga+HmrB3aDfebDJohk9zBZnBZDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZnwB+suM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZnwB+suM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD1E1F000E9;
	Fri, 12 Jun 2026 07:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781248632;
	bh=2B5VY8FPxFjEtH/OC5yUXfY2SdCYk/oVunqkmrz0X60=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZnwB+suMCEGYJRwcNZp37mm7Ri3QQidPX0NmJ2lzJNq1n9vWxM5fp3ILuyYNcagc9
	 gcWkH1J6w+OFI09ps19lmzh+wSfjr8I1hOIjNWx30Yt7Y000uwdwJAKpZnfHiUjBz4
	 FLC0mR5gMqveCeE7Rfi1fuIHXbMK8YxkoxiiRoVMHBeu6vcD3yTAjAImGeiXW2Jx/b
	 Gees171VrkQdnlzMxaoRbfDGu0T+2cMi9K2Tdu/Kf/Ee7UG4ifL9LfSkGAEJf0OJhV
	 xoVhHGigxZwZXUrY905QmLFlYzQZ58NN90NppcPvgu+J2FbmM0rnCaqH1/hFg+GMz7
	 7e8BADBC+RKRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 05/11] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
Reply-To: sashiko-reviews@lists.linux.dev
To: tabba@google.com
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260612065925.755562-6-tabba@google.com>
References: <20260612065925.755562-6-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 07:17:11 +0000
Message-Id: <20260612071712.2DD1E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Hardware/Memory State Desynchronization in EL2 sysreg accessors
--

commit 69d4753f169931c6c1990fc9118b5a6cffe54554
Author: tabba@google.com <tabba@google.com>

KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code

The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
shared with hyp code. Add _vcpu_read_sys_reg()/_vcpu_write_sys_reg()
inlines in kvm_emulate.h that dispatch on is_nvhe_hyp_code() to the
host- or hyp-side accessor. A follow-up series uses this to share that
emulation code at EL2.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index 5bf3d7e1d92c7..aed9fc0b717b1 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(s=
truct kvm_vcpu *vcpu)
>  	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>  }
> =20
> +static inline u64 _vcpu_read_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_sy=
sreg reg)
> +{
> +	if (!is_nvhe_hyp_code())
> +		return vcpu_read_sys_reg(vcpu, reg);
> +
> +	return __vcpu_sys_reg(vcpu, reg);
> +}
> +
> +static inline void _vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, e=
num vcpu_sysreg reg)
> +{
> +	if (!is_nvhe_hyp_code())
> +		vcpu_write_sys_reg(vcpu, val, reg);
> +	else
> +		__vcpu_assign_sys_reg(vcpu, reg, val);
> +}

[Severity: High]
If these accessors are called from nVHE EL2 code during guest exit handling,
will they read and write from the in-memory sys_regs array instead of the
active hardware registers?

Since the guest's system registers remain live in the CPU hardware during t=
he
run loop:

    do {
        __guest_enter(vcpu);
    } while (fixup_guest_exit(vcpu, &exit_code));

and aren't saved to memory until __sysreg_save_state_nvhe() runs after the
loop terminates, it seems _vcpu_read_sys_reg() might read stale values from
memory.

Likewise, would _vcpu_write_sys_reg() updates write to memory without updat=
ing
the active hardware registers before the guest is re-entered?

> +
>  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_mode_is_32bit(vcpu)) {
> @@ -516,9 +532,9 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *v=
cpu)
> =20
>  		r =3D vcpu_has_nv(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
> =20
> -		sctlr =3D vcpu_read_sys_reg(vcpu, r);
> +		sctlr =3D _vcpu_read_sys_reg(vcpu, r);
>  		sctlr |=3D SCTLR_ELx_EE;
> -		vcpu_write_sys_reg(vcpu, sctlr, r);
> +		_vcpu_write_sys_reg(vcpu, sctlr, r);
>  	}
>  }

[Severity: High]
When kvm_vcpu_set_be() is used at EL2, could this result in the guest being
re-entered without the new endianness taking effect?

Whether updating the 32-bit pstate via *vcpu_cpsr() or the 64-bit SCTLR via
_vcpu_write_sys_reg(), the modifications appear to happen to the in-memory
state rather than the active hardware registers (like SPSR_EL2 or SCTLR_EL1=
).

If so, wouldn't the updates be lost and unobserved by the guest upon re-ent=
ry?

> =20
> @@ -533,7 +549,7 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vc=
pu)
>  	r =3D is_hyp_ctxt(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
>  	bit =3D vcpu_mode_priv(vcpu) ? SCTLR_ELx_EE : SCTLR_EL1_E0E;
> =20
> -	return vcpu_read_sys_reg(vcpu, r) & bit;
> +	return _vcpu_read_sys_reg(vcpu, r) & bit;
>  }

[Severity: High]
Could this result in kvm_vcpu_is_be() reading an incorrect endianness state
at EL2?

If the guest modifies SCTLR_EL1 and traps to EL2, calling this helper would
use _vcpu_read_sys_reg() which accesses the stale memory array instead of t=
he
current hardware register state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.7555=
62-1-tabba@google.com?part=3D5
