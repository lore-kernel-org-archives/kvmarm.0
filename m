Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC9A47D936;
	Wed, 22 Jul 2026 08:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710236; cv=none; b=nY/SXjRdKaN618p6VaI6wpdA74B3JuQ3FZrhOGdr793K3gVO+jvk2liwwCoIXsrCsBcX7eZzNRfPW4rX/f/1xU/70Cht73+Nyd+PYOOLUo1QeiimjFy3B6jN9FZVf9P/O45CidNfh+sidKvtMV8GeFUBeLZV7UzUZhkTIebVuxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710236; c=relaxed/simple;
	bh=PyD+43B3xJfYiJBL3FxejHOXcl2WeYvDJygZ+UURbeg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hh8Pkb+Bw0hRTqqJUVx/r8PJvA3epdFuUAwmp/GvX1ph/xI3A44u56Ans6laEP7lb7ESDJH2gYCSPqjnjk7rsv0++riWTnCjdDXc3DRQ6FZ5sAYWB4aB1mb1LjJRju+8MBNklAvZsMprjiYUbDZdZTbJ2UKoM9aFaLZFjcf2/Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R4mC3wPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R4mC3wPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAB71F000E9;
	Wed, 22 Jul 2026 08:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784710235;
	bh=QP8dxWvVFY77dlLOfNJ8OfHmF34of7RJZ8pKsh1MB1E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R4mC3wPGPozNLIUSXHiPx7ch9nlOyC7RNmxHPcOSKDxsQWL6lUTBEA5hDJziTqHK9
	 pfqHOUfhuceTMV9mvxFNgc8I4hxBhZLXaA9quWmC5FqqDZLL73sMFmZrK2UB76CKBD
	 +fJ00TmXdGaOKsRrBHBeLTn/z4QQaFKjfm85pgUEtPhmVg7w55GDkKdcINxICFJzSH
	 P57qM/gVF6Z9vEoCu7mx3P/3v58WE0X9LD5yPKaiGQwMsRJzgJGJagcJyJTgaQPR1g
	 M3acqVVHGHgUVtp5GaBk60fjcxkEvHusd7H8B1IPWSDf2SzdgNcU1cg8q3XietSCW7
	 bnh0SnUSJxltw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 24/28] KVM: arm64: Engage NV3 ERET trap elision
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260722074234.3330999-25-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-25-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 08:50:34 +0000
Message-Id: <20260722085035.0FAB71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] NV3 ERET trap elision (HCRX_EL2_NVTGE) is evaluated statically at =
vCPU initialization, failing to reflect dynamic changes to HCR_EL2.E2H by t=
he guest, resulting in a severe performance regression.
- [Low] Typographical error in the newly added comment for NV3.
--

--- Patch [24]: [PATCH v3 24/28] KVM: arm64: Engage NV3 ERET trap elision -=
--
commit c8d6c5654353c481c8b8e9e0a6741ae11cc31c69
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Engage NV3 ERET trap elision

This patch enables ERET trap elision for L1 contexts on NV3 hardware by
setting HCRX_EL2.NVTGE, and adjusts the EL2 fast-path to bounce back to EL1
when NV3 and E2H are active, assuming the hardware handles the fast path.

> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/as=
m/kvm_emulate.h
> index c562d8171d5e1..b32870a5e1236 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
[ ... ]
> @@ -706,6 +706,16 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vc=
pu)
> =20
>  		if (kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V))
>  			vcpu->arch.hcrx_el2 |=3D HCRX_EL2_EnASR;
> +
> +		/*
> +		 * NV3 is a host-specific extension, and we always use it
> +		 * when present and that the guest uses NV. It may be be

[Severity: Low]
This isn't a bug, but there is a typo (be be) in this comment.

> +		 * hidden from the guest though.
> +		 */
> +		if (cpus_have_final_cap(ARM64_HAS_NV3) &&
> +		    vcpu_has_nv(vcpu) && vcpu_el2_e2h_is_set(vcpu)) {
> +			vcpu->arch.hcrx_el2 |=3D HCRX_EL2_NVTGE;
> +		}

[Severity: High]
Does evaluating the dynamic guest state vcpu_el2_e2h_is_set() here work cor=
rectly
given this populates the static vcpu->arch.hcrx_el2 cache?

If the guest hypervisor (L1) initializes and dynamically enables HCR_EL2.E2H
after KVM has already initialized the vCPU via kvm_calculate_traps(), this
HCRX_EL2_NVTGE bit won't be set because vcpu_set_hcrx() is not refreshed
dynamically.

This causes the hardware to fail to engage trap elision, forcing the ERET
instruction to trap to EL2 where it encounters the new check below.

> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> index cbda9e087db39..4ed745bdde418 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -345,6 +345,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcp=
u, u64 *exit_code)
>  	u64 esr =3D kvm_vcpu_get_esr(vcpu);
>  	u64 spsr, elr, mode;
> =20
> +	/* With NV3, the fast path is handled in HW */
> +	if (cpus_have_final_cap(ARM64_HAS_NV3) && vcpu_el2_e2h_is_set(vcpu))
> +		return false;
> +

[Severity: High]
Will this unconditionally abort the fast path and force a severe performance
regression if the hardware trap elision wasn't engaged?

Because the HCRX_EL2_NVTGE bit was evaluated statically in vcpu_set_hcrx()
and missed the guest's dynamic update, the ERET traps into this function.

kvm_hyp_handle_eret() evaluates the dynamic E2H state, correctly observes
that it is now set, and returns false under the incorrect assumption that
the hardware handled the fast path. This bounces the trap to the slow host
EL1 path, forcing a full, expensive context switch to emulate every L1 ERET.

>  	/*
>  	 * Going through the whole put/load motions is a waste of time
>  	 * if this is a VHE guest hypervisor returning to its own

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722074234.3330=
999-1-maz@kernel.org?part=3D24
