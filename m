Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2741F3B4EA1
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 10:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782728213; cv=none; b=akORv0yLQCal5VBJSplPZXiteIXaQUbCO165lZcOSB0+rKUG9mFV1FqW8oMo7DasvXyjw/TG2UvYDzTG75QdNuldgRwW/5Y0rN22BVmBF+k3naUZ8cMjGUmR90UrX1GB5mD7tnECHlzWh7gp4KYRiq6ysnaDUKPw6fVlJggSMDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782728213; c=relaxed/simple;
	bh=gh59nhcFve/EhAvI3zIZA1yvQdmn+qZmVOav9ukuY24=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ATtc6ykxfC4FCgJ3454gnR5/zpArQaJEaJOut1l6zoXG+l9zlTxIHLTBlEaSjaSbzeao63xDkyvqYVDLtrD5T0qK/maczf0LowS8so1i1y65x49wbLv/UonOR6X5CLo1Urd3GQC5Uw2fVefV6u5+1NiXtS4i1xe/aIg5VdWF1nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZ1yIOXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZ1yIOXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8742E1F000E9;
	Mon, 29 Jun 2026 10:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782728211;
	bh=faTfFXstiVHus+srBo/QNw/H6bmQFD4abSpj6KXqiQ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mZ1yIOXk9oDGVgI2LIXphJ/KqovzpmnCafOg844aKAlILt5Nnt4+M/iy581+K1cnI
	 piW2CS9K2AxhUJptUX4UQuRpqFh6liXgGkRcNiymmQLOm4XQYvJD9p4KkZ4WgLOA+v
	 bWiEM/T/LVTV3q25iJQVFKemFkNwsxNKKrABS+eUkv/sooRZ0X0zordQ+UurILLZLd
	 ouAXgOsYZWsTr7x0c5pVzXRB3b7aTQ0Rn47AwV5v5aADSutZoSS0a11QKhbAcLvulO
	 aIJuMbEgn1bwp1MtEOIF3fl9Dl52uBEgWlCQ4/hdCaV8toHXs7z/JVbIiUqoNs8asm
	 u4KXTR5A3pqhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 3/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in
 host handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260629093558.2425257-4-sebastianene@google.com>
References: <20260629093558.2425257-1-sebastianene@google.com>
 <20260629093558.2425257-4-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 10:16:51 +0000
Message-Id: <20260629101651.8742E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The FFA_NOTIFICATION_UNBIND handler incorrectly treats the W2 para=
meter as a reserved field and forces it to be zero, which violates the FF-A=
 specification and breaks valid unbind operations.
--

commit 607a657720d57d669adb319d0385db08fa611fcc
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler

This commit adds support for the FFA_NOTIFICATION_UNBIND host handler by
verifying the arguments and forwarding the message to TrustZone. It extracts
the endpoint ID and verifies that the correct host FF-A ID is used before
allowing the unbind operation to proceed.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
[ ... ]
> @@ -897,6 +896,27 @@ static void do_ffa_notif_bind(struct arm_smccc_1_2_r=
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

[Severity: High]
Does this incorrectly reject valid unbind operations? The FF-A specification
defines W2 as the Notification ID(s) Low bitmap for unbind requests.=20

By declaring W2 as reserved and forcing it to zero, it looks like this hand=
ler
prevents the host from unbinding any notifications that use the lower 32 bi=
ts
of the Notification ID bitmap.

Additionally, should there be an ffa_check_unused_args_sbz() call here to
verify the remaining unused registers are zeroed out, similar to the other
handlers?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629093558.2425=
257-1-sebastianene@google.com?part=3D3
