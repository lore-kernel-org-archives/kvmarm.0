Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196E231280D
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783333505; cv=none; b=lL05+8DvEaTGtiqJtwfzfWoj2J2gGMFfV6pNViAPoxPYhF7tqbqVycTEr65gZ5C3YtmVA+3L60hSwvbIxUG+a0nQnRM7jpKutwOV84wih89E9u8S9oZ7vgPcWvKreokNGt5alsclYfMeVoXSyV6cYjO8E6tQN97h4gNyLwfY2To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783333505; c=relaxed/simple;
	bh=mwk0EcCCJZWHxOr6x/uLqUiA2Pf0P2QE07GZ1FJyhHw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ALuaVhL3ylOBWjWhyPlsjMmcRO7GCLf/acuceP/3cb20wYpfNbR0wYRDydD9/Mhb+rRvlZMVyTFl0l7EJb/L9NAY+kgSAUUyFZKDm1r2mmEVjZYXaDFY654JE7beZy0Nbfqut5Od8Rdmd1FWe4i7ltw5Pz9rFJ2b1+ei6qRSa9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B9hw9csR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B9hw9csR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AD01F000E9;
	Mon,  6 Jul 2026 10:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783333503;
	bh=VeKNQMzSurnwseNITdgRxU2agcoAjUiLwdZ0DeMMVb0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B9hw9csRZI5ERTphKBW6Ni0wYtqGTeUqUahcKmFDIQZxKoACWkHzC/4KvthmofjxZ
	 m4gsIR4FSX0ZiTgTMq9x48pjfC7Zj5Xpf2mrz/z2LLoLh53cw205vfL+DRsH5HjE0U
	 grE6gihzm9fHi5aD6OrG6HRfRMsD6CNH4SKgYHbvzsmH97seFqvhD6e9JkVak52vzk
	 5K0PjAikFVSCohgNTeELAj1jc9WjeUy5TuGnjvdsZ9eAp5GJMDASfTFQrWSg6gCDfc
	 rgWjeiRSJJaNfpY/sgjBxrMc0RKcdM4ED0vA/SFDrYIRu3KSy7ylYubqv/FlCnszUG
	 6UpRDZDFJFpkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260706095927.560795-3-fuad.tabba@linux.dev>
References: <20260706095927.560795-1-fuad.tabba@linux.dev>
 <20260706095927.560795-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 10:25:02 +0000
Message-Id: <20260706102503.63AD01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] `kvm_vcpu_read_sys_reg()` and `kvm_vcpu_write_sys_reg()` are funda=
mentally unsafe for nVHE EL2 emulation (e.g., during `fixup_guest_exit`), d=
espite the commit claiming they are "valid in any context".
--

commit 61ee8756572b776a9170ae13bb7ede91ed5afb18
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code

This commit moves the wrappers for vcpu_read_sys_reg and vcpu_write_sys_reg=
=20
from exception.c to kvm_emulate.h as kvm_vcpu_read_sys_reg and=20
kvm_vcpu_write_sys_reg. This makes them available to all hyp code so that=20
emulation logic can be shared at EL2.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index 5bf3d7e1d92c7..80b30fead3d16 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(s=
truct kvm_vcpu *vcpu)
>  	return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
>  }
> =20
> +static inline u64 kvm_vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int=
 reg)
> +{
> +	if (has_vhe())
> +		return vcpu_read_sys_reg(vcpu, reg);
> +
> +	return __vcpu_sys_reg(vcpu, reg);
> +}

[Severity: High]
This is a pre-existing issue, but are these accessors actually safe for nVH=
E=20
EL2 emulation? The commit message claims they are valid in any context, but
during early exit handling (like fixup_guest_exit), the live guest state is
still in hardware registers.

Because has_vhe() evaluates to false in nVHE EL2, kvm_vcpu_read_sys_reg() f=
alls
back to reading the memory context via __vcpu_sys_reg(). This means it reads
stale state until __sysreg_save_state_nvhe() runs.

For example, when an exception is injected into a protected guest via
inject_sync64(), enter_exception64() uses this helper to read SCTLR_EL1 and
computes the new PSTATE from it. This reads a stale SCTLR_EL1, potentially
corrupting the injected PSTATE.SPAN and PSTATE.SSBS bits.

Could exposing these as generic helpers lead to more traps where EL2 code
accidentally reads stale memory-backed sysregs before they are synced?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706095927.5607=
95-1-fuad.tabba@linux.dev?part=3D2
