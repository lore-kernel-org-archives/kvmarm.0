Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B463D1707
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785327791; cv=none; b=rYM5x5nMseWr9lcZv7k2xWQlNk9RhSYN3J/dPI49dPZg30sJT9RvOew7FDfaiz3901vuFJmKN8t4meDLhfm61cUCy0JYP5nGBOBkQfh1gdF+fC0YZJko6If8z7RohP9IgmFbGujDDqFKrdA+9zWBqML5OTN+Q+jlHAdH9OSQjj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785327791; c=relaxed/simple;
	bh=PJgHfzt8UWikp5xOZvYYWSJRfLTdHUp9uPqlMnlCH0A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dv3u0GS0IxpbqhhH9z2OCUc89gn7zaKsyGyKWyFFP3sxTVQhevYP4uUdDG2wZ1sjWVf68px4UM98MPAUxVpiurf/l/tCe3WwVQOAk1TTBPspvwwmiEs5qK4BeH+hElT017cl6PYn7je7/z/fyzcb0DDARjTkIZzGzWFYlIDJYeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=argET+de; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="argET+de"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA5F1F000E9;
	Wed, 29 Jul 2026 12:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785327790;
	bh=ZoVxzIiQQ5bii0qp3ngJpmkdeW6WZ9zj9RRmZnA37o0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=argET+de2azwKfyQpM1UCVd480mtPaoR1jgvFsSw+Bh3nsJhjLGdo95gHsAKMZtsz
	 BW1EtGAWZpkDRMNoUuwON+kHOlj0Ryu83pT/bFtT7D3Yt8qSrotQN/NAYEMkoUAeR5
	 eTQ4UuMn1ti5FPOoIrMJ4lwJJ83+nUtpdTP04Dkr2aIutrMASDxrgAM99Kpd750G29
	 HpXSzSrPO18ZFQsrIE7JZA8IS0tlp0HzlczvyKEA3LUXfMi8MyjmQY6Ri8vrIbJ7fb
	 7gkuR4/Tq/BH7jHncVqXJ8r2kV1QO+JS0NAblqmkJdLYEKAXxt6p6FpUi4Yw70YJ9M
	 wdqIVyfUYq3JA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 4/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260729121306.1519473-6-sebastianene@google.com>
References: <20260729121306.1519473-2-sebastianene@google.com>
 <20260729121306.1519473-6-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 12:23:09 +0000
Message-Id: <20260729122309.AEA5F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The `FFA_NOTIFICATION_SET` handler incorrectly uses `GENMASK(15,=
 2)` to validate the `flags` parameter, failing to check the upper 16 bits.
- [Medium] `do_ffa_notif_set` fails to validate that unused SMC arguments a=
re zero (SBZ) before proxying the call to EL3.
--

--- Patch [4]: [PATCH v8 4/7] KVM: arm64: Support FFA_NOTIFICATION_SET in h=
ost handler ---
commit baa4efd6afc2d0d38d7b2978ab35d6925fbb388e
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_SET in host handler

This patch allows FF-A notification SET messages to be proxied from the
pKVM hypervisor to Trustzone and verifies the arguments.

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
Does this mask adequately validate the upper bits of the flags parameter?

Because GENMASK(15, 2) is used, bits 31:16 of the flags parameter passed in
W2 are left unvalidated. If an untrusted host issues the hypercall with
non-zero values in these upper 16 bits, they will be forwarded directly to =
EL3.

> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args =3D (void *)&ctxt->regs.regs[0];

[Severity: Medium]
Should this function validate that unused SMC arguments are zero before
proxying the call to EL3?=20

Other handlers in this file call ffa_check_unused_args_sbz() to enforce this
behavior. Without that check, if the untrusted host passes arbitrary data in
unused registers, that data will be forwarded verbatim to the Secure Payload
Manager, potentially providing a fuzzing channel against EL3.

> +	hyp_smccc_1_2_smc(args, res);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729121306.1519=
473-2-sebastianene@google.com?part=3D4
