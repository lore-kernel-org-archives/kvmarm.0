Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A744749F6
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 22:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300924; cv=none; b=N0fPKz/uVeb2+PWRpgx3ExNTI2pfiU0fhvWrh6iY/o6kGisw2hRF66Im5fpI5Qe4aNT7sqOUJWnCF0lDvBSoRLAs0QDIsRBJhjkmNxjUyDlDuWt4VYzZgFh4MdG4hvt6yj+TjiFD1IUHO5fOEvpce3CgugewX+oIYMvnFIjOb70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300924; c=relaxed/simple;
	bh=+1rCC8keAP0tDgWbSKCTqUAjxE9nhc7YwE6Mns157Pw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eug73SKrtQKnJtSoHw0TvOTld338ZqMo9BzZ/P/jFeufrBqRdQfwfHMKwRtl+zrBvMtrg6Zrz9JxunapbhiEaf3mAYEMfB5DSKMKu2WkmSwbDe93ExwtJc/T1eLha0IcOEFz/dAZna21vLnsLKvvQA6zAqmoXH+bLpmnNKDZCu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJN7bPNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJN7bPNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CB01F000E9;
	Tue,  1 Sep 2026 22:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300920;
	bh=TugCivAW0NtDgf/qiyKsIHtC7GEfau1Il0VzOdX5S/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iJN7bPNzfM8bcYA1ocPVsv2/QkPOA/cKaWebomlG15yZM/cWniZVVI0ifv7eeOJSR
	 kHXWvCpR84dyt8R/eQa9RLqgrdI/+rWN55zuLD43mopJH+19NMvRcgvWuPUXEeqxHK
	 teU5GKa4boiCgoOg5kW5RCgiVPNB8/kD/hTG/gglOlDPWc7/KkENL86zZc4zasBWha
	 xic9CQF/gBubCn5zzoK9FPcx9KwKo0oyfMvqzJDeSQi6nTPnDiIUPhk5Zphnq6Fb2Q
	 4IcSeRvx+vLrnBeHZPEn8SyJjvebiPXlGS1P3gJXFJ93NITPBERX3vHQNAv78/VZKW
	 x6aQ6UD5Xd4hg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 08/14] KVM: arm64: Enforce EXLOCK for SPSR and ELR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260901-arm64-gcs-v20-8-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-8-f31750bdfadb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 22:15:20 +0000
Message-Id: <20260901221520.B0CB01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] KVM incorrectly injects spurious EXLOCK exceptions for ELR_EL1 and=
 SPSR_EL1 writes when executed from guest EL2.
--

commit 9a420a46393dc947b55c66f63966668a4f79d12b
Author: Mark Brown <broonie@kernel.org>

KVM: arm64: Enforce EXLOCK for SPSR and ELR

This commit adds enforcement of the EXLOCK rules for attempts to write to
SPSR_ELx and ELR_ELx from a guest. It injects an EXLOCK exception if both
GCSCR_ELx.EXLOCKEN and PSTATE.EXLOCK are set.

[ ... ]

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c5ce18b3f7d8d..1f80c26a98393 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2866,14 +2866,42 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
>  	return true;
>  }
> =20
> +static inline bool sysregs_exlocked(struct kvm_vcpu *vcpu)
> +{
> +	u64 gcscr;
> +
> +	if (!kvm_has_gcs(vcpu->kvm))
> +		return false;
> +
> +	if (!(vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT))
> +		return false;
> +
> +	/*
> +	 * Note that the EXLOCKEN for the running EL is checked
> +	 * regardless of the register written to.
> +	 */
> +	if (is_hyp_ctxt(vcpu))
> +		gcscr =3D vcpu_read_sys_reg(vcpu, GCSCR_EL2);
> +	else
> +		gcscr =3D vcpu_read_sys_reg(vcpu, GCSCR_EL1);

[Severity: High]
Does this logic correctly follow the architectural requirements for EXLOCK
exceptions?

According to the ARM Architecture Reference Manual, the pseudocode for
AArch64.CheckEXLOCK(target_el) restricts EXLOCK exception generation to cas=
es
where PSTATE.EL =3D=3D target_el.

When a guest running at vEL2 accesses ELR_EL1 or SPSR_EL1, the target_el is=
 1,
but the PSTATE.EL is 2. Since 2 !=3D 1, the hardware would not generate an
exception here. However, by checking the running EL's EXLOCKEN (GCSCR_EL2)
and ignoring the target EL of the register written to, KVM will inject a
spurious EXLOCK exception into the nested EL2 guest.

Can we update this to skip the check when target_el !=3D PSTATE.EL to preve=
nt
spurious exceptions during guest context switching?

> +
> +	return gcscr & GCSCR_ELx_EXLOCKEN;
> +}
> +
>  static bool access_elr(struct kvm_vcpu *vcpu,
>  		       struct sys_reg_params *p,
>  		       const struct sys_reg_desc *r)
>  {
> -	if (p->is_write)
> +	if (p->is_write) {
> +		if (sysregs_exlocked(vcpu)) {
> +			kvm_inject_exlock(vcpu);
> +			return false;
> +		}
> +

[Severity: High]
Can this cause spurious exceptions for vEL2 guests?

When a guest hypervisor writes to ELR_EL1 (which is architecturally valid a=
nd
necessary for nested virtualization), this check applies the flawed EXLOCK
logic from sysregs_exlocked() and triggers an incorrect exception injection.

>  		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
> -	else
> +	} else {
>  		p->regval =3D vcpu_read_sys_reg(vcpu, ELR_EL1);
> +	}
> =20
>  	return true;
>  }
> @@ -2882,10 +2910,16 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
>  			struct sys_reg_params *p,
>  			const struct sys_reg_desc *r)
>  {
> -	if (p->is_write)
> +	if (p->is_write) {
> +		if (sysregs_exlocked(vcpu)) {
> +			kvm_inject_exlock(vcpu);
> +			return false;
> +		}
> +

[Severity: High]
Similarly, can this lead to an incorrect exception injection when a guest
hypervisor accesses SPSR_EL1 from vEL2?

>  		__vcpu_assign_sys_reg(vcpu, SPSR_EL1, p->regval);
> -	else
> +	} else {
>  		p->regval =3D __vcpu_sys_reg(vcpu, SPSR_EL1);
> +	}
> =20
>  	return true;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-arm64-gcs-=
v20-0-f31750bdfadb@kernel.org?part=3D8
