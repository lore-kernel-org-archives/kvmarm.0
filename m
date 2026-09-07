Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2CE3043DB
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788765969; cv=none; b=l5qBOtRRGYEgTw3LZROGBB/DicnwsB3tAl6Cbx1dMhRQKL1U9dvvuk7bfHmUOCXlNb+aPOfB5EZcsBV9liBEWYXk1bQIGNoZZ8dgBHJOeYuVGlNUOkqMONL22YybyM2csUhkkFbcq3REqPRy2AI2bh42NF8FwklO1J1iyJnImv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788765969; c=relaxed/simple;
	bh=KS8pSaoq4zqblasgVaC1F9RaZbnBPgkpGOdmLCo6iQU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H797KUGFFsmrmtJl82Pki0ZDVinTSafm8oFbAlS6K071wS8Xg9K/cQxHSo4YjrrHQFmA6T4DqLzEggNauR+Q8UsQuni/26TRfMUHIi732uGzvdoBoo1kPQ1RnknzDolPxOA0kW8IwNCjpe+YI9dn9cr8H0BDwTeE+BOBMm7KDAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fGBaagyw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fGBaagyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AFB1F00A3A;
	Mon,  7 Sep 2026 07:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788765968;
	bh=D3c6EnaibPZyZkcdSkE5XxDQyXIiiKYxndjqaIgAa1Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fGBaagywdZmf3aj7Gg0V3tXMVusSK6XFR9ouOJSL8ooPsbwxEdgXQc5eEftKgedYb
	 WZVSOzL2dC9iBQwckYP8ysZZWzQ6tYghWJaS+DsQ/uuQhfAb1vOutvoAcfDrojf6Mz
	 Jv4U+34rRazEDQHCqgzW3VterzymjIZp+gljJeO9+DWvplhKqPIbjndlXdWUxFaABq
	 Xij4MOMdKeJfEH90LPeyt+KcU2w+4kBtxTkqRINMih8HHaX172fStPYBlAG5rU2add
	 9HUcZna0eyglqeuo9JdCzlUi4atawlV1t50CJQ+8aafWv7pANz3uukYRoGNW3L3m0b
	 WdlBPqazHG4Qg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/17] KVM: arm64: Add per-EC entry/exit state
 marshalling for protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260907070002.3333525-13-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-13-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 07:26:07 +0000
Message-Id: <20260907072608.31AFB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Dead fallback code due to EL2 WARN_ON panic semantics
--

commit e6a23fd729ce9b1a6ab9652bdfcd06dd180d6ce8
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Add per-EC entry/exit state marshalling for protected guests

This commit introduces per-EC entry and exit state marshalling for protected
guests. It routes protected guests through specific entry and exit handlers
to copy only the necessary context rather than the entire context between t=
he
host and the hyp vCPU.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 1a3f23e90e563..2015bf5ce6287 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c

[ ... ]

> @@ -34,13 +38,342 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_conte=
xt *host_ctxt);

[ ... ]

> +static void handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	u64 ret =3D READ_ONCE(hyp_vcpu->host_vcpu->arch.ctxt.regs.regs[0]);
> +	u32 psci_fn =3D smccc_get_function(&hyp_vcpu->vcpu);
> +
> +	switch (psci_fn) {
> +	case PSCI_0_2_FN_CPU_ON:
> +	case PSCI_0_2_FN64_CPU_ON:
> +		/*
> +		 * Roll back a CPU_ON the host failed, unless the target
> +		 * already reached ON: it is running, and the guest sees
> +		 * SUCCESS.
> +		 */
> +		if (ret !=3D PSCI_RET_SUCCESS) {
> +			unsigned long cpu_id =3D smccc_get_arg1(&hyp_vcpu->vcpu);
> +			struct pkvm_hyp_vcpu *target_vcpu;
> +			struct pkvm_hyp_vm *hyp_vm;
> +			int prev;
> +
> +			hyp_vm =3D pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> +			target_vcpu =3D pkvm_mpidr_to_hyp_vcpu(hyp_vm, cpu_id);
> +
> +			/*
> +			 * pvm_psci_vcpu_on() resolved this MPIDR and vcpus[]
> +			 * entries are never removed, so the lookup cannot miss.
> +			 */
> +			if (WARN_ON(!target_vcpu)) {
> +				ret =3D PSCI_RET_INTERNAL_FAILURE;
> +				break;
> +			}

[Severity: Low]
Is the fallback error handling unreachable here?

At EL2 in nVHE/pKVM, WARN_ON evaluates to a BRK instruction which panics the
hypervisor. There is no warn-and-continue behavior in this context. If
target_vcpu evaluates to NULL, the hypervisor will panic immediately, leavi=
ng
the fallback assignment to PSCI_RET_INTERNAL_FAILURE and the break statement
entirely dead code.

> +
> +			prev =3D cmpxchg_relaxed(&target_vcpu->power_state,
> +					       PSCI_0_2_AFFINITY_LEVEL_ON_PENDING,
> +					       PSCI_0_2_AFFINITY_LEVEL_OFF);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907070002.3333=
525-1-fuad.tabba@linux.dev?part=3D12
