Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807E53CCFDE
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782460604; cv=none; b=Gekt8vZ2DyYdJh9qJOCJPj8GgF4XWrEMdw5b9x4Zv7LDfEosJ/fmU4/JyKK4yrH1GWw4fIv4zpJdU1lhuZ59ka9YZi2/zq6965sbhq0WSxvGrf55wkOH01Z1LzC/vVs5XcSlxdFWz3HsiSGJFrCW9s1pZWQk2S6TGwGE5DVRXsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782460604; c=relaxed/simple;
	bh=kiOzu/WrO2fCpEi835iY7b+uDLs+MaPbi3lI3sz9w2s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MsgQBbnaE+ZWQqZdd6OMIkkK8yMfVsyPGdSIV2RymCP85ju0QGV739Ucv1+fRODmQKu51qgzHVgoLOB0tCYqnu/+uqcaZXCVPj24KmRKdQ6MQT0qmr7o/QIQpZHfXPBEN8W67rrOo936Iqgj654APIfS4LCS6BprRR7liKkfj88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0XmNAGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0XmNAGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE3C1F000E9;
	Fri, 26 Jun 2026 07:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782460603;
	bh=IQa7EoC9pUgZMqaJQehb+ZlOOZ/GFia/ITx4Aq/BAa4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H0XmNAGpO0hmDh8mqIjfP8EX1El6CBgMjI3YA+pDEE6GeBHwhN58Y66g3wmqCxhE+
	 B1UhAgmKhF6FOmWNeuUIlM33kFS/O1buUcK3ibeWK6qyJpiEJDp9hLODPj12PqQi4J
	 Eo1DnjpTekzSCJF8nw/DmnsWgNE4x+mSL7WV9ShL1dsxHJwrJuT3rbxgBDnTD6pXFy
	 /Wn3YF6/+AESYfAX1QtDEgV776igy1WeWnn6PBz1gypNhrzuCVtUu248yvrN9nSsT2
	 b2J1EQSPvYT2dG+4jURzAlvPnBKJkPFbRnJ7qAl/rvzPtj5I6CcJ1axhGBOYWRo/Y0
	 e6isiY3dYoeug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 7/7] KVM: arm64: Enforce strict SBZ checks in the
 FF-A proxy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260626074545.433234-8-sebastianene@google.com>
References: <20260626074545.433234-1-sebastianene@google.com>
 <20260626074545.433234-8-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 07:56:42 +0000
Message-Id: <20260626075642.DBE3C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] `ffa_check_unused_args_sbz` incorrectly enforces 64-bit zeroing =
on unused registers for SMC32 calls, violating the SMCCC calling convention.
- [Medium] `FFA_FEATURES` returns `FFA_RET_INVALID_PARAMETERS` instead of `=
FFA_RET_NOT_SUPPORTED` when MBZ parameters are non-zero.

Pre-existing issues:
- [High] The early return paths in `do_ffa_version` leave `res->a1` through=
 `res->a7` uninitialized, resulting in EL2 stack garbage being leaked to th=
e untrusted EL1 host.
--

commit 307381420348c3a7f498a4b56cd09448fc71cde0
Author: Sebastian Ene <sebastianene@google.com>
Subject: KVM: arm64: Enforce strict SBZ checks in the FF-A proxy

This commit introduces a helper method ffa_check_unused_args_sbz to enforce
strict arguments checking when the hypervisor acts as a relayer between the
host and Trustzone. It adds calls to this helper across various FF-A handle=
rs.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 712811e894352..bd50ddc5b61cc 100644
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
> +	if (FFA_MINOR_VERSION(hyp_ffa_version) >=3D 2)
> +		end_reg =3D ARM_SMCCC_IS_64(func_id) ? 17 : 7;
> +	for (reg =3D first_reg; reg <=3D end_reg; reg++) {
> +		if (cpu_reg(ctxt, reg))
> +			return true;
> +	}
> +
> +	return false;
> +}

[Severity: Medium]
For SMC32 calls, the SMCCC specification states that the upper 32 bits of
parameter registers are UNKNOWN and must be ignored. Does cpu_reg() evaluate
the full 64-bit register here?

If so, this could erroneously reject valid SMC32 calls from the host if the=
ir
upper 32 bits contain garbage.

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
> +
>  	if (FFA_MAJOR_VERSION(ffa_req_version) !=3D 1) {
>  		res->a0 =3D FFA_RET_NOT_SUPPORTED;
>  		return;

[Severity: High]
This is a pre-existing issue, but by just setting res->a0 and returning, do=
 we
leak EL2 stack contents to the host?

kvm_host_ffa_handler() allocates the res structure on the stack uninitializ=
ed,
and ffa_set_retval() blindly copies a0-a7 back to the host's context.

Since this early return doesn't initialize res->a1 through res->a7, it appe=
ars
to leak 56 bytes of uninitialized stack memory back to the untrusted EL1 ho=
st.

[ ... ]

> @@ -984,6 +1069,11 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *h=
ost_ctxt, u32 func_id)
> =20
>  	switch (func_id) {
>  	case FFA_FEATURES:
> +		if (ffa_check_unused_args_sbz(host_ctxt, 3)) {
> +			ffa_to_smccc_res(&res, FFA_RET_INVALID_PARAMETERS);
> +			goto out_handled;
> +		}
> +
>  		if (!do_ffa_features(&res, host_ctxt))
>  			return false;
>  		goto out_handled;

[Severity: Medium]
According to the FF-A v1.2 specification (Section 13.1.1 FFA_FEATURES), if =
any
parameter specified as MBZ is non-zero, the ABI must return FFA_ERROR with =
the
error code FFA_RET_NOT_SUPPORTED.

Should this return FFA_RET_NOT_SUPPORTED instead of FFA_RET_INVALID_PARAMET=
ERS
to match the specification?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626074545.4332=
34-1-sebastianene@google.com?part=3D7
