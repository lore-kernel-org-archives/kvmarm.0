Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F243D5246
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 12:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782216421; cv=none; b=hVz7pC8GucEKQ4jaMC9eIbLBGjEZFMCWsWWuOxADjZRUm2GpBL/NuIJpLeqgCLgAE2Ni25cQO67oiRY3BBDCvPLFX5AZSu31uQhWsDli3sOlhBun1rU3QpCEsYX2E4xKvVWZjPKI5/l7uXBZLu04Zo3MpEwwwVIFY02jsZWOYF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782216421; c=relaxed/simple;
	bh=9rRusmHatwq9OPq/u5kWrlPc6KlyKTDx8CiY0iF8UrE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=opLRGEYLqFFeO79+IJvrHt0R5K/AGY5ckAIlRk7QziMq6kLyXsty3lcK7LjypDSnzKM5xSBVtMf01AIM2Yji8cVPhVn9ByQdhNNG91DwuRNaHHyphTWQEuE21b01qyxSWE322QXctlmPbuitCZLQysBsOCbvlny945NpbqOt83c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jm/WmDyf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jm/WmDyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1356B1F000E9;
	Tue, 23 Jun 2026 12:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782216420;
	bh=mtQjQ8xQR1cId5S0QsCbWYv6pJVXI+tLl57dBBpoEYI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jm/WmDyf47SHsYIhgPYX0hG8HrwmULsKTNDX94FS20f015zhfYuhXXufy3PL5j4/I
	 vW2jM4PSgptq6ujxSHnyPUmk2o9NvgviA0RRjIvBjwFv/DepZd3v3hW16slnn59vRt
	 926pZ6BQuBfyMbPVngpaK1ybAAC/8Ak+1R4k4+3Le9nR0Uqntdg/BKACK/xsur2q3T
	 coLu2+y25J0Ntl97FR/UsoVnmP09U7mKv0Rkbw1rhKUu+OIqK9RKHZJlUh9lH2Jt2V
	 1+s8hsKlb7hnwB+GQj3r0BAWnfmfvdD5b0hisRA9awCs+3f5Um+5Nyd3PZs9hg5A07
	 DbSEVHfxxrz0Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/7] KVM: arm64: Enforce strict SBZ checks in the
 FF-A proxy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260623115354.632361-2-sebastianene@google.com>
References: <20260623115354.632361-1-sebastianene@google.com>
 <20260623115354.632361-2-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 12:06:59 +0000
Message-Id: <20260623120700.1356B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The strict SBZ check for unused arguments does not ignore the uppe=
r 32 bits for SMC32 calls, violating the SMCCC and FF-A specifications.
- [Medium] The FFA_FEATURES handler incorrectly returns FFA_RET_INVALID_PAR=
AMETERS instead of FFA_RET_NOT_SUPPORTED when unused arguments are non-zero.
--

commit d261b7516c8a6d707698f336a32184a5de586911
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Enforce strict SBZ checks in the FF-A proxy

Introduce a helper method ffa_check_unused_args_sbz to enforce strict
arguments checking when the hypervisor acts as a relayer between the
host and Trustzone.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178a..78bb043b33ee0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -71,6 +71,20 @@ static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
>  static hyp_spinlock_t version_lock;
> =20
> +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int =
first_reg)
> +{
> +	DECLARE_REG(u32, func_id, ctxt, 0);
> +	int reg, end_reg;
> +
> +	end_reg =3D ARM_SMCCC_IS_64(func_id) ? 17 : 7;
> +	for (reg =3D first_reg; reg <=3D end_reg; reg++) {
> +		if (cpu_reg(ctxt, reg))

[Severity: High]
Does this correctly handle the upper 32 bits for SMC32 calls?

According to the SMCCC, for SMC32 calls, the upper 32 bits of X registers a=
re
unknown, and the host is not required to clear them. Since cpu_reg() returns
the full 64-bit register value, this might erroneously reject valid host FF=
-A
SMC32 calls if there is residual data in the upper 32 bits.

> +			return true;
> +	}
> +
> +	return false;
> +}

[ ... ]

> @@ -890,6 +939,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *ho=
st_ctxt, u32 func_id)
> =20
>  	switch (func_id) {
>  	case FFA_FEATURES:
> +		if (ffa_check_unused_args_sbz(host_ctxt, 3)) {
> +			ffa_to_smccc_res(&res, FFA_RET_INVALID_PARAMETERS);

[Severity: Medium]
Should this return FFA_RET_NOT_SUPPORTED instead?

According to the FF-A specification, if an unused parameter is non-zero in =
an
FFA_FEATURES call, the implementation must return FFA_RET_NOT_SUPPORTED.
Returning FFA_RET_INVALID_PARAMETERS might violate the FF-A ABI and confuse=
 the
host driver during capability negotiation.

> +			goto out_handled;
> +		}
> +
>  		if (!do_ffa_features(&res, host_ctxt))
>  			return false;
>  		goto out_handled;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623115354.6323=
61-1-sebastianene@google.com?part=3D1
