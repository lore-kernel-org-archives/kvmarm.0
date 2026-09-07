Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144D765192
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 17:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788802378; cv=none; b=YMnMETsXAuFLvvDECXfkwV1bn7Utshs27+spHn7FeszZCU3egwFMdQY+eXZq8TnlX3gOUV3MU6JdImxwv/JjzFTXhJiKt+lNOAKNY8Z3gwgMf+Si1KPRcA7OU41GFnxpGBoT8oAkTlpkuTl2qwD9UzjGGDaNWl3J1Fyc9qXEawU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788802378; c=relaxed/simple;
	bh=69tG4KdWIC7w3jIVJGWQiWLhbCWCRvOr2+xFpnZmsRc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Kvhsi2CtZdZCZ3ybUwOuj/jw/vpuXD6odOXkLQMsfr3lIt28V9CwqHpsoRzcI8JRmj8KdXzNPud2jEq1bbwZgRdzSFiPX3Uc++ud6USHlw+1swE0GJ3ZOux27Y2Phh88lxjgJuTZUfx3zLyZzyKF/h47F949hgSU853cktV7GW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csTSHXEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csTSHXEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495A51F00A3A;
	Mon,  7 Sep 2026 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788802376;
	bh=tWFoM5o1VBklegX7NzJlXk0/jvkpNhoVSTJrVpjplBk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=csTSHXEYLE5ne8EFztjYbH7Ud0JQcSS+Co9dtlficDCwrNmRELeKjDd/kC7LyOBqa
	 UWGsPOrwrf0yWvokckPJXugKE7kLcGHyisEwo0244iME7pDCNeflYBjF7GmY22o+ee
	 fsRWBsqoyogfWCRyoy/s1SSa+Go95pxVyBRO+m7jD4fhEfDcKhyHPAN7pVetVD0AbL
	 TvYShVnGqjQ2J6Su4kA02IsWICkVlvh7C33ywFjfo6oku+tDxMCF1zmTlPoSIiD4ro
	 cOc4UBVB3QfOL/+3FFR8+3EDM72emfoRpX0foas1VW+2updmE3oC3lhWVFv+KyqzUg
	 bxYy43F8ZDA1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 3/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in
 host handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260907171930.4037166-4-sebastianene@google.com>
References: <20260907171930.4037166-1-sebastianene@google.com>
 <20260907171930.4037166-4-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 17:32:55 +0000
Message-Id: <20260907173256.495A51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] do_ffa_notif_unbind improperly restricts the host to only unbind=
 notifications where it is the receiver, preventing it from unbinding notif=
ications it sent.
--

commit c6b253b0c883368d7d43d8e94ff20acf54cb8109
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler

This commit adds support for the FFA_NOTIFICATION_UNBIND hypercall in the
host handler, verifying arguments and forwarding the message to Trustzone.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 89872e12f9d45..a1ba4463d1ef7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -913,6 +912,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_r=
egs *res,
>  	hyp_smccc_1_2_smc(args, res);
>  }
> =20
> +static void do_ffa_notif_unbind(struct arm_smccc_1_2_regs *res,
> +				struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, endp_id, ctxt, 1);
> +	DECLARE_REG(u32, reserved, ctxt, 2);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (reserved) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) !=3D HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}

[Severity: Medium]
Does this check improperly restrict the host to only unbind notifications
where it is the receiver?

The FF-A 1.1 specification explicitly permits either the sender or receiver
to unbind a notification. By unconditionally rejecting the hypercall when
the receiver ID does not match HOST_FFA_ID, this prevents the host (acting
as a sender) from unbinding a notification it bound to an SP.

> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907171930.4037=
166-1-sebastianene@google.com?part=3D3
