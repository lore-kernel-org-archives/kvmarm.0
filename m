Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C027333B961
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 10:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782728707; cv=none; b=fA2SpiCaG2RoS+Wjja+Xep+2zYxYuC3MHyae/36/aSKSnj1eDiIWgOEfu5i52reEdtbGf+xLadfcVGaRHpHWFn42fFLhP2VYAdBOslaKv/Qc10qGB+IaLM0TsH5yIBeg9VWhtBC1+aQKNh910CliM6fJAahYi9Whr8HhNAY1L+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782728707; c=relaxed/simple;
	bh=z24lDj6zwgM1wAMauV/Hf2WwtspoK6qt5lnenQ9QAKI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qfWXOG+zY4yEYYAvmGRONnS/hm1vW5bbB27FusU+ZZKkgfwFX59tww4XF5pNhjNo89OgvSRGK6sv+VhyUTxR3wz+NTuKnRvUdvrvbZw3f/vX4pFa18+kj7cIHTs4vm5RkrOqflzUkvb4dRMUqsGdV5OxUJ06uuK+zkS4zoR84bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WV0aLCHb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WV0aLCHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A181F000E9;
	Mon, 29 Jun 2026 10:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782728706;
	bh=9ji7CdNt4jNNjd6gPQNA6EGIP5Q+2NblcdRjb9fBRjQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WV0aLCHbyIze61zZshePW+cQXEKA3ztTk47zCAbrqFWdEv8Mi0H+umokTw3OX3jnS
	 vWFpz0dafhTNbEfaV+3rVNy2UbPS3qPHweBiTRdjIigfd7vd5iGSJyugTE2cyYQ+Cz
	 qi35th+ha/kH/axRQlUraz0NxZt1PAbqNlyyxKir0zWgl/Ju2GCl8ikzaqu8C+YB79
	 YWR//VsFf0KOpdk0kTKEFoTjJcYgqazYGCI8+E1YkQRfrsK+slHThdZoQ/EDlyu3ed
	 KCiEye5Jnv/Ao88+ehfAip9heASvo7alkIg4dv7VnmF/P1WDZT5d13S0JyLvYQ57pu
	 dXvLiHOoCxxHA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 4/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260629093558.2425257-5-sebastianene@google.com>
References: <20260629093558.2425257-1-sebastianene@google.com>
 <20260629093558.2425257-5-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 10:25:05 +0000
Message-Id: <20260629102506.31A181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incomplete validation of MBZ bits in the `FFA_NOTIFICATION_SET` =
flags parameter.
--

commit 143dce86ae3c0640e01881b137e64cf1efebff28
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_SET in host handler

This commit allows FF-A notification SET messages to be proxied from the
pKVM hypervisor to Trustzone by validating the endpoint ID and flags argume=
nts
before forwarding the hypercall.

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

[Severity: Medium]
Does this missing validation allow the host to pass arbitrary data in the
upper bits of the flags parameter to EL3?

In do_ffa_notif_set(), the check masks and verifies only bits 15:2. However,
the FF-A specification defines bits 31:16 as Must Be Zero (MBZ) as well.

This seems to introduce a regression where pKVM does not completely sanitize
host inputs before forwarding them to TrustZone, potentially exposing EL3
to unauthorized use of future extensions.

> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}
> +

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629093558.2425=
257-1-sebastianene@google.com?part=3D4
