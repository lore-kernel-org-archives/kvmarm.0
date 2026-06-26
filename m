Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3891E3DDE
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782460548; cv=none; b=X1ixU3hHaZjLbUaPJFKAwkFsptadSFq+JI4DwuzMDJ4fF0okAhdWcUVEV3Dzgtzv2T4BuKo3OdOXIv34H/PLpUph+ZN9IhXMM1OIIQf6uu7ScYUOy8yMVtlnOHYvPVMn72vuOAcuJASMrCCTeAEza6vVUeHgMBeYzzeJWHDKUGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782460548; c=relaxed/simple;
	bh=g05QQtuoVU/+fRS7ZfcpGd1FmKbE5xNGc9z3a4sknBU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U7iS4MfhlCTd+HRhiCvqh1clON0DlBE9Izx1RiC9+vB0Ybh5pdjqaxf5lOhrEuOji4zwsxQnAX7h60or93/6J5a6CcNGKxRI+Fx8ErcDZmUbXglZGfKlW8DczcabisRwDS9o3Th0FQz3K+zpWwWZFTerGQcP+LKztsVoulmBFi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PA0Jd1ml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PA0Jd1ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8923A1F000E9;
	Fri, 26 Jun 2026 07:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782460546;
	bh=ePJjUs7JoHAZ6tov/2g/bi5YzzFJGnhQS1Y3wKGuzzY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PA0Jd1mlqAlYe4r8qc6A2lp5/jlRYAfkF/pu5n6ZsvNT2svOWUPgbUGCEinPtj9NS
	 a8T/hKLtC67/i1KLfl+8EYr+KqMk/DHLF5vL7dKznXU+HKk3mDvI2ykqfznHNvjLEH
	 HdLIG1Aydh9LM+yea8AviO3SAyjqs2rOINqJp5xMRUDx0Lrv0JAlGta3PSTw4GBoap
	 83X+jP5TLlkeFagjyaCN7xFYnDMlIJhPZbgBRy61Lw/KMaU3Ui3eXSUU0KN6wNlaDg
	 etmz1rIHnHQtD59lT4N8RpyGg2Gixaasg9BcO6LrkAiA+kem6YI/j1Iq3eo0FGlKxn
	 Nghm2y2uQOwiQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 4/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260626074545.433234-5-sebastianene@google.com>
References: <20260626074545.433234-1-sebastianene@google.com>
 <20260626074545.433234-5-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 07:55:46 +0000
Message-Id: <20260626075546.8923A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete validation of host-supplied `flags` (MBZ bits) before=
 proxying FFA_NOTIFICATION_SET to EL3.
--

commit 390edd982e712bdb39d83c8b5c1be4b16e311bcb
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_SET in host handler

Allow FF-A notification SET messages to be proxied from the pKVM
hypervisor to Trustzone and verify the arguments.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index d52d7c4d5e7f5..2bb16aa414f9f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c

[ ... ]

> @@ -917,6 +917,27 @@ static void do_ffa_notif_unbind(struct arm_smccc_1_2=
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
> +	if (flags & GENMASK(15, 2)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}

[Severity: Medium]
Does this validation check miss the upper 16 bits of the flags register?

According to the FF-A specification for FFA_NOTIFICATION_SET, when bit 0 of=
=20
the flags is 0 (global notification), bits [31:16] must be zero (MBZ). Since
this check only covers GENMASK(15, 2), it appears the host could pass
unvalidated data in the upper 16 bits of the flags argument to Trustzone.

Should this check be expanded to enforce the MBZ requirement on bits [31:16]
before proxying the hypercall to EL3?

> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626074545.4332=
34-1-sebastianene@google.com?part=3D4
