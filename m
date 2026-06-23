Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B33D34BB
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782216092; cv=none; b=uAAApceuNbUHQww0IeU0Qa1nsJBjTBXOC045XvTAcJEvmrVxuPwkJVkM5NFvq/D41cprdmuKRAX3nIr70jax1tFc/z+Z6Mc4wTJC1kX731LqTz7bqqkdEhzHeLfgrAa8kFlY4bQCmN8mz3N6sOYaV1MxHseMEgoBm2Ppuvcfu88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782216092; c=relaxed/simple;
	bh=KsTi87KpatRME5bO9AYIPHC+ZcXd413AA0V6zzgm+nc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eJqq1L1SxcXMCP/5k3+7kbor0968mddv/Y13xXlIKTkJgqyjOgztCgn9AbqOZ4RiVS+tHAnVXatIRngtM87S77MH/Z3ExuN0ejJcjlOPxdQV8Iu4iu8R0bX7upFgL+RQPkYGpe6R/XRoQaNZM41BIBpsv15R1YE5Hqi1MIMzUIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BR5bFqRG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BR5bFqRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD961F000E9;
	Tue, 23 Jun 2026 12:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782216090;
	bh=SMeiKehPQFxml+fjhfQyezmkciOSVqmFfB2ND+BAJSc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BR5bFqRG4WHUlZ3+eiyTPrypHh8MTYDB7NVXEMnnN7A2uBB4dBJ8xy04GUj/5D0ky
	 JnfxhfUvUF8/IYPCBJNt7hTeCLruUmQPEj5Xp3QLOI+MfDh+EWoyyRI++Zu5ysJ/3W
	 GK1FVA3qePLcH49ts5Kb/kTPPMdxVZNyDVbJdxo9ps2QkuCKOjihNb9fXoFkkintYO
	 POwVgspTENQsQsbkw/xl5EQCHmd5+Bs8YQQlH/JvcFlw56X/aeIn+eeBq8qJvkvoIo
	 EJ6EvfgYjx7m7T+XiuS7zeuPnh/quvB0i8rKp+NHxZmgjwvb3+2UxtXIlKmaymy3+f
	 3QfN+Fs5IIxhg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 5/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260623115354.632361-6-sebastianene@google.com>
References: <20260623115354.632361-1-sebastianene@google.com>
 <20260623115354.632361-6-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 12:01:29 +0000
Message-Id: <20260623120130.2BD961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `FFA_NOTIFICATION_SET` handler incorrectly uses `GENMASK(15,=
 2)` for flags validation, failing to enforce the MBZ requirement for bits =
[31:16].
--

commit 39a7cfefe221df6ca3d0e5547b28dcec40a5e09a
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_SET in host handler

This commit adds support for proxying the FFA_NOTIFICATION_SET message from
the host to TrustZone in the pKVM hypervisor. It also implements enforcement
of MBZ/SBZ fields for the hypercall arguments.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c

[ ... ]

> @@ -977,6 +977,32 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2=
_regs *res,
>  	hyp_smccc_1_2_smc(args, res);
>  }
> =20
> +static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
> +			     struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, endp_id, ctxt, 1);
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) !=3D HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (ffa_check_unused_args_sbz(ctxt, 5)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (flags & GENMASK(15, 2)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}

[Severity: Medium]
Does this flags validation completely enforce the MBZ requirement?

The commit message mentions enforcing MBZ/SBZ fields, but checking against
GENMASK(15, 2) appears to leave bits [31:16] unchecked. If an untrusted
host invokes the FFA_NOTIFICATION_SET hypercall with non-zero values in the
upper bits of the flags register (w2), it looks like this validation would
evaluate to false and allow the malformed arguments to be proxied to EL3.

Should this mask be expanded to include GENMASK(31, 16)?

> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623115354.6323=
61-1-sebastianene@google.com?part=3D5
