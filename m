Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B973D3D1B
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 12:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782216358; cv=none; b=NFhEwoemwElc7r9Vi/ZSEjnYM4WC5VBCtpZjWwnTqEPdYpqWzhk1W3etUdERez4LVVxWjAnEZslIdvNWHayIBrJH2yW8o3i0swwHo2BjkCRtuEstRqj4VYwxxmvvWhQBE1Sejnag/9F5nj687bCjFDaSWK9qCO/qcr7Ngyp90W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782216358; c=relaxed/simple;
	bh=82HPuu7DcNTyPscU6aBO6ITpfRtxWRMiXxgvzBEMmec=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LpKWmgMtr2Aj6g4owLCR5KEWBl2b/uG0Mk2o19yKL0bv3uceOAaDbDgtLsZn+oulfxuWDQV39H1kZNhFE8NMXQtJEiWFZOyVz0bL5fqrlq3ReBAV4Sj9PdtgfoIzPrCocYWXLcmJJ2EQ7Z0kwpE2OreddFHH+M5oxQ0/NgfK7R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LhRNXxUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LhRNXxUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A8D1F000E9;
	Tue, 23 Jun 2026 12:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782216357;
	bh=WptFI8GH4vFXOJCkD1OPhsKEKq9tq0h4u7y9sE23WvE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LhRNXxUn/DbhdwVZRodhclNn2MFIU+/kHYzwzrM4NKUFnkJ5LXayNyvUNeqwnFjth
	 32LIVrLAZim1AlIo9s86oFLGL4inQhLv1tKH/WTcUHb5cFRYGpfASv5w3DajyzLE0U
	 jYfdsmKIPUY/PBEXL9rg8iSmzzWSsuRNvEOTc3MfnlI/6GzVXZ2ivvkcPLFO2a8m7U
	 U2wmDnRC9Vz99mbgveVxUAU0C7I5zSG0yZwpc4yzWuCQ046xZcXXiCEzTiKHb7NAXq
	 FGqsQduk14Tsn9HiA2ZO+aVsAS6a6sT7ZSMHx52+Tkw2xQjLL5LoJOUZmw0z9JD5xl
	 JYJfQ+Mup1FgQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in
 host handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260623115354.632361-5-sebastianene@google.com>
References: <20260623115354.632361-1-sebastianene@google.com>
 <20260623115354.632361-5-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 12:05:56 +0000
Message-Id: <20260623120557.24A8D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] FFA_NOTIFICATION_UNBIND incorrectly treats the Notification ID bit=
map parameter (W2) as a reserved field and requires it to be 0, preventing =
the host from unbinding notifications and causing a firmware resource leak.
--

commit 33f494c35955148d0babe5e028baf1876db19208
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler

This commit adds support for the FFA_NOTIFICATION_UNBIND interface in the
host handler, verifying arguments before forwarding the message to TrustZon=
e.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -957,6 +956,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_r=
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
> +	if (ffa_check_unused_args_sbz(ctxt, 5) || reserved) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}

[Severity: High]
Does this reject valid unbind requests by forcing W2 to be zero?

It looks like W2 is extracted as reserved and required to be 0 here. Howeve=
r,
the FF-A specification uses W2 to pass the Notification ID bitmap for the
FFA_NOTIFICATION_UNBIND call.

If the host attempts to unbind a notification with a non-zero bitmap, this
check will reject the call with FFA_RET_INVALID_PARAMETERS. Could this
prevent the host from successfully unbinding notifications, potentially
causing a notification tracking resource leak in the secure monitor over ti=
me?

> +
> +	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) !=3D HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623115354.6323=
61-1-sebastianene@google.com?part=3D4
