Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A9635C1A1
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788802384; cv=none; b=ev3f/LgZmNtuwpxvttrOIVVgFdpQw1thTQ47Mg4ChW0KLyF7K7xgHXnz4yak2iXDYcvMZiEZr88F7g7lQWHw6BItKFcoq/yZ1msWcpGYEid/n8dexKHLO43g+jRfpnWtZZ0KbOH3E8lobTQIepqDwxba5WZm65FQ5WMCFlJgVf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788802384; c=relaxed/simple;
	bh=jZaLV4vUEsCAygt6dlpUyHE9gjD1wibbblJbpWrdFN0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZqkdZqLzQwDWOLN/Qbk6DILG78HaMgvhTxHjOsMR+fTW8LQOif47FjF2eHpWEnE47hE2AtkCy3WMeE8hjN6zsFEoO3g7chKr6/9B+UtyrZezPX/UhQGkoW+uMpSd1MGk2NrqDqYYAftu5hpi+h+aXV2fMEtPiYAWGyIgoFMyht8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQgaz/BU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQgaz/BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2350C1F00A3A;
	Mon,  7 Sep 2026 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788802382;
	bh=+vCvoQdZUN19uJsWriIM8a32Bz38Q6yJntHTpiI4vf0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NQgaz/BUmKfr58gPC3Rva8pvZOLE2kTHBJFtRnjZ8hHVzHGXBhJ2sNtQfSZLkVGp7
	 MUK7NBGDFpTxpgnyrhbbAFxF0cmXaOHx6sDFPDe/wBW7vfuAfgYSgXSC4RvRiUnWZ7
	 behgT0jlAMIyB/MGCAoCcIpte9YpE1djwVH0QumQVgI7fMfz63Hfaf1kDRFMfxSvxo
	 3kOCT1850aCHfCdCyzVYK2s/lRUMROj3Ue5SgeRR0Kq25kBSS0EG+qs7O5KUU5kEm4
	 /ejmwWi5LgxdAsNq9ysruiKheQzSglPmlChUtmWYAMU4T6YA51NxqL/i/Pvmx8W4Lr
	 wgdcRWGgo5TDQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 7/7] KVM: arm64: Enforce strict SBZ checks in the
 FF-A proxy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260907171930.4037166-8-sebastianene@google.com>
References: <20260907171930.4037166-1-sebastianene@google.com>
 <20260907171930.4037166-8-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 17:33:01 +0000
Message-Id: <20260907173302.2350C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ffa_check_unused_args_sbz() incorrectly performs a full 64-bit che=
ck on unused arguments for SMC32 calls, violating the SMCCC and spuriously =
rejecting valid hypercalls.
- [Medium] Lockless concurrent read of hyp_ffa_version inside ffa_check_unu=
sed_args_sbz creates a data race when evaluated during concurrent FFA_VERSI=
ON calls.
--

commit 97873b3a67790aeb9b9e6b8c8672461b3304a15f
Author: Sebastian Ene <sebastianene@google.com>
KVM: arm64: Enforce strict SBZ checks in the FF-A proxy

This commit introduces a helper method ffa_check_unused_args_sbz to enforce
strict arguments checking when the hypervisor acts as a relayer between the
host and Trustzone. It adds checks across various FF-A handlers to ensure
unused arguments in SMC calls are strictly zeroed out.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 2281ac2e42fcb..5ad74ab265b57 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -74,6 +74,21 @@ static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
>  static hyp_spinlock_t version_lock;
> =20
> +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int =
first_reg)
> +{
> +	DECLARE_REG(u32, func_id, ctxt, 0);
> +	int reg, end_reg =3D 7;
> +
> +	if (hyp_ffa_version >=3D FFA_VERSION_1_2 && ARM_SMCCC_IS_64(func_id))

[Severity: Medium]
Could this lockless read of hyp_ffa_version create a data race?

When the host kernel executes concurrent FFA_VERSION calls, one CPU might=20
evaluate the hyp_ffa_version >=3D FFA_VERSION_1_2 condition here in=20
ffa_check_unused_args_sbz(), while another CPU mutates hyp_ffa_version unde=
r=20
version_lock in do_ffa_version().

Although the 32-bit read compiles to a single atomic load on ARM64 and the=
=20
result is ultimately discarded for FFA_VERSION because=20
ARM_SMCCC_IS_64(func_id) evaluates to false, it is still an unprotected=20
concurrent access to shared state.

Would reversing the condition to check ARM_SMCCC_IS_64(func_id) first safel=
y=20
short-circuit the read for SMC32 calls like FFA_VERSION?

> +		end_reg =3D 17;
> +	for (reg =3D first_reg; reg <=3D end_reg; reg++) {
> +		if (cpu_reg(ctxt, reg))
> +			return true;

[Severity: High]
Does ffa_check_unused_args_sbz() incorrectly perform a full 64-bit check on=
=20
unused arguments for SMC32 calls?

Under the SMCCC 1.2 specification, for SMC32 calls, only the lower 32 bits=
=20
of the registers (W0-W7) are used, and the upper 32 bits are UNPREDICTABLE.=
=20
However, cpu_reg(ctxt, reg) returns the full 64-bit register value.

If a compliant host issues any SMC32 FF-A hypercall (such as FFA_VERSION)=20
and leaves non-zero residual data in the upper 32 bits of the unused=20
registers, will this strictly reject valid SMC32 hypercalls with=20
FFA_RET_INVALID_PARAMETERS?=20

Should the register value be masked to 32 bits when ARM_SMCCC_IS_64(func_id=
)=20
is false?

> +	}
> +
> +	return false;
> +}
> +

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907171930.4037=
166-1-sebastianene@google.com?part=3D7
