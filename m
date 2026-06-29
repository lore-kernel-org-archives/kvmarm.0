Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C23328631
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 12:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737941; cv=none; b=VGupAh1uhj1OnM31G/RnmPUj7v2yjviLyiqmbTnY4+G9wL7YX0FOL3lkDm1ojOhC33S4xZQHqnKVRRuSNBonA1t0LgkY4o70rlD2unY2Et4Rh17rL2ZxqriJ43JDwbKnw6ydsN9D8PSpwE2pSt88dWPX/DMCpOKji2N3VCnoJ3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737941; c=relaxed/simple;
	bh=x74qUCoG1tMTPDnpRxgtvOaFFKN+rOKETRKN5NF9hJc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PqwBPyv5vQjVSGPXv8iCxUcgOSq3F6l5QIp2HX909Jk8dB67oM2jTFH7icnbeP30hkGYPC1zccnd59U7oyz5+MCqh06mMPIy/eqA6JefemwoMG7uFa7GPY3lUb3w9bVQbhcLNQZ+Oj1A6SEgi1cWNMwtxlkMQQFQmjGjAPHvtOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnCR9jRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnCR9jRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1BF1F000E9;
	Mon, 29 Jun 2026 12:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782737939;
	bh=+zdJmYKjVDHBMVoww9/9+FERKMAJ/5HHq5NF+3ytj6U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fnCR9jRavMvDMGLlKWdJp3Nx39m/rtXOgBTw18Rq62Tt/7rWfpQFTxLLPqPeLJamW
	 xuIL0uiZsjc77wEegsCWVgfUJ7GOoGMZscL1YS88q8NE13YkGAPPJq9hqdTfzZOtye
	 Zh31Xw2W/LTzIUXEoJ0ntuv0SHcYqkZjA94W+8LG6C5E4fWkKB7TCapch4kuMH+oZv
	 rPtvdwCvTquGAoB25VA9GDI+t//xj9ioWZNqsNn8rs4+EP4YvPtsX74o4xwdgrVKm7
	 tq9hXCz9EH5oWHCGDka82QiF4UeWuNu65sve5Tcs9P/X2MgsKE5yuJGMSc1pCLaKGE
	 U3PvombTSWjtw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 7/7] KVM: arm64: Enforce strict SBZ checks in the
 FF-A proxy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260629093558.2425257-8-sebastianene@google.com>
References: <20260629093558.2425257-1-sebastianene@google.com>
 <20260629093558.2425257-8-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 12:58:59 +0000
Message-Id: <20260629125859.8A1BF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Lockless read of `hyp_ffa_version` in `ffa_check_unused_args_sbz=
()` races with concurrent writes.

Pre-existing issues:
- [High] Uninitialized fields in the `res` structure leak EL2 stack memory =
to the host during FF-A version negotiation.
--

commit a19572356269d847d64eebb97bb025807ca073f2
Author: Sebastian Ene <sebastianene@google.com>
KVM: arm64: Enforce strict SBZ checks in the FF-A proxy

This patch introduces a helper function to enforce strict argument checking
when the hypervisor acts as a relayer between the host and Trustzone. It
adds calls to this new helper across various FF-A hypercall handlers to
ensure unused arguments are zeroed.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 712811e894352..334f8a28d942d 100644
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
Can this lockless read of hyp_ffa_version cause a data race?

During host initialization, multiple CPUs could issue the FFA_VERSION
hypercall concurrently. If CPU A acquires version_lock in do_ffa_version()
and writes to hyp_ffa_version, CPU B entering do_ffa_version() and calling
ffa_check_unused_args_sbz() will evaluate this condition.=20

Since logical AND evaluates left-to-right, CPU B could locklessly read
hyp_ffa_version while CPU A is writing it. Swapping the conditions to check
ARM_SMCCC_IS_64(func_id) first would short-circuit the evaluation for
FFA_VERSION (which is an SMC32 call) and avoid the unprotected read entirel=
y.

> +		end_reg =3D 17;
> +	for (reg =3D first_reg; reg <=3D end_reg; reg++) {
> +		if (cpu_reg(ctxt, reg))
> +			return true;
> +	}
> +
> +	return false;
> +}

[ ... ]

> @@ -764,6 +804,11 @@ static void do_ffa_version(struct arm_smccc_1_2_regs=
 *res,
>  {
>  	DECLARE_REG(u32, ffa_req_version, ctxt, 1);
> =20
> +	if (ffa_check_unused_args_sbz(ctxt, 2)) {
> +		res->a0 =3D FFA_RET_NOT_SUPPORTED;
> +		return;
> +	}

[Severity: High]
This is a pre-existing issue, but does this code leak uninitialized EL2
stack memory to the host?

In kvm_host_ffa_handler(), an uninitialized struct arm_smccc_1_2_regs res
is declared on the stack. When do_ffa_version() is called (both on this
newly added failure path and the existing paths), it only manually assigns
res->a0 before returning.

Back in kvm_host_ffa_handler(), ffa_set_retval(host_ctxt, &res) then
blindly copies the entire structure into the host context, which exposes
the uninitialized a1-a17 fields to the untrusted host.

> +
>  	if (FFA_MAJOR_VERSION(ffa_req_version) !=3D 1) {
>  		res->a0 =3D FFA_RET_NOT_SUPPORTED;
>  		return;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629093558.2425=
257-1-sebastianene@google.com?part=3D7
