Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CE73B47C4
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785328037; cv=none; b=uO6oR7Of9yxON5zCLLdOaDLPidN9yMD80DtxI2VLoAJqBg5q2UbEJ1ylXG/Z1UBU5W9iZmwc1zVZDTNbY+ORSs654NFLMy5ZcvxV2uMilrPUIBjy141CzHLT+R4+Vioe0LvaZTejeKLiAkest+UfUNscxVrLuvXX++7hc1bwc+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785328037; c=relaxed/simple;
	bh=hrQnIC5kVaYliPIvd3uEaoG/h/4Xrm3RM6hCZuQTR8E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ay54mFbr1EmepX2X9AwU6o9GCC3zJv+TU9neOxwbZZX9fkAfNJF5tcV1bG0WsBevPKSG4ETBBdjQyKYyGtKGPudiqqgEY/GRc/9Fda83RzKtZUjFuVo+QtiiESFdr9Wm2XvlNY6Ss08pQusuO7OOe8cDjCVN7M2EMbK+JDI8JdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b64btf77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b64btf77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED04A1F000E9;
	Wed, 29 Jul 2026 12:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328032;
	bh=bQctR9FCH+e1nnxA5IGveiKygmMFZN0c0TwN8iARLQ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b64btf77Rirt1h5kRQIpQQNuvFvcRGL/pxscafSMEewx20C0sQjolhxy7oDfV8LQv
	 PBWHLaR4kZcOuHsPBGxA6e0bYl+egtbLTBfFZOo5Abj2ud8zIDYWFuUZPJsIS2i2vl
	 BV5duBsAJ0SaMJpijYD5NgacDqRNYeYpTHqU8pFLpo4PhzDlJM2XOPLXKgPw7OHWb1
	 As6wpgdb9nrqKADSEaRSKMxU95QA0tonL1zOSnCIxvQcCU/fCMEaNIWcnuZ/sAnrPX
	 E3tPEKuBBQEJqmYW5IZkLyBQn6WkQmmGmxyA2ceqBvjuru9eSnk3vrURJ2BhmlJPTl
	 s904B3w6HYXRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 5/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host
 handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260729121306.1519473-7-sebastianene@google.com>
References: <20260729121306.1519473-2-sebastianene@google.com>
 <20260729121306.1519473-7-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 12:27:11 +0000
Message-Id: <20260729122711.ED04A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing validation of unused MBZ (Must Be Zero) arguments in `do=
_ffa_notif_get` before forwarding to EL3.
--

--- Patch [5]: [PATCH v8 5/7] KVM: arm64: Support FFA_NOTIFICATION_GET in h=
ost handler ---
commit cd049d1e9c7b39f84753d7230fd609869137d4ae
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support FFA_NOTIFICATION_GET in host handler

This patch adds support for proxying FF-A notification GET messages from
the pKVM hypervisor to TrustZone, validating the endpoint and flag
arguments sent from the host driver.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c

[ ... ]

> @@ -938,6 +937,27 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_re=
gs *res,
>  	hyp_smccc_1_2_smc(args, res);
>  }
> =20
> +static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
> +			     struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, endp_id, ctxt, 1);
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +	struct arm_smccc_1_2_regs *args;
> +

[Severity: Medium]
Should this function verify that the unused registers are zero before
forwarding the raw context to EL3?

Looking at do_ffa_notif_bind() and do_ffa_notif_unbind(), they use
ffa_check_unused_args_sbz() to ensure unused registers are cleared. Without
a similar check here, could an untrusted host pass unvalidated data in the
remaining registers (x3-x17) directly to the SPMD?

> +	if (FIELD_GET(FFA_NOTIF_RECEIVER_ENDP_MASK, endp_id) !=3D HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (flags & GENMASK(31, 4)) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729121306.1519=
473-2-sebastianene@google.com?part=3D5
